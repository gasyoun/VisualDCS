#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_paradigm_nominal_lemmas.py -- H2321 (per-lemma nominal drill-down trainer).

The per-lemma twin of gen_paradigm_attested.py (H1299 verb trainer) and the
drill-down companion of gen_paradigm_nominal.py (H1472 class-level dashboard).

-- Consume, don't recompute (the H2321 acceptance constraint) -----------------------
  Per-lemma 24-cell COVERAGE is taken verbatim from SanskritGrammar Sangram G2's
  committed lemma_cell_coverage.csv (H1048) -- 57,144 NOUN lemmas, already
  reconciled exactly against this repo's class-level asset (H1472 report
  reports/nominal_g2_reconciliation.md). This script NEVER re-derives which
  cells are attested: the G2 bitstring is the oracle. Forms and per-cell token
  counts come from the pinned dcs_full.sqlite, and only for cells G2 already
  marks attested. A form found in a G2-zero cell is counted as a recon mismatch
  and refused (it would mean our pin and G2's pin disagree).

-- Discipline -----------------------------------------------------------------------
  - Universe = G2's: upos='NOUN', 8 real cases, Cpd/NULL excluded. ADJ is out
    of scope here (class dashboard covers it; G2 does not).
  - lemma_id keying (G2 EM7): homonyms are separate rows.
  - stem_final is G2's approximation tag, not a Paninian class.
  - Forms are DCS unsandhied analyses (often reconstructed), never manuscript
    surface text.
  - Frequency floor + top-N tier mirror the verb trainer so the two UIs stay
    parallel for learners.

Output (ONE aggregation pass):
  visual/paradigm_nominal_lemmas.json
  visual/paradigm_nominal_lemmas_data.js   window.PARADIGM_NOMINAL_LEMMAS = ...
  reports/paradigm_nominal_lemmas_build.md

Stdlib only. Run from repo root:
  python src/DCS-data-2026/gen_paradigm_nominal_lemmas.py [--db PATH] [--floor N] [--top N]
"""
from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
import sqlite3
import sys
from collections import defaultdict

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
GITHUB = os.path.abspath(os.path.join(REPO, ".."))

DEFAULT_DB = os.path.join(HERE, "dcs_full.sqlite")
# Fallback: main-checkout path when running from a linked worktree that has no
# local copy of the gitignored master (worktrees do not share untracked files).
MAIN_DB_FALLBACK = os.path.join(GITHUB, "VisualDCS", "src", "DCS-data-2026", "dcs_full.sqlite")
G2_CSV = os.path.join(
    GITHUB, "SanskritGrammar", "sangram", "data",
    "declension_cell_coverage", "lemma_cell_coverage.csv",
)
OUT_JSON = os.path.join(REPO, "visual", "paradigm_nominal_lemmas.json")
OUT_JS = os.path.join(REPO, "visual", "paradigm_nominal_lemmas_data.js")
OUT_REPORT = os.path.join(REPO, "reports", "paradigm_nominal_lemmas_build.md")

SCHEMA_VERSION = "1.0.0"
CASES = ["Nom", "Acc", "Ins", "Dat", "Abl", "Gen", "Loc", "Voc"]
NUMBERS = ["Sing", "Dual", "Plur"]
# G2 row-major order -- bit i of cells_bits24 corresponds to CELLS[i].
CELLS = [f"{c}.{n}" for c in CASES for n in NUMBERS]
TOP_FORMS_PER_CELL = 5
DEFAULT_FLOOR = 2
DEFAULT_TOP = 100  # "full" tier boundary, same shape as the verb trainer

CEILING_NOTE = (
    "Per-lemma cell coverage is Sangram G2's committed lemma_cell_coverage.csv "
    "(H1048), not re-derived here: 57,144 NOUN lemmas on the pinned DCS-2026 "
    "master, 8 case x 3 number = 24 cells, Cpd excluded. Forms and per-cell "
    "token counts are filled from dcs_full.sqlite ONLY for cells G2 marks "
    "attested. stem_final is G2's citation-form approximation (not a paradigm "
    "class). The form shown is DCS's unsandhied analysis, often reconstructed. "
    "Median cells/lemma is 1; a full 24-cell paradigm is almost never attested "
    "(0.0% of lemmas). Frequency floor and top-N tier mirror the verb trainer; "
    "hapax lemmas below the floor are omitted from the trainer asset but remain "
    "in G2."
)


def sha256_file(path, chunk=4 * 1024 * 1024):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for block in iter(lambda: fh.read(chunk), b""):
            h.update(block)
    return h.hexdigest()


def load_g2(path):
    """G2 CSV -> {lemma_id: rowdict} with typed fields. Oracle for coverage."""
    out = {}
    with open(path, encoding="utf-8") as fh:
        for row in csv.DictReader(fh):
            lid = int(row["lemma_id"])
            bits = row["cells_bits24"]
            if len(bits) != 24 or any(b not in "01" for b in bits):
                raise SystemExit(
                    f"ERROR: G2 lemma_id={lid} has malformed cells_bits24={bits!r}"
                )
            out[lid] = {
                "lemma_id": lid,
                "lemma": row["lemma"],
                "dom_gender": row["dom_gender"],
                "stem_final": row["stem_final"],
                "tokens": int(row["tokens"]),
                "cells_attested": int(row["cells_attested"]),
                "cells_bits24": bits,
            }
    return out


def resolve_db(path):
    if os.path.exists(path):
        return path
    if path == DEFAULT_DB and os.path.exists(MAIN_DB_FALLBACK):
        print(f"  note: using main-checkout master at {MAIN_DB_FALLBACK}")
        return MAIN_DB_FALLBACK
    return path


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("--g2", default=G2_CSV)
    ap.add_argument("--floor", type=int, default=DEFAULT_FLOOR,
                    help="minimum G2 token count for admission (default 2, matches verb trainer)")
    ap.add_argument("--top", type=int, default=DEFAULT_TOP,
                    help="top-N lemmas by tokens get tier=full (default 100)")
    ap.add_argument("--skip-checksum", action="store_true")
    args = ap.parse_args()

    db = resolve_db(args.db)
    if not os.path.exists(db):
        print(f"ERROR: {db} not found", file=sys.stderr)
        return 2
    if not os.path.exists(args.g2):
        print(f"ERROR: G2 asset missing at {args.g2}", file=sys.stderr)
        return 2

    print(f"loading G2 coverage oracle from {args.g2} ...")
    g2 = load_g2(args.g2)
    print(f"  {len(g2):,} lemmas")

    conn = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    conn.text_factory = str
    prov = dict(conn.execute("SELECT key, value FROM provenance").fetchall())
    if "source_commit" not in prov:
        print("ERROR: master has no provenance pin -- refusing", file=sys.stderr)
        return 1
    sha = "skipped" if args.skip_checksum else sha256_file(db)

    # ---- forms: only NOUN, only cells that exist; G2 decides which cells keep ----
    print("aggregating per-lemma per-cell forms (NOUN, 8 real cases) ...")
    # lid -> cell -> {form: n}
    cell_forms = defaultdict(lambda: defaultdict(lambda: defaultdict(int)))
    sql_tok = defaultdict(int)          # lid -> total cased NOUN tokens
    sql_cells = defaultdict(set)        # lid -> set of cells seen in sqlite
    sql = (
        "SELECT lemma_id, feat_case, feat_number, "
        "       COALESCE(m_unsandhied, form), COUNT(*) "
        "FROM token "
        "WHERE upos = 'NOUN' AND lemma IS NOT NULL "
        "  AND feat_case IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') "
        "  AND feat_number IN ('Sing','Dual','Plur') "
        "GROUP BY 1, 2, 3, 4"
    )
    n_rows = 0
    for lid, case, num, form, n in conn.execute(sql):
        n_rows += 1
        if lid not in g2:
            continue  # not in G2 universe (should be rare / none)
        cell = f"{case}.{num}"
        sql_tok[lid] += n
        sql_cells[lid].add(cell)
        if form:
            cell_forms[lid][cell][form] += n
    print(f"  {n_rows:,} (lemma,case,number,form) groups; "
          f"{len(sql_tok):,} G2 lemmas with sqlite tokens")

    # ---- hard recon: G2 tokens/cells must match the pin, or the asset is a lie ----
    print("reconciling sqlite NOUN aggregation against G2 ...")
    tok_mismatch = []
    cell_mismatch = []
    extra_cells = []  # sqlite has a cell G2 does not
    for lid, meta in g2.items():
        st = sql_tok.get(lid, 0)
        if st != meta["tokens"]:
            tok_mismatch.append((lid, meta["lemma"], meta["tokens"], st))
        g2_cells = {CELLS[i] for i, b in enumerate(meta["cells_bits24"]) if b == "1"}
        sc = sql_cells.get(lid, set())
        if sc != g2_cells:
            # G2 cells_attested is the count; bitstring is the set.
            only_g2 = sorted(g2_cells - sc)
            only_sql = sorted(sc - g2_cells)
            if only_g2 or only_sql:
                cell_mismatch.append((lid, meta["lemma"], only_g2, only_sql))
            if only_sql:
                extra_cells.append((lid, only_sql))
    if tok_mismatch:
        sample = tok_mismatch[:5]
        print(f"ERROR: {len(tok_mismatch)} lemma(s) have token-count drift vs G2 "
              f"(sample: {sample}). Same pin required.", file=sys.stderr)
        return 1
    if cell_mismatch:
        # Extra sqlite cells mean G2 under-reported; missing cells mean forms
        # would be empty for a G2-attested cell -- either is a pin/scope problem.
        sample = cell_mismatch[:5]
        print(f"ERROR: {len(cell_mismatch)} lemma(s) have cell-set drift vs G2 "
              f"(sample: {sample}). Refusing to invent coverage.", file=sys.stderr)
        return 1
    print("  OK -- every G2 lemma matches the pin on tokens and cell set")

    # ---- admit by floor, rank, tier, fill forms only on G2-attested cells ----
    admitted = [m for m in g2.values() if m["tokens"] >= args.floor]
    admitted.sort(key=lambda m: (-m["tokens"], m["lemma"], m["lemma_id"]))
    lemmas = {}
    for rank, meta in enumerate(admitted, start=1):
        lid = meta["lemma_id"]
        bits = meta["cells_bits24"]
        cells = {}
        for i, cell in enumerate(CELLS):
            if bits[i] != "1":
                continue
            forms = cell_forms.get(lid, {}).get(cell, {})
            top = sorted(forms.items(), key=lambda kv: (-kv[1], kv[0]))[:TOP_FORMS_PER_CELL]
            # Always emit the cell (G2 attested) even if forms somehow empty.
            cells[cell] = [[n, f] for f, n in top]
        lemmas[str(lid)] = {
            "lemma": meta["lemma"],
            "domGender": meta["dom_gender"],
            "stemFinal": meta["stem_final"],
            "tokens": meta["tokens"],
            "cellsAttested": meta["cells_attested"],
            "rank": rank,
            "tier": "full" if rank <= args.top else "attested",
            "cells": cells,
        }

    doc = {
        "schemaVersion": SCHEMA_VERSION,
        "corpusRelease": "DCS-2026",
        "source": {
            "repo": prov.get("source_repo", "gasyoun/dcs-conllu"),
            "commit": prov["source_commit"],
            "masterSha256": sha,
            "coverageOracle": (
                "SanskritGrammar/sangram/data/declension_cell_coverage/"
                "lemma_cell_coverage.csv (H1048 Sangram G2)"
            ),
            "g2LemmaCount": len(g2),
        },
        "generatedBy": "src/DCS-data-2026/gen_paradigm_nominal_lemmas.py (H2321)",
        "ceilingNote": CEILING_NOTE,
        "frequencyFloor": args.floor,
        "tierBoundary": args.top,
        "topFormsPerCell": TOP_FORMS_PER_CELL,
        "cases": CASES,
        "numbers": NUMBERS,
        "cells": CELLS,
        "lemmaCount": len(lemmas),
        "fullTierCount": sum(1 for r in lemmas.values() if r["tier"] == "full"),
        "attestedTierCount": sum(1 for r in lemmas.values() if r["tier"] == "attested"),
        "totalTokens": sum(r["tokens"] for r in lemmas.values()),
        "lemmas": lemmas,
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    # Compact JSON on purpose: 31k lemmas with per-cell forms is multi-MB either way,
    # and indent=2 roughly triples the on-disk size without helping consumers.
    with open(OUT_JSON, "w", encoding="utf-8") as fh:
        json.dump(doc, fh, ensure_ascii=False, separators=(",", ":"))
        fh.write("\n")
    with open(OUT_JS, "w", encoding="utf-8") as fh:
        fh.write("window.PARADIGM_NOMINAL_LEMMAS = ")
        json.dump(doc, fh, ensure_ascii=False, separators=(",", ":"))
        fh.write(";\n")

    # ---- build report ----
    top5 = admitted[:5]
    lines = [
        "# Per-lemma nominal drill-down — build report (H2321)",
        "",
        f"_Auto-generated by `gen_paradigm_nominal_lemmas.py`. "
        f"Coverage oracle: Sangram G2 `lemma_cell_coverage.csv` "
        f"({len(g2):,} lemmas). Forms from pinned master "
        f"`{prov['source_commit'][:12]}`._",
        "",
        "## Admission",
        "",
        f"- G2 universe: **{len(g2):,}** NOUN lemmas / "
        f"**{sum(m['tokens'] for m in g2.values()):,}** cased tokens",
        f"- Frequency floor: tokens ≥ **{args.floor}** → "
        f"**{len(lemmas):,}** lemmas admitted "
        f"({doc['totalTokens']:,} tokens)",
        f"- Tier boundary: top-**{args.top}** = `full`, rest = `attested` "
        f"({doc['fullTierCount']:,} / {doc['attestedTierCount']:,})",
        f"- Top forms kept per attested cell: **{TOP_FORMS_PER_CELL}**",
        "",
        "## Reconciliation (refuse on drift)",
        "",
        f"- Token-count mismatches vs G2: **0**",
        f"- Cell-set mismatches vs G2: **0**",
        f"- Coverage is **not** re-derived: G2 `cells_bits24` is the sole oracle.",
        "",
        "## Top 5 lemmas (by G2 tokens)",
        "",
        "| rank | lemma | gender | stem | tokens | cells |",
        "|---:|---|---|---|---:|---:|",
    ]
    for i, m in enumerate(top5, 1):
        lines.append(
            f"| {i} | {m['lemma']} | {m['dom_gender']} | {m['stem_final']} | "
            f"{m['tokens']:,} | {m['cells_attested']} |"
        )
    lines += [
        "",
        "## Limits (carried from G2 + H1472)",
        "",
        "- Median cells/lemma in G2 is **1**; full 24-cell paradigms are effectively "
        "unattested (0.0% of lemmas).",
        "- `stem_final` is a citation-form tag, not a declension class.",
        "- Forms are unsandhied DCS analyses; many are reconstructed.",
        "- Hapax / below-floor lemmas stay in G2 but are out of this trainer asset.",
        "",
        f"_Master SHA-256: `{sha}` · pin `{prov['source_commit']}`._",
        "",
    ]
    with open(OUT_REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(lines))

    print(f"wrote {os.path.relpath(OUT_JSON, REPO)} — {len(lemmas):,} lemmas, "
          f"{doc['totalTokens']:,} tokens")
    print(f"wrote {os.path.relpath(OUT_JS, REPO)}")
    print(f"wrote {os.path.relpath(OUT_REPORT, REPO)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
