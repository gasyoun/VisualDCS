# Korrelyacii

_Created: 05-07-2026 · Last updated: 05-07-2026_

The smallest topic folder in `derived-data/` (<0.1MB, 1 file) — a single spreadsheet studying
correlative-pronoun pairing in the DCS corpus. See the parent
[`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md) for how
this folder fits into the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md) for the
size/file-count table.

## Contents

- **[`Корреляции yad tad в одинаковых формах.xls`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Korrelyacii/Корреляции%20yad%20tad%20в%20одинаковых%20формах.xls>)**
  ("Correlations of *yad*/*tad* in matching forms") — a legacy Excel 97 binary workbook. Not
  opened in this pass (binary format, out of scope for the read budget); the title indicates a
  table of the Sanskrit relative/correlative pronoun pair **yad … tad** ("which … that")
  co-occurring in the same grammatical form (case/number/gender match between the relative and
  correlative clause), presumably with corpus frequency counts per form-pair, in the same
  general spirit as the pronoun-combination tables in the sibling
  [`../Mestoimeniya/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Mestoimeniya/README.md)
  folder.

## Usage example

Being a legacy `.xls`, open with `pandas`/`xlrd` or LibreOffice/Excel directly:

```python
import pandas as pd
df = pd.read_excel("Корреляции yad tad в одинаковых формах.xls")
print(df.head())
```

## Caveats

- Not opened/verified in this pass — schema (columns, exact counts) is unconfirmed; the
  description above is inferred from the filename alone. Open the file directly before relying
  on its contents for analysis.

## Provenance

Generating script not found (one targeted repo-wide grep for `Korrelyacii` turned up no
matching pipeline code). Part of [`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
the DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired into the
VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — treat as
reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
