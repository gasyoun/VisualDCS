_Created: 06-06-2026 · Last updated: 05-09-2026_

# `src/DCS-data-2021/` — Digital Corpus of Sanskrit (DCS) relational-DB export (2021)

This folder holds a **dump of the [Digital Corpus of Sanskrit (DCS)](https://github.com/OliverHellwig/sanskrit)**
by **Oliver Hellwig**, together with the derived analysis files and small processing programs that
VisualDCS builds on top of it. It is the upstream data behind the dashboards in the repository root
and the JSON assets in `visual/`.

> **Companion docs.** This is the **2021 relational export**; the current **CoNLL-U** version lives in
> the sibling [`../DCS-data-2026/`](../DCS-data-2026/). This README explains *what the data is and where
> it came from*. For *how the oversized files are split / stored* (Git LFS, `*.part###`, `rejoin.bat`,
> MD5 checks) see [`DCS-data-CLEANUP.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/DCS-data-CLEANUP.md); for how the two versions differ see
> [`../DCS-data-2026/DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md).

---

## Provenance

- **Source:** the Digital Corpus of Sanskrit — the largest morphologically and lexically annotated
  corpus of Sanskrit, created and maintained by Oliver Hellwig (2010–present).
- **Author / upstream:** Oliver Hellwig · <https://github.com/OliverHellwig/sanskrit> ·
  project site <http://www.sanskrit-linguistics.org/dcs/>.
- **Format & vintage:** this is the **older relational-database export** of the DCS (raw SQL `INSERT`
  tuples and table CSVs). The largest source files carry **August 2021** timestamps, so treat this as a
  **~2021 snapshot**. The DCS is *today* distributed as **CoNLL-U** files at
  [`OliverHellwig/sanskrit/dcs/data/conllu`](https://github.com/OliverHellwig/sanskrit/tree/master/dcs/data/conllu);
  if you need a current or cleaner copy, prefer that (or the sanitized
  [`ambuda-org/dcs`](https://github.com/ambuda-org/dcs)) over this snapshot.
- **Encoding:** Sanskrit is in **IAST** (Unicode, e.g. `praṇipatya`, `karoti`). Several derived files
  carry **Russian** column headers (`Лицо`, `Частота появления в корпусе`).

---

## License & citation

The DCS data is released by Oliver Hellwig under a **Creative Commons Attribution** license — the
current CoNLL-U release is **CC BY 4.0**; earlier DCS releases were **CC BY 3.0**. Because this is a
~2021 snapshot, confirm the exact terms upstream before redistributing, but in all cases **attribution
to Oliver Hellwig / DCS is required**.

```bibtex
@online{dcs,
  title  = {DCS -- The Digital Corpus of Sanskrit},
  author = {Hellwig, Oliver},
  year   = {2010--2021},
  url    = {http://www.sanskrit-linguistics.org/dcs/index.php}
}
```

Plain form: *Oliver Hellwig: Digital Corpus of Sanskrit (DCS). 2010–2021.*
For the segmentation/annotation method, additionally cite Hellwig & Nehrdich (2018),
*“Sanskrit Word Segmentation Using Character-level Recurrent and Convolutional Neural Networks”* (EMNLP).

> **Scope note.** The CC BY terms above cover the **DCS-derived data** in this folder. The **derived
> statistical summaries and the Free Pascal / Lazarus tools** (see below) are VisualDCS's own work and
> fall under the repository's [Apache-2.0 license](https://github.com/gasyoun/VisualDCS/blob/main/LICENSE) — but they are *built from* the DCS and
> so inherit the attribution requirement.

---

## ⚠️ Original vs. derived — read before reusing

This is a working directory, not a clean data release. Three distinct kinds of file are mixed together:

1. **DCS database dump** (Hellwig's data) — the numbered SQL/CSV table exports.
2. **Derived analysis** (VisualDCS's own) — per-text statistics, frequency tables, collocations; these
   feed the `.xlsx` source and the dashboards. Many have English/Russian headers.
3. **Processing tools** (VisualDCS's own) — Free Pascal / Lazarus programs and compiled `.exe`s used to
   transform the dump into the analysis files.

Column semantics for the raw tables below are **partially inferred** from samples; the authoritative
schema is the DCS itself.

---

## 1. DCS database dump (raw tables)

These appear to be direct exports of DCS database tables (some as bare CSV, some as SQL `INSERT` tuples).

| File | What it is | Row shape (sample) |
|---|---|---|
| `0.csv` (~79 MB) | **Sentences / text-lines** — one analyzed line per row: text name, reference, index, the word-IDs it contains, and the IAST text | `"Abhidhānacintāmaṇi";AbhCint, 1: 1;1;,162427,62226,…,;praṇipatya… \|\|` |
| `10.csv` (~189 MB) | **Word/token analysis table** (bare CSV) — one row per analyzed word: lemma/word & sentence IDs, position indices, and DCS morphological code fields | `165692,18127,1,1,0,0,161275,41,1,3,3,0` |
| `10.txt` (~294 MB) | **Same word table as SQL** `INSERT` tuples (extra leading primary-key id) | `(281915, 165692, 18127, 1, 1, 0, 0, 161275, 41, 1, 3, 3, 0),` |
| `7.txt` (~52 MB) | **Text-structure SQL dump** — `CREATE TABLE` / `INSERT` for `headlines`, `text_lines (id, chapter_id, line, strophe, stanza)` | `INSERT INTO text_lines (id, …) VALUES (1,270,'ādīśvarāya …',1,1),` |
| `9.txt` | **Prefix annotations** — word/lemma IDs + verbal prefix | `156108,159759,prefixes,ā` |
| `12.csv` / `12.txt` | **Non-finite verbal forms** (absolutives, participles): id, word-id, form, stem, codes | `4518,165579,'saṃbhidya','saṃbhidya',23,1,` |
| `15.csv` / `15.txt` | **Finite verb forms**: id, word-id, form, tense/person-number codes (`likhyante` = pres. passive 3pl) | `21865,158442,'likhyante',24,9,` |
| `_8.csv` / `8.csv` | **Lemma frequency list**: count, lemma, part-of-speech | `155067,ca,ind` |
| `621445.{txt,csv,dig}`, `_0_.txt`, `_7.csv`, `!7.csv`, `WR.!`, `ldx0`, … | **Intermediate / snapshot exports** from the extraction pipeline — variant copies and scratch dumps; exact roles not documented | — |

> `10.csv` and `10.txt` are the **same table in two formats**, not duplicates — both are kept. They are
> git-ignored at full size and committed as `10.*.part###`; rebuild with `rejoin.bat`
> (see [`DCS-data-CLEANUP.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/DCS-data-CLEANUP.md)).

---

## 2. Derived analysis (feeds the dashboards)

Computed by this project from the dump above; this is the layer the `.xlsx` source and the
root/`visual/` JSON assets are built from.

| File | Contents | Feeds |
|---|---|---|
| `texts.csv` / `texts.txt` | **Per-text statistical profile** — dates, POS totals & %, case×number distribution, finite/non-finite tense breakdown (`FF.`/`IF.` columns), phoneme %, author. Colon-delimited | the `.xlsx` source, genre/diachronic dashboards |
| `timws.csv` | **38 tense/mood categories × corpus frequency** (`ID:Tense/Mood:Частота появления в корпусе`) | verb-form frequency dashboard |
| `cs.csv` | **Case × number** counts and percentages (`Nom/Voc/… × Sg/Du/Pl`) | morpho-statistics, future nominal dashboard |
| `verx.csv` | **Verbal endings** grouped by tense / person / number (Russian headers) | paradigm endings |
| `111.csv` | **Collocations** — headword; totals; collocates with counts | `visual/coll_compact.json` |
| `topics.csv` | Topic / genre tags per text | genre profiles |
| `texttop.csv` | Text names (⚠️ stored as **cp1251 mojibake**) | — |
| `TEXTS.xlsx`, `Verbal forms finite.csv`, `Чистота появления глагольных форм в корпусе (Предварительные данные).csv` | **Excel analysis workbooks.** ⚠️ the two `…forms…` files are really binary **`.xls`** (OLE compound documents) despite the `.csv` extension | — |
| `ERRORS.txt` (+ `.zip`) | Processing **error log** from the extraction run | — |
| `forms.csv`, `forms10.csv`, `subjunctive.csv`, `VEnds.csv`, `vffi.csv`, `clx.csv`, `cs*.csv`, `gas1.csv`, `ggg1.csv`, `resx.csv`, `t11.csv`, `x1215.csv`, `x621446.csv`, `zTable.csv`, `Vedic 1.csv`, … | Assorted intermediate/working tables from the same pipeline | — |

---

## 3. Processing tools (Free Pascal / Lazarus)

VisualDCS's own programs that transformed the dump into the analysis files. **Not part of the DCS.**
Compiled `.exe`s are committed alongside source (e.g. `AddAuthor.exe` ≈ 22 MB — a Windows build
artifact).

| Project | Files | Purpose (from source) |
|---|---|---|
| `AddAuthor` | `.lpr` `.lpi` `.lps` `.res` `.ico` `.exe` | Adds author/text metadata to records |
| `pref` | `.lpr` `.lpi` `.lps` `.exe` | Verbal-prefix processing |
| `csn1` | `.lpr` `.lpi` `.lps` `.exe` + units `dts.pas`, `ans.pas` | Console extraction program |
| (GUI form) | `u1.pas` + `u1.lfm` | Lazarus `StringGrid` viewer/form |
| — | `rejoin.bat` | Rebuilds the split `10.csv` / `10.txt` originals |

---

## 4. Format comparison (vs. CoNLL-U)

The DCS is now distributed as **CoNLL-U**, not this relational dump. The full comparison — and a verified
demonstration that both are the *same data* (the integer IDs in `0.csv` are the CoNLL-U `LemmaId`s) —
now lives in the **2026** folder:

- [`../DCS-data-2026/DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md) — the findings.
- [`../DCS-data-2026/compare_dcs_formats.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/compare_dcs_formats.py) — the script
  (`python compare_dcs_formats.py`), with a bundled CoNLL-U sample.
- [`../DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md) — the plan to
  import the CoNLL-U updates into this export.

---

## Gotchas

- **Delimiters vary:** `0.csv` and `texts.csv` are **semicolon/colon**-delimited, not comma — open with the
  right separator or columns will collapse.
- **Mislabeled binaries:** `Verbal forms finite.csv` and `Чистота…csv` are actually `.xls`; `texttop.csv`
  is cp1251-mojibake. Don't trust the extension blindly.
- **Big files need Git LFS** + reassembly — see [`DCS-data-CLEANUP.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/DCS-data-CLEANUP.md).
- For project-wide context, see the repo-root [`README.md`](https://github.com/gasyoun/VisualDCS/blob/main/README.md) and
  [`CLAUDE.md`](https://github.com/gasyoun/VisualDCS/blob/main/CLAUDE.md).

_Dr. Mārcis Gasūns_
