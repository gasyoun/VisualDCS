# Sochetaemost-sanskritskih-osnov

_Created: 05-07-2026 · Last updated: 05-07-2026_

**"Сочетаемость санскритских основ"** ("Collocability of Sanskrit stems") — left/right
word-collocation (syntagmatic) tables computed from the DCS corpus, broken out **by
historical period**, plus a couple of standalone case studies (one word's collocates,
one lemma-set's MW dictionary-entry lengths). Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
— see that README for how this folder fits the wider research archive, and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
for the size/file-count table (`Sochetaemost-sanskritskih-osnov` = 97MB / 19 files).

## Files

### Collocation tables (the core dataset)

| File | Notes |
|---|---|
| [`Ishodnye-dannye/SINTAGMA.7z`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Ishodnye-dannye/SINTAGMA.7z) ("Source data") | The **source archive** — confirmed via `7z l` listing to contain 25 files (2022 timestamps) that unpack into exactly the same filenames now sitting unpacked in `Sochetaemost/` below (`S_-800.txt`, `S_-800_-300.txt`, `S_-300_200.txt`, `S_200_700.txt`, `S_700_1200.txt`, `S_1200_1700.txt`, `S_1700_1999.txt`, plus `S_Unknown.txt` which was **not** carried into the unpacked folder), each period's raw `lex80.txt` (80%-coverage lexical core for that period) and `Texts_*.txt` (source-text list per period) side files. This is the **traceable source-to-derived pair** for this folder — the clearest provenance link found in this batch. |
| [`Sochetaemost/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost) | 7 `.txt` files, one per historical period: [`S_-800.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_-800.txt) (to −800), [`S_-800_-300.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_-800_-300.txt), [`S_-300_200.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_-300_200.txt), [`S_200_700.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_200_700.txt), [`S_700_1200.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_700_1200.txt), [`S_1200_1700.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_1200_1700.txt), [`S_1700_1999.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Sochetaemost/S_1700_1999.txt) — the unpacked, currently-tracked copies of the same-named files inside `SINTAGMA.7z`. Format directly verified: one line per headword, `word;count;collocate1;count1;collocate2;count2;...` (semicolon-delimited, IAST transliteration, right-collocates only in the sample checked — e.g. `S_-800.txt` row 1: `indra;5476;1625;agni;172;soma;168;kṛ;76;...`, meaning `indra` occurs 5,476 times with 1,625 unique right-collocates, most frequently `agni` (172), `soma` (168), `kṛ` (76), …). |
| [`NEW/1-222342.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/NEW/1-222342.csv) | 36MB, tab-separated, **different schema** from `Sochetaemost/`'s semicolon files: `row_id` · `lemma_id` · `lemma (IAST)` · `L`/`R` (left/right collocation side) · `total_count` · repeating `(text_id, count)` pairs. Row 1: `1  1  akāra  L  23  1557  1  5484  3  ...` = lemma `akāra`, **left**-collocation side, 23 total occurrences, distributed across corpus texts `1557` (×1), `5484` (×3), etc. Row 2 is the same lemma's `R` (right) row. This is **per-text-distribution** data (which corpus texts a collocation was found in), not the aggregated collocate-frequency-list format used in `Sochetaemost/`'s `S_*.txt` files — likely an intermediate/finer-grained export feeding the aggregated period tables, not confirmed by a shared script. |
| [`Works-Share-SINTAGMA/data23.txt`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Works-Share-SINTAGMA/data23.txt) | 27MB, same semicolon `word;count;collocate;count;...` format as `Sochetaemost/`'s files, but SLP1-cased mixed-in mojibake in the header/first rows (e.g. garbled leading bytes) — recovered from the legacy `Works/Share/SINTAGMA` export tree; not cross-checked against `Sochetaemost/`'s period files for overlap. |

### Standalone workbooks

| File | Sheets | Notes |
|---|---|---|
| [Ратха. Сочетаемость..xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Ратха.%20Сочетаемость..xlsx) ("Ratha [chariot]. Collocability.") | `Лист1` (1,438 shared strings — smallest workbook in this folder) | A **single-word case study**: collocates of `ratha` ("chariot"). Columns: `Сочетаемость слева` (collocability left) · `Сочетаний` (# collocations) · `Сочетаемость справа` (collocability right). Sample right-collocates: `mahat` (adj), `aśva` (m., "horse"), `yuj` (verb, 6th class Ātmanepada), `tad`, `āruh`, `tatas`, `nāga`, `vājin`, `rājan`, `sva`, `dṛś` — each with a POS tag. |
| [Словарные статьи в MW.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Словарные%20статьи%20в%20MW.xlsx) ("Dictionary entries in MW") | `Лист1` (168,603 shared strings — largest workbook in this folder) | `Лемма` (lemma) · `Сл.Статья` (dictionary-entry text, presumably from Monier-Williams) · `Определений` (# definitions). Sample lemmas: `vimala`, `viṣama`, `kāla`, `kṛṣṇa`, `tattva`, `sudarśana`, `viśeṣa`, `vinaya`, `bhadra`, `sugandha`, `tridaśa`, `prakāśa`, `virūpa`, `śiva`, `kālaka`, `tripura`, `nīla`. Cross-references MW entry length/definition-count against corpus lemmas — likely a companion metric to the synonym-mining work in [`../Sinonimy/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/README.md) (which also draws on MW definitions), not confirmed as directly linked. |
| [Лексические ядра по периодам.xltx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/Лексические%20ядра%20по%20периодам.xltx) ("Lexical cores by period") | `Тексты` (Texts) · `Лексические ядра 80%` (80% lexical cores) · `Сочетаемость основ` (stem collocability) | An Excel **template** (`.xltx`) cross-referencing this folder's collocability data with the period-based lexical-core methodology of [`Lexical-Cores/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md). The `Тексты` sheet lists per-period stem counts matching `SINTAGMA.7z`'s side-file period boundaries almost exactly (`До -800 г. (16267 основ)`, `От -800 до -300 г. (19567 основ)`, `От -300 до 200 г. (30002 основ)`, `От 200 до 700 г. (23219 основ)`, `От 700 до 1200 г. (28194 основ)`, `От 1200 до 1700 г. (27243 основ)`, `От 1700 до 2000 г. (19622 основ)`, `Без датировки (21206 основ)` [undated]) alongside named corpus texts (`Kauśikasūtra`, `Ṛgvedavedāṅgajyotiṣa`, `Suśrutasaṃhitā`, `Sūryasiddhānta`, `Aṣṭāṅgahṛdayasaṃhitā`, `Rāmāyaṇa`, `Carakasaṃhitā`, `Yogasūtra`, …) — this is the sheet that ties period boundaries to actual corpus text lists. |
| [`Works-Share-SINTAGMA/data18.xlsx`, `data19.xlsx`, `data20.xlsx`, `data21.xlsx`, `data22.xlsx`, `data31.xlsx`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Sochetaemost-sanskritskih-osnov/Works-Share-SINTAGMA) | `data19`: `Синтагматика верхн. уровня` (top-level syntagmatics), `Синтагматика нижн. уровня` (bottom-level); `data20`/`data22`/`data31`: single `Лист1`/`Значения`-style sheets; `data21`: 7 sheets incl. `Статистика по группам. По буквам` (stats by group/by letter), `Общая статистика`, `Разные слова`, `Не в словах и синонимах`, `Слова в словах`, `Разные группы`, `Разные основы` | Recovered from the legacy `Works/Share/SINTAGMA` export tree — generically named, sizes range from 9.5KB (`data22.xlsx`) to 4MB (`data18.xlsx`); **`data31.xlsx` is byte-size-identical (415,081 bytes) to [`Sinonimy/Подобие по векторам.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/README.md)**, suggesting a shared or duplicate file between the two topic folders (not byte-diff confirmed). `data21`'s sheet names suggest word-vs-word-inside-word / group-based syntagmatic statistics, distinct from the plain collocate-count files above. |

## Data schema

Three distinct collocation-table schemas coexist in this folder:

1. **`Sochetaemost/S_*.txt` (period tables, verified format):** one line per headword —
   `word;count;collocate;count;collocate;count;...`, semicolon-delimited, IAST, right-side
   collocates only in the row sampled.
2. **`NEW/1-222342.csv` (verified format):** tab-delimited — `row_id`, `lemma_id`, `lemma
   (IAST)`, `L`/`R` side marker, `total_count`, then repeating `(corpus_text_id, count)` pairs.
   Two rows per lemma (one `L`, one `R`).
3. **Workbook schemas** (`Ратха. Сочетаемость.`, `Словарные статьи в MW`): plain
   lemma/collocate/count or lemma/dictionary-entry/definition-count tables, one sheet each.

## Usage example

Parsing a `Sochetaemost/` period file (verified against `S_-800.txt`):

```python
with open("Sochetaemost-sanskritskih-osnov/Sochetaemost/S_-800.txt", encoding="utf-8") as f:
    for line in f:
        fields = line.rstrip("\n").rstrip(";").split(";")
        headword, total = fields[0], int(fields[1])
        collocates = list(zip(fields[2::2], map(int, fields[3::2])))
        print(headword, total, collocates[:3])
        break
# -> indra 5476 [('1625', ), ...]  # NOTE: first pair is actually (unique_collocate_count, ...)
#    inspect a few rows by hand before trusting the field offsets — the very first
#    "collocate" slot in the sample row is itself a count (1625), not a word; the
#    real first collocate/count pair starts one slot later ("agni", 172).
```

Parsing `NEW/1-222342.csv` (tab-separated, verified against row 1):

```python
with open("Sochetaemost-sanskritskih-osnov/NEW/1-222342.csv", encoding="utf-8") as f:
    for line in f:
        row_id, lemma_id, lemma, side, total, *rest = line.rstrip("\n").split("\t")
        text_counts = list(zip(rest[0::2], rest[1::2]))  # (text_id, count) pairs
        break
```

## Known caveats / limitations

- **Off-by-one risk in the `Sochetaemost/S_*.txt` format.** The sampled row
  (`indra;5476;1625;agni;172;...`) has an extra numeric field (`1625`, likely a
  unique-collocate-count) between the headword's total frequency and the first real
  collocate — don't assume a naive `word,count` pair-split starts in the right place; verify
  against a few known rows before bulk-parsing.
- **`S_Unknown.txt`** exists inside `SINTAGMA.7z` (undated-text bucket) but was **not** carried
  into the unpacked `Sochetaemost/` folder — if undated-text collocations are needed, extract
  it from the `.7z` directly.
- **Encoding/mojibake** observed in `Works-Share-SINTAGMA/data23.txt`'s leading bytes — same
  class of legacy-encoding issue seen in [`../Sinonimy/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/README.md)'s syntagmatic CSV/TXT; not resolved here.
- **Two suspected cross-folder duplicates by byte-size only** (`data31.xlsx` ↔
  `Sinonimy/Подобие по векторам.xlsx`) — not byte-diff verified.
- **`NEW/1-222342.csv`'s relationship to `Sochetaemost/`'s period files is inferred, not
  confirmed** — both encode collocation data but at different granularities (per-text-ID
  distribution vs. aggregated collocate list) and no shared script or README tying them
  together was found.

## Provenance

**`Ishodnye-dannye/SINTAGMA.7z` → `Sochetaemost/` is a directly confirmed source→derived pair**
(the `7z l` listing's 25 filenames match the unpacked folder's contents, including matching
period boundaries) — the strongest provenance link found across this whole batch of 4 folders.
Beyond that unpacking step, **no processing script was found anywhere in the VisualDCS repo**
— a repo-wide grep for `Sochetaemost`/`Сочетаем`/`SINTAGMA` matched only this archive's own
README/INDEX files. Per the parent
[`derived-data/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
this is hand-curated research material (V.V. Leonchenko and collaborators' corpus studies,
explicitly naming "stem collocability" as one of the covered topics), **not** wired into the
VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — reference
archive only.

_Dr. Mārcis Gasūns_
