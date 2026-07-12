# non-derived — index

_Created: 02-07-2026 · Last updated: 08-07-2026_

Catalogue of `VisualDCS/non-derived/` — the **non-DCS** half of a two-repo-root split.
The **DCS-corpus** half (frequency/statistics data computed from the Digital Corpus of
Sanskrit) lives at the sibling [`../derived-data/`](../derived-data/INDEX.md) folder.
This directory is **tracked in git and pushed to GitHub** (since 02-07-2026) with one
exclusion: `Zalizniak/GH/` — independent nested git repos with their own remotes,
intentionally gitignored. Files over ~95MB are stored as 7-Zip split volumes — see
[RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md).

## History

This folder was originally the `Non-DCS/` bucket inside `derived-data/`, created
02-07-2026 by classifying every folder there as DCS-corpus-derived (statistical
analysis of corpus text) or not. It was then promoted out to repo root as
`non-derived/` so the two provenance buckets sit as peers rather than nested — see
[`../derived-data/INDEX.md`](../derived-data/INDEX.md) "History" section for the full
three-pass account (Cyrillic→Latin rename, `Works/Share` merge, DCS/non-DCS split,
this promotion). Folder names here are already Latin-transliterated from that first
pass; files were left untouched throughout.

`Zalizniak/GH/*` contains actual cloned git repositories (`Astronomy`, `L_Base-1`,
`SaudAmanI`, `Zaliznyak-Kochergina`) — their internal `.git/` contents were never
touched by any rename/move pass, so those repos remain functional.

Current total: **1,239 files, 3.75GB** (18 folders + 2 loose root files), of which
628 files are git-tracked — the remaining 611 (1.5GB) are the nested `Zalizniak/GH/`
repos, gitignored here because each has its own GitHub history/remote. Oversize
binaries were replaced by tracked 7-Zip split volumes during the 02-07-2026 backup
(see [`../derived-data/INDEX.md`](../derived-data/INDEX.md) "History" pass 5). `vedaweb`
(added 08-07-2026, [H096](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H096-Sonnet_VisualDCS_vedaweb_feed_export_03.07.26.md))
is an **external-corpus feed**, not a folder classified during the original
Cyrillic→Latin rename pass — see its own [README.md](vedaweb/README.md) for
retrieval/license provenance.

## Folders (18) — dictionaries, catalogs, reference material, external tools

| Folder | Size | Files | Contents |
|---|---|---|---|
| `Zalizniak` | 1.8GB | 805 | A.A. Zaliznyak Sanskrit grammar materials — includes cloned git repos under `GH/` (Astronomy, L_Base-1, SaudAmanI, Zaliznyak-Kochergina) and `Vyskazyvaniya` (statements/quotes by grammatical topic) |
| `Elektronnyj-slovar` | 1.3GB | 218 | Electronic dictionary binaries (Saudamani SDM4 + `bin/`, `SRC/`) + merged `Works-Share-catalogs` (`.sdm` catalog files) |
| `NCC` | 297MB | 23 | New Catalogus Catalogorum (manuscript commentary trees/family trees) — a manuscript catalog, not corpus stats, despite the name similarity to other "corpus"-adjacent folders + `files/`, `Works-Share-NCC` |
| `Astronomiya` | 210MB | 13 | Astronomy-in-Sanskrit-texts lecture notes/slides + related media |
| `Slovari` | 230MB | 35 | General dictionary comparisons, compound words in DCS, frequency/length stats |
| `Sanskritskie-izrecheniya` | 78MB | 4 | Subhāṣita (Sanskrit sayings) datasets + `Works-Share-ELSE` (heterogeneous leftovers: a larger Subhāṣita workbook variant + an archived copy of the Rāmāyaṇa highlighted-names dictionary) |
| `Dubyanskie-chteniya-20112021` | 75MB | 10 | Materials for the "Dubyanskie chteniya" 2011–2021 conference series (data/report/documents) |
| `PWG_MW` | 30MB | 7 | PWG vs MW dictionary comparison + `Works-Share-dic` (dictionary-comparison leftovers, mapped here since most `dic` files were exact PWG_MW duplicates) |
| `Simvolicheskie-vyrazheniya` | 14MB | 9 | Symbolic expressions: world concepts, numbers, colors |
| `Zagadki` | 5MB | 12 | Riddles/folklore-adjacent notes (Nighaṇṭu, celestial tree, time) + `Works-Share-ATC` |
| `Perevody` | 5MB | 10 | Translations (Kṣemendra, Bhagavad Gītā) + phrasebooks |
| `Paralleli-v-sanskritskih-tekstah` | 10MB | 21 | Philological cross-text parallels: Vedas (Atharvaveda, Rigveda), Mahābhārata, Rāmāyaṇa + `Works-Share-PARALS`. Its corpus-search subfolder (the bulk of the original data, ~3.97GB) was split into `../derived-data/Paralleli-v-tekstah-korpusa-SRC/` |
| `Grammaticheskie-tablicy` | 2MB | 27 | Grammar reference tables (verbs, verb classes, nouns/pronouns/alphabet, sandhi, particles) |
| `XCHG` | 2MB | 13 | Exchange/misc data (CESS, word lists) |
| `Kochergina` | 2MB | 1 | Kochergina Sanskrit–Russian dictionary (unicode) |
| `CHANDAH` | 1MB | 5 | Chandas (Sanskrit meter/prosody) references + `Works-Share-CHANDAS` |
| `ALANKARA` | 1MB | 1 | Alaṅkāra (rhetoric/figures of speech) reference HTML |
| `Rigveda` | 0.4MB | 3 | Rigveda introduction/hymn-164 article/parallels drafts |
| [`vedaweb`](vedaweb/README.md) | 65MB | 13 | VedaWeb 2.0 (Uni Köln) Rig-Veda bulk export — catalog + 4 core annotation layers (Casaretto et al. accented word-split/morphology, gzipped; lemmatization+dictionary refs; Scarlata & Widmer accented text; Lubotsky padapāṭha), 10,552 stanzas each, plus Elizarenkova (1989-1999) Russian RV translation (CC BY 4.0, confirmed 08-07-2026, H361) → [RussianTranslation](https://github.com/gasyoun/SanskritLexicography/tree/master/RussianTranslation) citation/context witness, Metrical Data (Kiss & Kölligan 2024, 10,551 stanzas, meter label + scansion, H360), and Geldner + Grassmann German RV translations (CC BY 4.0, confirmed 08-07-2026, H362); GRA crosswalk (H097); PWG gloss cross-check crosswalk (H362); [`type_d_id_join.tsv`](vedaweb/type_d_id_join.tsv) (H522, 11-07-2026) — Type-D `id_gra`↔VedaWeb-stanza concordance, 29,808 rows, joining `gra_vedaweb_crosswalk.tsv`'s example locations against the metrical/Geldner/Grassmann exports (5,164/5,164/5,160/5,164 unique locations matched); [`LAYERS_TRIAGE.md`](vedaweb/LAYERS_TRIAGE.md) (H098, updated H360/H361/H362) — GO/DECIDE triage of the remaining catalog layers, rights-honesty finding (only 2/36 resources carry an explicit machine-readable license), 4 of the original DECIDE layers since confirmed GO by H359 |

## Loose root files

- `Titov-knantitivnaya-leksikologiya-2001.DOC` — Titov, quantitative lexicology (2001)
- `Краткое резюме.docx` — short summary document (left untranslated; only folder names were in scope for the rename pass)

_Dr. Mārcis Gasūns_
