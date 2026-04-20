# VisualDCS

Interactive frequency dashboards for the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/), built from a single Excel source and rendered as standalone HTML files.

---

## Source Data

**`Распределение времен и наклонений.xlsx`** — the master Excel file containing raw frequency counts of Sanskrit verb forms across the DCS corpus:

- **781,616** total examples
- **55,032** unique lemmas
- **38** tense/mood categories

All dashboards in this repository are generated from this single file.

---

## Dashboards

### [`sanskrit_verb_form_dashboard.html`](sanskrit_verb_form_dashboard.html)
**Sanskrit Verb Form Frequency — Distribution of Tenses, Moods, and Participles**

An interactive single-page dashboard with three charts:

| Chart | What it shows |
|-------|---------------|
| Bar + Pareto curve | Frequency of each verb form category with cumulative % overlay |
| Pareto detail line | Cumulative coverage by form rank (top 5 → 77.6%, top 11 → 94.9%) |
| Lemma density bars | Unique lemmas per category (breadth of vocabulary per form) |

**Key findings:**
- Past Passive Participle leads with **233,079 examples (29.8%)**
- Present Indicative follows with **157,003 (20.1%)**
- Just **5 forms** cover **77.6%** of the entire corpus
- Just **11 forms** cover **94.9%** of the entire corpus

> This is the first dashboard. More will follow based on the same source file.

---

## Methodology

Dashboards use **Pareto % (cumulative frequency %)** to show how corpus coverage concentrates in a small number of high-frequency forms.

### How Pareto % is calculated

Forms are sorted by descending frequency. Pareto %[N] is the share of the total covered by the top N forms:

```
Pareto %[N] = (Count₁ + Count₂ + … + CountN) / Total × 100
(233 079 + 157 003) / 781 616 × 100 = 49.91%
```

### Key thresholds in this corpus

| Coverage | Forms needed |
|----------|-------------|
| ~50% | 2 forms (PPP + Pres.Ind.) |
| ~80% | 5–6 forms |
| ~95% | 11 forms |
| 100% | 38 forms |

The remaining 27 forms form a **long tail** — together they add only ~3.7% of coverage despite being the majority of distinct categories.

For the full methodology with term definitions, see [`pareto.md`](pareto.md).

---

## Tech Stack

- **Data:** Microsoft Excel (`.xlsx`)
- **Dashboards:** Vanilla HTML + [Chart.js 4.4.1](https://www.chartjs.org/) — no build step, no dependencies, open directly in browser

---

## License

[Apache 2.0](LICENSE)
