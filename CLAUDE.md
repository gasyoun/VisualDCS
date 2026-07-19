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
| `dcs_texts_clean.json` | 288 texts with tense profiles | diachronic analysis |
| `dcs_genres.json` | 18 genre profiles — 17 named families + `Other` (weighted averages) | genre comparison |
| `dcs_scatter.json` | 170 diachronic data points | timeline charts |
| `coll_compact.json` | 800 lemmas × collocates by POS | collocate explorer |
| `conc_part1/2/3.json` | Concordance: 6,423 forms × ≤5 examples (2,141 each) | example lookup |
| `conc_totals.json` | 6,423 forms → total corpus occurrences | example lookup |
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
  README section for the data ceiling (no verb-class numbers, P./A. pooled, Tense=Past conflated).

**🔴 Still pending — high priority (new functionality):**
- **Nominal paradigm dashboard** — case × number heatmap for noun/adjective stems
  (2.28M nominal tokens vs 781k verbal). The biggest unbuilt tool.

**🟡 Pending — polish:**
- Print/PDF export with clean CSS (current export is CSV + Markdown only)
- Several landing-page tool cards are still aspirational widgets, not yet built as standalone files

---

## Notes

- **No build step:** Dashboards open directly in browser; data is embedded or loaded from `visual/` via `fetch()` or inline `<script>`
- **Two upstream sources:** the Excel file (`Распределение времен и наклонений.xlsx`, 38-category frequencies) feeds the verb-form dashboard; the raw `src/DCS-data-2021/` corpus dump feeds the paradigm browser and the concordance/JSON assets. The Excel file is no longer the sole source of truth.
- **Encoding:** All JSON files must be UTF-8
- **Browser-only:** No server required; full offline support
- **Session continuity:** Use `.ai_state.md` to track progress across sessions
