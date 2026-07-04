# VisualDCS

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

Two large folders sit alongside this repo's code: [`derived-data/`](derived-data/README.md)
and [`non-derived/`](non-derived/README.md), together ~7.2GB / ~2,080 files. They're a personal
Sanskrit-linguistics research archive (much of it V.V. Leonchenko's "Цифровой корпус санскрита"
corpus-statistics work and related material) that predates and is broader than this repo's shipped
dashboards. Both are **git-tracked and pushed since 02-07-2026** (files >95MB as 7-Zip split
volumes, see [RESTORE_SPLIT_FILES.md](RESTORE_SPLIT_FILES.md); only the nested `Zalizniak/GH/`
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
[`DCS_CONLLU_IMPORT_PLAN.md`](src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md) and `src/DCS-data-2026/reports/`
for the pipeline, the verb tense/mood **code map**, and the 2021→2026 deltas.

---

## Dashboards

Three standalone HTML tools, best entered via the landing page.

### [`sanskrit_index.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_index.html) — landing page / tool map

The recommended starting point. A single page that lays out a **Stage 1 → 4 learning path**
(which roots and forms to study first for the fastest corpus coverage) and a filterable grid of
tool cards. It advertises 11 planned tools; the two below are the ones currently built as
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

> The two dashboards report different headline totals (781,616 vs 745,394) because they use
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
| `visual/corpus_stats_widget.json` | Summary morpho-statistics for widgets |
| `visual/anki_compact.json` | 200 Anki flashcards |
| `visual/conc_totals.json` | 6,423 forms → total occurrences in corpus |
| `visual/conc_part1/2/3.json` | Concordance: 6,423 forms × ≤5 examples (2,141 forms per part) |
| `verb_classes.json` | 13 verb classes with P/Ā distribution |
| `tense_case_data.json` | Form frequencies + case data (from cs.csv) |
| `morph_pn.json` | Person × number by tense (from 10.csv) |
| `prefix_clean.json` | Prefix productivity scores |
| `passage_library.json` | 40 curated passages from the corpus |

> JSON files live in two places — most under `visual/`, but `verb_classes`, `tense_case_data`,
> `morph_pn`, `prefix_clean`, and `passage_library` sit at the repo root.

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

**🔴 Still planned — high priority**
- **Nominal paradigm dashboard** — the corpus contains 2.28M nominal tokens vs 781k verbal. A case × number heatmap for the major stem classes (-a, -ā, -i, -u, -an, -in, -ant) is the most natural next tool. *(biggest unbuilt item)*
- **Per-root attestation counts** — how many times a specific form of a specific root (e.g. *jagāma* √gam 3sg Perfect) appears, distinct from the general tense frequency, from `12.csv`/`15.csv`.

**🟢 Still planned — polish**
- **Print/PDF export** — clean CSS print stylesheet for the paradigm table (current export is CSV + Markdown).

See [`roadmap.md`](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md) for the original discussion.

---

## Tech Stack

- **Data:** Microsoft Excel (`.xlsx`) for the frequency tables; raw DCS corpus CSV/txt under `src/DCS-data-2021/` (Git LFS) for the paradigm browser; derived JSON in `visual/` and the repo root
- **Dashboards:** Vanilla HTML + [Chart.js 4.4.1](https://www.chartjs.org/) — no build step, no dependencies, open directly in browser

---

## License

[Apache 2.0](https://github.com/gasyoun/VisualDCS/blob/main/LICENSE)
