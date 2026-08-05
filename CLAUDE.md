# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**VisualDCS** — Interactive frequency dashboards for the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/), built from corpus frequency data and rendered as standalone HTML files. No build step, no server, open directly in a browser.

The project transforms raw morphological frequency data (781,616 verb examples from the DCS) into interactive visualizations that show:
- Which Sanskrit verb forms dominate in actual texts
- How many forms are needed to cover 50%, 80%, 95% of corpus frequency (Pareto analysis)
- Per-form vocabulary breadth (lemma density)
- Per-root paradigms with corpus frequency color-coding
- Concordance examples from real texts

All dashboards are standalone `.html` files that run entirely in the browser — no build step, no dependencies beyond Chart.js.

---

## Architecture

### Data Flow

There are **two** upstream sources, not one:

```
src/Распределение времен и наклонений.xlsx        src/DCS-data-2021/ (raw DCS corpus dump:
(38-category tense/mood frequencies)               10.csv, _8.csv, 7.txt, cs.csv, …)
    ↓                                                   ↓
[manual extraction / Python]                       [Python processing]
    ↓                                                   ↓
sanskrit_verb_form_dashboard.html                  JSON data files (form_lookup.json,
(781,616 examples, 38 categories)                  paradigm_endings.json, conc_part1/2/3.json,
                                                    visual/*.json, root-level *.json)
                                                        ↓
                                                   sanskrit_pxn_v4.html + sanskrit_index.html
                                                   (embedded Chart.js + data)
```

The Excel file (`src/Распределение времен и наклонений.xlsx`) contains:
- Raw frequency counts of 38 tense/mood categories
- 781,616 total verbal examples
- 55,032 unique lemmas

The raw corpus dump under `src/DCS-data-2021/` (added 2026-06-05, Git LFS + split parts; see
`DCS-data-CLEANUP.md`) is the source for the paradigm browser and the concordance/JSON assets.
Its `10.csv` carries ~4.57M morphologically annotated tokens; the paradigm browser reports
**745,394** verbal uses across 87 person×number/non-finite cells — a different aggregation than the
Excel's 38-category 781,616, so the two headline totals are expected to differ.

### Key Files & Structure

| File | Purpose |
|---|---|
| `src/Распределение времен и наклонений.xlsx` | Excel source — 38-category verb-frequency data |
| `src/DCS-data-2021/` | Raw DCS corpus dump (CSV/txt, Git LFS + split parts) — source for the paradigm browser and concordance/JSON assets. See `DCS-data-CLEANUP.md` |
| `sanskrit_index.html` | **Landing page / tool map** — Stage 1→4 learning path + cards for 11 tools (only some are built yet); the recommended entry point |
| `sanskrit_verb_form_dashboard.html` | Frequency distribution dashboard with Pareto curve, bar charts, lemma density (781,616 examples) |
| `sanskrit_pxn_v4.html` | Interactive paradigm browser: **6 roots (√kṛ √bhū √as √gam √vac √dā) × 9 tenses × 9 person/number cells** (87 cells), corpus color-coding, examples panel, root comparison, stem+ending split, flashcard mode, zero-filter, CSV/MD export |
| `sanskrit_pxn_v4_docs.md` | Feature-by-feature documentation for the paradigm browser (Russian) |
| `sanskrit_paradigm_trainer.html` | H1299: attested-verb-space paradigm trainer, 7,689 roots (top-100 full tier + attested-only long tail), frequency-weighted flashcards, JSON deck export |
| `sanskrit_nominal_dashboard.html` | H1472: **nominal** paradigm — 8 case × 3 number grid per declension class (14 heuristic stem classes × token gender), surface endings + attested forms + corpus examples per cell, over 2.26M cased NOUN/ADJ tokens |
| `sanskrit_anki_decks.html` | H1504: Anki-deck flashcard widget — 200 cards across 4 learning stages (data embedded, no companion file), stage filter, CSV export (Anki-importable) + Markdown export (Obsidian) |
| `sanskrit_concordance.html` | H1505: standalone **concordance search** — type a root/form, get every match's total corpus count + up to 5 example strophes with citation, diacritic-insensitive, fully client-side |
| `visual/` | Derived JSON data assets (concordance, genres, texts, collocates, …) |
| `*.json` (repo root) | Derived JSON assets read by the dashboards: `morph_pn`, `tense_case_data`, `verb_classes`, `prefix_clean`, `passage_library` |
| `pareto.md` | Methodology documentation for Pareto % calculation |
| `roadmap.md` | Prioritized feature roadmap (Russian) — much of it now shipped; see status note at its top |
| `sanskrit_verb_forms.md` | Obsidian reference for top 100 roots with paradigms |

