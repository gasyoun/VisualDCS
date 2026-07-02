# derived-data

_Created: 02-07-2026 · Last updated: 02-07-2026_



This folder is the **DCS-corpus** half of a personal Sanskrit-linguistics research
archive that lives alongside the [VisualDCS](../README.md) dashboards project. For the
folder-by-folder table with sizes and file counts, see [`INDEX.md`](INDEX.md) — this
README covers the *why* and *how to work with it* instead.

## What this is

`derived-data/` holds datasets and working files produced by statistically analyzing
the [Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/) — the
same corpus VisualDCS's dashboards visualize. Nearly everything here is *derived* data:
frequency counts, distributions, collocations, and cross-tabulations computed from
corpus text, not primary source material. Much of it comes from research by
V.V. Leonchenko ("Цифровой корпус санскрита" / "Digital corpus of Sanskrit" — the study
behind `Lexical-Cores/`) and collaborators, spanning verb forms, nominal forms,
compounds, pronouns, particles, phonetics, synonymy, and stem collocability.

Its sibling, [`../non-derived/`](../non-derived/README.md), holds everything from the
same archive that is *not* corpus-statistics — dictionaries, manuscript catalogs,
lecture/conference material, translations, and cloned external tools. The two folders
used to be one (`derived-data/DCS-Corpus/` + `derived-data/Non-DCS/`) before being
promoted to peer directories at the repo root; see "History" in [`INDEX.md`](INDEX.md)
for the full three-pass account of how the archive got here.

## How it's organized

Each top-level folder is one research topic (verb forms, compounds, synonyms, …),
named with a practical Latin transliteration of its original Cyrillic name. Inside a
topic folder you'll typically find:

- The primary dataset(s) for that topic (mostly `.xlsx`/`.xls`/`.csv`/`.doc(x)`).
- Zero or more `Works-Share-<TAG>/` subfolders — files recovered from a now-deleted
  `Works/Share/` export tree that partially mirrored this same archive under short
  English tags (`CORES`, `COMPOSITE`, `VERBAL FORMS`, …). Anything that exactly
  duplicated a file already here (by name **and** size) was discarded during the
  merge; what's left in `Works-Share-*` are files that turned out to be genuinely new,
  kept grouped by their original tag rather than silently flattened in, since several
  of those tags (`POSIT`, `NAMES`, `Endings`, `DIF`, `Roots`) only ever had
  generically-named files (`data42.xlsx`, …) with no reliable signal for exactly where
  within the topic folder they belong.

`Paralleli-v-tekstah-korpusa-SRC/` is the odd one out size-wise (15.07GB / 851 files,
by far most of this entire folder's weight) — it's the corpus-wide parallel-passage
search data, split out of a formerly single `Параллели в санскритских текстах` folder
whose Veda/Mahābhārata/Rāmāyaṇa philological-parallels material went to
`non-derived/` instead (see below). It grew significantly and was deduplicated on
02-07-2026 — see the "Contents of `Paralleli-v-tekstah-korpusa-SRC/`" section in
[`INDEX.md`](INDEX.md) for the current internal structure and what was consolidated.

## Working with this data

- **Not git-tracked.** This directory (and `non-derived/`) is intentionally untracked
  — mixed binary formats (Excel, Word, 7z archives, raw DCS dumps) and multi-GB total
  size make it a poor fit for the git repo. `INDEX.md` and this README are the only
  persistent map; keep them current when you add or move things (see below).
- **Encoding.** Filenames and file contents are a mix of Russian and English;
  spreadsheets are mostly legacy `.xls`/Excel-97 format. No special handling needed
  beyond normal UTF-8-aware tooling — Windows/NTFS stores names fine even where a
  particular shell (e.g. Git Bash) chokes on rendering them.
- **Provenance confidence.** `Ramayana` and `Sinonimy` were the two lowest-confidence
  DCS-vs-non-DCS calls at classification time (filename/content inspection, not every
  spreadsheet opened) — confirmed by M.G. (02-07-2026) as correctly placed here.
- **Adding new data.** Drop it into the matching topic folder (or a new one if it's a
  genuinely new topic), then update the table in [`INDEX.md`](INDEX.md) — folder name,
  size, file count, one-line description. If the new folder is dictionaries/catalogs/
  reference material rather than corpus statistics, it likely belongs in
  `../non-derived/` instead.
- **Renaming.** Folder names here are already Latin — don't reintroduce Cyrillic
  folder names. Filenames themselves were left untouched during the original cleanup
  and don't need to match that convention.

## Relationship to the VisualDCS dashboards

This archive is **not** wired into the VisualDCS dashboards' data pipeline — that
pipeline runs on `../src/DCS-data-2021/` and `../src/DCS-data-2026/` (see the project
root [`CLAUDE.md`](../CLAUDE.md) / [`README.md`](../README.md)). `derived-data/` is
older, broader, hand-curated research material from a different (though related)
corpus-analysis effort; treat it as a reference archive to mine for ideas or figures,
not as a live input to the shipped `.html` dashboards.

_Dr. Mārcis Gasūns_
