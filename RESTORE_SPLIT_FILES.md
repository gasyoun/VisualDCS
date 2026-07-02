# Restoring split files in `derived-data/` and `non-derived/`

_Created: 02-07-2026 · Last updated: 02-07-2026_

Files over ~95MB in `derived-data/` and `non-derived/` are stored in this repo as
7-Zip split volumes (`<original-name>.7z.001`, `.7z.002`, …) instead of the raw file,
because GitHub hard-rejects any single blob over 100MB. The original filename plus
`.7z` is the archive name; the `.NNN` suffixes are its volumes.

## Restore one file

With [7-Zip](https://www.7-zip.org/) installed, from the folder containing the parts:

```sh
7z x "<original-name>.7z.001"
```

7-Zip auto-detects the sibling `.002`, `.003`, … volumes and reassembles the original
file in place. You only ever run this on the `.001` part.

## Restore everything at once

From the repo root:

```sh
find derived-data non-derived -name '*.7z.001' -print0 | while IFS= read -r -d '' part; do
  dir=$(dirname "$part")
  (cd "$dir" && 7z x "$(basename "$part")")
done
```

This walks every split archive under both folders and reassembles it next to its
parts. The reassembled file lands alongside the `.7z.NNN` volumes — delete the
volumes afterward if you want the working copy without the archive parts (they stay
in git history regardless).

## Which files are split this way

See `derived-data/INDEX.md` and `non-derived/INDEX.md` for the current list — any
folder entry noting "(split for GitHub)" has its original replaced by `.7z.NNN`
volumes. As of 02-07-2026, 25 files (5.45GB pre-split) were split this way; the two
files already handled by other means — `src/DCS-data-2026/dcs_full.sqlite` (published
as a GitHub Release asset) and `src/DCS-data-2021/10.csv`/`10.txt` (already split via
the project's existing `rejoin.bat` line-boundary mechanism) — are untouched by this
process.

_Dr. Mārcis Gasūns_
