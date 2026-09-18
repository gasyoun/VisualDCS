#!/usr/bin/env python3
"""sais_concordance.py — H5153: compiled SA-IS concordance layer over the DCS 2026 master.

Corpus: src/DCS-data-2026/dcs_full.sqlite (~878 MB, gitignored, read-only URI mode
per CLAUDE.md / docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md). The text is the
concatenation of all 5,688,416 token.form values in token.id order (the synthetic
PK assigned at CoNLL-U import = corpus reading order), joined by a single space,
with '\\n' at sentence boundaries and '\\x00' at text boundaries (270 texts).

Constructions (Demaine, MIT 6.851 Spring'21 L16/L17; handoff H5153):
  * suffix array via compiled SA-IS — pydivsufsort (pip wheel wrapping
    Yuta Mori's libdivsufsort); ctypes load of a system libdivsufsort is the
    fallback. Never a pure-Python construction at this scale.
  * Kasai LCP, O(n) — C accelerator compiled with cc on first build when
    available, pure-Python fallback (same algorithm, slower).
  * color arrays: every position maps to (token, sentence, text) through the
    canonical spine join token -> sentence -> chapter -> text (manual §3).

Query CLI:
  build                      extract + construct + persist the index (cached)
  find PATTERN [--limit N]   all occurrence positions + text/sentence refs
  count-text PATTERN         per-text occurrence counts
  repeats [--top K]          top-k maximal repeats (LCP intervals + left diversity)
  table                      measured build-time / index-size table (vs H5137 estimate)
  selftest                   5 patterns vs naive scan, exact match, on a 1M-token slice

Pattern rules: UTF-8 string; '\\n' and '\\x00' are rejected (matches never cross
sentence/text boundaries); spaces are allowed and match the token-join space, so
multi-word phrase queries work. Sub-word matches (inside a form) are legitimate
concordance hits and are attributed to the token containing the match start.

Run from the VisualDCS repo root:
    python tools/sais_concordance.py selftest
Index artifacts land in derived-data/concordance_sa/ (gitignored): T.bin, sa.npy,
lcp.npy, tok_start.npy, tok_sent.npy, sent_chap.npy, sent_no.npy, sent_sid.json.gz,
chapters.json, texts.json, meta.json.
"""
from __future__ import annotations

import argparse
import gzip
import json
import os
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent  # tools/ -> repo root
DEFAULT_DB_CANDIDATES = [
    REPO / "src" / "DCS-data-2026" / "dcs_full.sqlite",      # main clone
    REPO.parent / "VisualDCS" / "src" / "DCS-data-2026" / "dcs_full.sqlite",  # worktree
]
DEFAULT_OUT = REPO / "derived-data" / "concordance_sa"
H5137_ESTIMATE_BYTES = 100 * 1024 * 1024  # ~100 MB estimate from the H5137 L16 study

SEP_SENT = b"\n"
SEP_TEXT = b"\x00"
FORBIDDEN_IN_PATTERN = ("\n", "\x00")


# ------------------------------------------------------- suffix array (compiled) ----

def _sa_via_pydivsufsort(data: bytes):
    import pydivsufsort
    return pydivsufsort.divsufsort(data)  # int32 SA (force64 only beyond 2^31)


def _sa_via_ctypes_libdivsufsort(data: bytes):
    import ctypes
    import ctypes.util
    import numpy as np
    name = ctypes.util.find_library("divsufsort") or "libdivsufsort.so.3"
    lib = ctypes.CDLL(name)
    n = len(data)
    sa = np.empty(n, dtype=np.int64)
    buf = ctypes.create_string_buffer(data, n)
    # divsufsort(const unsigned char *T, saidx_t *SA, saidx_t n) — saidx_t is int32
    # on stock builds; assert the 32-bit path and reject corpora that overflow it.
    if n >= 2 ** 31:
        raise SystemExit("corpus too large for 32-bit saidx_t libdivsufsort build")
    sa32 = np.empty(n, dtype=np.int32)
    rc = lib.divsufsort(buf, sa32.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),
                        ctypes.c_int(n))
    if rc != 0:
        raise SystemExit(f"divsufsort failed rc={rc}")
    sa[:] = sa32
    return sa