### JSON Data Files

Each is embedded or referenced by the HTML dashboards. **Note the two locations** — most live in
`visual/`, but five sit at the repo root.

In `visual/`:

| File | Contents | Primary User |
|---|---|---|
| `form_lookup.json` | 7,873 forms → root / tense / rank | paradigm browser |
| `paradigm_endings.json` | 25 tenses × attested endings from corpus | paradigm browser |
| `paradigm_attested.json` / `paradigm_attested_data.js` | H1299: per-root (7,689) attested finite/non-finite cells, full corpus scale | paradigm trainer |
| `paradigm_nominal.json` / `paradigm_nominal_data.js` | H1472: 14 declension classes × token gender × 24 case·number cells (counts, surface endings, attested forms, corpus examples) | nominal dashboard |
| `dcs_texts_clean.json` | 288 texts with tense profiles | diachronic analysis |
| `dcs_genres.json` | 18 genre profiles — 17 named families + `Other` (weighted averages) | genre comparison |
| `dcs_scatter.json` | 170 diachronic data points | timeline charts |
| `coll_compact.json` | 800 lemmas × collocates by POS | collocate explorer |
| `conc_part1/2/3.json` | Concordance: 6,423 forms × ≤5 examples (2,141 each) | example lookup |
| `conc_totals.json` | 6,423 forms → total corpus occurrences | example lookup |
| `conc_data.js` | H1505: packed `window.CONC_DATA` twin of `conc_part1/2/3.json` (all 6,423 forms, one file) | concordance search widget |
| `anki_compact.json` | 200 Anki flashcard definitions | flashcard mode |
| `corpus_stats_widget.json` | Morpho-statistics summary | dashboard widgets |

At the repo root:

| File | Contents | Primary User |
|---|---|---|
| `tense_case_data.json` | Form frequencies + case data | (future nominal dashboard) |
| `morph_pn.json` | Person × number distribution per tense | paradigm display |
| `passage_library.json` | 40 curated passages from corpus | passage reader |
| `prefix_clean.json` | Prefix productivity scores | affix analysis |
| `verb_classes.json` | 13 verb classes with P/Ā distribution | paradigm context |

---

## Key Concepts

### Pareto Analysis

Core methodology: forms are ranked by descending corpus frequency; **Pareto %** = cumulative share of total corpus by top-N forms.

- **5 forms** cover **77.6%** (Past Passive Participle, Present Indicative, Absolutive, Present Potential, Perfect Indicative)
- **11 forms** cover **94.9%**
- **38 forms** cover **100%**

This drives the learning strategy: focus first on high-frequency forms for maximum corpus coverage gain. See `pareto.md` for full methodology.

### Paradigm Representation

Sanskrit verb forms are displayed as grids:
- Rows: person/number (1s, 2s, 3s, 1d, 2d, 3d, 1p, 2p, 3p)
- Columns: tense/mood (Present, Imperfect, Aorist, Perfect, Future, Conditional, etc.)
- Cell color: corpus frequency (darker = more common)
- Cell content: attested ending + frequency count

The `paradigm_endings.json` file maps each (tense, person/number) cell to real corpus attestations.

### Flashcard Mode

Interactive drill mode in `sanskrit_pxn_v4.html`: presents a cell (root + tense + person) as a question, answer on click. Data comes from `morph_pn.json` (correct forms) + `conc_part1/2/3.json` (corpus examples).

---

## Development Workflow

### Session State Tracking

This project uses `.ai_state.md` for multi-session continuity:

```markdown
# Project Objective: [High-level goal]
## ➡️ Next Steps (Queue)
## 🚧 Current Work-In-Progress (WIP)
## 🧠 Dev Notes & Hypotheses (Bugs, ideas, context)
## ✅ Completed (Recent only)
```

**When finishing work:**
- Move completed sub-tasks to `## ✅ Completed`
- Record persistent bugs or architectural decisions in `## 🧠 Dev Notes & Hypotheses`
- Write explicit `## ➡️ Next Steps` with concrete next micro-tasks
- Commit with `ai-wip:` prefix after logical milestones

### Adding a New Dashboard

