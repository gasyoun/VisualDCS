# DCS-data cleanup & large-file handling

Date: 2026-06-05

This folder contained files larger than GitHub's hard **100 MB per-file limit**, which
blocked pushing the folder. This document records the cleanup that was done so the folder
can be committed and pushed, and explains how to restore the original files.

## Summary

| Action | Files |
| --- | --- |
| Split (original kept locally, git-ignored) | `10.csv`, `10.txt` |
| Deleted as exact `.csv` duplicates | 8 `.txt` files (see below) |
| Tracked via **Git LFS** (50–99 MB) | the split parts + 6 standalone large files (see §3) |

Nothing else in the folder was modified.

---

## 1. Oversized files — split into ≤ 99 MB parts

Two files exceeded 100 MB. They are **different files** (different format and content),
not copies of each other, so both were kept:

- `10.csv` — bare comma-separated rows, e.g. `165692,18127,1,1,0,0,...`
- `10.txt` — SQL-tuple rows, e.g. `(281915, 165692, 18127, 1, 1, ...),`

Each was split on **line boundaries** (no line is cut across a part), so every part is
both independently readable and concatenates back to a byte-exact original.

| Original | Size | Parts | Each part |
| --- | --- | --- | --- |
| `10.csv` | 189.3 MB | `10.csv.part001`, `10.csv.part002` | 99.0 MB, 81.5 MB |
| `10.txt` | 293.9 MB | `10.txt.part001`, `10.txt.part002`, `10.txt.part003` | 99.0 MB, 99.0 MB, 82.2 MB |

Limit used for splitting: **99 MiB (103,809,024 bytes)** — safely under GitHub's 100 MB.

### What gets committed
- ✅ The `*.part###` files are committed to the repo.
- 🚫 The original `10.csv` and `10.txt` are listed in `.gitignore` and are **not** committed
  (they would be rejected by GitHub). They remain on your local disk untouched.

### How to reassemble the originals
From inside this folder run:

```bat
rejoin.bat
```

(or manually:)

```bat
copy /b "10.csv.part001"+"10.csv.part002" "10.csv"
copy /b "10.txt.part001"+"10.txt.part002"+"10.txt.part003" "10.txt"
```

On Linux/macOS / Git Bash:

```bash
cat 10.csv.part* > 10.csv
cat 10.txt.part* > 10.txt
```

### Integrity (MD5)
Verified that concatenating the parts reproduces the originals exactly:

```
10.csv  f7e90cecf30299e364275d9ea56080a7
10.txt  e6e0e27cd60fe61f70e02d9b6c4cc774
```

Verify after rejoining with: `certutil -hashfile 10.csv MD5`

---

## 2. Deleted exact duplicates (`.txt` identical to `.csv`)

These 8 `.txt` files were **byte-for-byte identical** (MD5-confirmed) to the `.csv` of the
same name, so the redundant `.txt` was deleted and the `.csv` kept:

| Kept | Deleted (identical) | MD5 |
| --- | --- | --- |
| `All.csv` | `All.txt` | `1f3d08fbc0b88339fc66aa39cf765691` |
| `capters.csv` | `capters.txt` | `ebbd86c450d036445fd55c457cf707db` |
| `cpx.csv` | `cpx.txt` | `9b77710bae38ca4a1d65f8686e3a95c9` |
| `forms.csv` | `forms.txt` | `29351d2db4f7c5b216be474a8d64a2df` |
| `forms10.csv` | `forms10.txt` | `997167c3157322ebd65a53790bcf17a4` |
| `gra.csv` | `gra.txt` | `6230ebe4d2c97d01c95c47a9e2aff657` |
| `topics.csv` | `topics.txt` | `da51e8fabbb12574af5b73a24211c710` |
| `Files.csv` | `Files.txt` | `3c4d40590d5f0f8640689b349d052fbc` |

### CSV/TXT pairs that were KEPT (not identical)
These share a base name but differ in content, so **both** were kept:
`10`, `12`, `15`, `texts`.

---

## 3. Git LFS — large files (50–99 MB)

To keep the repository lean and avoid GitHub's >50 MB warnings, the large committed
files are stored via **Git LFS** instead of as normal blobs. The tracking rules live in
the repo-root **`.gitattributes`** (full paths are used so the `!7.csv` filename's leading
`!` is not misread as a glob negation).

**LFS-tracked files (11):**

| File | Size |
| --- | --- |
| `10.csv.part001`, `10.csv.part002` | 99.0 MB, 81.5 MB |
| `10.txt.part001`, `10.txt.part002`, `10.txt.part003` | 99.0 MB, 99.0 MB, 82.2 MB |
| `0.csv` | 78.9 MB |
| `_0_.txt` | 67.2 MB |
| `7.txt` | 52.1 MB |
| `621445.txt` | 51.0 MB |
| `621445.dig` | 49.8 MB |
| `!7.csv` | 49.8 MB |

Verified with `git check-attr filter -- <file>` that **only** these 11 files resolve to the
`lfs` filter; similarly-named neighbors (`_7.csv`, `!!8.csv`, `!9.csv`, …) are unaffected.

### Cloning / pulling
Git LFS must be installed to get the real file contents:

```bash
git lfs install      # once per machine
git clone <repo>     # LFS files download automatically
```

GitHub Desktop has LFS built in and handles this automatically.

### Decision (2026-06-06): keep LFS as-is

We **kept Git LFS** rather than switching the files back to plain git blobs.

- The 11 referenced LFS objects total **~846 MB**.
- GitHub's free LFS tier is **1 GB storage + 1 GB/month bandwidth** (per *account*, not per repo).
- The account currently shows **~1.32 GB** of LFS storage. The extra ~474 MB is **orphaned
  objects** left over from earlier history rewrites (LFS migration + a re-split to fix
  line-ending corruption in the first parts). GitHub does **not** garbage-collect LFS objects,
  so a history rewrite removes the *references* but not the stored bytes — reclaiming them would
  require deleting + recreating the repo (or a GitHub Support purge). We deliberately did **not**
  do that.

**Why over-quota is fine for this project:** these files are a **static data dump** —
not updated and not downloaded on a schedule (used locally for comparison / data extraction).
Being over the **storage** quota only blocks *uploading new/changed LFS objects* (which won't
happen here); normal git pushes (code, docs) are unaffected. The **bandwidth** cap only matters
for frequent LFS downloads, which also won't happen.

If the repo ever becomes heavily cloned, revisit this — plain git blobs (all parts are < 100 MB)
avoid the LFS storage *and* bandwidth limits entirely, but switching would still need a
delete+recreate or Support purge to clear the already-stored objects.

---

## Files added by this cleanup
- `.gitignore` — excludes the oversized originals `10.csv` / `10.txt`.
- `rejoin.bat` — rebuilds the originals from the parts.
- `DCS-data-CLEANUP.md` — this document.
- `../../.gitattributes` (repo root) — Git LFS tracking rules for the large files.
