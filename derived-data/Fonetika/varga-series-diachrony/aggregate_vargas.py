"""Aggregate the 48-varṇa per-period counts into the 5 consonant series (varga)
and compute per-period shares + Cramér's V — the diachronic 'ряды согласных'
table for GasunsDhatu 2026 §2.6 (replaces the χ² p-value Table 5, defect L7).

Input : ../regen-2026/varna_freq.csv  (48 varṇas × slot1..slot5, DCS 2026)
Output: varga_share_by_period.csv     (5 vargas × 5 periods, shares + counts)
Fully deterministic; run: python aggregate_vargas.py
"""
import sys, csv, math, os
sys.stdout.reconfigure(encoding='utf-8')

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "..", "regen-2026", "varna_freq.csv")
OUT = os.path.join(HERE, "varga_share_by_period.csv")

# SLP1 -> varga. The 25 sparśa (stops + class nasals) only; anusvāra M, visarga H,
# semivowels y r l v, sibilants ś ṣ s h are separate classes, not vargas.
VARGA = {
 'k':'velar','K':'velar','g':'velar','G':'velar','N':'velar',
 'c':'palatal','C':'palatal','j':'palatal','J':'palatal','Y':'palatal',
 'w':'retroflex','W':'retroflex','q':'retroflex','Q':'retroflex','R':'retroflex',
 't':'dental','T':'dental','d':'dental','D':'dental','n':'dental',
 'p':'labial','P':'labial','b':'labial','B':'labial','m':'labial',
}
ORDER = ['velar','palatal','retroflex','dental','labial']
LABEL = {'velar':'ka-varga velar','palatal':'ca-varga palatal',
         'retroflex':'ṭa-varga retroflex','dental':'ta-varga dental','labial':'pa-varga labial'}
SLOTS = ['slot1','slot2','slot3','slot4','slot5']

table = {v:{s:0 for s in SLOTS} for v in ORDER}
with open(SRC, encoding='utf-8') as f:
    for row in csv.DictReader(f):
        v = VARGA.get(row['slp1'])
        if v:
            for s in SLOTS:
                table[v][s] += int(row[s])

coltot = {s: sum(table[v][s] for v in ORDER) for s in SLOTS}
rowtot = {v: sum(table[v][s] for s in SLOTS) for v in ORDER}
N = sum(coltot.values())

chi2 = sum((table[v][s] - rowtot[v]*coltot[s]/N)**2 / (rowtot[v]*coltot[s]/N)
           for v in ORDER for s in SLOTS)
V = math.sqrt(chi2 / (N * (min(5,5)-1)))

with open(OUT, 'w', encoding='utf-8', newline='') as f:
    w = csv.writer(f)
    w.writerow(['series','I_vedic_pct','II_pct','III_pct','IV_pct','V_late_pct','corpus_pct',
                'I_count','II_count','III_count','IV_count','V_count','delta_I_to_V_pp'])
    for v in ORDER:
        shares = [100*table[v][s]/coltot[s] for s in SLOTS]
        w.writerow([LABEL[v]] + [round(x,3) for x in shares] + [round(100*rowtot[v]/N,3)]
                   + [table[v][s] for s in SLOTS] + [round(shares[4]-shares[0],3)])

print(f"chi^2(16) = {chi2:,.1f}   Cramér's V = {V:.4f}   N(stops) = {N:,}")
print(f"wrote {OUT}")