def build_suffix_array(data: bytes):
    """Compiled SA-IS; pydivsufsort first, system libdivsufsort via ctypes second."""
    try:
        return _sa_via_pydivsufsort(data), "pydivsufsort divsufsort (compiled SA-IS)"
    except ImportError:
        pass
    return _sa_via_ctypes_libdivsufsort(data), "system libdivsufsort (ctypes)"


# ------------------------------------------------------------- LCP (Kasai) ----------

def build_lcp(T: bytes, sa, rank=None):
    """Kasai LCP, textbook convention: lcp[i] = LCP(T[sa[i-1]:], T[sa[i]:]), lcp[0]=0.

    pydivsufsort.kasai returns the forward-shifted variant (lcp[i] = gap between
    SA entries i and i+1); reindexed here so every downstream consumer sees the
    textbook array. Pure-Python Kasai is the fallback without the wheel (it
    derives the rank array itself; `rank` is only needed on that path).
    """
    import numpy as np
    try:
        import pydivsufsort
        lcp = pydivsufsort.kasai(T, sa)
        return (np.concatenate([np.zeros(1, dtype=lcp.dtype), lcp[:-1]]),
                "Kasai via pydivsufsort (compiled)")
    except ImportError:
        pass
    if rank is None:
        rank = np.empty(len(T), dtype=np.int64)
        rank[sa] = np.arange(len(T), dtype=np.int64)
    n = len(T)
    lcp = np.empty(n, dtype=np.int32)
    h = 0
    Tm = T
    for i in range(n):
        r = int(rank[i])
        if r > 0:
            j = int(sa[r - 1])
            while i + h < n and j + h < n and Tm[i + h] == Tm[j + h]:
                h += 1
            lcp[r] = h
            if h:
                h -= 1
        else:
            lcp[r] = 0
    return lcp, "Kasai (pure Python fallback)"


# ------------------------------------------------------------- extraction -----------

def extract_corpus(db_path: Path, token_cap: int | None = None):
    """Stream the spine join and build corpus text + color maps.

    Returns (T, tok_start, tok_sent, chapref, sent_chap, sent_no, sent_sid, texts, timings).
    tok_start: int32 char offset of each token's form start; tok_sent: int32 sentence
    row ordinal per token; sent_chap: int32 chapter_id per sentence row; texts: id->name.
    """
    import numpy as np
    import sqlite3

    t0 = time.perf_counter()
    uri = f"file:{db_path}?mode=ro"
    con = sqlite3.connect(uri, uri=True)
    cur = con.cursor()

    texts = {tid: name for tid, name in
             cur.execute("SELECT text_id, name FROM text ORDER BY text_id")}
    chap_ref, chap_text = {}, {}
    for cid, ref, tid in cur.execute(
            "SELECT chapter_id, ref, text_id FROM chapter ORDER BY chapter_id"):
        chap_ref[cid] = ref
        chap_text[cid] = tid

    sentences = cur.execute("SELECT id, chapter_id, sent_counter, sent_id FROM sentence ORDER BY id")
    sent_chap, sent_no, sent_sid = [], [], []
    sent_row_of = {}
    for row_i, (sid, cid, no, sid_str) in enumerate(sentences):
        sent_row_of[sid] = row_i
        sent_chap.append(cid)
        sent_no.append(int(no) if no is not None else -1)
        sent_sid.append(sid_str if sid_str is not None else "")
    sent_chap = np.asarray(sent_chap, dtype=np.int32)
    sent_no = np.asarray(sent_no, dtype=np.int32)
    t_spine = time.perf_counter() - t0

    t1 = time.perf_counter()
    chunks: list[bytes] = []
    tok_start: list[np.ndarray] = []
    tok_sent: list[np.ndarray] = []
    pos = 0
    prev_sent = None
    q = ("SELECT t.id, t.sentence_id, t.form FROM token t ORDER BY t.id"
         + (f" LIMIT {int(token_cap)}" if token_cap else ""))
    for tok_id, sent_id, form in cur.execute(q):
        if prev_sent is not None and sent_id != prev_sent:
            chunks.append(SEP_SENT)
            pos += 1
        fb = form.encode("utf-8")
        tok_start.append(np.asarray([pos], dtype=np.int32))
        tok_sent.append(np.asarray([sent_row_of[sent_id]], dtype=np.int32))
        chunks.append(fb + b" ")
        pos += len(fb) + 1
        prev_sent = sent_id
    T = b"".join(chunks)
    # text boundaries: rewrite? — cheaper: mark via a second pass on sentence chap ids
    T = bytearray(T)
    n_tok = len(tok_start)
    tok_start = np.concatenate(tok_start) if n_tok else np.zeros(0, dtype=np.int32)
    tok_sent = np.concatenate(tok_sent) if n_tok else np.zeros(0, dtype=np.int32)
    t_extract = time.perf_counter() - t1
    con.close()
    timings = {"spine_s": round(t_spine, 2), "extract_s": round(t_extract, 2)}
    return T, tok_start, tok_sent, chap_ref, sent_chap, sent_no, sent_sid, texts, timings


