# Leksicheskie-issledovaniya

_Created: 05-07-2026 · Last updated: 05-07-2026_

"Lexical studies" — a grab-bag of smaller DCS-corpus lexical analyses: homoforms
(same surface form, different lemma/analysis), ligature counts, rarest-word lists, and
lemma/stem-ending distributions. See the parent
[`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md) for how
this folder fits into the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md) for the
size/file-count table (11MB / 17 files).

## Data schema

- **[`sarvached.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/sarvached.txt)**
  and **[`Sarvached (Все датированные).txt`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Sarvached%20(Все%20датированные).txt>)**
  ("all dated [texts]") — plain word lists, one IAST-transliterated headword per line (e.g.
  `kṛ`, `vac`, `bhū`, `mahat`), no frequency data visible in the first column alone in the
  sample checked — actually 3 semicolon/tab-separated fields per line in `sarvached.txt`:
  `lemma;POS;number` (e.g. `kṛ;v;2.75`, `rājan;m;134.63`, `dharma;mn;281.25`) — POS is a short
  tag (`v`, `adj`, `m`, `n`, `mn`) and the third field is a decimal (likely an average rank or
  weighted frequency across dated sub-corpora, given the ".75/.25/.63" fractional values —
  not verified further).
- **[`Омоформы.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Омоформы.xlsx)**,
  **[`Омоформы глаголов и имен.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Омоформы%20глаголов%20и%20имен.xlsx>)**,
  **[`Омоформы имен и глаголов по частотам.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Омоформы%20имен%20и%20глаголов%20по%20частотам.xlsx>)**
  — "homoforms [of verbs and nouns / by frequency]" — binary spreadsheets, not opened; likely
  tables of surface forms ambiguous between verbal and nominal analyses, per the filenames.
- **[`Двухсимвольные лигатуры.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Двухсимвольные%20лигатуры.xlsx)**
  — "two-character ligatures" — not opened; likely a Devanagari ligature-frequency table (cf.
  the phonetics folder `Fonetika/` which has a similar ligature table).
- **[`Распределение Лемм по окончаниям.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Распределение%20Лемм%20по%20окончаниям.xlsx>)**,
  **[`Распределение основ fmn по окончаниям.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Распределение%20основ%20fmn%20по%20окончаниям.xlsx>)**
  — "distribution of lemmas / f/m/n stems by ending" — not opened; likely cross-tabulations of
  lemma or stem-gender vs. inflectional ending.
- **[`Распределение ядерной лексики по периодам.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Распределение%20ядерной%20лексики%20по%20периодам.xlsx>)**,
  **[`исходные данные для диаграммы по распределению лексики.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/исходные%20данные%20для%20диаграммы%20по%20распределению%20лексики.xlsx)**
  — "distribution of core vocabulary by period" / "source data for the vocabulary-distribution
  chart" — likely feeder data related to the [`../Lexical-Cores/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md)
  study's per-period core-vocabulary tables.
- **[`Редчайшие слова в санскрите.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Редчайшие%20слова%20в%20санскрите.xlsx)**
  — "rarest words in Sanskrit" — likely a hapax/low-frequency word list, the low-frequency
  counterpart to the `Lexical-Cores/` most-frequent lists.
- **[`Works-Share-DIF/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Leksicheskie-issledovaniya/Works-Share-DIF)**,
  **[`Works-Share-LEX/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Leksicheskie-issledovaniya/Works-Share-LEX)**,
  **[`Works-Share-OMOFORMS/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Leksicheskie-issledovaniya/Works-Share-OMOFORMS)**
  — generically-named files (`data5.xls`, `data6.xlsx`, `data13.xlsx`, `data14.xlsx`, …)
  recovered from the legacy `Works/Share/{DIF,LEX,OMOFORMS}` export tree; no reliable signal
  for exactly where they belong among the named files above (see the org-level note in
  [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)).

## Usage example

```python
# sarvached.txt: lemma;POS;numeric-field, one entry per line
rows = []
with open("sarvached.txt", encoding="utf-8") as f:
    for line in f:
        lemma, pos, value = line.strip().split(";")
        rows.append((lemma, pos, float(value)))
print(rows[:5])
```

## Caveats (observed)

- `sarvached.txt`'s third numeric field (fractional values like `2.75`, `134.63`) has an
  unconfirmed exact meaning — likely an averaged frequency/rank across dated sub-corpora, but
  this was not traced to a formula or header.
- Most `.xlsx`/`.xls` files in this folder were not opened in this pass (binary, out of
  scope) — descriptions above are inferred from Russian filenames only; verify contents
  directly before relying on them for analysis.
- `Works-Share-*` subfolders carry generic `dataN.xlsx` names with no positional guarantee
  relative to the named files.

## Provenance

Generating script not found (one targeted repo-wide grep for
`Leksicheskie-issledovaniya` turned up no matching pipeline code). Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md), the
DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired into the
VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — treat as
reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
