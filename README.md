# VisualDCS

_Created: 20-04-2026 · Last updated: 05-09-2026_

Interactive frequency dashboards for the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/), built from corpus frequency data and rendered as standalone HTML files — no build step, no server, open directly in a browser.

---

## What is this?

The DCS is the largest annotated corpus of Sanskrit texts, containing hundreds of thousands of morphologically tagged verb and nominal forms. VisualDCS turns that raw frequency data into visual, interactive tools for learners and researchers who want to understand **what Sanskrit actually looks like in practice** — which forms dominate, which are rare, and how coverage accumulates.

---

## CSL Atlas DCS Handoff

VisualDCS is the home for DCS/corpus material moved out of `csl-atlas`. The
initial atlas handoff landed on 2026-06-04 in
[`VisualDCS` PR #4](https://github.com/gasyoun/VisualDCS/pull/4), under
[`docs/csl-atlas-migration/`](docs/csl-atlas-migration/).

Those files are migration material only; they are not yet integrated into the
runtime dashboards.

---

## Research Archive (`derived-data/`, `non-derived/`) — tracked, not part of the dashboards

Two large folders sit alongside this repo's code: [`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
and [`non-derived/`](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/README.md), together ~7.2GB / ~2,080 files. They're a personal
Sanskrit-linguistics research archive (much of it V.V. Leonchenko's "Цифровой корпус санскрита"
corpus-statistics work and related material) that predates and is broader than this repo's shipped
dashboards. Both are **git-tracked and pushed since 02-07-2026** (files >95MB as 7-Zip split
volumes, see [RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md); only the nested `Zalizniak/GH/`
git repos are excluded), but **neither feeds the dashboard pipeline**, which runs solely on
`src/DCS-data-2021/` and `src/DCS-data-2026/` below. Treat them as a reference archive to mine
for ideas or figures, not as live dashboard input.

- **`derived-data/`** — the DCS-corpus half: datasets computed by statistically analyzing corpus
  text (frequency counts, distributions, collocations, verb/nominal-form analysis, compounds,
  synonyms, and the large `Paralleli-v-tekstah-korpusa-SRC/` intra-corpus parallel-passage search).
  The most-frequent-Sanskrit-word / core-vocabulary lists specifically live in
  [`derived-data/Lexical-Cores/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md).
- **`non-derived/`** — the non-DCS half: dictionaries (Kochergina, PWG/MW comparisons, the
  Saudamani electronic dictionary), the NCC manuscript catalog, lecture/conference material,
  translations, and cloned external tool repos under `Zalizniak/GH/`.

Both were reorganized 02-07-2026 — folder names transliterated Cyrillic→Latin, a legacy
`Works/Share/` export tree merged and deduplicated, and topics split DCS-vs-non-DCS. Each folder
has its own `README.md` (context/how-to-work-with-it) and `INDEX.md` (per-folder size/file-count
table + full change history) — start there rather than exploring blind.

---

## Source Data

The repository draws on **two** upstream sources:

**1. `src/Распределение времен и наклонений.xlsx`** — an Excel file of raw frequency counts of
Sanskrit verb forms across the DCS corpus. It powers the verb-form frequency dashboard:

| Metric | Value |
|---|---|
| Total examples | 781,616 |
| Unique lemmas | 55,032 |
| Tense/mood categories | 38 |

**2. `src/DCS-data-2021/`** — a raw dump of the DCS corpus (CSV/txt: `10.csv` ≈ 4.57M annotated tokens,
`7.txt`, `_8.csv`, `cs.csv`, …). It is the source for the paradigm browser and the derived
concordance/JSON assets. Because some files exceed GitHub's 100 MB limit, the dump is split into
line-boundary parts (rebuild with `src/DCS-data-2021/rejoin.bat`) and stored as **plain git blobs**
(converted out of Git LFS to avoid the storage quota); see
[`DCS-data-CLEANUP.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/DCS-data-CLEANUP.md)
for the full inventory and rationale.

**3. `src/DCS-data-2026/`** — the **current** DCS distribution (CoNLL-U / Universal Dependencies, CC BY 4.0),
imported into a queryable SQLite master by a documented, validated pipeline. The full corpus —
**270 texts · 5,688,416 tokens · 754,726 sentences · 74 treebank texts** — is pinned to
[`gasyoun/dcs-conllu`](https://github.com/gasyoun/dcs-conllu) `@ 04e0778` (a submodule at
`src/DCS-data-2026/conllu`) and published as a SQLite **GitHub Release**
([`dcs-full-2026-03-05`](https://github.com/gasyoun/VisualDCS/releases/tag/dcs-full-2026-03-05), 287 MB gz).
Pipeline: `parse_conllu` → `import_dcs_conllu` → `coverage_diff` → `export_master` → `validate` →
`regen_widgets`, validated end-to-end (cross-walk 0 mismatches; CI re-runs the suite on push). See
[`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md) and `src/DCS-data-2026/reports/`
for the pipeline, the verb tense/mood **code map**, and the 2021→2026 deltas.

### Cross-repo consumer asset — `dcs_lemma_summary.json`

[`dcs_lemma_summary.json`](https://github.com/gasyoun/VisualDCS/blob/main/dcs_lemma_summary.json)
(**83,239 lemmas**) is the canonical DCS lemma-frequency summary that other repos in the org are
meant to consume directly instead of re-parsing the CoNLL-U corpus — VisualDCS is registered as
the org's DCS corpus/morphology ingest owner (family 8 in
[`SHARED_CODE.md`](https://github.com/gasyoun/SanskritLexicography/blob/master/SHARED_CODE.md)).
It is produced by [`gen_dcs_lemma_summary.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_dcs_lemma_summary.py)
from the DCS-2026 master and checked by
[`validate_dcs_lemma_summary.py`](https://github.com/gasyoun/VisualDCS/blob/main/validate_dcs_lemma_summary.py)
(CI-gated via [`validate-lemma-summary.yml`](https://github.com/gasyoun/VisualDCS/blob/main/.github/workflows/validate-lemma-summary.yml)).
It is the feed behind the `csl-atlas` DCS adapter.

### Aorist ≠ Perfect — the `Tense=Past` re-split (H1486)

UD's `Tense` inventory has no Aorist or Perfect value, so Sanskrit's two past tenses both
surface as `Tense=Past` (111,167 tokens). DCS's own `feat_formation` carries the past-stem
formation, and `regen_widgets.py` now uses it to re-separate them inside the finite past
indicative (93,329 tokens — the only sub-bucket where the feature is populated):

| class | rule | tokens | % of bucket |
|---|---|---:|---:|
| Aorist | `feat_formation` ∈ `root`·`them`·`red`·`s`·`is`·`sis`·`sa` (Whitney's seven aorist types) | 12,054 | 12.92% |
| Periphrastic Perfect | `feat_formation = peri` | 4,046 | 4.34% |
| Perfect | `feat_formation IS NULL` — DCS leaves the simple perfect unmarked | 77,229 | 82.75% |

Only the last row is a **default** rather than an observation, so it is measured, not
assumed: [`validate_past_tense_resplit.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/validate_past_tense_resplit.py)
runs four independent checks and writes
[`reports/past_tense_resplit_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/past_tense_resplit_validation.md).

**Read this before quoting either number.** Both classes are **bounds, not exact counts**:
Aorist is a *lower* bound (≥1.13% more aorists sit untagged inside Perfect, provably — the
same surface forms appear tagged elsewhere in the same bucket), and Perfect is an *upper*
bound additionally carrying ≥3.54% forms attested elsewhere as `Tense=Impf`, an upstream
tense-tagging inconsistency the re-split cannot repair.

This supersedes the repo's former claim that `feat_formation` is "present on <2% of verbs,
too sparse to re-split them". That divided 16,100 tags by *all* ~1.01M verb tokens; against
the finite past indicative — the only bucket the feature applies to — coverage is **17.25%**.
The split is applied in `verb_forms_ud.json` / `verb_forms_38cat.json`; it is deliberately
**not** propagated into `visual/paradigm_attested.json` (see the paradigm-trainer section).

**The other past moods cannot be split at all (H3878).** The re-split stops at
`Mood=Ind` because that is where the data stops: across the whole pinned distribution
`Formation` occurs 17,440 times and **never once outside `Mood=Ind`** — 16,100 on
`Tense=Past` and 1,340 on `Tense=Fut` (the periphrastic *future*, a different feature that
must never be summed with the periphrastic perfect). The 8,726 non-indicative past tokens
(Jus 4,067 · Imp 1,700 · Sub 1,317 · Opt 1,065 · Prec 577) and the 9,112 past participles
are unformationed **upstream**, so no query change here can recover a tag. Propagating from
identical surface forms attested elsewhere would reach 296 of them (3.39%), which is why
that inference layer was measured and rejected rather than built. Quote these moods by mood
only — `Mood=Jus` on `Tense=Past` is the augmentless injunctive, and whether it rests on an
aorist or an imperfect stem is exactly what DCS declines to say. Evidence and method:
[reports/past_nonindicative_formation_audit.md](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/past_nonindicative_formation_audit.md),
regenerable by
[`audit_past_nonindicative_formation.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/audit_past_nonindicative_formation.py)
and guarded by
[`test_past_nonindicative_formation.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/test_past_nonindicative_formation.py).

---

## Dashboards

Four standalone HTML tools, best entered via the landing page.

### [`sanskrit_index.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_index.html) — landing page / tool map

The recommended starting point. A single page that lays out a **Stage 1 → 4 learning path**
(which roots and forms to study first for the fastest corpus coverage) and a filterable grid of
tool cards. It advertises 11 planned tools; the three below are the ones currently built as
standalone files — the rest are described widgets, not yet shipped.

### [`sanskrit_verb_form_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_verb_form_dashboard.html) — verb-form frequency

**Distribution of Tenses, Moods, and Participles.** An interactive single-page dashboard with three
charts, built from the Excel source (38 categories, 781,616 examples):

| Chart | What it shows |
|---|---|
| Bar + Pareto curve | Frequency of each verb form category with cumulative % overlay |
| Pareto detail line | Cumulative coverage by form rank (top 5 → 77.6%, top 11 → 94.9%) |
| Lemma density bars | Unique lemmas per category (breadth of vocabulary per form) |

**Key findings:**

- Past Passive Participle leads with **233,079 examples (29.8%)**
- Present Indicative follows with **157,003 (20.1%)**
- Just **5 forms** cover **77.6%** of the entire corpus
- Just **11 forms** cover **94.9%** of the entire corpus

### [`sanskrit_pxn_v4.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4.html) — paradigm browser

An interactive paradigm browser for **6 roots** (√kṛ, √bhū, √as, √gam, √vac, √dā) across
**9 tenses × 9 person/number cells** (87 cells), built from the raw DCS corpus (`745,394` verbal
uses). Each cell is colour-coded by corpus frequency and clickable for real corpus examples.
Features: stem+ending colour split, root comparison, verb-class labels, a "what to study next"
coverage route, flashcard mode, a zero-cell filter, and CSV/Markdown export. Full feature
documentation is in [`sanskrit_pxn_v4_docs.md`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4_docs.md)
(Russian).

### [`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html) — paradigm trainer, attested verb space (H1299)

Scales the paradigm browser from 6 hand-picked roots to **7,689 corpus-attested roots**
(frequency floor >=2 total VERB tokens; top 100 = "full" tier, the rest = "attested-only"
long tail, cards with no hand-curated notes). Root picker with search + frequency rank,
attested-only cell rendering by construction (every cell shown carries at least one real
corpus form + count), and a frequency-weighted flashcard trainer mode with a JSON deck
export for downstream SRS. Built by
[`src/DCS-data-2026/gen_paradigm_attested.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_attested.py)
from the full 2026 DCS master (`dcs_full.sqlite`, 270 texts, 1,007,361 VERB tokens);
regression-pinned by
[`src/DCS-data-2026/test_paradigm_attested.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/test_paradigm_attested.py).
Loads `visual/paradigm_attested_data.js` via a plain `<script src>` (no `fetch()`, no
server) -- keep both files together when copying. The 6-root deep view
(`sanskrit_pxn_v4.html`) is untouched and still the tool for those 6 roots' full
textbook paradigm with P./A. columns.

**Data ceiling -- read before trusting a cell as "resolved":** DCS tags unaccented text,
so it cannot distinguish verb class I vs VI, or class IV vs the passive formation, at
the root-class level -- **no Panini class number is shown anywhere in this dataset**.
`Tense=Past` conflates aorist and perfect in UD, but DCS's own `feat_formation` re-splits
the finite past indicative, and **since H2294 this dataset carries that split too** —
`Aorist` / `Periphrastic Perfect` / `Perfect` are separate per-root cell categories, and
the E46 reconciliation was re-run unchanged (6,454 matching roots, 0 disagreements). The
split is **bounded and one-sided, and the dataset says which way**: `Aorist` and
`Periphrastic Perfect` are read off `feat_formation`, while `Perfect` is the **unmarked
default** — DCS does not tag the simple perfect, so every `Perfect` cell is 100% inferred
rather than observed. The dataset therefore ships a `cellEvidence` map
(`formation-attested` vs `defaulted`) and the trainer badges it on every cell, flashcard
and exported deck card: the defaulted share of a cell is exactly 0% or 100% — never in
between, asserted at build time — which is what makes a per-category marker exact rather
than an approximation. **Aorist is a lower bound, Perfect an upper bound** (>=1.13%
aorist leakage, >=3.54% imperfect contamination); prose quoting either as an exact corpus
count is a defect. `feat_voice`
only tags Passive vs non-passive -- parasmaipada vs atmanepada is **not** separately
tagged by DCS, so non-passive finite forms for a cell are pooled together (unlike the
6-root RD grid's P./A. columns, which come from external grammatical knowledge, not
this corpus tag set). Full report:
[`reports/paradigm_attested_build.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_attested_build.md);
cross-check against csl-observatory's E46 paradigm-cell-coverage census:
[`reports/e46_reconciliation.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/e46_reconciliation.md).

### [`sanskrit_nominal_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html) — nominal paradigm, case × number (H1472)

The nominal twin of the verb paradigm browser, and the tool `roadmap.md` had been calling
"the most obvious next step" since 2026-06: the **8 case × 3 number grid per declension
class**, over **2,263,192 cased NOUN + ADJ tokens** (against 781k verbal ones). Pick a stem
class (`-a`, `-ā`, `-i`, `-ī`, `-u`, `-ū`, `-ṛ`, `-an`, `-in`, `-ant`, `-as`, `-is`, `-us`,
plus an explicit `other consonant` residue) and a token gender; each cell is colour-coded by
its share within that gender and opens the attested surface endings, the top attested forms,
and real corpus sentences with text + reference. Built by
[`src/DCS-data-2026/gen_paradigm_nominal.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal.py)
from the pinned 2026 DCS master; render-tested headlessly by
[`tests/test_nominal_dashboard.js`](https://github.com/gasyoun/VisualDCS/blob/main/tests/test_nominal_dashboard.js)
(`node tests/test_nominal_dashboard.js`). Loads `visual/paradigm_nominal_data.js` via a plain
`<script src>` (no `fetch()`, no server) — keep both files together when copying.

**Data ceiling — read before trusting a cell:**

- **Declension class is not a corpus tag.** DCS tags case, number and gender, never a
  declension class. Every class label here is an orthographic heuristic over the lemma's
  citation form, reusing the tag list of SanskritGrammar's Sangram G2 asset (H1048) and its
  "citation form ≠ stem" caveat, extended with the `-ant` class G2 leaves in its residue.
- **Compound members are not a case.** 724,676 NOUN/ADJ tokens carry `feat_case='Cpd'` — no
  case at all. They are excluded from the grid and counted separately per class, so the
  dashboard can never pass the grid off as the whole nominal picture. Grid + Cpd +
  case-untagged = 2,996,410 = the entire NOUN/ADJ universe, asserted at build time.
- **A gender column is not a gender paradigm.** The axis is the *token's* tagged gender: an
  adjective cited in its masculine `-a` form contributes its feminine tokens (`paramayā`) to
  the `-a` class's Fem column, where they inflect as ā-/ī-stems.
- **Endings are surface residues, not morphemes** — what is left after stripping the
  class-marked stem; where the form does not start with that stem (strong/weak alternation,
  `rājan` → `rājñā`) the token is counted as not segmentable and left out of the endings
  view rather than force-split. The segmentable share is shown per class and per cell.
- **The form shown is DCS's unsandhied analysis, not manuscript surface** — 68.0% of grid
  tokens are flagged `m_unsandhiedreconstructed`.
- Known unsplit conflations, labelled per class: `-ī` pools the `devī`/`nadī` type with the
  monosyllabic `śrī`/`strī` type; `-an` pools `-an`/`-man`/`-van`; `-ant` pools
  `-ant`/`-vant`/`-mant` with the master's own `-at`/`-vat`/`-mat` citations of the same
  stems; `other consonant` is a residue bucket, not a class.
- **Two of those conflations are now split (H3984)** on an external lexical signal, not a
  character rule: `-ī` by IAST vowel-nucleus count (17 lemma_ids / 6,373 tokens monosyllabic
  vs 4,477 / 58,295 polysyllabic), `-ant` by MW+PWG csl-json headword **entry-id sets**
  (191 / 8,851 one-lexeme-two-spellings, 0 two-headwords, 36 / 70 left pooled with no
  dictionary witness). NOUN universe only — the ADJ mass is declared unreached, not
  estimated. Builder
  [`src/DCS-data-2026/split_pooled_nominal_classes.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/split_pooled_nominal_classes.py),
  reports [`reports/nominal_pooled_class_split.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_pooled_class_split.md)
  + [`reports/nominal_g2_reconciliation_split.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_g2_reconciliation_split.md)
  (`reconciles: true`, no G2 total moves), payload `visual/paradigm_nominal_class_split.json`.
  The `paradigm_nominal.json` buckets themselves are unchanged — the split is an additive
  side-car. See [GAPS §14](https://github.com/gasyoun/SanskritLexicography/blob/master/GAPS.md)
  and [FINDINGS §630](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md).
- **The `-ant` pool's ADJ half is now measured too (H4011)** — the surplus H3984 declared
  unreached. Sourced per-lemma from the DCS master (read-only) instead of the NOUN-only G2
  CSV: **36,768 ADJ tokens over 1,880 lemma_ids**, adjudicated by the same MW+PWG entry-id
  signal into **34,809 / 1,015 one-lexeme-two-spellings, 0 two-headwords, 661 / 193
  `at_only`, 95 / 13 `ant_only`, 1,203 / 659 left pooled**. The pinned `bhagavat`
  (lemma_id 48482, ADJ, 3,238 tokens) is finally classified: **one lexeme, two spellings**.
  The `-ī` class's 664 ADJ tokens / 54 lemma_ids are split by the same syllable count
  (31 / 3 monosyllabic vs 633 / 51 polysyllabic). With both halves in, the `-ant` pool is
  **100 % inventoried** and **97.4 % of its token mass carries a verdict**; every NOUN and
  Sangram G2 total is re-derived and unmoved. Builder
  [`src/DCS-data-2026/split_pooled_nominal_classes_adj.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/split_pooled_nominal_classes_adj.py),
  report [`reports/nominal_pooled_class_split_adj.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_pooled_class_split_adj.md),
  payload `visual/paradigm_nominal_class_split_adj.json` — a sibling, not an overwrite.

Full report:
[`reports/paradigm_nominal_build.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_nominal_build.md);
cross-check against Sangram G2's declension-cell coverage (57,144 lemma_ids, exact agreement
on tokens and attested cells): [`reports/nominal_g2_reconciliation.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_g2_reconciliation.md).

### [`sanskrit_nominal_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_trainer.html) — per-lemma nominal trainer (H2321)

The nominal twin of
[`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html):
**31,753 NOUN lemmas** (frequency floor ≥ 2 tokens; top-100 = `full` tier) with a search list,
an 8 case × 3 number grid of *attested* cells only, frequency-weighted flashcards, and JSON
deck export. Built by
[`src/DCS-data-2026/gen_paradigm_nominal_lemmas.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal_lemmas.py);
render-tested by
[`tests/test_nominal_trainer.js`](https://github.com/gasyoun/VisualDCS/blob/main/tests/test_nominal_trainer.js)
(`node tests/test_nominal_trainer.js`). Loads
`visual/paradigm_nominal_lemmas_data.js` via `<script src>` — keep both files together.

**Load-bearing constraint — coverage is not re-derived.** The 24-cell bitstring for every
lemma is taken from SanskritGrammar Sangram G2's
[`lemma_cell_coverage.csv`](https://github.com/gasyoun/SanskritGrammar/blob/main/sangram/data/declension_cell_coverage/lemma_cell_coverage.csv)
(H1048; 57,144 lemmas, already reconciled exactly against this repo's class dashboard). Forms
and per-cell counts come from the pinned master, and only for cells G2 already marks attested.
The generator **refuses** on any token-count or cell-set drift vs G2 (measured: 0 / 0).

**Data ceiling:** same as G2 + H1472 — median cells/lemma is 1; a full 24-cell paradigm is
almost never attested; `stem_final` is a citation-form tag; forms are DCS unsandhied analyses
(often reconstructed). Hapax lemmas below the floor stay in G2 but are out of this trainer asset.

Build report:
[`reports/paradigm_nominal_lemmas_build.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_nominal_lemmas_build.md).

### [`sanskrit_anki_decks.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_anki_decks.html) — Anki-deck flashcard widget (H1504)

A standalone flashcard viewer over the already-computed `visual/anki_compact.json` — **200
cards across 4 learning stages** (Stage 1: √kṛ, √vac, √bhū, √as; Stage 2: √gam, √dṛś, √dā,
√śru, √sthā, √brū, √ah; Stage 3 and 4 widen to the long tail). Data is embedded directly in
the page (no `fetch()`, no companion file — the whole deck is ~16 KB of JSON), so the file
is self-contained and opens directly from disk. Stage filter, click-to-flip cards, a
**CSV export** in Anki's plain-text import format (`#separator:Comma` / `#html:true` /
`#columns:Front,Back,Tags` header, HTML-formatted backs, per-card tags), and a **Markdown
export** grouped by stage for Obsidian. The landing page's *Anki-деки* (D2) card links to it
directly.

### [`sanskrit_concordance.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_concordance.html) — concordance search (H1505)

A standalone search widget over the 6,423-form concordance that had, until now, only been
consumed inline by other dashboards' example panels. Type a root or an inflected form
(diacritic-insensitive, so ASCII `kuryat` matches `kuryāt`) and get every matching form with
its total corpus occurrence count and up to 5 real example strophes, each with a source
citation and the query highlighted in place. Built by
[`gen_concordance_data.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_concordance_data.py),
which packs the existing `visual/conc_part1/2/3.json` into a single
`visual/conc_data.js` `window.*` script twin (≈5.3 MB, no `fetch()`, no server — works from a
double-clicked `file://` page); render-tested headlessly by
[`tests/test_concordance.js`](https://github.com/gasyoun/VisualDCS/blob/main/tests/test_concordance.js)
(`node tests/test_concordance.js`). The landing page's "Конкорданс" card now opens it directly.

### [`dcs_corpus_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/dcs_corpus_dashboard.html) — corpus / genre statistics

**DCS Corpus Statistics** (Russian UI). A single page summarising the corpus by text and genre,
consuming the tracked JSON assets [`visual/corpus_stats_widget.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/corpus_stats_widget.json),
[`visual/dcs_genres.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/dcs_genres.json)
(18 genre profiles), and [`visual/dcs_texts_clean.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/dcs_texts_clean.json)
(288 texts with tense profiles). The landing-page cards *Корпусная статистика* and *DCS: 17 жанров*
open it.

> The two verb dashboards report different headline totals (781,616 vs 745,394) because they use
> different aggregations of the corpus — the Excel's 38 tense/mood categories vs the browser's
> 87 person×number / non-finite cells.

---

## Data Assets

The repository also tracks a set of derived JSON and reference files used to power future dashboards and widgets:

| File | Contents |
|---|---|
| `docs/csl-atlas-migration/` | DCS/corpus handoff material migrated out of `csl-atlas` |
| `sanskrit_verb_forms.md` | Obsidian reference for the top 100 roots with paradigms |
| `visual/dcs_texts_clean.json` | 288 texts with tense profiles |
| `visual/dcs_genres.json` | 18 genre profiles — 17 named families + `Other` (weighted averages) |
| `visual/dcs_scatter.json` | 170 data points for diachronic charts |
| `visual/form_lookup.json` | 7,873 verb forms → root / tense / rank |
| `visual/coll_compact.json` | 800 lemmas × collocates by part of speech |
| `visual/paradigm_endings.json` | 25 tenses × attested endings from the corpus |
| `visual/paradigm_attested.json` / `paradigm_attested_data.js` | H1299: 7,689 roots × attested finite/non-finite cells (top-100 full tier + long tail), consumed by `sanskrit_paradigm_trainer.html` |
| `visual/paradigm_nominal.json` / `paradigm_nominal_data.js` | H1472: 14 declension classes × token gender × 24 case·number cells — counts, surface endings, top forms, corpus examples; consumed by `sanskrit_nominal_dashboard.html` |
| `visual/paradigm_nominal_lemmas.json` / `paradigm_nominal_lemmas_data.js` | H2321: 31,753 NOUN lemmas × G2-attested cells + top forms; coverage from G2, forms from pin; consumed by `sanskrit_nominal_trainer.html` |
| `visual/paradigm_nominal_class_split.json` | H3984: the `-ī` and `-ant` pools re-bucketed on an external lexical signal (syllable count; MW/PWG entry-id sets) with per-lemma verdicts and the G2 reconciliation totals; additive side-car to `paradigm_nominal.json`, no dashboard consumer yet |
| `visual/paradigm_nominal_class_split_adj.json` | H4011: the `-ant` pool's **ADJ half** (36,768 tokens / 1,880 lemma_ids) inventoried per-lemma from `dcs_full.sqlite` and adjudicated on the same MW/PWG entry-id signal, plus the `-ī` class's non-NOUN residue; sibling of the H3984 payload, which it does not modify |
| `visual/corpus_stats_widget.json` | Summary morpho-statistics for widgets |
| `visual/anki_compact.json` | 200 Anki flashcards |
| `visual/conc_totals.json` | 6,423 forms → total occurrences in corpus |
| `visual/conc_part1/2/3.json` / `conc_data.js` | Concordance: 6,423 forms × ≤5 examples (2,141 forms per part); `conc_data.js` is the packed `window.*` twin consumed by `sanskrit_concordance.html` (H1505) |
| `verb_classes.json` | 13 verb classes with P/Ā distribution |
| `tense_case_data.json` | Form frequencies + case data (from cs.csv) |
| `morph_pn.json` | Person × number by tense (from 10.csv) |
| `prefix_clean.json` | Prefix productivity scores |
| `passage_library.json` | 40 curated passages from the corpus |

> JSON files live in two places — most under `visual/`, but `verb_classes`, `tense_case_data`,
> `morph_pn`, `prefix_clean`, and `passage_library` sit at the repo root.

---

## Other tracked material

Beyond the dashboards, source data, and research archive, the repo also holds:

- **[`papers/`](https://github.com/gasyoun/VisualDCS/tree/main/papers)** — the A38 data-descriptor
  paper for the DCS-2026 SQLite release ([`A38_dcs2026_release_paper.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_dcs2026_release_paper.md))
  and its [`A38_release_checklist.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_release_checklist.md)
  (Zenodo deposit + DOI-mint steps, still pending the upstream CC-BY sign-off).
- **[`derived-parametric-core/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-parametric-core/README.md)** —
  a dictionary-side **parametric core of Sanskrit** extracted from PWG (Voronezh-school
  parametric-lexicology method of V. T. Titov / A. A. Kretov), cross-checked against V. V.
  Leonchenko's corpus core in [`derived-data/Lexical-Cores/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md).
  A separate, additive dataset — the Leonchenko sources in `derived-data/` are untouched.
- **[`mockups/`](https://github.com/gasyoun/VisualDCS/tree/main/mockups)** — non-destructive dark
  data-app restyles of the three shipped dashboards (CSS-only; the dashboard scripts are
  byte-identical). Design exploration, not the live pages.

---

## Methodology

Dashboards use **Pareto % (cumulative frequency %)** to show how corpus coverage concentrates in a small number of high-frequency forms.

### How Pareto % is calculated

Forms are sorted by descending frequency. Pareto %[N] is the share of the total covered by the top N forms:

```
Pareto %[N] = (Count₁ + Count₂ + … + CountN) / Total × 100

Example: (233,079 + 157,003) / 781,616 × 100 = 49.91%
```

### Key thresholds in this corpus

| Coverage | Forms needed |
|---|---|
| ~50% | 2 forms (PPP + Pres. Ind.) |
| ~80% | 5–6 forms |
| ~95% | 11 forms |
| 100% | 38 forms |

The remaining 27 forms form a **long tail** — together they add only ~3.7% of coverage despite representing the majority of distinct categories.

For full methodology with term definitions, see [`pareto.md`](https://github.com/gasyoun/VisualDCS/blob/main/pareto.md).

---

## Roadmap

**✅ Already shipped** (in `sanskrit_pxn_v4.html`, plus the landing page):
- **Landing page / tool map** with a Stage 1 → 4 learning path — `sanskrit_index.html`
- **Concordance integration** — clicking a paradigm cell opens real corpus examples for that form
- **Root comparison** — a second root shown inline under each form
- **Stem + ending colour split** — invariant ending highlighted, stem greyed
- **Flashcard mode** — a cell as a question (root + person + tense → ?), answer on flip
- **"What to study next" route** — slider-driven, by corpus coverage gain
- **Attested-only filter** — hide paradigm cells with zero corpus examples
- **CSV / Markdown export**
- **Per-root attestation counts, scaled to the whole attested verb space (H1299)** — done via
  [`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html)
  (7,689 roots, not just the 6 hand-picked ones; attested-only by construction, frequency-weighted
  trainer mode, JSON deck export). Supersedes the "Per-root attestation counts" item below for the
  general case; the 6-root deep view keeps its own richer P./Ā.-split cells for those 6 roots.

- **Nominal paradigm dashboard, case × number per declension class (H1472)** — done via
  [`sanskrit_nominal_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html)
  (2,263,192 cased NOUN + ADJ tokens, 14 stem classes × token gender × 24 cells, surface
  endings + corpus examples per cell). This was the roadmap's "biggest unbuilt item".

- **Anki-deck flashcard widget (H1504)** — done via
  [`sanskrit_anki_decks.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_anki_decks.html)
  (200 cards, 4 learning stages, stage filter, CSV export for Anki + Markdown export for
  Obsidian, data embedded so no companion file is needed). Landing page's D2 card flipped
  from `type:'widget'` to `type:'file'`.

- **Concordance search widget (H1505)** — done via
  [`sanskrit_concordance.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_concordance.html)
  (6,423 forms, diacritic-insensitive search, total occurrence count + up to 5 example
  strophes with citation per form). The landing page's "Конкорданс" card flipped from
  `type:'widget'` to `type:'file'`.

- **Print / PDF one-page export (H1536)** — an on-screen "🖨 Печать / PDF" button (`window.print()`)
  plus an `@media print` stylesheet in
  [`sanskrit_pxn_v4.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4.html) and
  [`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html):
  Ctrl+P / clicking the button hides all nav/controls/side panels and prints only the current
  paradigm grid, one page.

- **Per-lemma nominal drill-down trainer (H2321)** — done via
  [`sanskrit_nominal_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_trainer.html)
  (31,753 NOUN lemmas, G2 coverage oracle, frequency-weighted trainer). See the section above.

**🔴 Still planned — high priority**
- **Split the `-ī` and `-ant` conflations** — needs an external lexical signal (stem
  syllable count / a dictionary class tag); DCS alone cannot separate `devī` from `śrī`,
  and no guess is made in the current asset.

See [`roadmap.md`](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md) for the original discussion.

---

## Tech Stack

- **Data:** Microsoft Excel (`.xlsx`) for the frequency tables; raw DCS corpus CSV/txt under `src/DCS-data-2021/` (plain git blobs, split into line-boundary parts — converted out of Git LFS) for the paradigm browser; derived JSON in `visual/` and the repo root
- **Dashboards:** Vanilla HTML + [Chart.js 4.4.1](https://www.chartjs.org/) — no build step, no dependencies, open directly in browser

---

## License

- **Code and dashboards** (the HTML tools, Python pipeline, and derived JSON): [Apache 2.0](https://github.com/gasyoun/VisualDCS/blob/main/LICENSE).
- **The DCS-2026 SQLite master and its exports**: **CC BY 4.0**, inherited from the upstream
  Digital Corpus of Sanskrit (Hellwig, CC BY 4.0). Cite it per
  [`CITATION.cff`](https://github.com/gasyoun/VisualDCS/blob/main/CITATION.cff), and cite the
  underlying corpus annotation separately.

---

_Dr. Mārcis Gasūns_
