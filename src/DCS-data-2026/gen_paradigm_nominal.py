#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_paradigm_nominal.py -- H1472 (nominal paradigm dashboard: the case x number grid
per declension class, for NOUN + ADJ). The nominal twin of gen_paradigm_attested.py
(H1299), which did the same job for the verb space.

Roadmap origin: roadmap.md's "Самый очевидный следующий шаг: именная парадигма" --
2.28M nominal tokens against 781k verbal ones, and no nominal tool at all. Builds the
8-case x 3-number grid per declension class with corpus-frequency colour-coding and
real corpus examples, from the pinned DCS-2026 master.

-- Reuse, don't re-derive (CLAUDE.md "Check prior art before building") --------------
  - Declension-class bucketing REUSES the lemma-final tag list of SanskritGrammar's
    Sangram G2 asset (scripts/sg_g2_declension_cell_coverage.py, H1048) verbatim,
    including its "citation form != stem" caveat, and EXTENDS it with the -ant class
    (bhagavant/mahat/bhavat) that G2 leaves in `other_consonant` but that this
    dashboard's roadmap brief names explicitly. Every re-bucketing relative to G2 is
    counted and logged in reports/nominal_g2_reconciliation.md -- never silently.
  - Universe/keying conventions (lemma_id keying for homonyms = G2's EM7, 8 real
    cases, 'Cpd' and NULL excluded from the grid) follow G2 so the two assets can be
    reconciled row-for-row on their shared NOUN-only subset.
  - Output shape (pure .json + a window.* .js twin from ONE aggregation pass, plus a
    build report) follows gen_paradigm_attested.py's house pattern, so the dashboard
    loads via <script src> and works from a double-clicked file:// page.
  - Lexical gender comes from the master's OWN `lemma.grammar` column (m/f/n/adj/mn/
    mf/fn/mfn, dictionary-derived), not from a re-derivation.

-- Discipline (never fabricate; the nominal analogue of H1299's constraints) ---------
  - DECLENSION CLASS IS NOT A CORPUS TAG. DCS tags case/number/gender, never a
    declension class. Every class label here is a documented ORTHOGRAPHIC heuristic
    over the lemma's citation form -- G2's §6.1 caveat ("citation form != stem")
    holds unchanged. The output carries `classIsHeuristic: true` and the dashboard
    prints it; nothing here claims a Paninian or Whitneyan classification.
  - KNOWN CONFLATIONS, carried through and labelled, never split by guesswork:
      * -ī pools the polysyllabic devi-type (devī, nadī) with the monosyllabic
        śrī/strī/bhū type, which declines differently. DCS gives no signal to split.
      * -an pools -an/-man/-van (rājan, nāman, ātman); -ant pools -ant/-vant/-mant
        and DCS's own -at/-vat/-mat citation variants of the same stems (the master
        cites `bhagavant` AND `bhagavat` as separate lemma_ids -- both land in -ant,
        and the split is logged, not resolved).
      * `other_consonant` is a residue bucket, not a class: root nouns (marut, vidyut,
        sarit), Paninian affix strings that leaked into the lemma inventory (vun,
        tosun, kasun), and genuine outliers (puṃs) sit in it together.
  - COMPOUND MEMBERS ARE NOT A CASE. feat_case='Cpd' is 724,676 NOUN/ADJ tokens --
    ~32% of the nominal mass -- with no case and (almost always) no number. They are
    excluded from the 24-cell grid and reported as their own per-class counter, so
    the dashboard can never imply the grid covers all nominal usage.
  - ENDINGS ARE SURFACE RESIDUES, NOT MORPHEMES. An "ending" here is what remains of
    DCS's unsandhied form after stripping the class-marked stem prefix; where the
    form does not start with that stem (strong/weak alternation: rājan -> rājñā), the
    token is counted as NOT segmentable and excluded from the endings view, with the
    segmentable share printed per class. No ending is ever reconstructed.
  - THE FORM SHOWN IS DCS'S UNSANDHIED ANALYSIS, NOT THE MANUSCRIPT SURFACE. 68% of
    cased NOUN/ADJ tokens carry m_unsandhiedreconstructed='True' -- the unsandhied
    string is DCS's reconstruction, not directly attested text. Recorded per class.

Output (all from ONE aggregation pass, so they can never drift apart):
  visual/paradigm_nominal.json        pure JSON (downstream/kosha-consumable export)
  visual/paradigm_nominal_data.js     window.PARADIGM_NOMINAL = <same object>;
  reports/paradigm_nominal_build.md   build/limitations report (reproducibility)
  reports/nominal_g2_reconciliation.md  cross-check against Sangram G2 (H1048)

Stdlib only except sqlite3. Run from repo root:
    python src/DCS-data-2026/gen_paradigm_nominal.py [--db PATH] [--skip-checksum]