1. Extract / compute data and save to `visual/` as JSON
2. Create a new `.html` file with embedded Chart.js or table markup
3. Load data inline (via `<script>const data = {...}</script>`) or from `visual/*.json`
4. Test by opening directly in browser (no server needed)
5. Update README.md to describe the new dashboard
6. Commit both HTML and JSON

### Modifying HTML Dashboards

- All JavaScript is inline (no separate `.js` files)
- Chart.js 4.4.1 is loaded from CDN (https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js)
- Color scheme: blue (`#3266ad`), red (`#e24b4a`), teal (`#1d9e75`)
- Responsive design via CSS Grid and Flexbox
- Dark mode support via `@media(prefers-color-scheme:dark)` in `<style>` blocks

### Sync rules — change one side, change the other in the same PR

- **`gen_paradigm_nominal.py` → regenerate → re-run the test.** Any edit to the generator or to
  `sanskrit_nominal_dashboard.html` means `python src/DCS-data-2026/gen_paradigm_nominal.py`
  (full run, real SHA-256 — never ship `--skip-checksum` output) **and**
  `node tests/test_nominal_dashboard.js` in the same PR. The test executes the page's own
  inline script against the real data, so a page/data contract break fails there and nowhere
  else.
- **Never weaken the denominator-closure assertion.** The generator exits non-zero unless
  grid + `Cpd` + unplaceable equals the whole NOUN/ADJ universe. It exists because a
  `NOT (feat_case IN (…) AND feat_number IN (…))` complement silently lost 8,542 case-untagged
  tokens to SQL three-valued logic. Any new per-slice query here needs the same closure check.
- **`past_class()` → re-run the validator, and never quote its output as exact.** The
  aorist/perfect re-split in `regen_widgets.py` (`AORIST_FORMATIONS`, `past_class`,
  `is_past_indicative`) rests on one default — `feat_formation IS NULL` → Perfect, because DCS
  leaves the simple perfect unmarked. Any edit to those rules means re-running
  `python src/DCS-data-2026/validate_past_tense_resplit.py` in the same PR; it re-measures the
  default's error bars and asserts denominator closure. `validate_past_tense_resplit.py`
  **imports** the rules rather than restating them, so the validator cannot drift from what it
  validates — keep it that way. The resulting Aorist count is a **lower** bound and Perfect an
  **upper** bound; prose that quotes either as an exact corpus count is a defect (H1486).
- **The re-split IS in `paradigm_attested.json` (H2294) — and it is applied per token, not
  looked up.** `gen_paradigm_attested.py` calls `past_class()` itself on the finite past
  indicative; it does **not** get the split from `ud_to_category`, which is keyed on
  `(Tense,Voice,Mood)` and structurally cannot carry a per-token feature. So **re-running the
  generator is not how you propagate a change to the split** — anyone planning that as "just
  re-run it" has mis-scoped the work. The merged `Perfect/Aorist` entry still sitting in
  `ud_to_category` is now dead for finite-past rows; leave it as the fallback label, don't
  "fix" it. Regenerating means re-running the E46 reconciliation in the same PR and confirming
  per-root distinct-cell counts are **unchanged** (6,454 match / 0 disagree) — the split
  touches the **display** category only, never the E46 5-tuple, which is byte-identical to
  csl-observatory's census by design.
- **`cellEvidence` must ship with the data, and its degeneracy is asserted, not assumed.**
  `Perfect` IS the untagged residue (`feat_formation IS NULL`), so no `Perfect` cell can carry
  formation evidence and no `Aorist`/`Periphrastic Perfect` cell can lack it — the per-cell
  defaulted share is exactly 0% or 100%. That is the only reason a per-CATEGORY evidence flag
  is honest at per-cell granularity. `assert_evidence_degenerate()` fails the build if it ever
  stops holding; **do not weaken or delete it** — at that point per-cell marking becomes
  mandatory, and a category flag would start quietly misdescribing individual cells. Any
  consumer rendering a `defaulted` category to a learner must mark it (the trainer badges the
  browse grid, the flashcard, and the exported deck).
- **The declension-class taxonomy is shared, not local.** `STEM_TAGS` is SanskritGrammar
  Sangram G2's list (`scripts/sg_g2_declension_cell_coverage.py`, H1048). Changing a tag here
  without changing it there silently desynchronises two published assets — the build's G2
  reconciliation is what catches it, and it must stay at 0 disagreements.

### Modifying Data Assets

JSON files in `visual/` are manually curated or semi-automated from the Excel source or `conc_*.json` concordance splits. Before editing:

