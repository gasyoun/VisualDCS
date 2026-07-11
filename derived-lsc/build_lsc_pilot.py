#!/usr/bin/env python
r"""Sanskrit lexical semantic change (LSC) pilot — SemEval-2020-Task-1 shape (H728).

First LSC derivation for Sanskrit (the ACL Anthology's 81-paper LSC family contains
zero Sanskrit work as of 11-07-2026; see Uprava/ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md).

Data (all local, canonical — nothing re-derived):
  * contexts:  ../../dcs-conllu/files/**/*.conllu  (DCS gold lemmatization, IAST lemmas)
  * dating:    ../../dcs-conllu/lookup/chapter-info.xml  <dcsTimeSlot> per chapter,
               DCS's own 5-slot chronology (anchored empirically, see README):
               1 Vedic · 2 Epic/early · 3 Classical · 4 Medieval · 5 Late/early-modern
  * (baseline cross-check: kosha data/frequency/lemma_frequency.tsv per-period vectors)

Method (deterministic, count-based — no neural components, per the house
offline/versioned invariant and csl-atlas H662's embedding-lane rule):
  1. Per time slot, build lemma co-occurrence counts (bag-of-sentence contexts,
     context vocabulary = top CONTEXT_DIM lemmas by whole-corpus count, shared
     across slots so vector spaces are aligned by construction).
  2. PPMI-weight each slot's vectors.
  3. Graded change score for a lemma between two slots = cosine DISTANCE between
     its PPMI vectors (0 = same distributional profile, 1 = orthogonal).
  4. Binary change flag = top quartile of the graded score among scoreable lemmas
     (threshold heuristic pending a ChiWUG-style human-judged gold; documented).
  5. Frequency-shift baseline = |log2 relative-frequency ratio| between the slots
     (controls that the graded score is not a pure frequency artifact; Spearman
     rho between the two rankings is reported).

Scoreability: a lemma is scored for slot pair (i, j) iff it has >= MIN_COUNT
tokens in BOTH slots. Primary pair = (1, 2) Vedic->Epic (the two largest slots and
the classic Vedic->post-Vedic semantic frontier); also reported: (2, 3), (3, 4),
(4, 5), (1, 5).

Outputs (written next to this script):
  lsc_scores.tsv    every lemma scoreable on >= 1 reported pair
  lsc_targets.tsv   frequency-stratified 60-lemma target set for the primary pair
  lsc_stats.json    per-slot token/vocab totals, thresholds, rho, provenance

Run from the VisualDCS repo root (dcs-conllu checked out as a sibling):
    python derived-lsc/build_lsc_pilot.py
    python derived-lsc/build_lsc_pilot.py --selftest
"""
import argparse
import collections
import json
import math
import os
import sys
import xml.etree.ElementTree as ET

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(HERE)
DCS = os.path.normpath(os.path.join(REPO, "..", "dcs-conllu"))
SUTIL = os.path.normpath(os.path.join(REPO, "..", "sanskrit-util", "py"))
sys.path.insert(0, SUTIL)
from sanskrit_util import to_slp1  # canonical transcoder — never re-derive

CONTEXT_DIM = 5000
MIN_COUNT = 50
PAIRS = [(1, 2), (2, 3), (3, 4), (4, 5), (1, 5)]
PRIMARY = (1, 2)
SLOTS = [1, 2, 3, 4, 5]
SLOT_LABEL = {1: "Vedic", 2: "Epic", 3: "Classical", 4: "Medieval", 5: "Late"}
SKIP_UPOS = {"PUNCT", "X"}


def iter_sentences():
    """Yield (slot, [lemma, ...]) per sentence across the whole DCS corpus."""
    info = ET.parse(os.path.join(DCS, "lookup", "chapter-info.xml"))
    for ch in info.getroot().iter("chapter"):
        slot = ch.findtext("dcsTimeSlot")
        if slot not in {"1", "2", "3", "4", "5"}:
            continue
        slot = int(slot)
        path = os.path.join(DCS, "files", ch.findtext("path"))
        if not os.path.exists(path):
            continue
        sent = []
        with open(path, encoding="utf-8") as f:
            for line in f:
                if line.startswith("#"):
                    continue
                line = line.rstrip("\n")
                if not line:
                    if sent:
                        yield slot, sent
                        sent = []
                    continue
                cols = line.split("\t")
                if len(cols) < 4 or "-" in cols[0] or "." in cols[0]:
                    continue  # multiword range / empty node
                lemma, upos = cols[2], cols[3]
                if lemma in ("_", "") or upos in SKIP_UPOS:
                    continue
                sent.append(lemma)
        if sent:
            yield slot, sent


def pass1():
    """Whole-corpus and per-slot lemma counts."""
    total = collections.Counter()
    per_slot = {s: collections.Counter() for s in SLOTS}
    slot_tokens = collections.Counter()
    n_sent = 0
    for slot, sent in iter_sentences():
        n_sent += 1
        slot_tokens[slot] += len(sent)
        for lem in sent:
            total[lem] += 1
            per_slot[slot][lem] += 1
    return total, per_slot, slot_tokens, n_sent


