#!/usr/bin/env python3
"""Build the two-tier ligature canon: union table + coverage curve (H6391).

MG ruling 10-10-2026 (A1, Uprava/reports/LIGATURE_TEACHING_GRILL_DECISIONS_10-10-2026.md):
DCS-999 sets the teaching order; the union of four inventories is ONE artifact.
Teaching order = DCS frequency (fence — unchanged by this script).

Inputs (all committed — no network, no yadisk, no corpus needed):
  sources/ustavchat_appendix.csv  — «Сводный список лигатур», ustav-chat appendix
      (788 measured entries; the «~280» figure is the pre-revolutionary textbook's
      nominal quote, not the appendix size)
  sources/attested807.csv         — Zimmermann Liste-807 (789 distinct of 807 lines;
      18 duplicate tokens in the legacy file)
  sources/rigveda460.csv          — Zimmermann Rigveda list (460 distinct + counts)
  ../regen-2026/ligature_freq.csv — DCS-observed 999 conjuncts, 3,265,549 tokens

Outputs (byte-deterministic: same inputs -> same bytes, LF, UTF-8, no BOM):
  ligature_canon_union.csv — every distinct conjunct from the four inventories;
      row = conjunct (IAST/SLP1/HK + Devanāgarī joined & halant), source flags,
      Rigveda count, DCS rank/count/pct; sorted by DCS rank (unobserved last, by IAST)
  coverage_topn.tsv — cumulative coverage curve: top-N ligatures vs % of the
      3,265,549 ligature tokens (and % of the 4,240,775 corpus words)

Verify: python3 build_ligature_canon.py && git diff --exit-code -- . && echo DETERMINISTIC
"""
import csv
import os
import sys
import unicodedata

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")
from indic_transliteration import sanscript
from indic_transliteration.sanscript import transliterate as tr

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "sources")
REGEN = os.path.join(os.path.dirname(HERE), "regen-2026")

LIG_TOKENS = 3_265_549   # DCS ligature occurrences (regen-2026 provenance.json)
CORPUS_WORDS = 4_240_775  # DCS corpus words (regen-2026 provenance.json)


def read(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f))


def norm(s):
    return unicodedata.normalize("NFC", s.strip())


def render(iast):
    """IAST consonant cluster -> slp1, devanagari (joined) + halant form."""
    slp1 = tr(iast, sanscript.IAST, sanscript.SLP1)
    joined = tr(slp1 + "a", sanscript.SLP1, sanscript.DEVANAGARI)
    halant = tr(slp1, sanscript.SLP1, sanscript.DEVANAGARI)
    return slp1, joined, halant


def main():
    ustav = {norm(r["iast"]): r for r in read(os.path.join(SRC, "ustavchat_appendix.csv"))}
    att = {norm(r["iast"]) for r in read(os.path.join(SRC, "attested807.csv"))}
    rigv = {norm(r["iast"]): int(r["rigveda_count"])
            for r in read(os.path.join(SRC, "rigveda460.csv"))}
    dcs_rows = read(os.path.join(REGEN, "ligature_freq.csv"))
    dcs = {norm(r["iast"]): (i, r) for i, r in enumerate(dcs_rows, 1)}

    all_keys = sorted(set(ustav) | att | set(rigv) | set(dcs),
                      key=lambda k: (dcs.get(k, (10 ** 9,))[0], k))

    out_rows = []
    for k in all_keys:
        if k in dcs:
            rank, r = dcs[k]
            slp1, joined, halant = r["slp1"], r["devanagari"], r["devanagari_halant"]
            ncons = int(r["n_consonants"])
            count, pct = int(r["count"]), float(r["pct"])
        else:
            rank = None
            slp1, joined, halant = render(k)
            ncons = len(slp1)
            count, pct = 0, 0.0
        src = {"ustavchat_appendix": k in ustav, "attested807": k in att,
               "rigveda460": k in rigv, "dcs999": k in dcs}
        out_rows.append({
            "iast": k, "slp1": slp1,
            "hk": tr(slp1, sanscript.SLP1, sanscript.HK),
            "devanagari": joined, "devanagari_halant": halant,
            "n_consonants": ncons,
            "in_ustavchat_appendix": int(src["ustavchat_appendix"]),
            "in_attested807": int(src["attested807"]),
            "in_rigveda460": int(src["rigveda460"]),
            "in_dcs999": int(src["dcs999"]),
            "n_sources": sum(src.values()),
            "rigveda_count": rigv.get(k, ""),
            "dcs_rank": rank if rank is not None else "",
            "dcs_count": count if count else "",
            "dcs_pct": f"{pct:.4f}" if count else "",
        })

    fields = list(out_rows[0].keys())
    with open(os.path.join(HERE, "ligature_canon_union.csv"), "w", newline="",
              encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields, lineterminator="\n")
        w.writeheader()
        w.writerows(out_rows)

    # ---- coverage curve: top-N vs cumulative % of ligature tokens ------------
    counts = [int(r["count"]) for r in dcs_rows]
    ladder = sorted({10, 20, 25, 30, 50, 100, 150, 200, 250, 280, 300, 417, 460,
                     500, 750, 788, 789, 900, 999} | {len(counts)})
    cov = [["top_n", "cumulative_count", "cumulative_pct_of_ligature_tokens",
            "cumulative_pct_of_corpus_words"]]
    for n in ladder:
        if n > len(counts):
            continue
        cum = sum(counts[:n])
        cov.append([n, cum, f"{100.0 * cum / LIG_TOKENS:.2f}",
                    f"{100.0 * cum / CORPUS_WORDS:.2f}"])
    with open(os.path.join(HERE, "coverage_topn.tsv"), "w", newline="",
              encoding="utf-8") as f:
        w = csv.writer(f, delimiter="\t", lineterminator="\n")
        w.writerows(cov)

    # ---- self-checks (fail closed) -------------------------------------------
    assert len(out_rows) == len(all_keys), "row count"
    keys = [r["iast"] for r in out_rows]
    assert len(set(keys)) == len(keys), "iast key uniqueness"
    top10 = [r["iast"] for r in out_rows[:10]]
    assert top10 == ["pr", "sy", "tr", "nt", "kṣ", "ty", "rv", "st", "tv", "tt"], top10
    # every DCS count row must be flagged in exactly one dcs999=1 way
    assert sum(1 for r in out_rows if r["in_dcs999"]) == len(dcs_rows)
    assert sum(1 for r in out_rows if r["in_ustavchat_appendix"]) == len(ustav)
    assert sum(1 for r in out_rows if r["in_attested807"]) == len(att)
    assert sum(1 for r in out_rows if r["in_rigveda460"]) == len(rigv)
    print(f"union rows={len(out_rows)} "
          f"(ustav {len(ustav)} / attested {len(att)} / rigveda {len(rigv)} / "
          f"dcs {len(dcs)}); coverage points={len(cov) - 1}")


if __name__ == "__main__":
    main()
