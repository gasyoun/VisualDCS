# Kompozity

_Created: 05-07-2026 · Last updated: 13-09-2026_

Compound-word (samāsa) datasets derived from the DCS corpus — headword lists, per-compound
stem splits, and part-of-speech-specific compound-frequency tables broken down by historical
period. See the parent [`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
for how this folder fits into the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md) for the
size/file-count table (732MB / 15 files — the largest folder here after `Paralleli-v-tekstah-korpusa-SRC`).

## Data schema

- **[`CompDic.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/CompDic.csv)**
  — one column, one compound headword per line (IAST transliteration, e.g. `aṁśāvataraṇa`,
  `aṁśuhasta`). A plain compound dictionary/word list, no frequency or split data attached.
- **[`parts.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/parts.csv)**,
  **[`verbx.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/verbx.csv)**,
  **[`cmps.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/cmps.csv)**,
  **[`cmp400000.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/cmp400000.csv)**,
  **[`names.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/names.csv)**
  — semicolon-delimited rows of the shape:
  `surfaceForm; splitIntoParts; partCount; totalFrequency; freq_period_1; freq_period_2; …`
  (observed in `parts.csv`/`verbx.csv`: e.g. `vāpi; vā api;2;1080;279;66;127;…` — the surface
  compound/sandhi form, its split into constituent parts, a small integer (part count, always
  `2` in the sample), the total corpus frequency, then a long tail of per-period or per-text
  frequency columns, mostly small counts with many zeros). `verbx.csv` looks to be the same
  schema restricted to verb-derived compounds (splits like `bandh bandh`, `puṣ bhid`, `vac
  vac`). Exact column count/period labels were not verified beyond the sample rows read.
- **[`pronx.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/pronx.txt)**
  — not sampled in this pass; by naming convention likely the pronoun-compound counterpart to
  `verbx.csv`.
- **[`compounds.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/compounds.txt)**
  + **[`mw_h3_parent_compounds.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/mw_h3_parent_compounds.tsv)**
  + **[`build_mw_h3_parent_compounds.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/build_mw_h3_parent_compounds.py)**
  (H4480, 13-09-2026) — the "MW H3 compounds" table (yadisk, Сложные слова (samāsa)/Алгоримы
  обработки…): 12,609 parent occurrences / 12,326 distinct MW H1/H2 headwords × H3 compound
  children, Cologne MW 1899 digitization. **Parent-(pūrvapada)-keyed** — the complementary axis
  to H1328's final-member-keyed `uttarapada_dict_vs_corpus.tsv`. TSV shape:
  `parent<TAB>n_children<TAB>children(space-sep)`; children folded per H1328 conventions
  (`@` join, avagraha, anusvara U+1E43→U+1E41). Coverage vs DCS `cmps.csv`: 11.6% attested
  (any key), 88.4% dictionary-only (lower bound; elision/sandhi/kosa residuals NOT collapsed).
  Rationale + numbers: [`../../reports/h4480_samasa_algorithms_verdict.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/h4480_samasa_algorithms_verdict.md).
- **[`Композиты 4+.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/Композиты%204%2B.xlsx)**,
  **[`Композиты.xlsx.7z.001`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/Композиты.xlsx.7z.001)**
  (split archive — see [`../../RESTORE_SPLIT_FILES.md`](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)),
  **`Сложные слова с разбиением на основы (испр).ods`.ods>)**,
  **[`категории композитов.ods`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/категории%20композитов.ods)**
  — binary spreadsheets (not opened in this pass): "Compounds 4+" (compounds of 4+ members),
  "compound words split into stems (corrected)", and "compound categories" respectively —
  titles are self-describing from the Russian filenames.
- **[`good.txt.7z.001`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/good.txt.7z.001)**
  — split 7-Zip archive, contents not inspected.
- **[`Works-Share-COMPOSITE/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Kompozity/Works-Share-COMPOSITE)**
  — `data1.xlsx`, `data3.xlsx`, recovered from the legacy `Works/Share/COMPOSITE` export tree
  (generically named, no reliable signal for where they belong relative to the files above —
  see the org-level note in [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)).

## Usage example

```python
import csv

with open("CompDic.csv", encoding="utf-8") as f:
    compounds = [line.strip() for line in f if line.strip()]
print(len(compounds), compounds[:5])

# parts.csv / verbx.csv: semicolon-delimited, variable trailing frequency columns
with open("parts.csv", encoding="utf-8") as f:
    for row in csv.reader(f, delimiter=";"):
        surface, split, n_parts, total_freq, *period_freqs = row
        # ... aggregate or filter as needed
        break
```

## Caveats (observed)

- `parts.csv`/`verbx.csv` rows have a large, ragged number of trailing frequency columns —
  no header row is present, so column meaning (which period/text each position maps to) is
  not self-documenting from the file alone.
- Several `.xlsx`/`.ods` files were not opened (binary, out of scope for this pass) — titles
  above are taken from filenames only.
- Two files ship as split 7-Zip archives (`.7z.001`) per the repo's >95MB convention; see
  [`../../RESTORE_SPLIT_FILES.md`](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)
  to reassemble.

## Provenance

Generating script not found (one targeted repo-wide grep for `Kompozity` turned up no
matching pipeline code). Part of [`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
the DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired into
the VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — treat as
reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