def mark_text_boundaries(T: bytearray, tok_start, tok_sent, sent_chap, chap_text):
    """Rewrite the join space before a text-changing sentence boundary as \\x00.

    A text boundary is always also a sentence boundary, so the flat stream reads
    "...lasttok SPACE '\\n' firsttok..." there; the SPACE becomes \\x00 and the
    sentence '\\n' stays. Matches containing a space therefore never cross a text
    (or sentence) boundary. Keeps extraction single-pass and streaming.
    """
    import numpy as np
    sent_text = chap_text_lookup(sent_chap, chap_text)
    tok_text = sent_text[tok_sent]
    changes = np.nonzero(tok_text[1:] != tok_text[:-1])[0]
    marked = 0
    for k in changes.tolist():
        end = int(tok_start[k + 1]) - 1  # char right before the next token
        if 0 <= end < len(T) and T[end:end + 1] == SEP_SENT:
            if end - 1 >= 0 and T[end - 1:end] == b" ":
                T[end - 1] = 0
                marked += 1
        elif 0 <= end < len(T) and T[end:end + 1] == b" ":
            T[end] = 0
            marked += 1
    return T, sent_text, marked


def chap_text_lookup(sent_chap, chap_text):
    import numpy as np
    lut = np.zeros(max(chap_text) + 1, dtype=np.int32)
    for cid, tid in chap_text.items():
        lut[cid] = tid
    return lut[sent_chap]


# ------------------------------------------------------------- search ---------------

def find_range(T: bytes, sa, P: bytes):
    """O(P log n) binary search for the SA run of P; returns (lo, hi) exclusive hi."""
    import numpy as np
    n = len(sa)
    lp = len(P)

    def suffix_has_p(i: int, upper: bool) -> bool:
        st = int(sa[i])
        chunk = T[st:st + lp]
        if chunk == P:
            return True
        return chunk > P if upper else False

    lo, hi = 0, n
    while lo < hi:                       # first suffix >= P
        mid = (lo + hi) // 2
        st = int(sa[mid])
        chunk = T[st:st + lp]
        if chunk < P:
            lo = mid + 1
        else:
            hi = mid
    left = lo
    lo, hi = left, n
    while lo < hi:                       # first suffix > P (ignoring equality)
        mid = (lo + hi) // 2
        st = int(sa[mid])
        chunk = T[st:st + lp]
        if chunk[:lp] == P:
            lo = mid + 1
        else:
            hi = mid
    return left, lo


def occurrences_to_refs(occ_positions, tok_start, tok_sent, sent_chap, sent_no,
                        sent_sid, chap_ref, T: bytes, span_len: int):
    """Map match start positions to per-hit display rows (token/sentence/chapter)."""
    import numpy as np
    starts = np.asarray(occ_positions, dtype=np.int64)
    tok = np.searchsorted(tok_start, starts, side="right") - 1
    rows = []
    for p, k in zip(starts.tolist(), tok.tolist()):
        srow = int(tok_sent[k])
        cid = int(sent_chap[srow])
        rows.append({
            "pos": p,
            "token": k,
            "match": T[p:p + span_len].decode("utf-8", "replace"),
            "sent": sent_sid[srow],
            "sent_no": int(sent_no[srow]),
            "chapter": chap_ref.get(cid, "?"),
        })
    return rows


