# Paralleli-v-tekstah-korpusa-SRC

_Created: 05-07-2026 · Last updated: 05-07-2026_

Corpus-wide **parallel-passage search** data — output of scanning a ~400-text Digital Corpus
of Sanskrit (DCS) text list for passages that recur across texts (quotations, shared verses,
formulaic repetition), run by two independent methods. This is the largest folder in
`derived-data/` (1.5GB / 606 files) — split out of a formerly single
`Параллели в санскритских текстах` folder whose Veda/Mahābhārata/Rāmāyaṇa
*philological*-parallels material went to
[`../../non-derived/`](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/README.md)
instead. See the parent [`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
and [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
("Contents of `Paralleli-v-tekstah-korpusa-SRC/`" section) for the authoritative structure
table and full dedup/deletion history (pass 4–5, 02-07-2026) — this README does not repeat
that table, only summarizes it.

## Structure (top level)

- **`PARA/`** — the actual per-method parallel-search output, in three subfolders:
  - `Stopovye/` (1.4GB, 113 files) — stop-word-method parallels, a partial 113-text run; the
    only surviving stop-word data after a full 245-text run (`PART/`, 11.7GB) was deliberately
    deleted by M.G. on 02-07-2026 (regenerable in principle by re-running the search).
  - `Polnorazmernye/` (57MB, 245 files) — **canonical** full-text-match parallels, the
    corrected/regenerated 2026 pass.
  - `Polnorazmernye-2022-archive/` (54MB, 245 files) — the original 2022 full-text-match
    export, kept for comparison, not canonical.
- **Root-level files** (not opened in this pass, per the read budget for this oversize
  folder):
  - [`Содержание папок и структура файлов.rtf`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Paralleli-v-tekstah-korpusa-SRC/Содержание%20папок%20и%20структура%20файлов.rtf>)
    ("folder contents and file structure") — the folder's own documentation RTF, referenced as
    the authoritative source for schema below.
  - [`Распределение точных параллелей по частотам и длинам.xltx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Paralleli-v-tekstah-korpusa-SRC/Распределение%20точных%20параллелей%20по%20частотам%20и%20длинам.xltx>)
    ("distribution of exact parallels by frequency and length") — Excel template.
  - [`Словарь точных полных параллелей.xlsx`](<https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Paralleli-v-tekstah-korpusa-SRC/Словарь%20точных%20полных%20параллелей.xlsx>)
    ("dictionary of exact full parallels") — summary workbook.

## Data schema

Per [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md), each
CSV under `PARA/` is named `<sourceTextID>_<targetTextIDRange>.csv`, with rows of the form:

```
text,book,verse: absoluteVerse; GOOD|PARTLY; matched-words||separated
```

i.e. a source location (text/book/verse plus an absolute verse index), a match-quality flag
(`GOOD` for exact match, `PARTLY` for partial), and the specific matched words separated by
`||`. This schema is stated in the folder's own structure RTF and the org-level `INDEX.md`; it
was not independently re-verified against a live CSV in this pass (oversize-folder budget).

## Usage example

```python
import glob, csv

# Iterate the canonical full-text-match parallels
for path in glob.glob("PARA/Polnorazmernye/*.csv"):
    with open(path, encoding="utf-8") as f:
        for row in csv.reader(f, delimiter=";"):
            # row[0] = "text,book,verse: absoluteVerse", row[1] = GOOD|PARTLY, row[2] = matched words
            pass
```

Files over ~95MB in this folder (e.g. some `Stopovye/` CSVs) are stored as split 7-Zip volumes
(`*.7z.NNN`) — see
[`../../RESTORE_SPLIT_FILES.md`](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)
to reassemble before reading.

## Caveats

- This folder was **not** enumerated recursively or sampled in this pass given its size
  (~1.5GB / 606 files) — schema above is taken from the folder's documentation RTF and the
  org-level `INDEX.md`, not independently confirmed against a live data file.
- `Stopovye/` is a **partial** 113-text run, not the full 245-text stop-word search — the full
  run (`PART/`) was deliberately deleted 02-07-2026 (see
  [`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md) history,
  pass 5) and is not present anywhere in this repo.
- `Polnorazmernye/` (2026, canonical) and `Polnorazmernye-2022-archive/` differ in **140 of 245
  files** (same row counts, different byte content per the INDEX.md dedup note) — don't assume
  they're interchangeable; use `Polnorazmernye/` unless specifically comparing against the 2022
  pass.

## Provenance

Generating script not found (one targeted repo-wide grep for `Paralleli` turned up no matching
pipeline code in this repo). Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md), the
DCS-corpus half of a personal Sanskrit-linguistics research archive. **Not** wired into the
VisualDCS dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — treat as
reference material to mine for ideas or figures.

_Dr. Mārcis Gasūns_