"""

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
OUT_JSON = os.path.join(REPO, "visual", "paradigm_nominal.json")
OUT_JS = os.path.join(REPO, "visual", "paradigm_nominal_data.js")
OUT_REPORT = os.path.join(REPO, "reports", "paradigm_nominal_build.md")
G2_CSV = os.path.join(GITHUB, "SanskritGrammar", "sangram", "data",
                      "declension_cell_coverage", "lemma_cell_coverage.csv")
G2_RECON = os.path.join(REPO, "reports", "nominal_g2_reconciliation.md")

SCHEMA_VERSION = "1.0.0"

CASES = ["Nom", "Acc", "Ins", "Dat", "Abl", "Gen", "Loc", "Voc"]
NUMBERS = ["Sing", "Dual", "Plur"]
NUM_KEY = {"Sing": "sg", "Dual": "du", "Plur": "pl"}
CELLS = [f"{c}.{n}" for c in CASES for n in NUMBERS]   # G2's 24-cell order, row-major

TOP_FORMS_PER_CELL = 8      # attested unsandhied forms surfaced per cell
TOP_ENDINGS_PER_CELL = 6    # surface residues surfaced per cell
EXAMPLES_PER_CELL = 3       # corpus sentences surfaced per cell (one per top form)
EXAMPLE_MAX_CHARS = 220

# --- Declension-class bucketing --------------------------------------------------
# G2's STEM_TAGS (scripts/sg_g2_declension_cell_coverage.py, H1048) verbatim, then the
# H1472 extension. Order matters: a lemma is matched against this list top-down and
# takes the FIRST hit, so longer/consonant suffixes must precede the shorter ones they
# contain. Vowel-final and consonant-final tests can never collide (a citation form
# ends in exactly one of the two), which is why G2's own ordering was already safe.
#
# EXTENSION (H1472, flagged in the output as `extendsG2`): the -ant class. G2 has no
# -ant tag, so bhagavant / mahat / bhavat / jagat / bṛhat / dhīmat all fall into its
# `other_consonant` residue. The roadmap brief names -ant explicitly as one of the
# seven classes the dashboard must show, so it is broken out here -- and because DCS
# cites the same stems both ways ("bhagavant" and "bhagavat" are two lemma_ids), BOTH
# the -ant and the -at/-vat/-mat citation shapes map to the one class.
STEM_TAGS = [
    # --- H1472 extension: consonant classes G2 does not tag, longest-first ---
    ("ant", "ant"), ("at", "ant"),
    # --- G2 verbatim (order preserved) ---
    ("ā", "aa"), ("ī", "ii"), ("ū", "uu"), ("ṛ", "r_vocalic"),
    ("i", "i"), ("u", "u"), ("a", "a"),
    ("an", "an"), ("in", "in"), ("as", "as"), ("is", "is"), ("us", "us"),
]
G2_STEM_TAGS = STEM_TAGS[2:]   # the subset G2 itself ships, for the reconciliation

# Human-facing labels + the traditional exemplar, for the dashboard's class picker.
CLASS_META = {
    "a":            {"label": "-a",  "iast": "-a",   "exemplar": "deva",      "note": "masculine/neuter a-stems — the largest class. ⚠️ Its Fem column is NOT an a-stem feminine paradigm: DCS cites an adjective by its masculine -a form, so feminine tokens of -a adjectives (paramayā, uttarayā) are lemmatised here and inflect as ā-/ī-stems. Read the Fem column as 'feminine forms of -a-citation adjectives', not as a class of its own."},
    "aa":           {"label": "-ā",  "iast": "-ā",   "exemplar": "senā",      "note": "feminine ā-stems"},
    "i":            {"label": "-i",  "iast": "-i",   "exemplar": "agni",      "note": "i-stems (all genders)"},
    "ii":           {"label": "-ī",  "iast": "-ī",   "exemplar": "devī",      "note": "ī-stems — POOLS the polysyllabic devī/nadī type with the monosyllabic śrī/strī type, which declines differently"},
    "u":            {"label": "-u",  "iast": "-u",   "exemplar": "guru",      "note": "u-stems (all genders)"},
    "uu":           {"label": "-ū",  "iast": "-ū",   "exemplar": "vadhū",     "note": "ū-stems (feminine, plus monosyllabic bhū)"},
    "r_vocalic":    {"label": "-ṛ",  "iast": "-ṛ",   "exemplar": "pitṛ",      "note": "ṛ-stems (agent nouns and kinship terms, which differ in the strong cases)"},
    "an":           {"label": "-an", "iast": "-an",  "exemplar": "rājan",     "note": "an-stems — POOLS -an / -man / -van (rājan, nāman, ātman)"},
    "in":           {"label": "-in", "iast": "-in",  "exemplar": "yogin",     "note": "in-stems — pools -in / -min / -vin"},
    "ant":          {"label": "-ant", "iast": "-ant", "exemplar": "bhagavant", "note": "ant-stems — POOLS -ant / -vant / -mant AND the master's own -at / -vat / -mat citation variants of the same stems (H1472 extension; G2 leaves these in other_consonant)"},
    "as":           {"label": "-as", "iast": "-as",  "exemplar": "manas",     "note": "as-stems (mostly neuter)"},
    "is":           {"label": "-is", "iast": "-is",  "exemplar": "havis",     "note": "is-stems"},
    "us":           {"label": "-us", "iast": "-us",  "exemplar": "cakṣus",    "note": "us-stems"},
    "other_consonant": {"label": "other cons.", "iast": "—", "exemplar": "marut",
                        "note": "RESIDUE, NOT A CLASS: root nouns (marut, vidyut, sarit), stray Pāṇinian affix strings in the lemma inventory (vun, tosun), and outliers (puṃs) pooled together"},
}

# Which suffix to strip to get the stem an ending is measured against. For -ant the
# marker is variable (-ant / -at), so the actually-matched suffix is stripped, minus
# the -v/-m that belongs to the stem (bhagavant -> bhagav-, endings -ān / -ataḥ).
CLASS_STRIP = {
    "a": ["a"], "aa": ["ā"], "i": ["i"], "ii": ["ī"], "u": ["u"], "uu": ["ū"],
    "r_vocalic": ["ṛ"], "an": ["an"], "in": ["in"], "ant": ["ant", "at"],
    "as": ["as"], "is": ["is"], "us": ["us"], "other_consonant": [],
}

GENDERS = ["Masc", "Fem", "Neut", "?"]

CEILING_NOTE = (
    "Declension class is NOT a DCS tag. DCS annotates case, number and gender; it "
    "never annotates a declension class, so every class label in this asset is an "
    "orthographic heuristic over the lemma's citation form and inherits Sangram G2's "
    "§6.1 caveat that the citation form is not the stem. Known pooled conflations are "
    "labelled per class and never split by guesswork: -ī pools the devī type with the "
    "monosyllabic śrī type; -an pools -an/-man/-van; -ant pools -ant/-vant/-mant with "
    "the master's own -at/-vat/-mat citation variants of the same stems; "
    "other_consonant is a residue bucket, not a class. Compound members "
    "(feat_case='Cpd', ~32% of all NOUN/ADJ tokens) carry no case and are excluded "
    "from the 24-cell grid, counted separately per class. Endings are surface "
    "residues after stripping the class-marked stem prefix, not morphological "
    "segmentations; tokens whose form does not start with that stem (strong/weak "
    "alternation, rājan -> rājñā) are counted as not segmentable and excluded from "
    "the endings view rather than force-split. The form displayed is DCS's unsandhied "
    "analysis, which for ~68% of cased NOUN/ADJ tokens is flagged reconstructed "
    "rather than directly attested surface text. Finally, the gender axis is the "
    "TOKEN's tagged gender, not the lemma's lexical gender: an adjective cited in its "
    "masculine -a form contributes its feminine tokens (paramayā) to the -a class's "
    "Fem column, where they inflect as ā-/ī-stems -- so a gender column of a class is "
    "'tokens of this class tagged with this gender', never 'the class's paradigm in "
    "this gender'."
)


def stem_class(lemma, tags=STEM_TAGS):
    for suf, tag in tags:
        if lemma.endswith(suf):
            return tag
    return "other_consonant"


def ending_of(lemma, form, cls):
    """Surface residue after stripping the class-marked stem prefix.

    Returns (ending, True) when the form actually starts with that stem, else
    (None, False) -- never a reconstructed or force-split ending.
    """
    for suf in CLASS_STRIP.get(cls, []):
        if lemma.endswith(suf):
            stem = lemma[: len(lemma) - len(suf)]
            if stem and form.startswith(stem):
                return form[len(stem):], True
            return None, False
    if cls == "other_consonant" and form.startswith(lemma):
        return form[len(lemma):], True
    return None, False


def sha256_file(path, chunk=4 * 1024 * 1024):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for block in iter(lambda: fh.read(chunk), b""):
            h.update(block)
    return h.hexdigest()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("--skip-checksum", action="store_true",
                    help="skip the 920MB SHA-256 (dev loop only; the committed asset "
                         "must carry a real checksum, C3 §2.1)")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        print(f"ERROR: {args.db} not found. Build it via the M1-M8 DCS CoNLL-U import first.",
              file=sys.stderr)
        return 2

    conn = sqlite3.connect(f"file:{args.db}?mode=ro", uri=True)
    conn.text_factory = str

    prov = dict(conn.execute("SELECT key, value FROM provenance").fetchall())
    if "source_commit" not in prov:
        print("ERROR: master has no provenance pin -- refusing (G2 contract C3 §2.1)",
              file=sys.stderr)
        return 1
    sha = "skipped" if args.skip_checksum else sha256_file(args.db)

    # ---- lexical gender from the master's own dictionary-derived lemma.grammar ----
    print("reading lemma.grammar (dictionary-derived lexical gender) ...")
    lex_gram = {}
    for lemma_id, grammar in conn.execute("SELECT lemma_id, grammar FROM lemma"):
        lex_gram[lemma_id] = (grammar or "").strip()

    # ---- pass 1: the 24-cell grid, per (class, gender) ----------------------------
    print("aggregating the case x number grid (NOUN/ADJ, 8 real cases) ...")
    cell_forms = defaultdict(lambda: defaultdict(int))     # (cls,gen,cell) -> {form: n}
    cell_endings = defaultdict(lambda: defaultdict(int))   # (cls,gen,cell) -> {ending: n}
    cell_total = defaultdict(int)                          # (cls,gen,cell) -> n
    cell_segmentable = defaultdict(int)                    # (cls,gen,cell) -> n segmentable
    cell_lemmas = defaultdict(set)                         # (cls,gen,cell) -> {lemma_id}
    cls_tokens = defaultdict(int)                          # cls -> cased tokens
    cls_lemmas = defaultdict(set)                          # cls -> {lemma_id}
    cls_recon = defaultdict(int)                           # cls -> reconstructed-unsandhied tokens
    cls_upos = defaultdict(lambda: defaultdict(int))       # cls -> {NOUN/ADJ: n}
    cls_lexgram = defaultdict(lambda: defaultdict(int))    # cls -> {lemma.grammar: n lemmas}
    lemma_str = {}                                         # lemma_id -> citation string
    lemma_cls = {}                                         # lemma_id -> class
    lemma_tokens = defaultdict(int)                        # lemma_id -> cased tokens
    lemma_cells = defaultdict(set)                         # lemma_id -> {cell}  (for G2 recon)
    # A lemma_id is not guaranteed to carry a single upos across its tokens, so the G2
    # comparison (whose universe is upos='NOUN') is kept on NOUN-only counters rather
    # than on the mixed totals -- otherwise an ADJ token of the same lemma_id would
    # look like a G2 disagreement when it is only a scope difference.
    lemma_upos_set = defaultdict(set)                      # lemma_id -> {NOUN, ADJ}
    lemma_tokens_noun = defaultdict(int)                   # lemma_id -> NOUN-only cased tokens
    lemma_cells_noun = defaultdict(set)                    # lemma_id -> {cell} over NOUN tokens
    case_number_totals = defaultdict(int)                  # cell -> n (roadmap cross-check)

    grid_sql = (
        "SELECT lemma_id, lemma, upos, feat_case, feat_number, feat_gender, "
        "       COALESCE(m_unsandhied, form), m_unsandhiedreconstructed "
        "FROM token "
        "WHERE upos IN ('NOUN','ADJ') AND lemma IS NOT NULL "
        "  AND feat_case IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') "
        "  AND feat_number IN ('Sing','Dual','Plur')"
    )
    n_grid = 0
    for lid, lemma, upos, case, num, gender, uform, recon in conn.execute(grid_sql):
        n_grid += 1
        cls = lemma_cls.get(lid)
        if cls is None:
            cls = stem_class(lemma)
            lemma_cls[lid] = cls
            lemma_str[lid] = lemma
        lemma_upos_set[lid].add(upos)
        gen = gender if gender in ("Masc", "Fem", "Neut") else "?"
        cell = f"{case}.{num}"
        key = (cls, gen, cell)
        cell_total[key] += 1
        cell_lemmas[key].add(lid)
        cls_tokens[cls] += 1
        cls_lemmas[cls].add(lid)
        cls_upos[cls][upos] += 1
        lemma_tokens[lid] += 1
        lemma_cells[lid].add(cell)
        if upos == "NOUN":
            lemma_tokens_noun[lid] += 1
            lemma_cells_noun[lid].add(cell)
        case_number_totals[cell] += 1
        if recon:
            cls_recon[cls] += 1
        if uform:
            cell_forms[key][uform] += 1
            end, ok = ending_of(lemma, uform, cls)
            if ok:
                cell_segmentable[key] += 1
                cell_endings[key][end] += 1

    print(f"  {n_grid:,} cased NOUN/ADJ tokens placed on the 8x3 grid")

    # ---- pass 2: the excluded mass, counted rather than dropped silently ----------
    print("counting the excluded nominal mass (Cpd / no case / no number) ...")
    cls_cpd = defaultdict(int)
    cls_unplaceable = defaultdict(int)
    unplaceable_reasons = defaultdict(int)
    # NB: the complement must be spelled out NULL-safely. Writing it as
    # `NOT (feat_case IN (...) AND feat_number IN (...))` silently loses every row
    # whose feat_case IS NULL -- SQL's three-valued logic makes `NULL IN (...)` NULL,
    # `NULL AND TRUE` NULL, and `NOT NULL` NULL, so the row matches neither the grid
    # query nor its supposed complement and vanishes from both denominators.
    excl_sql = (
        "SELECT lemma_id, lemma, feat_case, feat_number FROM token "
        "WHERE upos IN ('NOUN','ADJ') AND lemma IS NOT NULL AND ("
        "  feat_case IS NULL "
        "  OR feat_case NOT IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') "
        "  OR feat_number IS NULL "
        "  OR feat_number NOT IN ('Sing','Dual','Plur'))"
    )
    n_cpd = n_unplaceable = 0
    for lid, lemma, case, num in conn.execute(excl_sql):
        cls = lemma_cls.get(lid)
        if cls is None:
            cls = stem_class(lemma)
        if case == "Cpd":
            cls_cpd[cls] += 1
            n_cpd += 1
        else:
            cls_unplaceable[cls] += 1
            n_unplaceable += 1
            unplaceable_reasons[
                "case untagged" if case is None else
                (f"case={case}" if case not in CASES else "number untagged"
                 if num is None else f"number={num}")] += 1
    print(f"  {n_cpd:,} compound members (no case), "
          f"{n_unplaceable:,} otherwise unplaceable (no case and/or no number)")
    for r, n in sorted(unplaceable_reasons.items(), key=lambda kv: -kv[1]):
        print(f"    {r}: {n:,}")
    # Denominator closure: grid + Cpd + unplaceable must exhaust the nominal universe.
    # This assertion is what catches a silently-dropped bucket (it fired on exactly the
    # NULL-logic bug documented above, where 8,542 case-untagged tokens matched neither
    # the grid query nor its complement).
    universe_total = conn.execute(
        "SELECT COUNT(*) FROM token WHERE upos IN ('NOUN','ADJ') AND lemma IS NOT NULL"
    ).fetchone()[0]
    grand_nominal = n_grid + n_cpd + n_unplaceable
    if grand_nominal != universe_total:
        print(f"ERROR: denominators do not close -- grid {n_grid:,} + Cpd {n_cpd:,} + "
              f"unplaceable {n_unplaceable:,} = {grand_nominal:,}, but the NOUN/ADJ "
              f"universe holds {universe_total:,} tokens. A bucket is being dropped.",
              file=sys.stderr)
        return 3

    # ---- pass 3: one real corpus example per surfaced form ------------------------
    print("collecting corpus examples for the top forms of every cell ...")
    wanted = {}     # (cls,gen,cell) -> [forms]
    form_needed = defaultdict(set)   # form -> {(cls,gen,cell)}
    for key, forms in cell_forms.items():
        top = [f for f, _n in sorted(forms.items(), key=lambda kv: (-kv[1], kv[0]))
               ][:EXAMPLES_PER_CELL]
        wanted[key] = top
        for f in top:
            form_needed[f].add(key)

    examples = {}   # (cls,gen,cell,form) -> {sent, text, ref}
    ex_sql = (
        "SELECT t.lemma_id, t.lemma, t.feat_case, t.feat_number, t.feat_gender, "
        "       COALESCE(t.m_unsandhied, t.form), s.text_sandhied, x.name, c.ref "
        "FROM token t "
        "JOIN sentence s ON s.id = t.sentence_id "
        "LEFT JOIN chapter c ON c.chapter_id = s.chapter_id "
        "LEFT JOIN text x ON x.text_id = c.text_id "
        "WHERE t.upos IN ('NOUN','ADJ') AND t.lemma IS NOT NULL "
        "  AND t.feat_case IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') "
        "  AND t.feat_number IN ('Sing','Dual','Plur') "
        "  AND s.text_sandhied IS NOT NULL"
    )
    for lid, lemma, case, num, gender, uform, sent, tname, ref in conn.execute(ex_sql):
        if not uform or uform not in form_needed:
            continue
        cls = lemma_cls.get(lid) or stem_class(lemma)
        gen = gender if gender in ("Masc", "Fem", "Neut") else "?"
        key = (cls, gen, f"{case}.{num}")
        if key not in form_needed[uform]:
            continue
        ek = key + (uform,)
        if ek in examples:
            continue
        txt = " ".join(str(sent).split())
        if len(txt) > EXAMPLE_MAX_CHARS:
            txt = txt[:EXAMPLE_MAX_CHARS - 1] + "…"
        examples[ek] = {"sent": txt, "text": tname or "?", "ref": ref or ""}
    conn.close()
    print(f"  {len(examples):,} examples collected")

    # ---- assemble ----------------------------------------------------------------
    print("assembling the per-class records ...")
    classes = {}
    for cls in sorted(cls_tokens, key=lambda c: -cls_tokens[c]):
        meta = CLASS_META.get(cls, {"label": cls, "iast": cls, "exemplar": "", "note": ""})
        genders = {}
        for gen in GENDERS:
            grid = {}
            gtot = 0
            gseg = 0
            for cell in CELLS:
                key = (cls, gen, cell)
                n = cell_total.get(key, 0)
                if not n:
                    continue
                forms = cell_forms.get(key, {})
                top_forms = sorted(forms.items(), key=lambda kv: (-kv[1], kv[0]))[:TOP_FORMS_PER_CELL]
                ends = cell_endings.get(key, {})
                top_ends = sorted(ends.items(), key=lambda kv: (-kv[1], kv[0]))[:TOP_ENDINGS_PER_CELL]
                seg = cell_segmentable.get(key, 0)
                ex = []
                for f in wanted.get(key, []):
                    e = examples.get((cls, gen, cell, f))
                    if e:
                        ex.append({"form": f, **e})
                grid[cell] = {
                    "n": n,
                    "lemmas": len(cell_lemmas.get(key, ())),
                    "segmentable": seg,
                    "forms": [[c, f] for f, c in top_forms],
                    "endings": [[c, e] for e, c in top_ends],
                    "examples": ex,
                }
                gtot += n
                gseg += seg
            if gtot:
                genders[gen] = {
                    "n": gtot,
                    "segmentablePct": round(100.0 * gseg / gtot, 1),
                    "cells": grid,
                    "cellsAttested": len(grid),
                }
        top_lemmas = sorted(
            (lid for lid in cls_lemmas[cls]), key=lambda l: -lemma_tokens[l])[:25]
        classes[cls] = {
            "label": meta["label"],
            "exemplar": meta["exemplar"],
            "note": meta["note"],
            "extendsG2": cls == "ant",
            "n": cls_tokens[cls],
            "lemmas": len(cls_lemmas[cls]),
            "upos": dict(cls_upos[cls]),
            "cpdTokens": cls_cpd.get(cls, 0),
            "unplaceableTokens": cls_unplaceable.get(cls, 0),
            "reconstructedUnsandhiedTokens": cls_recon.get(cls, 0),
            "genders": genders,
            "topLemmas": [[lemma_tokens[l], lemma_str[l], lex_gram.get(l, "")]
                          for l in top_lemmas],
        }

    grand = sum(cls_tokens.values())
    out = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedBy": "gen_paradigm_nominal.py (H1472)",
        "corpusRelease": "DCS-2026",
        "source": {
            "db": os.path.basename(args.db),
            "sourceRepo": prov.get("source_repo"),
            "sourceCommit": prov.get("source_commit"),
            "importedAt": prov.get("imported_at"),
            "sha256": sha,
            "provenanceNote": ("pin 04e0778 orphaned after the dcs-conllu history "
                               "rewrite; the binding is the provenance table + SHA-256 "
                               "(same convention as Sangram G2 / pilots P1-P5)"),
        },
        "universeWhere": ("upos IN ('NOUN','ADJ') AND lemma IS NOT NULL AND feat_case IN "
                          "(8 real cases) AND feat_number IN ('Sing','Dual','Plur'); "
                          "homonyms keyed by lemma_id (G2's EM7)"),
        "cases": CASES,
        "numbers": NUMBERS,
        "cellsOrder": CELLS,
        "classIsHeuristic": True,
        "classHeuristicNote": ("class = first match of the lemma's citation form against "
                               "the G2 lemma-final tag list, extended with -ant; NOT a "
                               "corpus tag and NOT a paradigmatic classification"),
        "ceilingNote": CEILING_NOTE,
        "totals": {
            "gridTokens": grand,
            "cpdTokens": sum(cls_cpd.values()),
            "unplaceableTokens": sum(cls_unplaceable.values()),
            "lemmaIds": len(lemma_cls),
            "reconstructedUnsandhiedTokens": sum(cls_recon.values()),
            "nominalUniverseTokens": universe_total,
            "unplaceableReasons": dict(unplaceable_reasons),
        },
        "cellTotals": {c: case_number_totals.get(c, 0) for c in CELLS},
        "classes": classes,
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
    json_size = os.path.getsize(OUT_JSON)
    with open(OUT_JS, "w", encoding="utf-8") as fh:
        fh.write("// AUTO-GENERATED by gen_paradigm_nominal.py (H1472) -- do not hand-edit.\n")
        fh.write("window.PARADIGM_NOMINAL = ")
        json.dump(out, fh, ensure_ascii=False, sort_keys=True, separators=(",", ":"))
        fh.write(";\n")
    js_size = os.path.getsize(OUT_JS)
    print(f"wrote {OUT_JSON} ({json_size/1024:.0f} KB)")
    print(f"wrote {OUT_JS} ({js_size/1024:.0f} KB)")

    # ---- G2 reconciliation (consume, don't rebuild; log disagreements) ------------
    print("reconciling against Sangram G2 (lemma_cell_coverage.csv) ...")
    g2_found = os.path.isfile(G2_CSV)
    recon = [
        "# Nominal paradigm — Sangram G2 reconciliation (H1472)\n",
        "_Auto-generated by `gen_paradigm_nominal.py`. Cross-checks this asset against "
        "SanskritGrammar's Sangram G2 declension-cell coverage "
        "([lemma_cell_coverage.csv](https://github.com/gasyoun/SanskritGrammar/blob/main/sangram/data/declension_cell_coverage/lemma_cell_coverage.csv), "
        "H1048), which reads the same pinned `dcs_full.sqlite` with the same 24-cell "
        "matrix and the same `lemma_id` keying. Disagreements are logged here, never "
        "silently resolved._\n",
        "**Scope difference, by design:** G2's universe is `upos='NOUN'` only; this "
        "asset also takes `ADJ`, because the roadmap brief asks for noun **and "
        "adjective** paradigms. The comparison below is therefore run on the shared "
        "NOUN-only subset, and the ADJ-only surplus is reported separately rather than "
        "counted as a disagreement.\n",
    ]
    n_match = n_mismatch = n_only_here = n_only_g2 = 0
    rebucketed = defaultdict(int)
    mismatches = []
    if not g2_found:
        recon.append(f"**BLOCKED**: G2 CSV not found at `{G2_CSV}` — reconciliation "
                     "skipped, not silently passed. Re-run once SanskritGrammar is "
                     "checked out alongside VisualDCS.\n")
    else:
        g2 = {}
        with open(G2_CSV, encoding="utf-8") as fh:
            for row in csv.DictReader(fh):
                g2[int(row["lemma_id"])] = (row["lemma"], row["stem_final"],
                                            int(row["tokens"]), int(row["cells_attested"]))
        noun_ids = {lid for lid, u in lemma_upos_set.items() if "NOUN" in u}
        for lid in noun_ids:
            if lid not in g2:
                n_only_here += 1
                continue
            _lem, g2_stem, g2_tokens, g2_cells = g2[lid]
            mine_cells = len(lemma_cells_noun[lid])
            mine_tokens = lemma_tokens_noun[lid]
            if mine_cells == g2_cells and mine_tokens == g2_tokens:
                n_match += 1
            else:
                n_mismatch += 1
                if len(mismatches) < 200:
                    mismatches.append((lemma_str[lid], mine_tokens, g2_tokens,
                                       mine_cells, g2_cells))
            mine_stem = lemma_cls[lid]
            if mine_stem != g2_stem:
                rebucketed[(g2_stem, mine_stem)] += 1
        for lid in g2:
            if lid not in noun_ids:
                n_only_g2 += 1
        adj_ids = {lid for lid, u in lemma_upos_set.items() if u == {"ADJ"}}
        mixed_ids = {lid for lid, u in lemma_upos_set.items() if len(u) > 1}
        recon.append(
            f"## Shared NOUN subset\n\n"
            f"- **{n_match:,}** lemma_ids agree exactly on both token count and "
            f"attested-cell count.\n"
            f"- **{n_mismatch:,}** disagree"
            f"{' (listed below, capped at 200)' if n_mismatch else ''}.\n"
            f"- **{n_only_here:,}** NOUN lemma_ids here are absent from the G2 CSV.\n"
            f"- **{n_only_g2:,}** G2 lemma_ids are absent from this asset's NOUN set.\n"
            f"- **{len(adj_ids):,}** ADJ-only lemma_ids are this asset's own surplus "
            f"(outside G2's universe by design, not a disagreement).\n"
            f"- **{len(mixed_ids):,}** lemma_ids carry BOTH `NOUN` and `ADJ` tokens in "
            f"the master; they are compared on their NOUN tokens only.\n")
        recon.append("## Class re-bucketing vs G2's `stem_final`\n")
        if rebucketed:
            recon.append("Every lemma_id whose class differs from G2's tag, and why. The "
                         "only intended source of difference is the H1472 `-ant` "
                         "extension pulling stems out of G2's `other_consonant` residue; "
                         "anything else in this table is an unintended divergence and "
                         "should be treated as a defect.\n")
            recon.append("| G2 `stem_final` | this asset | lemma_ids | intended? |")
            recon.append("|---|---|--:|---|")
            for (g2s, mine), n in sorted(rebucketed.items(), key=lambda kv: -kv[1]):
                intended = "yes — `-ant` extension" if (mine == "ant" and g2s == "other_consonant") else "**NO — investigate**"
                recon.append(f"| `{g2s}` | `{mine}` | {n:,} | {intended} |")
            recon.append("")
        else:
            recon.append("No lemma_id changes class relative to G2.\n")
        if mismatches:
            recon.append("## Token/cell-count disagreements (first 200)\n")
            recon.append("| lemma | tokens here | tokens G2 | cells here | cells G2 |")
            recon.append("|---|--:|--:|--:|--:|")
            for lem, mt, gt, mc, gc in mismatches:
                recon.append(f"| {lem} | {mt:,} | {gt:,} | {mc} | {gc} |")
            recon.append("")
    os.makedirs(os.path.dirname(G2_RECON), exist_ok=True)
    with open(G2_RECON, "w", encoding="utf-8") as fh:
        fh.write("\n".join(recon) + "\n\n_Auto-generated by gen_paradigm_nominal.py._\n")
    print(f"wrote {G2_RECON}: match={n_match} mismatch={n_mismatch} "
          f"only_here={n_only_here} only_g2={n_only_g2}")

    # ---- build report ------------------------------------------------------------
    nom_sg = case_number_totals.get("Nom.Sing", 0)
    dual = sum(v for k, v in case_number_totals.items() if k.endswith(".Dual"))
    max_dual_cell = max(((k, v) for k, v in case_number_totals.items()
                         if k.endswith(".Dual")), key=lambda kv: kv[1], default=("—", 0))
    rep = [
        "# Nominal paradigm data build report (H1472)\n",
        f"_Auto-generated by `gen_paradigm_nominal.py` over "
        f"`{os.path.basename(args.db)}` (DCS-2026, pin `{prov.get('source_commit', '?')}`)._\n",
        "## Denominators\n",
        f"| quantity | tokens |\n|---|--:|",
        f"| placed on the 8 case × 3 number grid | {grand:,} |",
        f"| compound members (`feat_case='Cpd'`, **no case**) | {sum(cls_cpd.values()):,} |",
        f"| otherwise unplaceable ({', '.join(f'{r}: {n:,}' for r, n in sorted(unplaceable_reasons.items(), key=lambda kv: -kv[1])) or 'none'}) | {sum(cls_unplaceable.values()):,} |",
        f"| **= the whole NOUN/ADJ universe** (denominators close, asserted at build time) | **{universe_total:,}** |",
        f"| distinct `lemma_id` on the grid | {len(lemma_cls):,} |",
        f"| grid tokens whose unsandhied form is DCS-**reconstructed** | "
        f"{sum(cls_recon.values()):,} ({100.0*sum(cls_recon.values())/max(grand,1):.1f}%) |\n",
        "## Roadmap cross-check\n",
        "`roadmap.md` claims, from the 2021 `cs.csv` dump, that \"Nominative Sg = 34.6% "
        "of all nominal forms, Dual everywhere < 1%\". Recomputed here on the 2026 "
        "master, over the grid denominator:\n",
        f"- Nom.Sing = **{nom_sg:,}** = **{100.0*nom_sg/max(grand,1):.1f}%** of grid tokens.\n",
        f"- Dual (all cases pooled) = **{dual:,}** = **{100.0*dual/max(grand,1):.2f}%** of "
        f"grid tokens — so the claim does *not* hold for the dual as a whole.\n",
        f"- Read per cell, which is what the claim most likely means, it does hold: the "
        f"largest single dual cell is **{max_dual_cell[0]}** at **{max_dual_cell[1]:,}** = "
        f"**{100.0*max_dual_cell[1]/max(grand,1):.2f}%** of grid tokens, i.e. every one of "
        f"the 8 dual cells is under 1%.\n",
        "## Per-class shape\n",
        "| class | exemplar | grid tokens | lemma_ids | NOUN | ADJ | Cpd (excluded) | cells attested (max 24) |",
        "|---|---|--:|--:|--:|--:|--:|--:|",
    ]
    for cls, rec in sorted(classes.items(), key=lambda kv: -kv[1]["n"]):
        cells_any = set()
        for g in rec["genders"].values():
            cells_any |= set(g["cells"])
        rep.append(f"| `{rec['label']}`{' *(H1472 ext.)*' if rec['extendsG2'] else ''} "
                   f"| {rec['exemplar']} | {rec['n']:,} | {rec['lemmas']:,} "
                   f"| {rec['upos'].get('NOUN', 0):,} | {rec['upos'].get('ADJ', 0):,} "
                   f"| {rec['cpdTokens']:,} | {len(cells_any)} |")
    rep += [
        "",
        "## Ceiling / discipline\n",
        CEILING_NOTE + "\n",
        "## Reconciliation\n",
        f"Against Sangram G2 (H1048): match={n_match:,} mismatch={n_mismatch:,} "
        f"only-here={n_only_here:,} only-G2={n_only_g2:,} — full detail in "
        "[reports/nominal_g2_reconciliation.md](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_g2_reconciliation.md).\n",
        "## Outputs\n",
        f"- [visual/paradigm_nominal.json](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal.json) — {json_size/1024:.0f} KB\n",
        f"- [visual/paradigm_nominal_data.js](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal_data.js) — {js_size/1024:.0f} KB\n",
        "- [sanskrit_nominal_dashboard.html](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html) — the dashboard that reads them\n",
    ]
    os.makedirs(os.path.dirname(OUT_REPORT), exist_ok=True)
    with open(OUT_REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(rep) + "\n\n_Auto-generated by gen_paradigm_nominal.py._\n")
    print(f"wrote {OUT_REPORT}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