def per_text_counts(occ_positions, tok_start, tok_sent, sent_chap, chap_text, texts):
    import numpy as np
    from collections import Counter
    starts = np.asarray(occ_positions, dtype=np.int64)
    tok = np.searchsorted(tok_start, starts, side="right") - 1
    srow = tok_sent[tok]
    cid = sent_chap[srow]
    lut = np.zeros(max(chap_text) + 1, dtype=np.int32)
    for c, t in chap_text.items():
        lut[c] = t
    tid = lut[cid]
    names = [texts.get(int(t), f"text {t}") for t in np.unique(tid).tolist()]
    cnt = Counter(tid.tolist())
    return [(texts.get(t, f"text {t}"), cnt[t]) for t in sorted(cnt, key=lambda x: -cnt[x])]


def top_maximal_repeats(sa, lcp, T: bytes, top_k: int):
    """LCP-interval scan + left-diversity check = maximal repeats (6.851 L16/L17).

    Textbook convention lcp[i] = LCP(sa[i-1], sa[i]): an LCP-interval of value v is
    a maximal run of SA entries [l..r] where min(lcp[l+1..r]) = v; it is a MAXIMAL
    repeat when the characters left of the occurrences are not all equal (the
    right-maximality is what the interval itself encodes). Interval bounds follow
    Abouelhoda et al.: on popping (v, start) at index i the interval is
    [start-1, i-1] (and [start-1, n-1] on the final flush).
    """
    import numpy as np
    n = len(sa)
    lcps = lcp.tolist()  # plain list: ~3x faster iteration than numpy scalar indexing
    cands = []  # (v, size, l, r)
    stack = []  # (v, start_index)
    for i in range(1, n):
        v = lcps[i]
        start = i
        while stack and stack[-1][0] > v:
            sv, sl = stack.pop()
            l, r = sl - 1, i - 1
            if sv > 0 and r >= l:
                cands.append((sv, r - l + 1, l, r))
            start = sl
        if v > 0 and (not stack or stack[-1][0] < v):
            stack.append((v, start))
    while stack:
        sv, sl = stack.pop()
        l, r = sl - 1, n - 1
        if sv > 0 and r >= l:
            cands.append((sv, r - l + 1, l, r))
    cands.sort(key=lambda c: (c[0], c[1]), reverse=True)
    out = []
    seen = set()
    for v, size, l, r in cands:
        if len(out) >= top_k:
            break
        hi = min(r + 1, l + 4096)
        lefts = {T[int(sa[i]) - 1] for i in range(l, hi) if int(sa[i]) > 0}
        if len(lefts) < 2:
            continue
        mid = int(sa[l])
        frag = T[mid:mid + v].decode("utf-8", "replace")
        if frag in seen:
            continue
        seen.add(frag)
        out.append({"repeat": frag, "length": v, "freq": size})
    return out


# ------------------------------------------------------------- persistence ----------

def save_index(out: Path, T, sa, lcp, tok_start, tok_sent, sent_chap, sent_no,
               sent_sid, chap_ref, texts, sa_backend, lcp_backend, timings):
    import numpy as np
    out.mkdir(parents=True, exist_ok=True)
    (out / "T.bin").write_bytes(T)
    np.save(out / "sa.npy", sa.astype(np.int32) if len(sa) < 2 ** 31 else sa)
    np.save(out / "lcp.npy", lcp)
    np.save(out / "tok_start.npy", tok_start)
    np.save(out / "tok_sent.npy", tok_sent)
    np.save(out / "sent_chap.npy", sent_chap)
    np.save(out / "sent_no.npy", sent_no)
    with gzip.open(out / "sent_sid.json.gz", "wt", encoding="utf-8") as fh:
        json.dump(sent_sid, fh, ensure_ascii=False)
    (out / "chapters.json").write_text(json.dumps(chap_ref, ensure_ascii=False), encoding="utf-8")
    (out / "texts.json").write_text(json.dumps(texts, ensure_ascii=False), encoding="utf-8")
    meta = {"sa_backend": sa_backend, "lcp_backend": lcp_backend,
            "n_bytes": len(T), "n_tokens": int(len(tok_start)), "timings": timings,
            "built": time.strftime("%Y-%m-%dT%H:%M:%S%z")}
    (out / "meta.json").write_text(json.dumps(meta, ensure_ascii=False, indent=1), encoding="utf-8")