def pass2(context_ids, row_ids):
    """Per-slot (row, context) co-occurrence counts, bag-of-sentence."""
    cooc = {s: collections.Counter() for s in SLOTS}
    row_totals = {s: collections.Counter() for s in SLOTS}
    ctx_totals = {s: collections.Counter() for s in SLOTS}
    grand = collections.Counter()
    for slot, sent in iter_sentences():
        ctx_in_sent = [context_ids[l] for l in sent if l in context_ids]
        if not ctx_in_sent:
            continue
        ctx_count = collections.Counter(ctx_in_sent)
        for pos, lem in enumerate(sent):
            r = row_ids.get(lem)
            if r is None:
                continue
            c_self = context_ids.get(lem)
            for c, k in ctx_count.items():
                k_eff = k - 1 if c == c_self else k  # a token is not its own context
                if k_eff <= 0:
                    continue
                cooc[slot][(r, c)] += k_eff
                row_totals[slot][r] += k_eff
                ctx_totals[slot][c] += k_eff
                grand[slot] += k_eff
    return cooc, row_totals, ctx_totals, grand


def build_row_index(cooc):
    """Index co-occurrence counters by row for fast per-lemma access."""
    by_row = {s: collections.defaultdict(dict) for s in cooc}
    for s, ctr in cooc.items():
        for (r, c), x in ctr.items():
            by_row[s][r][c] = x
    return by_row


def ppmi(by_row, slot, r, row_totals, ctx_totals, grand):
    n = grand[slot]
    rt = row_totals[slot].get(r, 0)
    if rt == 0 or n == 0:
        return {}
    out = {}
    for c, x in by_row[slot].get(r, {}).items():
        ct = ctx_totals[slot][c]
        val = math.log((x * n) / (rt * ct))
        if val > 0:
            out[c] = val
    return out


def cos_dist(a, b):
    if not a or not b:
        return None
    dot = sum(w * b[c] for c, w in a.items() if c in b)
    na = math.sqrt(sum(w * w for w in a.values()))
    nb = math.sqrt(sum(w * w for w in b.values()))
    if na == 0 or nb == 0:
        return None
    return 1.0 - dot / (na * nb)


def spearman(xs, ys):
    def rank(v):
        order = sorted(range(len(v)), key=lambda i: v[i])
        rk = [0.0] * len(v)
        i = 0
        while i < len(order):
            j = i
            while j + 1 < len(order) and v[order[j + 1]] == v[order[i]]:
                j += 1
            avg = (i + j) / 2.0 + 1
            for k in range(i, j + 1):
                rk[order[k]] = avg
            i = j + 1
        return rk
    rx, ry = rank(xs), rank(ys)
    n = len(xs)
    mx, my = sum(rx) / n, sum(ry) / n
    num = sum((rx[i] - mx) * (ry[i] - my) for i in range(n))
    den = math.sqrt(sum((r - mx) ** 2 for r in rx) * sum((r - my) ** 2 for r in ry))
    return num / den if den else 0.0


