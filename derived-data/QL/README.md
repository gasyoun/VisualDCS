# QL

_Created: 05-07-2026 · Last updated: 05-07-2026_

Frequency dictionaries of Sanskrit vocabulary broken out **by historical period**, plus
a supplementary word-length/part-of-speech distribution table. Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
— see that README for how this folder fits the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
for the size/file-count table (`QL` = 11MB / 2 files).

## Files

| File | Sheets | Notes |
|---|---|---|
| [Частотный словарь санскрита по периодам.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/QL/Частотный словарь санскрита по периодам.xlsx) ("Frequency dictionary of Sanskrit by period") | `FRQ_P` (single sheet, 83,264 shared strings) | Per-period frequency dictionary. Column headers found in the sheet's shared strings: `9 Vedic`, `11 Epic`, `12 Classic`, and period-range labels `1 -800`, `2 -300`, `5 1200`, `6 1700`, `7 1900` (numbered period buckets — some numbers in the sequence, e.g. 3/4, aren't among the first strings sampled, so the full period list wasn't confirmed). Data rows are lemmas in IAST (`tad`, `na`, `ca`, `iti`, `yad`, `mad`, `eva`, `tvad`, `etad`, `rasa`, `ādi`, …) each presumably paired with a frequency count per period column — **column-to-value mapping not verified cell-by-cell** (only the shared-string pool was inspected, not the worksheet's cell/row structure); open in Excel/LibreOffice to confirm exact column order before quantitative use. |
| [Works-Share-FRQ/Распределение слов по длинне и частям речи.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/QL/Works-Share-FRQ/Распределение%20слов%20по%20длинне%20и%20частям%20речи.xlsx) ("Distribution of words by length and part of speech") | 8 sheets: `Все леммы Корпуса по частоте` (all corpus lemmas by frequency), `Сортировка по длинне SLP1` (sorted by SLP1 length), `Глаголы` (verbs), `Имена` (nouns), `Несклоняемое` (indeclinables), `Местоимения` (pronouns), `DJAN-DJMA`, `САМАСЫ 3596` (compounds, 3,596 of them) | Recovered from the legacy `Works/Share/FRQ` export tree (see parent README's provenance note on `Works-Share-*` folders). Column headers include `Частота` (frequency), `IAST`, `Грамм.` (grammatical category), `SLP1`, `Длинна в SLP1` (length in SLP1), `Средняя длинна` (average length) — this workbook cross-tabulates corpus lemma frequency against word length and part-of-speech class, split into per-category sheets (verbs/nouns/indeclinables/pronouns/compounds). |

## Data schema

Both files are legacy Excel (`.xlsx`) with no accompanying schema doc. Based on shared-string
inspection (not full cell-grid parsing):

- **Частотный словарь...xlsx**: rows = lemma (IAST transliteration); columns = one frequency
  count per historical period (period labels embedded as header strings, not a clean numeric
  header row — treat period boundaries as approximate until opened and confirmed in Excel).
- **Распределение слов...xlsx**: rows = lemma; columns = `Частота` (raw frequency), `IAST`,
  `Грамм.` (POS tag, e.g. `ind` for indeclinable, `pron` for pronoun), `SLP1` transliteration,
  `Длинна в SLP1` (character length in SLP1), plus a derived `Средняя длинна` (average length)
  metric — likely a per-POS-class average shown once per sheet/category, not per row.

## Usage example

No CSV/JSON export exists; these are native Excel workbooks. Quick inspection without Excel
(e.g. to confirm sheet names or pull raw shared strings) via Python's stdlib `zipfile`,
since `.xlsx` is a zip container:

```python
import zipfile, re

path = r"QL/Частотный словарь санскрита по периодам.xlsx"
z = zipfile.ZipFile(path)
wb = z.read("xl/workbook.xml").decode("utf-8")
print(re.findall(r'<sheet name="([^"]+)"', wb))   # -> ['FRQ_P']

ss = z.read("xl/sharedStrings.xml").decode("utf-8")
strings = re.findall(r'<t[^>]*>([^<]*)</t>', ss)
print(strings[:10])
```

For actual row/column analysis, load with `pandas.read_excel()` or `openpyxl` instead —
the snippet above only inspects the shared-string pool, not full cell positions.

## Known caveats / limitations

- **Column-to-period mapping not fully verified.** The `FRQ_P` sheet's period-label headers
  were read from the shared-strings pool, not matched positionally to data columns cell-by-cell.
  Confirm the exact column layout in Excel/LibreOffice before using period boundaries
  quantitatively.
- **Legacy Excel encoding.** Filenames and cell content mix Russian (labels, sheet names) and
  Sanskrit IAST/SLP1 (lemma data) — no BOM/encoding issues observed via the zip-based shared-
  strings check, but full-fidelity reading requires a proper `.xlsx` reader (`openpyxl`,
  `pandas`), not the raw-zip approach shown above.
- **No row counts confirmed.** Unlike `Lexical-Cores/`, exact word/row counts were not
  extracted for this folder (would require full worksheet parsing, not just shared-strings
  inspection).

## Provenance

**No generating script was found anywhere in the VisualDCS repo** — a repo-wide grep for
`QL`, `Sochetaemost`, `Sinonimy`, `Ramayana`, `SINTAGMA` turned up matches only in this
archive's own README/INDEX files and unrelated files, never in `src/DCS-data-2021/` or
`src/DCS-data-2026/` processing scripts. This matches the parent
[`derived-data/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)'s
description of the whole archive as hand-curated research material from V.V. Leonchenko and
collaborators' corpus-frequency studies, **not** wired into the VisualDCS dashboard pipeline
(`../src/DCS-data-2021/`, `../src/DCS-data-2026/`). Treat as reference material to mine for
ideas or figures, not as a live input to the shipped `.html` dashboards.

_Dr. Mārcis Gasūns_