def load_index(out: Path):
    import numpy as np
    T = (out / "T.bin").read_bytes()
    sa = np.load(out / "sa.npy")
    lcp = np.load(out / "lcp.npy")
    tok_start = np.load(out / "tok_start.npy")
    tok_sent = np.load(out / "tok_sent.npy")
    sent_chap = np.load(out / "sent_chap.npy")
    sent_no = np.load(out / "sent_no.npy")
    with gzip.open(out / "sent_sid.json.gz", "rt", encoding="utf-8") as fh:
        sent_sid = json.load(fh)
    chap_ref = json.loads((out / "chapters.json").read_text(encoding="utf-8"))
    chap_ref = {int(k): v for k, v in chap_ref.items()}
    texts = json.loads((out / "texts.json").read_text(encoding="utf-8"))
    texts = {int(k): v for k, v in texts.items()}
    return T, sa, lcp, tok_start, tok_sent, sent_chap, sent_no, sent_sid, chap_ref, texts


# ------------------------------------------------------------- naive oracle ---------

def naive_find(T: bytes, P: bytes):
    out, i = [], T.find(P)
    while i != -1:
        out.append(i)
        i = T.find(P, i + 1)
    return out


# ------------------------------------------------------------- CLI commands ---------

def cmd_build(args):
    import numpy as np
    db = Path(args.db) if args.db else next((p for p in DEFAULT_DB_CANDIDATES if p.exists()), None)
    if not db or not db.exists():
        raise SystemExit("dcs_full.sqlite not found — pass --db /path/to/dcs_full.sqlite")
    print(f"[build] db: {db}")
    T, tok_start, tok_sent, chap_ref, sent_chap, sent_no, sent_sid, texts, timings = \
        extract_corpus(db, token_cap=args.token_cap)
    # text boundaries via chapter->text edges
    chap_text = {}
    import sqlite3
    con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    for cid, tid in con.execute("SELECT chapter_id, text_id FROM chapter"):
        chap_text[cid] = tid
    con.close()
    T, sent_text, marked = mark_text_boundaries(bytearray(T), tok_start, tok_sent, sent_chap, chap_text)
    T = bytes(T)
    print(f"[build] text: {len(T):,} bytes · {len(tok_start):,} tokens · "
          f"{len(sent_chap):,} sentences · {len(texts)} texts · {marked:,} text boundaries")

    t_sa = time.perf_counter()
    sa, sa_backend = build_suffix_array(T)
    t_sa = time.perf_counter() - t_sa
    print(f"[build] SA: {sa_backend} · {t_sa:.1f}s")

    t_lcp = time.perf_counter()
    lcp, lcp_backend = build_lcp(T, sa)
    t_lcp = time.perf_counter() - t_lcp
    print(f"[build] LCP: {lcp_backend} · {t_lcp:.1f}s")

    timings.update({"sa_s": round(t_sa, 2), "lcp_s": round(t_lcp, 2),
                    "sa_backend": sa_backend, "lcp_backend": lcp_backend})
    save_index(Path(args.out), T, sa, lcp, tok_start, tok_sent, sent_chap, sent_no,
               sent_sid, chap_ref, texts, sa_backend, lcp_backend, timings)
    print(f"[build] saved -> {args.out}")


