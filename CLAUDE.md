# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

**VisualDCS** — Interactive frequency dashboards for the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/), built from a single Excel source and rendered as standalone HTML files. No build step, no server, open directly in a browser.

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

```
Распределение времен и наклонений.xlsx (master Excel source)
    ↓
[Manual extraction / Python processing]
    ↓
JSON data files (form_lookup.json, paradigm_endings.json, conc_part1/2/3.json, etc.)
    ↓
HTML dashboards (embedded Chart.js + data)
```

The master Excel file contains:
- Raw frequency counts of 38 tense/mood categories
- 781,616 total verbal examples
- 55,032 unique lemmas

### Key Files & Structure

| File | Purpose |
|---|---|
| `src/Распределение времен и наклонений.xlsx` | Master source — raw frequency data |
| `sanskrit_verb_form_dashboard.html` | Frequency distribution dashboard with Pareto curve, bar charts, lemma density |
| `sanskrit_pxn_v4.html` | Interactive paradigm browser for individual roots (87 roots × 7 tenses) with corpus color-coding, examples panel, flashcard mode |
| `sanskrit_index.html` | (Landing page or index — purpose TBD) |
| `visual/` | Derived JSON data assets |
| `pareto.md` | Methodology documentation for Pareto % calculation |
| `roadmap.md` | Prioritized feature roadmap with Russian notes |
| `sanskrit_verb_forms.md` | Obsidian reference for top 100 roots with paradigms |

### JSON Data Files (in `visual/` directory)

Each is embedded or referenced by the HTML dashboards:

| File | Contents | Primary User |
|---|---|---|
| `form_lookup.json` | 7,873 forms → root / tense / rank | paradigm browser |
| `tense_case_data.json` | Form frequencies + case data | (future nominal dashboard) |
| `morph_pn.json` | Person × number distribution per tense | paradigm display |
| `paradigm_endings.json` | 25 tenses × attested endings from corpus | paradigm browser |
| `dcs_texts_clean.json` | 288 texts with tense profiles | diachronic analysis |
| `dcs_genres.json` | 17 genre profiles (weighted averages) | genre comparison |
| `dcs_scatter.json` | 170 diachronic data points | timeline charts |
| `coll_compact.json` | 800 lemmas × collocates by POS | collocate explorer |
| `conc_part1/2/3.json` | Concordance: 6,423 forms × 5 examples | example lookup |
| `anki_compact.json` | 200 Anki flashcard definitions | flashcard mode |
| `passage_library.json` | 40 curated passages from corpus | passage reader |
| `corpus_stats_widget.json` | Morpho-statistics summary | dashboard widgets |
| `prefix_clean.json` | Top 25 prefixes with productivity | affix analysis |
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

See `roadmap.md` (in Russian with English notes) for full discussion. High-level priorities:

🔴 **High** (new functionality):
- Nominal paradigm dashboard (case × number heatmap for noun/adjective stems)
- Per-root attestation counts (how many times √gam appears in 3sg Perfect, not just tense-level stats)
- Concordance integration (click a paradigm cell → real corpus examples)

🟡 **Medium** (tool unification):
- Landing page with learning path + links to all tools
- Root comparison mode (two paradigms side-by-side)
- Verb class + stem formula annotations

🟢 **Nice-to-have** (polish):
- Flashcard mode enhancements (shuffling, confidence scoring)
- Attested-forms-only filter (hide zero-frequency cells)
- Print/PDF export with clean CSS

---

## Notes

- **No build step:** Dashboards open directly in browser; data is embedded or loaded from `visual/` via `fetch()` or inline `<script>`
- **Single source of truth:** `Распределение времен и наклонений.xlsx` — all JSON files are derived from this
- **Encoding:** All JSON files must be UTF-8
- **Browser-only:** No server required; full offline support
- **Session continuity:** Use `.ai_state.md` to track progress across sessions
