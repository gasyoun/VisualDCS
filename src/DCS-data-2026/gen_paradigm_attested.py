#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_paradigm_attested.py -- H1299 (paradigm trainer scale-up: 6 roots -> the attested
verb space). Extends the generation path that produces visual/paradigm_endings.json
(see CLAUDE.md's "Adding a New Dashboard" flow and regen_widgets.py) into a per-root,
per-cell ATTESTED table over the full 2026 DCS master, instead of the hand-picked
6-root textbook paradigm baked into sanskrit_pxn_v4.html's RD object.

Reuses the repo's existing SQL/category logic rather than re-deriving it:
  - `ud_to_category`   (regen_widgets.py, M7)   -- Tense/Voice/Mood -> the same
    38-category display names already used by verb_forms_38cat.json, including its
    honest "Perfect/Aorist" override for UD's conflated Tense=Past.
  - `participle_cat`   (regen_widgets.py, M7)   -- the ending-heuristic that buckets
    untagged VerbForm=Part tokens into Present/Past-Passive participle.
Cell definition for finite forms matches csl-observatory's E46 census
(scripts/paradigm_cell_coverage.py) exactly -- (lemma, tense, mood, voice, person,
number) on feat_verbform IS NULL rows -- so this script's own per-root distinct-cell
counts can be reconciled against E46's committed TSV without re-deriving it.

-- Discipline (never fabricate -- H1299 target-specific constraint) ----------------
  - DCS tags unaccented text: it cannot distinguish verb class I vs VI, or class IV
    vs the passive formation, at the root-class level. This script NEVER assigns a
    Panini class number to any root's data (top-100 or long tail) -- the traditional
    class label the 6-root browser carries for kr/bhu/as/gam/vac/da is out of scope
    here; a future editorial pass may hand-attach classes from Whitney via
    sanskrit_verb_forms.md, but nothing here claims it automatically.
  - feat_voice only distinguishes Passive from non-passive -- DCS does NOT tag
    parasmaipada vs atmanepada (P./A.) separately (verified: feat_voice in {None,
    'Pass'} only, no 'Mid'/'Act' split). So non-passive finite forms for a cell are
    pooled together (both P. and A. surface forms, undistinguished), unlike the
    hand-curated 6-root RD grid, which shows separate P./A. columns from external
    grammatical knowledge. This script never claims a P./A. split it cannot see.
  - UD Tense=Past conflates aorist + perfect (no UD value separates them), but DCS's own
    feat_formation re-splits the FINITE PAST INDICATIVE, and since H2294 this generator
    applies that split itself -- per token, via regen_widgets.past_class(), exactly as
    verb_forms() does. It does NOT come from ud_to_category, whose (Tense,Voice,Mood) key
    structurally cannot carry a per-token feature; that map's merged "Perfect/Aorist"
    entry is now dead for this generator's finite-past rows.
    The split is BOUNDED, and the bound is shipped with the data, not just documented:
    Aorist and Periphrastic Perfect are read off feat_formation (attested); Perfect is
    the UNMARKED DEFAULT (feat_formation IS NULL) and is therefore inferred, never
    observed. Because "Perfect" is DEFINED as the untagged residue, the defaulted share
    of every emitted cell is exactly 0% or 100% -- never in between -- so the evidence
    status is a property of the CATEGORY, not of the cell, and is emitted as
    `cellEvidence` for consumers to badge. That degeneracy is ASSERTED at build time
    (assert_evidence_degenerate below), not assumed: if the corpus ever tags a simple
    perfect, the build fails loudly and per-cell marking becomes mandatory.
    Error bars: reports/past_tense_resplit_validation.md (H1486) -- Aorist is a LOWER
    bound, Perfect an UPPER bound; neither is exact.

Output (both from ONE aggregation pass, so they can never drift apart):
  visual/paradigm_attested.json   pure JSON (downstream/kosha-consumable export)
  visual/paradigm_attested_data.js   window.PARADIGM_ATTESTED = <same object>;
                                      (house pattern: <script src> load, no fetch(),
                                      works from a double-clicked file:// page)
  reports/paradigm_attested_build.md   floor/tier admission report (reproducibility)

Stdlib only except sqlite3. Run from repo root:
    python src/DCS-data-2026/gen_paradigm_attested.py [--db PATH] [--floor N] [--top N]
"""

import argparse
import json
import os
import re
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
sys.path.insert(0, HERE)
from regen_widgets import (ud_to_category, participle_cat,      # noqa: E402  (reuse, don't re-derive)
                            is_past_indicative, past_class)     # noqa: E402  (H1486 split, single source)

DEFAULT_DB = os.path.join(HERE, "dcs_full.sqlite")
OUT_JSON = os.path.join(REPO, "visual", "paradigm_attested.json")
OUT_JS = os.path.join(REPO, "visual", "paradigm_attested_data.js")
OUT_REPORT = os.path.join(REPO, "reports", "paradigm_attested_build.md")
E46_TSV = os.path.join(REPO, "..", "csl-observatory", "data", "paradigm_cell_coverage_per_root.tsv")
E46_RECON = os.path.join(REPO, "reports", "e46_reconciliation.md")

SCHEMA_VERSION = "1.1.0"   # 1.1.0 (H2294): finite past indicative split Aorist/Perfect/
                            # Periphrastic Perfect + `cellEvidence`; was "Perfect/Aorist"
NS = ["Sing", "Dual", "Plur"]
NS_KEY = {"Sing": "sg", "Dual": "du", "Plur": "pl"}
TOP_FORMS_PER_CELL = 5   # matches paradigm_endings.json's top-5 convention

# H1486 voice labels -- identical to regen_widgets.verb_forms(), so the two assets'
# past-split category names cannot drift apart.
VOICE_LABEL = {None: "Active", "Pass": "Passive", "Mid": "Middle"}

# How each past-split class was arrived at. "attested" = read off DCS's feat_formation;
# "defaulted" = the unmarked residue, i.e. INFERRED. Consumers must not render a
# "defaulted" category to a learner as though the corpus asserted it.
PAST_SPLIT_EVIDENCE = {
    "Aorist": "formation-attested",
    "Periphrastic Perfect": "formation-attested",
    "Perfect": "defaulted",
}

CEILING_NOTE = (
    "DCS tags unaccented text: it cannot distinguish verb class I vs VI, or class IV "
    "vs the passive formation, at the root-class level, so no Panini class number is "
    "assigned to any root here. The finite past indicative IS split into Aorist / "
    "Periphrastic Perfect / Perfect (H1486), but the split is BOUNDED and one-sided: "
    "Aorist and Periphrastic Perfect are read off DCS's feat_formation, while Perfect "
    "is the UNMARKED DEFAULT (feat_formation IS NULL) and is therefore inferred, not "
    "observed -- every 'Perfect' cell here is 100% defaulted, so Aorist is a LOWER "
    "bound and Perfect an UPPER bound (>=1.13% aorist leakage, >=3.54% imperfect "
    "contamination; see reports/past_tense_resplit_validation.md). feat_voice "
    "distinguishes only Passive from non-passive -- parasmaipada vs atmanepada is NOT "
    "separately tagged by DCS, so non-passive finite forms for a cell are pooled "
    "together (unlike the hand-curated 6-root deep view, which shows P./A. columns "
    "from external grammatical knowledge, not from this corpus tag set)."
)


def assert_evidence_degenerate(cell_evidence_counts):
    """H2294 discipline -- the same shape as gen_paradigm_nominal.py's denominator-closure
    assertion, and for the same reason: a silent change of epistemic status is worse than
    a failed build.

    `Perfect` is DEFINED as `feat_formation IS NULL`, so no Perfect cell can carry
    formation evidence and no Aorist/Periphrastic-Perfect cell can lack it. That makes the
    per-cell defaulted share exactly 0.0 or 1.0. The whole per-CATEGORY evidence flag this
    script emits is only honest while that holds. If DCS ever tags a simple perfect (or
    leaves an aorist type untagged inside a tagged class), the share goes fractional, a
    category-level flag starts lying about individual cells, and per-cell marking becomes
    mandatory -- so fail here rather than ship a flag that quietly stopped being true.
    Returns the {share_pct: n_cells} histogram for the build report.
    """
    hist = defaultdict(int)
    offenders = []
    for key, (defaulted, total) in cell_evidence_counts.items():
        share = defaulted / total
        hist[round(100 * share)] += 1
        if share not in (0.0, 1.0):
            offenders.append((key, defaulted, total))
    if offenders:
        raise SystemExit(
            "FATAL (H2294): the per-cell defaulted share is no longer degenerate -- "
            f"{len(offenders)} cell(s) are partly formation-attested and partly defaulted, "
            f"e.g. {offenders[:5]}. A category-level `cellEvidence` flag would now "
            "misdescribe individual cells. Emit per-cell evidence before shipping.")
    return dict(sorted(hist.items()))


def nonfinite_bucket(verbform, tense, form):
    if verbform == "Conv":
        return "Abs"
    if verbform == "Inf":
        return "Inf"
    if verbform == "Gdv":
        return "FPP"
    if verbform == "Part":
        if tense == "Pres":
            return "PresPart"
        if tense == "Fut":
            return "FutPart"
        if tense == "Past":
            return "PPP"
        cat = participle_cat(form)
        return "PresPart" if cat == "Present Participle" else (
            "PPP" if cat == "Past Passive Participle" else "PartOther")
    return "Other"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("--floor", type=int, default=2,
                     help="minimum total VERB-token count for a lemma to be admitted")
    ap.add_argument("--top", type=int, default=100,
                     help="rank cutoff for the 'full' tier (frequency-first)")
    ap.add_argument("--e46-tsv", default=E46_TSV,
                     help="csl-observatory paradigm_cell_coverage_per_root.tsv. The default "
                          "assumes csl-observatory sits beside this checkout; a linked git "
                          "worktree does NOT, and without this flag the reconciliation would "
                          "be rewritten as BLOCKED purely because of where the tree lives.")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        print(f"ERROR: {args.db} not found. Build it via the M1-M8 DCS CoNLL-U import first.",
              file=sys.stderr)
        return 2

    conn = sqlite3.connect(args.db)
    conn.text_factory = str

    print("ranking roots by total corpus VERB-token count ...")
    rank_rows = conn.execute(
        "SELECT lemma, COUNT(*) c FROM token WHERE upos='VERB' AND lemma IS NOT NULL "
        "GROUP BY lemma ORDER BY c DESC").fetchall()
    n_lemma_total = len(rank_rows)
    admitted = [(lemma, c) for lemma, c in rank_rows if c >= args.floor]
    rank_of = {lemma: i + 1 for i, (lemma, _c) in enumerate(rank_rows)}
    tier_of = {lemma: ("full" if i < args.top else "attested")
               for i, (lemma, _c) in enumerate(admitted)}
    admitted_set = set(lemma for lemma, _c in admitted)
    print(f"  {n_lemma_total} distinct VERB lemma strings; "
          f"{len(admitted)} admitted at floor>={args.floor} "
          f"({len(admitted) - min(args.top, len(admitted))} in the 'attested' long tail)")

    cat_map = ud_to_category(conn)   # (Tense,Voice,Mood) -> 38-category display name (M7, reused)

    # ---- finite cells: (lemma, tense, mood, voice, person, number) -- E46-identical filter ----
    print("aggregating finite cells (feat_verbform IS NULL) ...")
    finite_cell_forms = defaultdict(lambda: defaultdict(int))   # (lemma,cellkey,nk,pers) -> {form: n}
    finite_cell_total = defaultdict(int)                        # (lemma,cellkey) -> n
    e46_style_cells = defaultdict(set)                          # lemma -> {E46 5-tuple} for recon
    past_class_scope = defaultdict(int)                         # past-split class -> n (this filter's scope)
    cell_evidence_counts = defaultdict(lambda: [0, 0])          # emitted past cell -> [defaulted, total]
    past_cellkeys = set()                                       # display names actually emitted

    for lemma, tense, mood, voice, person, number, formation, form in conn.execute(
            "SELECT lemma, feat_tense, feat_mood, feat_voice, feat_person, feat_number, "
            "feat_formation, form "
            "FROM token WHERE upos='VERB' AND feat_verbform IS NULL AND lemma IS NOT NULL"):
        if lemma not in admitted_set:
            continue
        # E46 cell identity -- deliberately IDENTICAL to csl-observatory's
        # scripts/paradigm_cell_coverage.py. The re-split touches the DISPLAY category
        # only; re-splitting this tuple would silently break the cross-repo
        # reconciliation for a reason no reader of either repo could reconstruct.
        e46_tuple = (tense or "?", mood or "?", voice or "Act", person or "?", number or "?")
        e46_style_cells[lemma].add(e46_tuple)
        # feat_verbform IS NULL for every row this query returns, hence the literal None.
        past_split = is_past_indicative(tense, mood, None)
        if past_split:
            past_class_scope[past_class(formation)] += 1
        if person not in ("1", "2", "3") or number not in NS_KEY:
            continue   # can't place on the sg/du/pl x 1/2/3 grid -- still counted for E46 recon above
        if past_split:
            # H2294: the per-token split, applied here rather than looked up. ud_to_category
            # is keyed on (Tense,Voice,Mood) and structurally cannot carry feat_formation,
            # so re-running the old code path would reproduce the merged bucket verbatim.
            # Same expression as regen_widgets.verb_forms(), so the labels cannot drift.
            cat_name = f"{past_class(formation)} {VOICE_LABEL.get(voice, voice)}"
        else:
            cat_name = cat_map.get((tense, voice, mood)) or f"({tense or '-'}/{mood or '-'}/{voice or '-'})"
            if re.match(r"^\d+$", cat_name):
                # timws.csv itself carries a handful of self-referential/garbled names
                # (e.g. code 32's own name is literally "32") -- never surface a bare
                # number as a tense label; fall back to the honest raw UD tuple instead
                # of inventing a grammatical name the source doesn't actually give us.
                cat_name = f"Unclassified (Tense={tense or '-'}|Mood={mood or '-'}|Voice={voice or '-'})"
        cellkey = cat_name
        finite_cell_forms[(lemma, cellkey, NS_KEY[number], person)][form] += 1
        finite_cell_total[(lemma, cellkey)] += 1
        if past_split:
            past_cellkeys.add(cellkey)
            ev = cell_evidence_counts[(lemma, cellkey, NS_KEY[number], person)]
            ev[1] += 1
            if formation is None:
                ev[0] += 1

    # ---- non-finite cells ----
    print("aggregating non-finite cells (participle/absolutive/infinitive/gerundive) ...")
    nf_forms = defaultdict(lambda: defaultdict(int))   # (lemma,bucket) -> {form: n}
    for lemma, verbform, tense, form in conn.execute(
            "SELECT lemma, feat_verbform, feat_tense, form FROM token "
            "WHERE upos='VERB' AND feat_verbform IS NOT NULL AND lemma IS NOT NULL"):
        if lemma not in admitted_set:
            continue
        bucket = nonfinite_bucket(verbform, tense, form)
        nf_forms[(lemma, bucket)][form] += 1

    conn.close()

    # ---- past-split evidence: assert degeneracy BEFORE emitting a category-level flag ----
    evidence_hist = assert_evidence_degenerate(cell_evidence_counts)
    cell_evidence = {}
    for ck in sorted(past_cellkeys):
        # emitted display name is "<class> <voice>", built above from past_class()
        cls = next(c for c in PAST_SPLIT_EVIDENCE if ck.startswith(c + " "))
        cell_evidence[ck] = PAST_SPLIT_EVIDENCE[cls]
    n_defaulted_cells = evidence_hist.get(100, 0)
    n_attested_cells = evidence_hist.get(0, 0)
    print(f"past-split evidence: {n_attested_cells:,} formation-attested cells, "
          f"{n_defaulted_cells:,} defaulted cells (share histogram {evidence_hist}) -- degenerate OK")
    print("past-split scope (this generator's filter): "
          + ", ".join(f"{k}={v:,}" for k, v in sorted(past_class_scope.items())))

    # ---- assemble per-root JSON ----
    print("assembling per-root records ...")
    roots = {}
    by_lemma_cats = defaultdict(set)
    for (lemma, cellkey, nk, pers), _ in finite_cell_forms.items():
        by_lemma_cats[lemma].add(cellkey)

    total_count_map = dict(rank_rows)
    for lemma in admitted_set:
        rec = {
            "rank": rank_of[lemma],
            "totalTokens": total_count_map[lemma],
            "tier": tier_of[lemma],
            "finite": {},
            "nonfinite": {},
        }
        for cellkey in sorted(by_lemma_cats.get(lemma, ())):
            grid = {"sg": {}, "du": {}, "pl": {}}
            any_cell = False
            for nk in ("sg", "du", "pl"):
                for pers in ("1", "2", "3"):
                    forms = finite_cell_forms.get((lemma, cellkey, nk, pers))
                    if not forms:
                        continue
                    top = sorted(forms.items(), key=lambda kv: -kv[1])[:TOP_FORMS_PER_CELL]
                    grid[nk][pers] = [[n, f] for f, n in top]
                    any_cell = True
            if any_cell:
                rec["finite"][cellkey] = grid
        for bucket in ("PPP", "Abs", "Inf", "FPP", "PresPart", "FutPart", "PartOther", "Other"):
            forms = nf_forms.get((lemma, bucket))
            if forms:
                top = sorted(forms.items(), key=lambda kv: -kv[1])[:TOP_FORMS_PER_CELL]
                rec["nonfinite"][bucket] = [[n, f] for f, n in top]
        roots[lemma] = rec

    out = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedBy": "gen_paradigm_attested.py (H1299)",
        "corpusRelease": "DCS-2026",
        "source": {"db": os.path.basename(args.db), "verbTokensTotal": sum(c for _l, c in rank_rows)},
        "frequencyFloor": args.floor,
        "floorNote": (f"lemma admitted iff total corpus VERB-token count >= {args.floor} "
                       f"(excludes {n_lemma_total - len(admitted)} of {n_lemma_total} distinct "
                       "VERB lemma strings that are pure hapax at floor 1)."),
        "tierBoundary": args.top,
        "tierNote": (f"top {args.top} roots by total VERB-token count = tier 'full'; the "
                      "remaining admitted roots = tier 'attested' (long tail, attested cells "
                      "only, no hand-curated notes -- decision #3 of the H1299 plan)."),
        "ceilingNote": CEILING_NOTE,
        "cellEvidence": cell_evidence,
        "cellEvidenceNote": (
            "H2294. Applies to the finite past indicative only, whose UD Tense=Past bucket "
            "is re-split here on DCS's own feat_formation (H1486). 'formation-attested' = "
            "the corpus tags the past-stem formation on every token in the cell "
            "(Whitney's seven aorist types; 'peri' = periphrastic perfect). 'defaulted' = "
            "the cell is entirely UNTAGGED and is read as the simple/reduplicated perfect, "
            "which DCS leaves unmarked -- an inference, not an attestation. The defaulted "
            "share of every cell is exactly 0% or 100% (asserted at build time), because "
            "'Perfect' IS the untagged residue; so this flag is per-category by "
            "construction, not a per-cell approximation. A consumer that renders a "
            "'defaulted' category to a learner without marking it presents an assumption "
            "as an attestation. Measured bounds: reports/past_tense_resplit_validation.md."),
        "cellEvidenceCells": {"formationAttested": n_attested_cells,
                              "defaulted": n_defaulted_cells},
        "rootCount": len(roots),
        "roots": roots,
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    json_size = os.path.getsize(OUT_JSON)

    with open(OUT_JS, "w", encoding="utf-8") as fh:
        fh.write("// AUTO-GENERATED by gen_paradigm_attested.py -- do not hand-edit.\n")
        fh.write("window.PARADIGM_ATTESTED = ")
        json.dump(out, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        fh.write(";\n")
    js_size = os.path.getsize(OUT_JS)

    print(f"wrote {OUT_JSON} ({json_size/1024:.0f} KB)")
    print(f"wrote {OUT_JS} ({js_size/1024:.0f} KB)")
    print(f"roots in output: {len(roots)}  (tier=full: {sum(1 for r in roots.values() if r['tier']=='full')}, "
          f"tier=attested: {sum(1 for r in roots.values() if r['tier']=='attested')})")

    # ---- E46 reconciliation (consume, don't rebuild; log disagreements, never resolve silently) ----
    print("reconciling against csl-observatory E46 (paradigm_cell_coverage_per_root.tsv) ...")
    e46_rows = {}
    e46_found = os.path.isfile(args.e46_tsv)
    if e46_found:
        with open(args.e46_tsv, encoding="utf-8") as fh:
            next(fh)   # header
            for line in fh:
                parts = line.rstrip("\n").split("\t")
                if len(parts) < 3:
                    continue
                root, finite_tokens, distinct_cells = parts[0], int(parts[1]), int(parts[2])
                e46_rows[root] = (finite_tokens, distinct_cells)

    recon_lines = [
        "# E46 reconciliation -- paradigm-cell coverage cross-check (H1299)\n",
        "_Auto-generated by gen_paradigm_attested.py. Compares this script's own "
        "E46-style (tense,mood,voice,person,number) finite-cell tuples per root "
        "against csl-observatory's committed "
        "[paradigm_cell_coverage_per_root.tsv](https://github.com/sanskrit-lexicon/csl-observatory/blob/main/data/paradigm_cell_coverage_per_root.tsv) "
        "(H817). Both read the same dcs_full.sqlite with the identical filter "
        "(upos='VERB' AND feat_verbform IS NULL); disagreements are logged here, "
        "never silently resolved.\n",
    ]
    if not e46_found:
        recon_lines.append(f"**BLOCKED**: E46 TSV not found at {args.e46_tsv} -- reconciliation skipped, "
                            "not silently passed. Run this script again once csl-observatory is "
                            "checked out alongside VisualDCS.\n")
        n_match = n_mismatch = n_missing_e46 = n_missing_mine = 0
    else:
        n_match = n_mismatch = n_missing_e46 = n_missing_mine = 0
        mismatches = []
        for lemma in sorted(admitted_set):
            mine = len(e46_style_cells.get(lemma, ()))
            if lemma not in e46_rows:
                n_missing_e46 += 1
                continue
            _tok, e46_cells = e46_rows[lemma]
            if mine == e46_cells:
                n_match += 1
            else:
                n_mismatch += 1
                mismatches.append((lemma, mine, e46_cells))
        for lemma in e46_rows:
            if lemma not in admitted_set:
                n_missing_mine += 1
        recon_lines.append(f"**{n_match}** roots match exactly, **{n_mismatch}** disagree, "
                            f"**{n_missing_e46}** admitted here but absent from the E46 TSV "
                            f"(below E46's own scope, which has no frequency floor), "
                            f"**{n_missing_mine}** in the E46 TSV but below this script's "
                            f"floor>={args.floor}.\n")
        if mismatches:
            recon_lines.append("## Disagreements (root, this script's distinct cells, E46's)\n")
            recon_lines.append("| root | mine | E46 |\n|---|--:|--:|")
            for lemma, mine, e46_cells in mismatches[:200]:
                recon_lines.append(f"| {lemma} | {mine} | {e46_cells} |")
            if len(mismatches) > 200:
                recon_lines.append(f"\n... and {len(mismatches)-200} more (truncated).")
            recon_lines.append("")
    os.makedirs(os.path.dirname(E46_RECON), exist_ok=True)
    with open(E46_RECON, "w", encoding="utf-8") as fh:
        fh.write("\n".join(recon_lines) + "\n")
    print(f"wrote {E46_RECON}: match={n_match} mismatch={n_mismatch} "
          f"missing_from_e46={n_missing_e46} missing_from_mine={n_missing_mine}")

    # ---- build report ----
    rep = [
        "# Paradigm-attested data build report (H1299)\n",
        f"_Generated by gen_paradigm_attested.py over {os.path.basename(args.db)}._\n",
        f"- Source: **{sum(c for _l,c in rank_rows):,}** VERB tokens, "
        f"**{n_lemma_total:,}** distinct lemma strings.\n"
        f"- Frequency floor: **{args.floor}** total VERB tokens -> **{len(admitted):,}** "
        f"roots admitted ({n_lemma_total - len(admitted):,} excluded, all pure hapax "
        "at floor 1).\n"
        f"- Tier boundary: top **{args.top}** by frequency = 'full'; remaining "
        f"**{max(0, len(admitted)-args.top):,}** = 'attested' long tail.\n"
        f"- Output size: visual/paradigm_attested.json {json_size/1024:.0f} KB, "
        f"visual/paradigm_attested_data.js {js_size/1024:.0f} KB.\n",
        "## Past-tense re-split (H1486 -> H2294)\n",
        "UD has no Aorist value, so aorist and perfect both surface as `Tense=Past`. The "
        "finite past indicative is re-split here on DCS's own `feat_formation`, per token, "
        "via `regen_widgets.past_class()` -- the same expression `verb_forms()` uses, so "
        "the two assets cannot drift. **This is not a re-run of the old code path:** "
        "`ud_to_category` is keyed on `(Tense,Voice,Mood)` and structurally cannot carry a "
        "per-token feature, so regenerating without this change reproduces the merged "
        "`Perfect/Aorist` bucket verbatim.\n",
        "| class | rule | evidence | tokens in THIS generator's scope |\n|---|---|---|--:|\n"
        + "\n".join(
            f"| {cls} | {rule} | {PAST_SPLIT_EVIDENCE[cls]} | {past_class_scope.get(cls, 0):,} |"
            for cls, rule in (
                ("Aorist", "`feat_formation` in {root, them, red, s, is, sis, sa}"),
                ("Periphrastic Perfect", "`feat_formation = peri`"),
                ("Perfect", "`feat_formation IS NULL` (**default** -- inferred)"),
            ))
        + f"\n| **total** | | | **{sum(past_class_scope.values()):,}** |\n",
        "### Scope delta against the H1486 validation totals\n",
        "H1486 measured the whole finite past indicative: Aorist **12,054**, Periphrastic "
        "Perfect **4,046**, Perfect **77,229** (**93,329** total). This generator sees a "
        f"**subset** -- it applies a lemma frequency floor of >={args.floor} on top of the "
        "same `upos='VERB' AND feat_verbform IS NULL` filter -- so the totals above are "
        "expected to be lower, and the delta is stated rather than assumed equal: "
        + ", ".join(
            f"{cls} {past_class_scope.get(cls, 0):,} vs {ref:,} (delta {past_class_scope.get(cls, 0) - ref:+,})"
            for cls, ref in (("Aorist", 12054), ("Periphrastic Perfect", 4046), ("Perfect", 77229)))
        + f"; total {sum(past_class_scope.values()):,} vs 93,329 "
        f"(delta {sum(past_class_scope.values()) - 93329:+,}).\n",
        "### Per-cell defaulted share -- the number that decides how this may be displayed\n",
        f"Distribution over the **{sum(evidence_hist.values()):,}** emitted "
        "(root, category, number, person) past-indicative cells:\n",
        "| defaulted share | cells |\n|---|--:|\n"
        + "\n".join(f"| {pct}% | {n:,} |" for pct, n in evidence_hist.items()) + "\n",
        "The distribution is **degenerate: 0% or 100%, never in between** -- and it is "
        "degenerate by construction, since `Perfect` is *defined* as the untagged residue. "
        "So the epistemic status is a property of the CATEGORY, not of the cell, and is "
        "shipped as the dataset's `cellEvidence` map rather than as a per-cell error bar "
        "that could only ever read 0 or 100. `assert_evidence_degenerate()` fails the "
        "build if that ever stops holding, at which point per-cell marking becomes "
        "mandatory.\n",
        "### Bound direction (do not quote either class as exact)\n",
        "- **Aorist is a LOWER bound** -- only formation-tagged aorists are counted; "
        "H1486 found >=869 more (1.13% of the default) sitting untagged inside Perfect.\n"
        "- **Perfect is an UPPER bound** -- it is 100% defaulted, and carries >=1.13% "
        "misfiled aorists plus >=3.54% misfiled imperfects (an upstream `Tense` tagging "
        "inconsistency the re-split cannot repair).\n"
        "- Full instruments and error bars: "
        "[src/DCS-data-2026/reports/past_tense_resplit_validation.md](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/past_tense_resplit_validation.md).\n",
        "## Ceiling / discipline\n",
        CEILING_NOTE + "\n",
        "## E46 reconciliation\n",
        f"match={n_match} mismatch={n_mismatch} missing_from_e46={n_missing_e46} "
        f"missing_from_mine={n_missing_mine} -- full detail in "
        "[reports/e46_reconciliation.md](https://github.com/gasyoun/VisualDCS/blob/main/reports/e46_reconciliation.md).\n",
    ]
    with open(OUT_REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(rep) + "\n")
    print(f"wrote {OUT_REPORT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