def cmd_find(args):
    P = _pattern_bytes(args.pattern)
    idx = Path(args.out)
    T, sa, lcp, tok_start, tok_sent, sent_chap, sent_no, sent_sid, chap_ref, texts = load_index(idx)
    lo, hi = find_range(T, sa, P)
    n = hi - lo
    print(f"[find] {args.pattern!r}: {n:,} occurrence(s)")
    import numpy as np
    occ = sa[lo:hi][:args.limit]
    for p in occ.tolist():
        k = int(np.searchsorted(tok_start, p, side="right") - 1)
        srow = int(tok_sent[k])
        cid = int(sent_chap[srow])
        # chapter->text name
        print(f"  {p:>10,}  {T[p:p+len(P)].decode('utf-8','replace')!r}  "
              f"{chap_ref.get(cid,'?')} · sent {sent_no[srow]} · sent_id {sent_sid[srow]}")


def cmd_count_text(args):
    P = _pattern_bytes(args.pattern)
    T, sa, lcp, tok_start, tok_sent, sent_chap, sent_no, sent_sid, chap_ref, texts = load_index(Path(args.out))
    import numpy as np
    import sqlite3
    lo, hi = find_range(T, sa, P)
    print(f"[count-text] {args.pattern!r}: {hi - lo:,} occurrence(s) across texts:")
    chap_text = {}
    db = Path(args.db) if getattr(args, "db", None) else \
        next((p for p in DEFAULT_DB_CANDIDATES if p.exists()), None)
    if db and db.exists():
        con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
        chap_text = dict(con.execute("SELECT chapter_id, text_id FROM chapter"))
        con.close()
    if not chap_text:
        raise SystemExit("chapter->text map unavailable — pass --db so per-text counts can resolve")
    rows = per_text_counts(sa[lo:hi], tok_start, tok_sent, sent_chap, chap_text, texts)
    for name, c in rows[:args.top]:
        print(f"  {c:>8,}  {name}")
    if len(rows) > args.top:
        print(f"  ... {len(rows) - args.top} more texts")


def cmd_repeats(args):
    T, sa, lcp, *_rest = load_index(Path(args.out))
    t0 = time.perf_counter()
    reps = top_maximal_repeats(sa, lcp, T, args.top)
    dt = time.perf_counter() - t0
    print(f"[repeats] top {len(reps)} maximal repeats ({dt:.1f}s scan; preview ≤{args.max_print} chars):")
    for r in reps:
        preview = r["repeat"][:args.max_print] + ("…" if len(r["repeat"]) > args.max_print else "")
        print(f"  len {r['length']:>6,} × {r['freq']:>6,}  {preview!r}")


def cmd_table(args):
    out = Path(args.out)
    meta = json.loads((out / "meta.json").read_text(encoding="utf-8"))
    import numpy as np
    T = (out / "T.bin").stat().st_size
    sizes = {f: (out / f).stat().st_size for f in
             ["T.bin", "sa.npy", "lcp.npy", "tok_start.npy", "tok_sent.npy",
              "sent_chap.npy", "sent_no.npy", "sent_sid.json.gz", "meta.json"]}
    index_total = sum(sizes.values())
    print(f"[table] build-time / index-size — DCS 2026 master "
          f"({meta['n_tokens']:,} tokens, {meta['n_bytes']:,} text bytes)")
    print(f"  SA backend : {meta['sa_backend']}")
    print(f"  LCP backend: {meta['lcp_backend']}")
    print(f"  build times: spine {meta['timings']['spine_s']}s · extract "
          f"{meta['timings']['extract_s']}s · SA {meta['timings']['sa_s']}s · "
          f"LCP {meta['timings']['lcp_s']}s")
    for f, s in sizes.items():
        print(f"  {f:>18}: {s:>12,} B")
    print(f"  {'INDEX TOTAL':>18}: {index_total:>12,} B  = {index_total / T:.2f}× raw text")
    print(f"  vs H5137 ~100 MB estimate: {H5137_ESTIMATE_BYTES / 1e6:.0f} MB "
          f"-> {index_total / 1e6:.0f} MB measured")


