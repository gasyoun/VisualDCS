# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Day-to-day session state lives in [`.ai_state.md`](.ai_state.md); this file records
durable, user-facing milestones.

## [Unreleased]

### Added
- Documentation and tooling for the DCS data and its lineage:
  - `src/DCS-data-2021/README.md` — provenance of the 2021 relational-DB export (Oliver Hellwig's
    Digital Corpus of Sanskrit), license/citation, and an inventory of raw tables vs. derived
    analysis vs. the Free Pascal / Lazarus processing tools.
  - `src/DCS-data-2026/DCS_FORMAT_COMPARISON.md`, `compare_dcs_formats.py`, and a bundled
    `sample_conllu/` file — a verified comparison of the relational export against the
    current CoNLL-U distribution (same data, joinable on `LemmaId`).
  - `src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md` — plan + milestone roadmap for importing the
    current CoNLL-U updates into the relational export (full refresh, hybrid schema,
    SQLite + CSV exports, pilot-first, data-layer before dashboards).
  - `src/DCS-data-2026/check_conllu_updates.py` — checks upstream for CoNLL-U commits after the
    pinned snapshot (`04e0778`, 2026-03-05).
- `src/DCS-data-2021/` raw corpus assets prepared for GitHub:
  - Split parts of the two >100 MB files (`10.csv` → 2 parts, `10.txt` → 3 parts),
    each ≤ 99 MiB and split on line boundaries so they rebuild byte-for-byte.
  - `src/DCS-data-2021/rejoin.bat` — rebuilds the originals from their parts.
  - `src/DCS-data-2021/.gitignore` — excludes the >100 MB originals `10.csv` / `10.txt`
    (kept locally, committed only as split parts).
  - `src/DCS-data-2021/DCS-data-CLEANUP.md` — full inventory and rationale of the cleanup.
  - Repo-root `.gitattributes` — Git LFS tracking for the 11 large committed files
    (the split parts + 6 standalone 50–99 MB files).

### Changed
- **Split `src/DCS-data` into dated versions:** `src/DCS-data-2021/` (the relational-DB export) and
  `src/DCS-data-2026/` (the CoNLL-U side — comparison, import plan, update tracker, sample). The full
  2026 CoNLL-U corpus lives in a separate repo (`gasyoun/dcs-conllu`, pinned `04e0778` / 2026-03-05),
  mounted as a git submodule at `src/DCS-data-2026/conllu` — keeping VisualDCS lean and off Git LFS.
  Re-pointed the 8 LFS `.gitattributes` rules to the new `src/DCS-data-2021/` path.
- Brought the docs in line with the current repo: `README.md` and `CLAUDE.md` now cover all
  three dashboards and the `src/DCS-data-2021/` corpus, with the roadmap reconciled against shipped
  features, and `roadmap.md` got a status banner. Corrected the DCS dependency-annotation note
  (syntax coverage is **partial**, not absent) and de-linked two dead references in the
  migration ingestion plan.
- Renamed the data folder `src/DSC-data/` → `src/DCS-data/` (correct acronym, matching
  the Digital Corpus of Sanskrit / VisualDCS). Updated all internal references and
  re-pointed the Git LFS paths after the rename.

### Removed
- 8 redundant `.txt` files that were byte-for-byte identical to their `.csv` twin
  (`All`, `capters`, `cpx`, `forms`, `forms10`, `gra`, `topics`, `Files`) — kept the `.csv`.
