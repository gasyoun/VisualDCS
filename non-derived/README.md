# non-derived

_Created: 02-07-2026 · Last updated: 02-07-2026_

This folder is the **non-DCS** half of a personal Sanskrit-linguistics research
archive that lives alongside the [VisualDCS](../README.md) dashboards project. For the
folder-by-folder table with sizes and file counts, see [`INDEX.md`](INDEX.md) — this
README covers the *why* and *how to work with it* instead.

## What this is

`non-derived/` holds everything from the archive that is **not** produced by
statistically analyzing the Digital Corpus of Sanskrit (DCS) — i.e. not frequency
counts, distributions, or collocations computed from corpus text. Concretely, that's:

- **Dictionaries** — Kochergina (Sanskrit–Russian), PWG vs MW comparisons, the
  Saudamani electronic dictionary binaries (`Elektronnyj-slovar/`), general dictionary
  comparison workbooks (`Slovari/`).
- **A manuscript catalog** — `NCC/` (New Catalogus Catalogorum), commentary/family
  trees over manuscript records — a different data source entirely from corpus text,
  despite some filename similarity to "corpus"-adjacent material.
- **Lecture, conference, and reference material** — `Astronomiya/` (astronomy in
  Sanskrit texts), `Dubyanskie-chteniya-20112021/` (conference proceedings),
  `Grammaticheskie-tablicy/` (grammar reference tables), `Rigveda/`, `CHANDAH/`
  (meter/prosody), `ALANKARA/` (rhetoric).
- **Translations and philology** — `Perevody/`, `Sanskritskie-izrecheniya/`
  (Subhāṣita sayings), `Paralleli-v-sanskritskih-tekstah/` (Veda/Mahābhārata/Rāmāyaṇa
  parallel-passage drafts — the philological remainder after its much larger
  corpus-search subfolder was split out to `../derived-data/`), `Zagadki/`
  (riddles/folklore), `Simvolicheskie-vyrazheniya/` (symbolic expressions).
- **External tools** — `Zalizniak/GH/*` contains actual cloned git repositories
  (`Astronomy`, `L_Base-1`, `SaudAmanI`, `Zaliznyak-Kochergina`); their `.git/`
  internals were never touched by any rename/move pass in this archive, so those
  repos remain functional as normal git checkouts.

Its sibling, [`../derived-data/`](../derived-data/README.md), holds the corpus-
statistics half of the same archive. The two folders used to be one
(`derived-data/DCS-Corpus/` + `derived-data/Non-DCS/`) before being promoted to peer
directories at the repo root; see "History" in [`../derived-data/INDEX.md`](../derived-data/INDEX.md)
for the full three-pass account of how the archive got here.

## How it's organized

Each top-level folder is one topic, named with a practical Latin transliteration of
its original Cyrillic name. As in `derived-data/`, some topic folders contain a
`Works-Share-<TAG>/` subfolder — files recovered from a now-deleted `Works/Share/`
export tree that partially mirrored this archive under short English tags. Anything
that exactly duplicated a file already present (by name **and** size) was discarded
during that merge; what remains in `Works-Share-*` are genuinely new files, kept
grouped by their original tag.

## Working with this data

- **Not git-tracked.** Same as `derived-data/` — mixed binary formats and multi-GB
  size make this a poor fit for the git repo. `INDEX.md` and this README are the only
  persistent map; keep them current when you add or move things.
- **The `Zalizniak/GH/*` git repos are a special case.** They're real, independent
  git checkouts nested inside an untracked folder. Don't run repo-wide operations
  (bulk rename, bulk delete, archive/zip) that would walk into and mutate their
  `.git/` internals — treat each as its own repo when you need to touch it.
- **Adding new data.** Drop it into the matching topic folder (or a new one if it's a
  genuinely new topic), then update the table in [`INDEX.md`](INDEX.md). If the new
  material is corpus-frequency/statistics data rather than a dictionary, catalog, or
  reference/lecture item, it likely belongs in `../derived-data/` instead.
- **Renaming.** Folder names here are already Latin — don't reintroduce Cyrillic
  folder names. Filenames themselves were left untouched during the original cleanup.

## Relationship to the VisualDCS dashboards

Like `derived-data/`, this archive is **not** wired into the VisualDCS dashboards'
data pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/` — see the project root
[`CLAUDE.md`](../CLAUDE.md)). It's older, hand-curated reference and dictionary
material from a related but separate research effort — useful to consult, not a live
input to the shipped `.html` dashboards.

_Dr. Mārcis Gasūns_
