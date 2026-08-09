"""
build_lsc_gold_sample.py — stratified human-gold sample from lsc_targets.tsv

Stratification: 3 frequency terciles × 2 binary classes = 6 cells.
Sample size: 5 per cell → n=30.

Selection within each cell (deterministic, no random seed):
  binary=1 (changed): top 5 by dist_12 descending (strongest change signal)
  binary=0 (stable):  top 5 by dist_12 ascending  (most stable)

Output: lsc_human_gold_sample.tsv
  — all source columns from lsc_targets.tsv
  — four blank annotation columns: gold_binary, gold_graded, change_type, annotator_notes

Annotation schema:
  gold_binary    1 = semantic change, 0 = stable meaning
  gold_graded    continuous 0.0–1.0; 0=identical, 1=fully different
  change_type    narrowing | broadening | amelioration | pejoration |
                 metaphor | shift | stable | unclear
  annotator_notes  free text; cite at least one contextual contrast

Run:
  python derived-lsc/build_lsc_gold_sample.py [--selftest]

Usage pair protocol: for each lemma query dcs-conllu for slot-1 and slot-2
sentences (lemma column match), sample up to 5 per slot, and judge whether
the primary meaning has shifted. Frequency tercile and machine scores are
provided for calibration only — do not let them anchor the judgment.
"""

import sys
import csv
import pathlib

SRC = pathlib.Path(__file__).parent / "lsc_targets.tsv"
OUT = pathlib.Path(__file__).parent / "lsc_human_gold_sample.tsv"

CELLS_PER_TERCILE = 2    # binary 0 and 1
SAMPLE_PER_CELL = 5
EXPECTED_N = 30

ANNOTATION_COLS = ["gold_binary", "gold_graded", "change_type", "annotator_notes"]


def load_targets(path):
    with open(path, encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh, delimiter="\t")
        return list(reader), reader.fieldnames


def stratify(rows):
    cells = {}
    for row in rows:
        key = (int(row["freq_tercile"]), int(row["binary_changed_12"]))
        cells.setdefault(key, []).append(row)
    return cells


def sample_cell(rows, binary):
    key_fn = lambda r: float(r["dist_12"])
    reverse = (binary == 1)
    return sorted(rows, key=key_fn, reverse=reverse)[:SAMPLE_PER_CELL]


def build_sample(cells):
    sample = []
    for tercile in (1, 2, 3):
        for binary in (1, 0):
            key = (tercile, binary)
            rows = cells.get(key, [])
            sample.extend(sample_cell(rows, binary))
    return sample


def write_sheet(sample, fieldnames, out_path):
    out_cols = list(fieldnames) + ANNOTATION_COLS
    with open(out_path, "w", encoding="utf-8", newline="") as fh:
        writer = csv.DictWriter(fh, fieldnames=out_cols, delimiter="\t",
                                extrasaction="ignore")
        writer.writeheader()
        for row in sample:
            writer.writerow({**row, **{c: "" for c in ANNOTATION_COLS}})


def selftest(sample, cells):
    assert len(sample) == EXPECTED_N, f"n={len(sample)}, want {EXPECTED_N}"
    seen = set()
    for row in sample:
        lm = row["lemma_iast"]
        assert lm not in seen, f"duplicate lemma: {lm}"
        seen.add(lm)
    # check 5 per cell
    from collections import Counter
    cell_counts = Counter(
        (int(r["freq_tercile"]), int(r["binary_changed_12"])) for r in sample
    )
    for key, cnt in cell_counts.items():
        assert cnt == SAMPLE_PER_CELL, f"cell {key}: {cnt} rows, want {SAMPLE_PER_CELL}"
    # changed items should have higher dist_12 than stable in same tercile
    for tercile in (1, 2, 3):
        changed = [r for r in sample if int(r["freq_tercile"]) == tercile
                   and int(r["binary_changed_12"]) == 1]
        stable  = [r for r in sample if int(r["freq_tercile"]) == tercile
                   and int(r["binary_changed_12"]) == 0]
        min_changed = min(float(r["dist_12"]) for r in changed)
        max_stable  = max(float(r["dist_12"]) for r in stable)
        assert min_changed > max_stable, (
            f"tercile {tercile}: min changed dist {min_changed:.4f} not > "
            f"max stable dist {max_stable:.4f}"
        )
    print("selftest PASS")


def main():
    do_selftest = "--selftest" in sys.argv
    rows, fieldnames = load_targets(SRC)
    cells = stratify(rows)
    sample = build_sample(cells)
    write_sheet(sample, fieldnames, OUT)
    print(f"wrote {len(sample)} rows → {OUT}")
    if do_selftest:
        selftest(sample, cells)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8")
    main()
