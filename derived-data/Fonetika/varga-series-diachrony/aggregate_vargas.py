"""Aggregate the 48-varṇa per-period counts into the 5 consonant series (varga)
and compute per-period shares + Cramér's V — the diachronic 'ряды согласных'
table for GasunsDhatu 2026 §2.6 (replaces the χ² p-value Table 5, defect L7).

Input : ../regen-2026/varna_freq.csv  (48 varṇas × slot1..slot5, DCS 2026)
Output: varga_share_by_period.csv     (5 vargas × 5 periods, shares + counts)
Fully deterministic; run: python aggregate_vargas.py

Aggregation math lives in the shared `varga_engine.varga_shares()` (H926) —
this file only supplies the EN varga membership/labels and CSV formatting.
"""
import sys, csv, os
sys.stdout.reconfigure(encoding='utf-8')

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "regen-2026", "varna_freq.csv")
OUT = os.path.join(HERE, "varga_share_by_period.csv")

sys.path.insert(0, HERE)
from varga_engine import varga_shares, SLOTS

# SLP1 -> varga. The 25 sparśa (stops + class nasals) only; anusvāra M, visarga H,
# semivowels y r l v, sibilants ś ṣ s h are separate classes, not vargas.
VARGA_LABELS = {
    'velar':     ['k', 'K', 'g', 'G', 'N'],
    'palatal':   ['c', 'C', 'j', 'J', 'Y'],
    'retroflex': ['w', 'W', 'q', 'Q', 'R'],
    'dental':    ['t', 'T', 'd', 'D', 'n'],
    'labial':    ['p', 'P', 'b', 'B', 'm'],
}
LABEL = {'velar':'ka-varga velar','palatal':'ca-varga palatal',
         'retroflex':'ṭa-varga retroflex','dental':'ta-varga dental','labial':'pa-varga labial'}

counts, shares, chi2, cramers_v = varga_shares(SRC, VARGA_LABELS)

coltot = [sum(counts[v][i] for v in VARGA_LABELS) for i in range(len(SLOTS))]
N = sum(coltot)

with open(OUT, 'w', encoding='utf-8', newline='') as f:
    w = csv.writer(f)
    w.writerow(['series','I_vedic_pct','II_pct','III_pct','IV_pct','V_late_pct','corpus_pct',
                'I_count','II_count','III_count','IV_count','V_count','delta_I_to_V_pp'])
    for v in VARGA_LABELS:
        sh = shares[v]
        row_total = sum(counts[v])
        w.writerow([LABEL[v]] + [round(x,3) for x in sh] + [round(100*row_total/N,3)]
                   + counts[v] + [round(sh[4]-sh[0],3)])

print(f"chi^2(16) = {chi2:,.1f}   Cramér's V = {cramers_v:.4f}   N(stops) = {N:,}")
print(f"wrote {OUT}")
