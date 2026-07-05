# Ramayana

_Created: 05-07-2026 · Last updated: 05-07-2026_

Most-frequent-word study and a highlighted-names character dictionary for the
**Rāmāyaṇa**, one text singled out for its own dedicated frequency/Pareto analysis and
named-entity dictionary within the wider DCS-corpus archive. Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
— see that README for how this folder fits the wider research archive (and its
"Provenance confidence" note: `Ramayana` was one of the two lowest-confidence DCS-vs-non-DCS
placement calls, confirmed correct by M.G. on 02-07-2026), and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
for the size/file-count table (`Ramayana` = 187MB / 9 files).

## Files

| File | Format | Notes |
|---|---|---|
| [Рамаяна. Самые употребительные слова с примерами.doc](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Ramayana/Рамаяна.%20Самые%20употребительные%20слова%20с%20примерами.doc) ("Rāmāyaṇa. Most-used words with examples") | Word `.doc` (legacy binary, `Composite Document File V2`) | The core study document — most-frequent Rāmāyaṇa words, each presumably illustrated with in-text examples. Duplicated byte-for-byte-named copy also present under `Slovar-s-podsvechennymi-imenami/!/`. |
| [Словари Рамаяны. Паретто.xls](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Ramayana/Словари%20Рамаяны.%20Паретто..xls) ("Rāmāyaṇa dictionaries. Pareto") | Legacy Excel 97 `.xls` (`Composite Document File V2`, 2022-02-17/18) | Pareto-curve analysis of the Rāmāyaṇa's word-frequency dictionary — same "N words cover X% of the text" methodology used elsewhere in this archive (cf. [`Lexical-Cores`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md) and the main VisualDCS project's `pareto.md`), applied to this one text instead of the whole corpus. |
| [`Slovar-s-podsvechennymi-imenami/`](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Ramayana/Slovar-s-podsvechennymi-imenami) ("Dictionary with highlighted names") | 3 `.doc` files (`AJ.doc`, `JM.doc`, `MH.doc`, ~27-29MB each) + a nested `!/` subfolder | A character/proper-name dictionary for the Rāmāyaṇa, apparently split into three parts by initials (AJ / JM / MH — likely alphabetical ranges of names, not verified against content). The nested `!/` subfolder holds: a duplicate of the top-level `.doc` study, an `.htm` export (`_____.htm`, ~24MB, filename mangled — likely a Cyrillic name that didn't survive Windows/NTFS↔Git round-tripping), `Pron_res!.zip` (pronoun-resolution results?, unopened), and `!.7z` (a further archive, unopened). |

## Data schema

All primary content here is **prose/Word-document**, not tabular data — unlike most of the
sibling `derived-data/` folders. There is no CSV/JSON schema to describe: the `.doc` files are
narrative dictionaries (word + gloss + example sentence, or name + identification), and the
`.xls` is a Pareto workbook (word rank, cumulative frequency %) whose exact column layout was
not extracted (binary legacy `.xls` isn't zip-based like `.xlsx`, so the same shared-strings
inspection trick used for the other three folders in this batch doesn't apply — opening it
requires `xlrd`/LibreOffice/Excel).

## Usage example

The `.doc` files need a Word-compatible reader; there's no plain-text extraction verified here.
A quick sanity check that a `.doc` is genuinely a legacy binary Word file (not, say, RTF or
plain text mislabeled):

```python
import subprocess
result = subprocess.run(["file", "Рамаяна. Самые употребительные слова с примерами.doc"],
                         capture_output=True, text=True)
print(result.stdout)
# -> Composite Document File V2 Document, Little Endian, Os: Windows, ...
```

For the `.xls` Pareto workbook, use `pandas.read_excel(path, engine="xlrd")` (legacy `.xls`
needs the `xlrd` engine, not `openpyxl`).

## Known caveats / limitations

- **Not tabular.** Two of the three content groups (`Рамаяна. Самые употребительные...doc`
  and `Slovar-s-podsvechennymi-imenami/`) are Word documents — no schema/columns to document,
  and no automated extraction was attempted here.
- **Mangled filename.** `Slovar-s-podsvechennymi-imenami/!/_____.htm` lost its original
  Cyrillic name at some point (shows as underscores) — content wasn't opened to recover intent
  from the file itself.
- **Nested archives unopened.** `!.7z` and `Pron_res!.zip` inside `Slovar-s-podsvechennymi-
  imenami/!/` were not extracted or inspected for this README — their contents are unverified.
- **Duplication.** The top-level `.doc` study and the copy inside `!/` were not byte-compared;
  treat them as probable duplicates, not confirmed identical.
- **Provenance confidence flag (inherited from parent INDEX).** This folder was one of the two
  lowest-confidence DCS-vs-non-DCS classification calls when the archive was split — confirmed
  correctly placed here by M.G. (02-07-2026), but worth bearing in mind if the topic (a single
  text's word list + name dictionary) feels closer to `non-derived/`'s philological material
  than to corpus-wide statistics.

## Provenance

**No generating script was found anywhere in the VisualDCS repo** — a repo-wide grep for
`Ramayana`/`Рамаян` and sibling folder names matched only this archive's own README/INDEX
files. Per the parent
[`derived-data/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
this is hand-curated research material (V.V. Leonchenko and collaborators' corpus studies),
**not** wired into the VisualDCS dashboard pipeline (`../src/DCS-data-2021/`,
`../src/DCS-data-2026/`) — reference archive only.

_Dr. Mārcis Gasūns_