1. Understand the schema (object structure, key naming)
2. Ensure any changes propagate to dependent files (e.g., if updating `form_lookup.json`, check that paradigm browser still renders)
3. Test the affected dashboard in browser

---

## Roadmap & Priorities

See `roadmap.md` for the original discussion (Russian). Much of it has since shipped — current status:

**✅ Shipped** (in `sanskrit_pxn_v4.html` unless noted):
- Landing page / tool map with Stage 1→4 learning path — `sanskrit_index.html`
- Concordance integration (click a paradigm cell → real corpus examples)
- Root comparison (inline second root under each form)
- Verb-class + stem-formula label per root
- Stem + ending colour split
- "What to study next" coverage route (slider-driven)
- Flashcard mode with shuffle + self-scoring
- Attested-only / zero-cell filter
- CSV + Markdown export
- **Per-root attestation counts, scaled to the whole attested verb space (H1299)** — 7,689 roots
  (not just the 6 hand-picked ones) via `sanskrit_paradigm_trainer.html` + `gen_paradigm_attested.py`;
  attested-only by construction, frequency-weighted trainer mode, JSON deck export. See its own
  README section for the data ceiling (no verb-class numbers, P./A. pooled, Tense=Past conflated
  **in this asset** — H1486 re-split the widget layer via `feat_formation`, but deliberately did
  not regenerate `paradigm_attested.json`; see the aorist/perfect note below).

- **Nominal paradigm dashboard — case × number per declension class (H1472)** —
  `sanskrit_nominal_dashboard.html` + `gen_paradigm_nominal.py`: 2,263,192 cased NOUN + ADJ
  tokens over 14 heuristic stem classes × token gender × 24 cells, with surface endings,
  attested forms and corpus examples per cell. Reuses (does not rebuild) SanskritGrammar's
  Sangram G2 stem tags and reconciles against its per-lemma coverage asset — 57,144
  lemma_ids agree exactly. Read its README section for the data ceiling (class is a
  citation-form heuristic, not a corpus tag; `Cpd` members have no case and are excluded;
  a gender column is not a gender paradigm; endings are surface residues).

- **Anki-deck flashcard widget (H1504)** — `sanskrit_anki_decks.html`: standalone card viewer
  over the already-computed `visual/anki_compact.json` (200 cards, 4 learning stages), data
  embedded inline so it needs no companion file. Stage filter, click-to-flip cards, CSV export
  (Anki-importable plain-text format) and Markdown export (Obsidian). `sanskrit_index.html`'s
  D2 card now points at it (`type:'file'`, opens directly).

- **Concordance search widget (H1505)** — `sanskrit_concordance.html` +
  `gen_concordance_data.py`: standalone, diacritic-insensitive search over the 6,423-form
  concordance (`visual/conc_part1/2/3.json`, packed into `visual/conc_data.js`). Typing a
  root or inflected form returns every match with its total corpus occurrence count and up
  to 5 example strophes with source citation. `sanskrit_index.html`'s "Конкорданс" card
  flipped from `type:'widget'` to `type:'file'`.

- **Print/PDF one-page export (H1536)** — an on-screen "🖨 Печать / PDF" button
  (`window.print()`) plus an `@media print` block in `sanskrit_pxn_v4.html` and
  `sanskrit_paradigm_trainer.html`: Ctrl+P (or the button) hides nav/controls/side panels
  via a shared `.no-print` class and prints only the current paradigm grid, one page.

**🔴 Still pending — high priority (new functionality):**
- **Per-lemma nominal drill-down** — the nominal twin of `sanskrit_paradigm_trainer.html`
  (per-lemma attested cells + frequency-weighted trainer), consuming Sangram G2's
  `lemma_cell_coverage.csv` rather than recomputing it.

**🟡 Pending — polish:**
- Several landing-page tool cards are still aspirational widgets, not yet built as standalone files

---

## Notes

- **No build step:** Dashboards open directly in browser; data is embedded or loaded from `visual/` via `fetch()` or inline `<script>`
- **Two upstream sources:** the Excel file (`Распределение времен и наклонений.xlsx`, 38-category frequencies) feeds the verb-form dashboard; the raw `src/DCS-data-2021/` corpus dump feeds the paradigm browser and the concordance/JSON assets. The Excel file is no longer the sole source of truth.
- **Encoding:** All JSON files must be UTF-8
- **Browser-only:** No server required; full offline support
- **Session continuity:** Use `.ai_state.md` to track progress across sessions
