#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
coverage_diff.py — M3 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Aligns the 2026 CoNLL-U corpus against the 2021 relational export and writes
reports/coverage_diff.md:

  - TEXT coverage  : which texts 2026 adds / drops vs 2021 (246 <-> 270), matched
                     best-effort by normalized name, then by reference abbreviation.
  - LEMMA coverage : distinct attested lemmas (by LemmaId) 2021 vs 2026 — overlap,
                     only-2021, only-2026. (The cross-walk is exact: 0.csv's integer
                     ID lists ARE the CoNLL-U LemmaIds — see DCS_FORMAT_COMPARISON.md.)
  - per-text COUNT deltas for the pilot texts (2021 from 0.csv, 2026 from dcs.sqlite),
    which surface the granularity mismatch (1 relational line <-> N CoNLL-U sentences).

Stdlib only. Run after M2 (uses dcs.sqlite for the pilot counts).
    python coverage_diff.py
"""

import os
import re
import sqlite3
import sys
import unicodedata

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
REL_2021 = os.path.join(HERE, "..", "DCS-data-2021", "0.csv")
CONLLU_ROOT = os.path.join(HERE, "conllu", "files")
DB = os.path.join(HERE, "dcs.sqlite")
OUT = os.path.join(HERE, "reports", "coverage_diff.md")
LEMMAID_RE = re.compile(rb"LemmaId=(\d+)")


def norm(s):
    """Normalize a text name for fuzzy matching: drop diacritics + non-alnum, casefold."""
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))
    return re.sub(r"[^0-9a-z]", "", s.casefold())


def abbr_of(ref):
    return ref.split(",")[0].strip()


def read_2021(path):
    """0.csv -> {text_name: {abbr, n_sent, n_tok, lemmas}}, global lemma set, row count."""
    texts, all_lemmas, n_rows = {}, set(), 0
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            n_rows += 1
            parts = line.rstrip("\n").split(";")
            if len(parts) < 4:
                continue
            name = parts[0].strip().strip('"')
            ids = [int(x) for x in parts[3].split(",") if x.strip().isdigit()]
            t = texts.get(name)
            if t is None:
                t = texts[name] = {"abbr": abbr_of(parts[1]), "n_sent": 0, "n_tok": 0, "lemmas": set()}
            t["n_sent"] += 1
            t["n_tok"] += len(ids)
            t["lemmas"].update(ids)
            all_lemmas.update(ids)
    return texts, all_lemmas, n_rows


def read_2026_texts(root):
    """conllu/files -> {text_name: {abbr, text_id, folder}} (from each folder's first chapter header)."""
    texts = {}
    for d in sorted(os.listdir(root)):
        folder = os.path.join(root, d)
        if not os.path.isdir(folder):
            continue
        files = sorted(f for f in os.listdir(folder) if f.endswith(".conllu"))
        if not files:
            continue
        name, text_id, abbr = d, None, None
        with open(os.path.join(folder, files[0]), encoding="utf-8") as fh:
            for _ in range(8):
                ln = fh.readline()
                if not ln:
                    break
                if ln.startswith("## text_id:"):
                    text_id = ln.split(":", 1)[1].strip()
                elif ln.startswith("## text:"):
                    name = ln.split(":", 1)[1].strip()
                elif ln.startswith("## chapter:"):
                    abbr = abbr_of(ln.split(":", 1)[1].strip())
        texts[name] = {"abbr": abbr, "text_id": text_id, "folder": d}
    return texts


def scan_2026_lemmas(root):
    """Distinct LemmaIds across the whole corpus (fast bytes scan)."""
    lemmas, nfiles = set(), 0
    for dp, _dn, fns in os.walk(root):
        for fn in fns:
            if not fn.endswith(".conllu"):
                continue
            nfiles += 1
            with open(os.path.join(dp, fn), "rb") as fh:
                lemmas.update(int(m) for m in LEMMAID_RE.findall(fh.read()))
            if nfiles % 3000 == 0:
                print(f"    scanned {nfiles} files, {len(lemmas)} distinct lemmas ...", file=sys.stderr)
    return lemmas, nfiles


def pilot_counts(db):
    """dcs.sqlite -> {text_name: (n_sentences, n_tokens)} for the loaded pilot texts."""
    if not os.path.exists(db):
        return {}
    c = sqlite3.connect(db)
    out = {name: (ns, nt) for name, ns, nt in c.execute("""
        SELECT te.name, COUNT(DISTINCT s.sent_id), COUNT(tk.occ_id)
        FROM text te
        JOIN chapter ch ON ch.text_id = te.text_id
        JOIN sentence s ON s.chapter_id = ch.chapter_id
        JOIN token tk ON tk.sent_id = s.sent_id
        GROUP BY te.text_id""")}
    c.close()
    return out


def align(t2021, t2026):
    """Best-effort match 2021->2026: exact name, then normalized name, then abbreviation."""
    by_name = {n: n for n in t2026}
    by_norm, by_abbr = {}, {}
    for n, d in t2026.items():
        by_norm.setdefault(norm(n), n)
        if d["abbr"]:
            by_abbr.setdefault(norm(d["abbr"]), n)
    matched, only2021 = {}, []
    used = set()
    for n, d in t2021.items():
        hit = by_name.get(n) or by_norm.get(norm(n)) or (d["abbr"] and by_abbr.get(norm(d["abbr"])))
        if hit:
            matched[n] = hit
            used.add(hit)
        else:
            only2021.append(n)
    only2026 = [n for n in t2026 if n not in used]
    return matched, only2021, only2026


def md_list(items, n=40):
    items = sorted(items)
    s = "".join(f"- {x}\n" for x in items[:n])
    if len(items) > n:
        s += f"- … and {len(items) - n} more\n"
    return s or "- (none)\n"


def main():
    if not os.path.isfile(REL_2021):
        print(f"ERROR: 2021 export not found: {REL_2021}", file=sys.stderr)
        return 2
    print("reading 2021 export (0.csv) ...")
    t2021, lem2021, rows2021 = read_2021(REL_2021)
    print(f"  {len(t2021)} texts, {rows2021} sentence rows, {len(lem2021)} distinct lemmas")

    print("reading 2026 text list (conllu headers) ...")
    t2026 = read_2026_texts(CONLLU_ROOT)
    print(f"  {len(t2026)} texts")

    print("scanning 2026 corpus for distinct LemmaIds ...")
    lem2026, nfiles = scan_2026_lemmas(CONLLU_ROOT)
    print(f"  {nfiles} files, {len(lem2026)} distinct lemmas")

    pc = pilot_counts(DB)
    matched, only2021, only2026 = align(t2021, t2026)

    overlap = lem2021 & lem2026
    out_lines = []
    w = out_lines.append
    w("# DCS coverage diff — 2021 relational export vs. 2026 CoNLL-U\n")
    w("_Generated by `coverage_diff.py` (M3). Texts matched best-effort: exact name → "
      "normalized name → reference abbreviation._\n")
    w("## Summary\n")
    w("| | 2021 (relational) | 2026 (CoNLL-U) |")
    w("|---|---:|---:|")
    w(f"| texts | {len(t2021)} | {len(t2026)} |")
    w(f"| distinct attested lemmas (by LemmaId) | {len(lem2021):,} | {len(lem2026):,} |")
    w(f"| 0.csv sentence rows | {rows2021:,} | — |\n")

    w("## Text coverage\n")
    w(f"- **Matched:** {len(matched)} of {len(t2021)} 2021 texts found a 2026 counterpart.")
    w(f"- **Only in 2021 (dropped from / renamed in 2026):** {len(only2021)}")
    w(f"- **Only in 2026 (added since 2021):** {len(only2026)}\n")
    w("### Added in 2026 (only-2026)\n")
    w(md_list(only2026))
    w("\n### Only in 2021 (no 2026 match)\n")
    w(md_list(only2021))

    w("\n## Lemma coverage (by LemmaId — exact cross-walk)\n")
    w(f"- 2021 attested: **{len(lem2021):,}**  ·  2026 attested: **{len(lem2026):,}**")
    w(f"- shared (overlap): **{len(overlap):,}**")
    w(f"- only in 2021: **{len(lem2021 - lem2026):,}**  ·  only in 2026: **{len(lem2026 - lem2021):,}**")
    pct = 100.0 * len(overlap) / len(lem2021 | lem2026) if (lem2021 | lem2026) else 0
    w(f"- Jaccard overlap: **{pct:.1f}%** of the union is shared.\n")

    w("## Per-text count deltas (pilot)\n")
    w("2021 counts are sentence rows / token-ID counts from `0.csv`; 2026 counts are from "
      "`dcs.sqlite`. Sentence counts differ structurally — one 2021 metrical line maps to several "
      "CoNLL-U sentences.\n")
    w("| text | 2021 sent | 2026 sent | 2021 tok | 2026 tok | note |")
    w("|---|---:|---:|---:|---:|---|")
    for name in sorted(pc):
        s26, t26 = pc[name]
        # find the 2021 entry whose match == this 2026 name
        src = next((n for n, m in matched.items() if m == name), None)
        d21 = t2021.get(src) if src else None
        s21 = d21["n_sent"] if d21 else "—"
        t21 = d21["n_tok"] if d21 else "—"
        note = "Ṛgveda capped at 80 files in pilot" if name.startswith("Ṛgveda") else ("" if d21 else "not in 2021")
        w(f"| {name} | {s21} | {s26} | {t21} | {t26} | {note} |")

    w("\n## Method & caveats\n")
    w("- **Lemma cross-walk is exact** — `0.csv`'s integer ID lists are the CoNLL-U `LemmaId`s.\n"
      "- **Text matching** is best-effort; review the only-2021 list for renames vs. genuine drops.\n"
      "- **Counts** are pilot-only on the 2026 side (M6 builds the full master); Ṛgveda is capped.\n"
      "- Lemma coverage is corpus-wide on both sides (all 2021 texts; all 2026 texts).\n")

    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out_lines) + "\n")
    print(f"\nwrote {os.path.relpath(OUT, HERE)}")
    print(f"  texts 2021/2026: {len(t2021)}/{len(t2026)}  | matched {len(matched)}  | "
          f"added {len(only2026)}  | only-2021 {len(only2021)}")
    print(f"  lemmas 2021/2026: {len(lem2021)}/{len(lem2026)}  | shared {len(overlap)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
