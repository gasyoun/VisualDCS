# derived-data — index

_Created: 02-07-2026 · Last updated: 02-07-2026_

Catalogue of `VisualDCS/derived-data/` — the **DCS-corpus** half of a two-repo-root
split. The **non-DCS** half (dictionaries, manuscript catalogs, reference/lecture
material, external tool clones) lives at the sibling [`../non-derived/`](../non-derived/INDEX.md)
folder, moved out to repo root so the two provenance buckets sit as peers rather than
nested. Both directories are **tracked in git and pushed to GitHub** (since 02-07-2026,
pass 5 below): files over ~95MB are stored as 7-Zip split volumes — see
[RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)
— and the only exclusion is `non-derived/Zalizniak/GH/` (independent nested git repos
with their own remotes).

## History

1. **02-07-2026, pass 1** — 76 folders renamed Cyrillic→Latin transliteration; the
   `Works/Share/<TAG>/` export tree (~741MB) merged into its matching top-level
   folders (91 unique files relocated, 69 exact duplicates discarded by name+size
   match); junk removed (`install.exe`, an empty placeholder folder, 3 empty
   `Works/Share` subfolders).
2. **02-07-2026, pass 2** — all topic folders split into `DCS-Corpus/` vs `Non-DCS/`
   by data provenance (per project [README.md](../README.md), "DCS" = Digital Corpus
   of Sanskrit — the corpus this repo's dashboards visualize). A folder went to
   `DCS-Corpus/` if its files are computed by statistically analyzing corpus text
   (frequency counts, distributions, collocations — many explicitly labeled "Анализ
   Корпуса" / "Цифровой корпус санскрита" in their filenames); everything else went
   to `Non-DCS/`. The mixed `Paralleli-v-sanskritskih-tekstah` folder was split:
   its corpus-search subfolder became `Paralleli-v-tekstah-korpusa-SRC` (turned out
   to hold the bulk of the data, ~3.97GB/607 files) while the philological
   Veda/Mahābhārata/Rāmāyaṇa-parallels remainder (~10MB/21 files) stayed with the
   non-DCS side.
3. **02-07-2026, pass 3** — `Non-DCS/` promoted out of `derived-data/` to repo-root
   `non-derived/`, so `derived-data/` now holds only the (former `DCS-Corpus/`
   contents, un-nested — this folder itself now *is* the DCS-corpus bucket).
4. **02-07-2026, pass 4** — `Paralleli-v-tekstah-korpusa-SRC/PARA/` grew from 607 to
   1,096 files (3.97GB → 15.13GB) with new data, then was deduplicated: an exact
   byte-identical duplicate (`VSE/FULL`, a copy of the 2022 original) was deleted,
   the 2022 original (`Polnorazmernye`) was archived as
   `Polnorazmernye-2022-archive`, and the corrected/regenerated 2026 pass
   (`Full_NEW`) was promoted to the canonical `Polnorazmernye` name. Net at the time:
   851 files, 15.07GB in that folder.
5. **02-07-2026, pass 5 — backed up to GitHub.** The whole archive was committed and
   pushed to `gasyoun/VisualDCS` in 13 "Back up derived-data/non-derived research
   archive" batches (Claude Sonnet 5, `claude-sonnet-5`). Files over ~95MB were
   replaced by 7-Zip split volumes (`*.7z.NNN`, raw originals removed locally after
   splitting — reassembly instructions in
   [RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)).
   In the same pass **`PARA/VSE/PART/` (11.7GB / 245 files, the full 245-text
   stop-word parallel run) was deliberately deleted by M.G.** (confirmed 02-07-2026)
   rather than backed up — the stop-word method now survives only in the partial
   113-text `Stopovye/` run; the full-text-match method is unaffected (canonical
   `Polnorazmernye/` + its 2022 archive are intact and tracked).

Current total: **849 files, 3.5GB — all tracked in git.** (The drop from pass-4's
1,083 files / 17.61GB = the deliberate `PART` deletion + raw originals removed after
7z splitting.)

## Folders (14) — corpus-frequency/statistics-derived

| Folder | Size | Files | Contents |
|---|---|---|---|
| `DCS_FILES` | 1.1GB | 9 | Raw Digital Corpus of Sanskrit (DCS) export archives + quantitative-analysis workbook |
| `Glagolnye-formy` | 112MB | 71 | Verb-form corpus analysis, verb classes/root lists by class + `Works-Share-Roots`, `Works-Share-VERBAL-FORMS` |
| `Imennye-formy` | 75MB | 38 | Nominal-form (declension/stem-ending) corpus analysis + `Works-Share-Endings`, `Works-Share-NAMES`, `Works-Share-POSIT` |
| `Lexical-Cores` | 92MB | 24 | Leonchenko's "lexical cores" study — full appendix set (frequency dictionaries by period, core-vocabulary lists) |
| `Leksicheskie-issledovaniya` | 11MB | 17 | Lexical studies: homoforms, ligatures, rarest words, lemma-ending distributions + `Works-Share-DIF`, `Works-Share-LEX`, `Works-Share-OMOFORMS` |
| `QL` | 11MB | 2 | Frequency dictionary of Sanskrit by period + `Works-Share-FRQ` |
| `Kompozity` | 732MB | 15 | Compound-word (samāsa) datasets/CSVs and analysis workbooks + `Works-Share-COMPOSITE` |
| `Sochetaemost-sanskritskih-osnov` | 97MB | 19 | Collocability of Sanskrit stems (source data + collocation tables) + `Works-Share-SINTAGMA` |
| `Sinonimy` | 141MB | 12 | Synonym-set research (verbs, vector similarity) |
| `Mestoimeniya` | 12MB | 8 | Pronoun combination/case-distribution data + `Works-Share-PRON` |
| `Chasticy` | 0.4MB | 1 | Particle-combination frequency table |
| `Korrelyacii` | <0.1MB | 1 | yad/tad correlative-form correlation table |
| `Fonetika` | 1MB | 6 | Phonetics: ligature tables, historical alphabet frequency + `Works-Share-Lig` |
| `Ramayana` | 187MB | 9 | Rāmāyaṇa most-frequent-words study, dictionary Pareto analysis, highlighted-names dictionary |
| `Paralleli-v-tekstah-korpusa-SRC` | 1.5GB | 606 | Corpus-wide parallel-passage search — **still the largest folder here**; split out of `Paralleli-v-sanskritskih-tekstah` (see [`../non-derived/INDEX.md`](../non-derived/INDEX.md) for its philological counterpart). See "Contents of `Paralleli-v-tekstah-korpusa-SRC/`" below for its internal structure |

## Contents of `Paralleli-v-tekstah-korpusa-SRC/`

Documented by the folder's own `Содержание папок и структура файлов.rtf` ("folder
contents and file structure"): this is the output of an intra-corpus parallel-passage
search across a ~400-text DCS text list (244 texts realized as parallel sources), run
by two methods — full-text match and stop-word match. Each CSV is named
`<sourceTextID>_<targetTextIDRange>.csv`; rows give `text,book,verse: absoluteVerse;
GOOD|PARTLY; matched-words||separated`.

| Subfolder | Size | Files | What it is |
|---|---|---|---|
| `PARA/Stopovye/` | 1.4GB | 113 | Stop-word-method parallels, partial 113-text run — **the only surviving stop-word data** after `PART`'s deletion (pass 5); 11 oversize CSVs stored as `.7z.NNN` split volumes |
| `PARA/Polnorazmernye/` | 57MB | 245 | **Canonical.** Full-text-match parallels, 2026 corrected/regenerated pass (was `Full_NEW/`, promoted here 02-07-2026 after dedup) |
| `PARA/Polnorazmernye-2022-archive/` | 54MB | 245 | Full-text-match parallels, original 2022 export — kept for reference/comparison against the 2026 pass, not the canonical version |
| *(root)* | 0.6MB | 3 | Summary workbooks (`Распределение точных параллелей...xltx`, `Словарь точных полных параллелей.xlsx`) + the structure-doc RTF |

**Deleted (pass 5, deliberate):** `PARA/VSE/PART/` — 11.7GB / 245 files, the
stop-word-method full 245-text run. Removed by M.G. on 02-07-2026 instead of being
backed up; regenerable in principle by re-running the stop-word parallel search
against the DCS text list if ever needed.

**Dedup note (02-07-2026):** this folder previously also had `PARA/VSE/FULL/`, which
was byte-for-byte identical (MD5-verified, all 245 files) to the old
`Polnorazmernye/` — deleted as a pure duplicate. Separately, `Full_NEW/` differed
from the old `Polnorazmernye/` in 140/245 files (same row counts, different byte
content — a corrected/regenerated pass, not noise) and was promoted to be the new
canonical `Polnorazmernye/`, with the old data preserved as
`Polnorazmernye-2022-archive/` rather than deleted.

## Notes / open judgment calls

A few `Works/Share` buckets had only generically-named files (`data8.xlsx`,
`data42.xlsx`, etc.) with no reliable content signal to place them precisely — they
were merged as a labeled group (e.g. `Imennye-formy/Works-Share-POSIT/`,
`Imennye-formy/Works-Share-NAMES/`) rather than flattened into the parent folder, so
nothing was silently misfiled. Worth a manual look if you work in `Imennye-formy` or
`Leksicheskie-issledovaniya` next.

The `DCS-Corpus` / `Non-DCS` split was done by filename/content inspection, not by
opening every spreadsheet. `Ramayana` and `Sinonimy` were the two lowest-confidence
calls at classification time — confirmed by M.G. (02-07-2026) as correctly placed
here in `derived-data/`, no further verification needed.

_Dr. Mārcis Gasūns_