def cmd_selftest(args):
    """5 patterns vs naive scan on a 1M-token slice — exact match required."""
    import numpy as np
    db = Path(args.db) if args.db else next((p for p in DEFAULT_DB_CANDIDATES if p.exists()), None)
    if not db or not db.exists():
        raise SystemExit("dcs_full.sqlite not found — pass --db")
    print(f"[selftest] db: {db} · slice: first {args.slice_tokens:,} tokens")
    T, tok_start, tok_sent, chap_ref, sent_chap, sent_no, sent_sid, texts, timings = \
        extract_corpus(db, token_cap=args.slice_tokens)
    import sqlite3
    con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    chap_text = dict(con.execute("SELECT chapter_id, text_id FROM chapter"))
    con.close()
    T, _, marked = mark_text_boundaries(bytearray(T), tok_start, tok_sent, sent_chap, chap_text)
    T = bytes(T)
    print(f"[selftest] slice text: {len(T):,} bytes · {marked:,} text boundaries")

    sa, sa_backend = build_suffix_array(T)
    lcp, lcp_backend = build_lcp(T, sa)
    print(f"[selftest] SA {sa_backend} · LCP {lcp_backend}")

    # patterns: sampled real forms (incl. diacritics), a two-word phrase, an absent string
    import random
    rng = random.Random(6851)
    words = [T[a:a + (b - a - 1)].decode("utf-8", "replace")
             for a, b in zip(tok_start.tolist(), tok_start.tolist()[1:]) if b - a > 3]
    words = [w for w in words if " " not in w and "\n" not in w and "\x00" not in w]
    pats = rng.sample(words, 3)
    diac = [w for w in words if any(c in w for c in "āīūṛṭḍṇśṣṁḥṃ")]
    if diac:
        pats[2] = rng.choice(diac)
    # real adjacent bigram: two consecutive tokens inside one sentence
    for k in range(500, len(tok_start) - 1):
        a, b = int(tok_start[k]), int(tok_start[k + 2]) - 1
        bigram = T[a:b]
        if b" " in bigram and b"\n" not in bigram and b"\x00" not in bigram:
            pats[2] = bigram.decode("utf-8")
            break
    pats.append(pats[0] + " " + pats[1])
    pats.append("zzqqxx_absent_zz99")
    assert len(pats) == 5, pats

    ok = 0
    for P in pats:
        pb = P.encode("utf-8")
        lo, hi = find_range(T, sa, pb)
        sa_hits = sorted(sa[lo:hi].tolist())
        naive = naive_find(T, pb)
        match = sa_hits == naive
        ok += match
        print(f"  {'PASS' if match else 'FAIL'}  {P!r}: SA {len(sa_hits):,} vs naive {len(naive):,}")
    total = len(T)
    print(f"[selftest] {ok}/5 exact — slice {total:,} B · {len(tok_start):,} tokens")
    if ok != 5:
        raise SystemExit(1)


def _pattern_bytes(s: str) -> bytes:
    if any(c in s for c in FORBIDDEN_IN_PATTERN):
        raise SystemExit("pattern must not contain sentence/text separators")
    return s.encode("utf-8")


def main(argv=None):
    # Windows consoles default to a legacy codepage (cp1251/cp437) that cannot
    # encode Sanskrit diacritics; force UTF-8 so every subcommand prints cleanly.
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--db", help="path to dcs_full.sqlite (read-only)")
    ap.add_argument("--out", default=str(DEFAULT_OUT), help="index directory")
    sub = ap.add_subparsers(dest="cmd", required=True)
    b = sub.add_parser("build"); b.add_argument("--token-cap", type=int, default=None)
    f = sub.add_parser("find"); f.add_argument("pattern"); f.add_argument("--limit", type=int, default=20)
    c = sub.add_parser("count-text"); c.add_argument("pattern"); c.add_argument("--top", type=int, default=15)
    r = sub.add_parser("repeats"); r.add_argument("--top", type=int, default=20)
    r.add_argument("--max-print", type=int, default=100, help="preview chars per repeat")
    sub.add_parser("table")
    s = sub.add_parser("selftest"); s.add_argument("--slice-tokens", type=int, default=1_000_000)
    args = ap.parse_args(argv)
    {"build": cmd_build, "find": cmd_find, "count-text": cmd_count_text,
     "repeats": cmd_repeats, "table": cmd_table, "selftest": cmd_selftest}[args.cmd](args)


if __name__ == "__main__":
    main()
