# VisualDCS

Interactive frequency dashboards for the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/), built from a single Excel source and rendered as standalone HTML files — no build step, no server, open directly in a browser.

---

## What is this?

The DCS is the largest annotated corpus of Sanskrit texts, containing hundreds of thousands of morphologically tagged verb and nominal forms. VisualDCS turns that raw frequency data into visual, interactive tools for learners and researchers who want to understand **what Sanskrit actually looks like in practice** — which forms dominate, which are rare, and how coverage accumulates.

---

## Source Data

**`Распределение времен и наклонений.xlsx`** — the master Excel file containing raw frequency counts of Sanskrit verb forms across the DCS corpus:

| Metric | Value |
|---|---|
| Total examples | 781,616 |
| Unique lemmas | 55,032 |
| Tense/mood categories | 38 |

All dashboards in this repository are generated from this single file.

---

## Dashboards

### [`sanskrit_verb_form_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_verb_form_dashboard.html)

**Sanskrit Verb Form Frequency — Distribution of Tenses, Moods, and Participles**

An interactive single-page dashboard with three charts:

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

---

## Data Assets

The repository also tracks a set of derived JSON and reference files used to power future dashboards and widgets:

| File | Contents |
|---|---|
| `sanskrit_verb_forms.md` | Obsidian reference for the top 100 roots with paradigms |
| `dcs_texts_clean.json` | 288 texts with tense profiles |
| `dcs_genres.json` | 17 genre profiles (weighted averages) |
| `dcs_scatter.json` | 170 data points for diachronic charts |
| `form_lookup.json` | 7,873 verb forms → root / tense / rank |
| `coll_compact.json` | 800 lemmas × collocates by part of speech |
| `paradigm_endings.json` | 25 tenses × attested endings from the corpus |
| `verb_classes.json` | 13 verb classes with P/Ā distribution |
| `tense_case_data.json` | Form frequencies + case data (from cs.csv) |
| `morph_pn.json` | Person × number by tense (from 10.csv) |
| `corpus_stats_widget.json` | Summary morpho-statistics for widgets |
| `prefix_clean.json` | Top 25 prefixes with productivity scores |
| `passage_library.json` | 40 curated passages from the corpus |
| `anki_compact.json` | 200 Anki flashcards |
| `conc_totals.json` | 6,423 forms → total occurrences in corpus |
| `conc_part1/2/3.json` | Concordance: 6,423 forms × 5 examples (split in 3 parts) |

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

Planned next steps, in rough priority order:

**🔴 High priority**
- **Nominal paradigm dashboard** — the corpus contains 2.28M nominal tokens vs 781k verbal. A case × number heatmap for the major stem classes (-a, -ā, -i, -u, -an, -in, -ant) is the most natural next tool.
- **Per-root attestation counts** — show how many times a specific form of a specific root (e.g. *jagāma* √gam 3sg Perfect) appears, distinct from the general tense frequency.
- **Concordance integration** — clicking a paradigm cell opens 2–3 real corpus examples for that exact form of that root, drawn from `conc_part1/2/3.json`.

**🟡 Medium priority**
- **Landing page / tool map** — one page with a recommended learning path (Stage 1 → 4) and links to all tools.
- **Root comparison mode** — show two roots side by side in the same paradigm grid (e.g. √kṛ vs √bhū).
- **Stem + ending colour split** — highlight the invariant ending in blue and the root/stem in grey so learners see what changes and what doesn't.
- **Flashcard mode** — present a cell as a question (root + person + tense → ?), answer on flip.

**🟢 Nice to have**
- **"What to study next" advisor** — input known forms, get a ranked list of the next forms by corpus coverage gain.
- **Filter attested-only** — hide paradigm cells with zero corpus examples.
- **Print/PDF export** — clean CSS print stylesheet for the paradigm table.

See [`roadmap.md`](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md) for the full discussion.

---

## Tech Stack

- **Data:** Microsoft Excel (`.xlsx`)
- **Dashboards:** Vanilla HTML + [Chart.js 4.4.1](https://www.chartjs.org/) — no build step, no dependencies, open directly in browser

---

## License

[Apache 2.0](https://github.com/gasyoun/VisualDCS/blob/main/LICENSE)
