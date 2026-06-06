# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Day-to-day session state lives in [`.ai_state.md`](.ai_state.md); this file records
durable, user-facing milestones.

## [Unreleased]

### Added
- `src/DCS-data/` raw corpus assets prepared for GitHub:
  - Split parts of the two >100 MB files (`10.csv` → 2 parts, `10.txt` → 3 parts),
    each ≤ 99 MiB and split on line boundaries so they rebuild byte-for-byte.
  - `src/DCS-data/rejoin.bat` — rebuilds the originals from their parts.
  - `src/DCS-data/.gitignore` — excludes the >100 MB originals `10.csv` / `10.txt`
    (kept locally, committed only as split parts).
  - `src/DCS-data/DCS-data-CLEANUP.md` — full inventory and rationale of the cleanup.
  - Repo-root `.gitattributes` — Git LFS tracking for the 11 large committed files
    (the split parts + 6 standalone 50–99 MB files).

### Changed
- Renamed the data folder `src/DSC-data/` → `src/DCS-data/` (correct acronym, matching
  the Digital Corpus of Sanskrit / VisualDCS). Updated all internal references and
  re-pointed the Git LFS paths after the rename.

### Removed
- 8 redundant `.txt` files that were byte-for-byte identical to their `.csv` twin
  (`All`, `capters`, `cpx`, `forms`, `forms10`, `gra`, `topics`, `Files`) — kept the `.csv`.