def selftest():
    a = {1: 1.0, 2: 1.0}
    assert abs(cos_dist(a, a)) < 1e-12
    assert abs(cos_dist({1: 1.0}, {2: 1.0}) - 1.0) < 1e-12
    assert abs(spearman([1, 2, 3, 4], [10, 20, 30, 40]) - 1.0) < 1e-12
    assert abs(spearman([1, 2, 3, 4], [40, 30, 20, 10]) + 1.0) < 1e-12
    assert to_slp1("kāntā") == "kAntA"
    print("selftest OK (5 checks)")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    if args.selftest:
        selftest()
        return

    print("pass 1: counting ...", flush=True)
    total, per_slot, slot_tokens, n_sent = pass1()
    print(f"  {n_sent} sentences, {sum(slot_tokens.values())} tokens, "
          f"{len(total)} distinct lemmas", flush=True)
    for s in SLOTS:
        print(f"  slot {s} ({SLOT_LABEL[s]}): {slot_tokens[s]} tokens, "
              f"{len(per_slot[s])} lemmas", flush=True)

    contexts = [l for l, _ in total.most_common(CONTEXT_DIM)]
    context_ids = {l: i for i, l in enumerate(contexts)}
    rows = sorted(
        l for l in total
        if sum(1 for s in SLOTS if per_slot[s][l] >= MIN_COUNT) >= 2)
    row_ids = {l: i for i, l in enumerate(rows)}
    print(f"  context dim {len(contexts)}, scoreable rows {len(rows)}", flush=True)

    print("pass 2: co-occurrence ...", flush=True)
    cooc, row_totals, ctx_totals, grand = pass2(context_ids, row_ids)
    by_row = build_row_index(cooc)

    print("scoring ...", flush=True)
    vec_cache = {}

    def vec(slot, r):
        key = (slot, r)
        if key not in vec_cache:
            vec_cache[key] = ppmi(by_row, slot, r, row_totals, ctx_totals, grand)
        return vec_cache[key]

    out_rows = []
    for lem in rows:
        r = row_ids[lem]
        counts = {s: per_slot[s][lem] for s in SLOTS}
        rec = {"lemma_iast": lem, "lemma_slp1": to_slp1(lem)}
        for s in SLOTS:
            rec[f"n{s}"] = counts[s]
        any_pair = False
        for i, j in PAIRS:
            key = f"dist_{i}{j}"
            if counts[i] >= MIN_COUNT and counts[j] >= MIN_COUNT:
                d = cos_dist(vec(i, r), vec(j, r))
                rec[key] = round(d, 6) if d is not None else ""
                any_pair = any_pair or d is not None
                fi = counts[i] / slot_tokens[i]
                fj = counts[j] / slot_tokens[j]
                rec[f"fshift_{i}{j}"] = round(abs(math.log2(fj / fi)), 6)
            else:
                rec[key] = ""
                rec[f"fshift_{i}{j}"] = ""
        if any_pair:
            out_rows.append(rec)

    # primary-pair grading + binary flag
    pi, pj = PRIMARY
    pk = f"dist_{pi}{pj}"
    primary = [r for r in out_rows if r[pk] != ""]
    primary.sort(key=lambda r: -r[pk])
    q75 = primary[len(primary) // 4][pk] if primary else None
    for rank, r in enumerate(primary, 1):
        r["graded_rank_12"] = rank
        r["binary_changed_12"] = 1 if r[pk] >= q75 else 0
    for r in out_rows:
        r.setdefault("graded_rank_12", "")
        r.setdefault("binary_changed_12", "")

    rho = spearman([r[pk] for r in primary],
                   [r[f"fshift_{pi}{pj}"] for r in primary]) if primary else None

    # stratified 60 targets on the primary pair: 20 per frequency tercile
    # (by min(n1, n2)), each tercile's 10 highest + 10 lowest graded scores.
    targets = []
    if primary:
        by_freq = sorted(primary, key=lambda r: -min(r["n1"], r["n2"]))
        terc = max(1, len(by_freq) // 3)
        for t in range(3):
            band = by_freq[t * terc: (t + 1) * terc] if t < 2 else by_freq[2 * terc:]
            band = sorted(band, key=lambda r: -r[pk])
            picked = band[:10] + band[-10:] if len(band) >= 20 else band
            for r in picked:
                targets.append({**r, "freq_tercile": t + 1})

    cols = (["lemma_iast", "lemma_slp1"] + [f"n{s}" for s in SLOTS]
            + [f"dist_{i}{j}" for i, j in PAIRS]
            + [f"fshift_{i}{j}" for i, j in PAIRS]
            + ["graded_rank_12", "binary_changed_12"])

    def write_tsv(path, recs, extra=()):
        cs = cols + list(extra)
        with open(path, "w", encoding="utf-8", newline="\n") as f:
            f.write("\t".join(cs) + "\n")
            for r in recs:
                f.write("\t".join(str(r.get(c, "")) for c in cs) + "\n")

    write_tsv(os.path.join(HERE, "lsc_scores.tsv"), out_rows)
    write_tsv(os.path.join(HERE, "lsc_targets.tsv"), targets, ("freq_tercile",))

    stats = {
        "built": "H728, Fable 5 (claude-fable-5)",
        "corpus": "dcs-conllu (DCS gold lemmatization), dating chapter-info.xml dcsTimeSlot",
        "sentences": n_sent,
        "tokens_per_slot": {f"{s} {SLOT_LABEL[s]}": slot_tokens[s] for s in SLOTS},
        "distinct_lemmas": len(total),
        "context_dim": len(contexts),
        "min_count": MIN_COUNT,
        "scoreable_rows": len(rows),
        "rows_written": len(out_rows),
        "primary_pair": f"{pi}({SLOT_LABEL[pi]})->{pj}({SLOT_LABEL[pj]})",
        "primary_scored": len(primary),
        "binary_threshold_q75_dist": q75,
        "spearman_dist_vs_fshift_primary": round(rho, 4) if rho is not None else None,
        "targets": len(targets),
    }
    with open(os.path.join(HERE, "lsc_stats.json"), "w", encoding="utf-8") as f:
        json.dump(stats, f, ensure_ascii=False, indent=1)
    print(json.dumps(stats, ensure_ascii=False, indent=1))
    print("top-15 primary-pair graded changes:")
    for r in primary[:15]:
        print(f"  {r['lemma_iast']:<20} dist={r[pk]:.4f} n1={r['n1']} n2={r['n2']}")


if __name__ == "__main__":
    main()
