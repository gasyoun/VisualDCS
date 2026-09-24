#!/usr/bin/env python3
"""verb_total_check.py — pin the README's verb-form headline to timws.csv (H5426, E016 wave 6).

_Created: 24-09-2026 · Last updated: 24-09-2026_

The README's verb-form dashboard headline (781,616 examples / 38 tense-mood
categories) is **Excel-derived** — `src/Распределение времен и наклонений.xlsx`
is what the dashboard HTML renders, and it is not machine-readable here. The
tracked CSV twin `src/DCS-data-2021/timws.csv` IS: on 24-09-2026 it carries
**42** category codes summing **781,618**, because the H1486/H2294 Aorist ·
Periphrastic Perfect · Perfect re-split turned pre-split buckets into separate
codes. The 2-unit gap to the Excel headline is the documented ±10 reconciliation
(CHANGELOG, `.ai_state.md`).

Neither number is wrong; both were hand-typed, so neither was checked. This
script re-derives the CSV pair from bytes on disk and verifies the README states
them verbatim.

Usage:
    python scripts/verb_total_check.py            # or --check, same thing

Exit 0 = README matches the CSV
Exit 1 = drift (the CSV moved, or the README was edited away from it)
Exit 2 = usage / IO error
"""
from __future__ import annotations

import io
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

ROOT = Path(__file__).resolve().parent.parent
CSV = ROOT / "src" / "DCS-data-2021" / "timws.csv"
README = ROOT / "README.md"


def derive() -> tuple[int, int]:
    """(category count, example total) from timws.csv — `ID:  Label :count` rows."""
    with io.open(CSV, encoding="utf-8-sig") as fh:
        rows = [line.strip() for line in fh if line.strip()][1:]  # drop the header
    return len(rows), sum(int(row.rsplit(":", 1)[1]) for row in rows)


def main(argv: list[str]) -> int:
    if argv and argv[0] not in ("--check",):
        print(f"usage: {Path(__file__).name} [--check]", file=sys.stderr)
        return 2
    if not CSV.exists():
        print(f"ERROR: {CSV} not found", file=sys.stderr)
        return 2

    codes, total = derive()
    print(f"timws.csv: {codes} category codes · {total:,} examples")

    text = README.read_text(encoding="utf-8")
    want = [f"{codes} category codes", f"{total:,}"]
    missing = [w for w in want if w not in text]
    if missing:
        for w in missing:
            print(f"  MISSING from README.md: {w}")
        print("FAIL: README.md no longer states the figures timws.csv yields")
        return 1
    print("PASS: README.md states the CSV-derived category count and total verbatim")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
