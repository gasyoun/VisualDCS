"""Shared varga x epoch aggregation engine for the DCS 48-varna frequency
table (``VisualDCS/derived-data/Fonetika/regen-2026/varna_freq.csv``),
consumed by this directory's ``aggregate_vargas.py`` (EN labels) and by
``SanskritGrammar/GasunsDhatu_2014/revision-2026/varga_shares.py`` (RU
labels).

Both sites aggregate the 25 sparsa varnas (stops + class nasals) into the 5
traditional vargas (velar/palatal/retroflex/dental/labial =
kanthya/talavya/murdhanya/dantya/oshthya) per DCS time slot 1..5, then
compute per-slot shares and the varga x slot Cramer's V effect size. The two
sites' math was byte-identical (same summation order); only display
labels/columns diverged. Extracted verbatim — H926, Port 2 of the
cross-repo dev-status + reuse review.
"""
import csv
import math

SLOTS = ['slot1', 'slot2', 'slot3', 'slot4', 'slot5']


def varga_shares(varna_freq_csv, varga_labels, epoch_labels=None):
    """Aggregate `varna_freq_csv` (DCS 48-varna x slot1..slot5) into the
    vargas named by `varga_labels`.

    varga_labels: dict of varga_key -> list of 5 SLP1 sparsa letters for
                  that varga. Dict insertion order fixes the varga/row
                  order used throughout (and in the returned dicts).
    epoch_labels: optional list of 5 labels for slot1..slot5, used only to
                  validate the caller's epoch count matches SLOTS (the
                  math itself is label-agnostic).

    Returns (counts, shares, chi2, cramers_v):
      counts — {varga: [c_slot1..c_slot5]}     int, in SLOTS order
      shares — {varga: [pct_slot1..pct_slot5]} float 0..100, the share of
               that slot's sparsa total held by this varga
      chi2, cramers_v — floats, over the varga x slot contingency table
    """
    if epoch_labels is not None and len(epoch_labels) != len(SLOTS):
        raise ValueError(f"epoch_labels must have {len(SLOTS)} entries, got {len(epoch_labels)}")

    letter_to_varga = {l: v for v, letters in varga_labels.items() for l in letters}
    counts = {v: [0] * len(SLOTS) for v in varga_labels}
    seen = set()
    with open(varna_freq_csv, encoding='utf-8') as f:
        for row in csv.DictReader(f):
            v = letter_to_varga.get(row['slp1'])
            if v is None:
                continue
            seen.add(row['slp1'])
            for i, s in enumerate(SLOTS):
                counts[v][i] += int(row[s])
    missing = letter_to_varga.keys() - seen
    if missing:
        raise ValueError(f"varna(s) {sorted(missing)!r} missing from {varna_freq_csv}")

    slot_totals = [sum(counts[v][i] for v in varga_labels) for i in range(len(SLOTS))]
    grand = sum(slot_totals)

    chi2 = 0.0
    for v in varga_labels:
        row_total = sum(counts[v])
        for i in range(len(SLOTS)):
            expected = row_total * slot_totals[i] / grand
            chi2 += (counts[v][i] - expected) ** 2 / expected
    k = min(len(varga_labels), len(SLOTS))
    cramers_v = math.sqrt(chi2 / (grand * (k - 1)))

    shares = {v: [100 * counts[v][i] / slot_totals[i] for i in range(len(SLOTS))]
              for v in varga_labels}

    return counts, shares, chi2, cramers_v
