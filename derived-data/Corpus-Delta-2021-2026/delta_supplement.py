#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
delta_supplement.py — H686 supplement: DCS 2021 relational export vs 2026 CoNLL-U
master, full-corpus delta statistics. Complements delta_stats.py / REPORT.md (the
primary H686 pass, PR #37) with an independent replication plus three additions:
per-10k rate drift (vs rank drift), a per-text token delta over ALL matched texts,
and a POS shift computed with ONE shared lexicon applied to both token streams.
Interpretation lives in DRIFT_INTERPRETATION.md.

Inputs (read-only, nothing is re-ingested):
  ../../src/DCS-data-2021/0.csv        sentence rows with LemmaId lists (the exact
                                       cross-walk: those integer IDs ARE the CoNLL-U
                                       LemmaIds — see ../../src/DCS-data-2026/DCS_FORMAT_COMPARISON.md)
  ../../src/DCS-data-2021/_8.csv       2021 lemma frequency list (count, lemma, pos) — cross-check only
  ../../src/DCS-data-2026/dcs_full.sqlite  the full 2026 master (M6)

Outputs (this folder):
  lemma_freq_drift_top200.csv    union of each side's top-200 lemmas, rates per 10k, rank shift
  pos_distribution_shift.csv     token-weighted POS classes, one shared lexicon applied to both sides
  per_text_token_delta.csv       matched texts, 2021 vs 2026 sentence/token counts
  supplement_tables.md           generated tables (embedded into DRIFT_INTERPRETATION.md)

Stdlib only.  python delta_supplement.py
"""

import csv
import os
import re
import sqlite3
import sys
import unicodedata
from collections import Counter

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
CSV_2021 = os.path.join(HERE, "..", "..", "src", "DCS-data-2021", "0.csv")
FREQ_2021 = os.path.join(HERE, "..", "..", "src", "DCS-data-2021", "_8.csv")
DB_2026 = os.path.join(HERE, "..", "..", "src", "DCS-data-2026", "dcs_full.sqlite")

TOP_N = 200


def norm(s):
    """Normalize a text name for fuzzy matching (same rule as coverage_diff.py M3)."""
    s = unicodedata.normalize("NFD", s)
    s = "".join(c for c in s if not unicodedata.combining(c))
    return re.sub(r"[^0-9a-z]", "", s.casefold())


VERB_RE = re.compile(r"(\d+\s*\.\s*(P|Ā|A)\b)|Denom|Intens|Desid|Caus")
NOUN_RE = re.compile(r"^[mfn]+$")


def pos_class(grammar):
    """Coarse POS class from a DCS lexicon grammar label (shared by both snapshots)."""
    if not grammar:
        return "unlabelled"
    g = grammar.strip().strip(".")
    if NOUN_RE.match(g):
        return "noun"
    if g == "adj":
        return "adjective"
    if g == "pron":
        return "pronoun"
    if g == "ind":
        return "indeclinable"
    if VERB_RE.search(grammar):
        return "verbal root"
    if g in ("num", "card", "ord"):
        return "numeral"
    return "other"


def read_2021():
    """0.csv -> per-text stats, corpus-wide LemmaId occurrence counter, row count."""
    texts, occ, n_rows = {}, Counter(), 0
    with open(CSV_2021, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            n_rows += 1
            parts = line.rstrip("\n").split(";")
            if len(parts) < 4:
                continue
            name = parts[0].strip().strip('"')
            ids = [int(x) for x in parts[3].split(",") if x.strip().isdigit()]
            t = texts.setdefault(name, {"abbr": parts[1].split(",")[0].strip(),
                                        "n_sent": 0, "n_tok": 0})
            t["n_sent"] += 1
            t["n_tok"] += len(ids)
            occ.update(ids)
    return texts, occ, n_rows


def read_2021_own_lexicon_pos():
    """_8.csv (count, lemma, pos) -> token-weighted POS classes per the 2021 lexicon itself."""
    dist = Counter()
    with open(FREQ_2021, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(",")
            if len(parts) < 3 or not parts[0].isdigit():
                continue
            dist[pos_class(parts[-1])] += int(parts[0])
    return dist


def main():
    print("reading 2021 export (0.csv) ...")
    t21, occ21, rows21 = read_2021()
    tok21 = sum(occ21.values())
    print(f"  {len(t21)} texts, {rows21:,} sentence rows, {tok21:,} tokens, "
          f"{len(occ21):,} distinct lemmas")

    print("reading 2026 master (dcs_full.sqlite) ...")
    db = sqlite3.connect(DB_2026)
    n_texts26, n_sent26, n_tok26 = db.execute(
        "SELECT (SELECT COUNT(*) FROM text), (SELECT COUNT(*) FROM sentence),"
        " (SELECT COUNT(*) FROM token)").fetchone()
    occ26 = Counter(dict(db.execute(
        "SELECT lemma_id, COUNT(*) FROM token WHERE lemma_id IS NOT NULL GROUP BY lemma_id")))
    lex = {lid: (lem or "", gr or "") for lid, lem, gr in db.execute(
        "SELECT lemma_id, lemma, grammar FROM lemma")}
    upos26 = Counter(dict(db.execute("SELECT upos, COUNT(*) FROM token GROUP BY upos")))
    per_text26 = {name: (ns, nt) for name, ns, nt in db.execute("""
        SELECT te.name, COUNT(DISTINCT s.id), COUNT(tk.id)
        FROM text te JOIN chapter ch ON ch.text_id = te.text_id
        JOIN sentence s ON s.chapter_id = ch.chapter_id
        JOIN token tk ON tk.sentence_id = s.id
        GROUP BY te.text_id""")}
    db.close()
    print(f"  {n_texts26} texts, {n_sent26:,} sentences, {n_tok26:,} tokens, "
          f"{len(occ26):,} distinct lemmas")

    # ---- text alignment (M3 rule: exact name -> normalized name -> abbreviation)
    by_norm = {}
    for n in per_text26:
        by_norm.setdefault(norm(n), n)
    matched, only21 = {}, []
    used = set()
    for n, d in t21.items():
        # "Gopathabrāhmaṇa NEW"-style rename suffix: strip a trailing "new" token too
        hit = (n if n in per_text26 else by_norm.get(norm(n))
               or by_norm.get(re.sub(r"new$", "", norm(n)))
               or by_norm.get(norm(d["abbr"])))
        if hit:
            matched[n] = hit
            used.add(hit)
        else:
            only21.append(n)
    only26 = sorted(n for n in per_text26 if n not in used)

    # ---- lemma containment
    shared = set(occ21) & set(occ26)
    lost = set(occ21) - set(occ26)
    lost_in_dict = {i for i in lost if i in lex}
    lost_top = sorted(lost, key=lambda i: -occ21[i])[:15]

    # ---- top-200 lemma frequency drift
    rate21 = {i: occ21[i] * 10000.0 / tok21 for i in occ21}
    rate26 = {i: occ26[i] * 10000.0 / n_tok26 for i in occ26}
    rank21 = {i: r for r, i in enumerate(sorted(occ21, key=lambda i: -occ21[i]), 1)}
    rank26 = {i: r for r, i in enumerate(sorted(occ26, key=lambda i: -occ26[i]), 1)}
    union = {i for i in rank21 if rank21[i] <= TOP_N} | {i for i in rank26 if rank26[i] <= TOP_N}
    drift_rows = []
    for i in sorted(union, key=lambda i: rank26.get(i, 10 ** 9)):
        lemma, grammar = lex.get(i, ("<not in 2026 dictionary>", ""))
        r21, r26 = rate21.get(i, 0.0), rate26.get(i, 0.0)
        drift_rows.append({
            "lemma_id": i, "lemma": lemma, "grammar": grammar,
            "rank_2021": rank21.get(i, ""), "rank_2026": rank26.get(i, ""),
            "freq_2021": occ21.get(i, 0), "freq_2026": occ26.get(i, 0),
            "per10k_2021": round(r21, 3), "per10k_2026": round(r26, 3),
            "delta_per10k": round(r26 - r21, 3),
        })
    with open(os.path.join(HERE, "lemma_freq_drift_top200.csv"), "w",
              encoding="utf-8", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=list(drift_rows[0].keys()))
        wr.writeheader()
        wr.writerows(drift_rows)

    # ---- POS distribution: ONE lexicon (2026 dictionary grammar) applied to both token streams
    pos21, pos26 = Counter(), Counter()
    for i, n in occ21.items():
        pos21[pos_class(lex[i][1] if i in lex else "")] += n
    for i, n in occ26.items():
        pos26[pos_class(lex[i][1] if i in lex else "")] += n
    pos26["unlabelled"] += n_tok26 - sum(occ26.values())  # tokens without lemma_id
    pos21_own = read_2021_own_lexicon_pos()
    pos_rows = []
    for cls in sorted(set(pos21) | set(pos26), key=lambda c: -pos26.get(c, 0)):
        pos_rows.append({
            "pos_class": cls,
            "tokens_2021": pos21.get(cls, 0),
            "pct_2021": round(100.0 * pos21.get(cls, 0) / tok21, 2),
            "tokens_2026": pos26.get(cls, 0),
            "pct_2026": round(100.0 * pos26.get(cls, 0) / n_tok26, 2),
            "delta_pct": round(100.0 * pos26.get(cls, 0) / n_tok26
                               - 100.0 * pos21.get(cls, 0) / tok21, 2),
            "tokens_2021_own_lexicon": pos21_own.get(cls, 0),
        })
    with open(os.path.join(HERE, "pos_distribution_shift.csv"), "w",
              encoding="utf-8", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=list(pos_rows[0].keys()))
        wr.writeheader()
        wr.writerows(pos_rows)

    # ---- per-text deltas (full corpus, not the M3 pilot)
    text_rows = []
    for n21, n26 in sorted(matched.items(), key=lambda kv: kv[0]):
        s26, tk26 = per_text26[n26]
        text_rows.append({
            "text_2021": n21, "text_2026": n26,
            "sent_2021": t21[n21]["n_sent"], "sent_2026": s26,
            "tok_2021": t21[n21]["n_tok"], "tok_2026": tk26,
            "tok_delta": tk26 - t21[n21]["n_tok"],
        })
    for n in only26:
        s26, tk26 = per_text26[n]
        text_rows.append({"text_2021": "", "text_2026": n, "sent_2021": "",
                          "sent_2026": s26, "tok_2021": "", "tok_2026": tk26,
                          "tok_delta": ""})
    for n in sorted(only21):
        text_rows.append({"text_2021": n, "text_2026": "", "sent_2021": t21[n]["n_sent"],
                          "sent_2026": "", "tok_2021": t21[n]["n_tok"], "tok_2026": "",
                          "tok_delta": ""})
    with open(os.path.join(HERE, "per_text_token_delta.csv"), "w",
              encoding="utf-8", newline="") as fh:
        wr = csv.DictWriter(fh, fieldnames=list(text_rows[0].keys()))
        wr.writeheader()
        wr.writerows(text_rows)

    shrunk = [r for r in text_rows if r["tok_delta"] != "" and r["tok_delta"] < 0]

    # ---- generated markdown tables
    out = []
    w = out.append
    w("### Corpus growth\n")
    w("| | 2021 (relational export) | 2026 (CoNLL-U master) | delta |")
    w("|---|---:|---:|---:|")
    w(f"| texts | {len(t21)} | {n_texts26} | +{n_texts26 - len(t21)} |")
    w(f"| sentences | {rows21:,} (metrical/prose lines) | {n_sent26:,} (re-segmented) | "
      f"not comparable 1:1 |")
    w(f"| tokens | {tok21:,} | {n_tok26:,} | +{n_tok26 - tok21:,} "
      f"({100.0 * (n_tok26 - tok21) / tok21:.1f}%) |")
    w(f"| distinct attested lemmas | {len(occ21):,} | {len(occ26):,} | "
      f"+{len(occ26) - len(occ21):,} |")
    w(f"| texts matched / only-2021 / only-2026 | | | {len(matched)} / {len(only21)} / "
      f"{len(only26)} |")
    w("")
    w("### Lemma containment\n")
    w(f"- shared attested lemmas: **{len(shared):,}** "
      f"({100.0 * len(shared) / len(occ21):.1f}% of 2021 attested)")
    w(f"- attested only in 2021: **{len(lost):,}** "
      f"(tokens: {sum(occ21[i] for i in lost):,}; "
      f"{len(lost_in_dict):,} still in the 2026 dictionary, "
      f"{len(lost) - len(lost_in_dict):,} gone from it)")
    w(f"- attested only in 2026: **{len(occ26) - len(shared):,}**")
    w("- highest-frequency only-2021 lemmas: "
      + ", ".join(f"{lex.get(i, ('<gone>',''))[0] or '<gone>'} ({occ21[i]})" for i in lost_top))
    w("")
    w("### Top-20 lemmas, frequency drift (per 10k tokens)\n")
    w("| 2026 rank | lemma | grammar | per10k 2021 | per10k 2026 | Δ per10k | rank 2021 |")
    w("|---:|---|---|---:|---:|---:|---:|")
    for r in drift_rows[:20]:
        w(f"| {r['rank_2026']} | {r['lemma']} | {r['grammar']} | {r['per10k_2021']} | "
          f"{r['per10k_2026']} | {r['delta_per10k']:+} | {r['rank_2021']} |")
    w("")
    movers = sorted((r for r in drift_rows), key=lambda r: -abs(r["delta_per10k"]))[:15]
    w("### Biggest rate movers in the top-200 union\n")
    w("| lemma | grammar | per10k 2021 | per10k 2026 | Δ per10k |")
    w("|---|---|---:|---:|---:|")
    for r in movers:
        w(f"| {r['lemma']} | {r['grammar']} | {r['per10k_2021']} | {r['per10k_2026']} | "
          f"{r['delta_per10k']:+} |")
    w("")
    w("### POS distribution shift (token-weighted, one shared lexicon)\n")
    w("| POS class | 2021 tokens | 2021 % | 2026 tokens | 2026 % | Δ pp |")
    w("|---|---:|---:|---:|---:|---:|")
    for r in pos_rows:
        w(f"| {r['pos_class']} | {r['tokens_2021']:,} | {r['pct_2021']} | "
          f"{r['tokens_2026']:,} | {r['pct_2026']} | {r['delta_pct']:+} |")
    w("")
    w("### 2026 native UD UPOS distribution (no 2021 counterpart)\n")
    w("| UPOS | tokens | % |")
    w("|---|---:|---:|")
    for u, n in upos26.most_common():
        w(f"| {u} | {n:,} | {100.0 * n / n_tok26:.2f} |")
    w("")
    w(f"### Texts that SHRANK 2021→2026 ({len(shrunk)} of {len(matched)} matched)\n")
    w("| text | tok 2021 | tok 2026 | delta |")
    w("|---|---:|---:|---:|")
    for r in sorted(shrunk, key=lambda r: r["tok_delta"])[:15]:
        w(f"| {r['text_2026']} | {r['tok_2021']:,} | {r['tok_2026']:,} | {r['tok_delta']:,} |")
    if len(shrunk) > 15:
        w(f"| … and {len(shrunk) - 15} more (see per_text_token_delta.csv) | | | |")
    w("")
    w("### Only-2021 texts (no 2026 match)\n")
    for n in sorted(only21):
        w(f"- {n} ({t21[n]['n_tok']:,} tokens)")
    w("")

    with open(os.path.join(HERE, "supplement_tables.md"), "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")
    print("wrote supplement_tables.md + 3 CSVs")
    print(f"  cross-check: _8.csv token total = {sum(pos21_own.values()):,} "
          f"vs 0.csv-derived = {tok21:,}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
