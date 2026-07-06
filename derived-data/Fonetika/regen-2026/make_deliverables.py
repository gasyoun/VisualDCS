#!/usr/bin/env python3
"""Turn the regenerated frequency CSVs into teaching-ready tables + a cross-check
against the legacy Fonetika spreadsheets. Run after build_akshara_ligature_freq.py."""
import sys, os, csv, json
sys.stdout.reconfigure(encoding="utf-8")
HERE = os.path.dirname(os.path.abspath(__file__))
FONETIKA = os.path.dirname(HERE)

def load(name):
    with open(os.path.join(HERE, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))

prov = json.load(open(os.path.join(HERE, "provenance.json"), encoding="utf-8"))

# ---- cross-check my ligatures vs legacy "Все лигатуры.xlsx" -----------------
def cross_check():
    try:
        import pandas as pd
    except Exception:
        return "_pandas unavailable — cross-check skipped._"
    old = os.path.join(FONETIKA, "Все лигатуры.xlsx")
    xl = pd.ExcelFile(old)
    # union absolute freq across the legacy per-sheet tabs, keyed by IAST ligature
    agg = {}
    for sh in [s for s in xl.sheet_names if s.strip().isdigit()]:
        df = xl.parse(sh)
        col = "Лигатура"; fq = "Частота Абс."
        if col not in df.columns or fq not in df.columns:
            continue
        for _, r in df.iterrows():
            k = str(r[col]).strip()
            try: v = int(r[fq])
            except Exception: continue
            agg[k] = agg.get(k, 0) + v
    old_rank = [k for k, _ in sorted(agg.items(), key=lambda kv: -kv[1])]
    mine = load("ligature_freq.csv")
    my_rank = [r["iast"] for r in mine]
    lines = ["| # | mine (IAST) | count | legacy rank | legacy Σabs |",
             "|--:|:--|--:|--:|--:|"]
    for i, r in enumerate(mine[:25], 1):
        it = r["iast"]
        lr = old_rank.index(it) + 1 if it in old_rank else "—"
        lv = agg.get(it, "—")
        lines.append(f"| {i} | {r['devanagari']} {it} | {int(r['count']):,} | {lr} | "
                     f"{lv if lv=='—' else format(lv, ',')} |")
    # simple agreement metric over top-20
    top_mine = set(my_rank[:20]); top_old = set(old_rank[:20])
    overlap = len(top_mine & top_old)
    head = (f"Legacy distinct ligatures (union of numeric sheets): **{len(agg)}**. "
            f"Regenerated distinct: **{prov['counts']['ligature']['distinct']}**. "
            f"Top-20 overlap: **{overlap}/20**.\n")
    return head + "\n" + "\n".join(lines)

def table(rows, n, dim):
    lig = dim in ("ligature", "ligature2")
    hdr = (["#", "Devanāgarī", "IAST", "Count", "%", "Cum %"]
           + (["Cons"] if lig else []))
    out = ["| " + " | ".join(hdr) + " |",
           "|" + "|".join(["--:"] + [":--", ":--", "--:", "--:", "--:"] + (["--:"] if lig else [])) + "|"]
    cum = 0.0
    for i, r in enumerate(rows[:n], 1):
        cum += float(r["pct"])
        cells = [str(i), r["devanagari"], r["iast"], f"{int(r['count']):,}",
                 f"{float(r['pct']):.2f}", f"{cum:.1f}"]
        if lig:
            cells.append(r.get("n_consonants", ""))
        out.append("| " + " | ".join(cells) + " |")
    return "\n".join(out)

def varna_full():
    rows = load("varna_varnamala.csv")
    return table(rows, len(rows), "varna")

lig = load("ligature_freq.csv")
lig2 = load("ligature2_freq.csv")
aks = load("akshara_freq.csv")

readme = f"""# DCS akshara · varṇa · ligature frequency — for teaching Devanāgarī

_Created: 06-07-2026 · Last updated: 06-07-2026_

Regenerated from the **Digital Corpus of Sanskrit** (Oliver Hellwig, CC BY 4.0)
for [gasyoun/Nagari](https://github.com/gasyoun/Nagari) — data to sequence how
students learn the script (most-frequent conjuncts first).

## What this is

A reproducible frequency analysis of the reading surface of the whole DCS corpus
({prov['words']:,} words across {prov['text_lines']:,} sandhied `# text` lines).
Every word is transliterated IAST → SLP1 (one unambiguous char per phoneme) and
segmented into three orthographic units:

| Unit | Definition | Distinct | Total occurrences |
|---|---|--:|--:|
| **akshara** (syllable) | onset cluster + vowel + modifiers `C* V M*`, or a word-final consonant coda | {prov['counts']['akshara']['distinct']:,} | {prov['counts']['akshara']['total']:,} |
| **varṇa** (letter) | each individual phoneme (consonant / vowel / anusvāra / visarga) | {prov['counts']['varna']['distinct']:,} | {prov['counts']['varna']['total']:,} |
| **ligature** (conjunct) | a maximal run of ≥2 consonants (rendered as a saṃyoga glyph) | {prov['counts']['ligature']['distinct']:,} | {prov['counts']['ligature']['total']:,} |

`ligature2` is the two-consonant subset ({prov['counts']['ligature2']['distinct']:,} distinct).

## Files

Each unit ships as two CSVs — **frequency order** (`*_freq.csv`) and traditional
**varṇamālā order** (`*_varnamala.csv`) — with columns Devanāgarī · IAST · SLP1 ·
count · % · per-period counts (`slot1..slot5`).

| Unit | Frequency order | Varṇamālā order |
|---|---|---|
| akshara | [`akshara_freq.csv`](akshara_freq.csv) | [`akshara_varnamala.csv`](akshara_varnamala.csv) |
| varṇa | [`varna_freq.csv`](varna_freq.csv) | [`varna_varnamala.csv`](varna_varnamala.csv) |
| ligature | [`ligature_freq.csv`](ligature_freq.csv) | [`ligature_varnamala.csv`](ligature_varnamala.csv) |
| ligature (2-cons) | [`ligature2_freq.csv`](ligature2_freq.csv) | [`ligature2_varnamala.csv`](ligature2_varnamala.csv) |

Regenerate: `python build_akshara_ligature_freq.py && python make_deliverables.py`.

## Periods

Counts are also split by DCS `dcsTimeSlot` (1 = oldest/Vedic stratum … 5 = latest),
mapped per chapter from `chapter-info.xml`. The legacy Fonetika spreadsheets used
slots 2–5 only; this regeneration keeps all five ({prov['unmatched_slot_files']} files had no slot).

---

## Top 30 conjuncts (ligatures) — the teaching priority list

{table(lig, 30, "ligature")}

## Top 25 two-consonant conjuncts

{table(lig2, 25, "ligature2")}

## Top 30 aksharas (syllables)

{table(aks, 30, "akshara")}

## All varṇas by frequency-in-corpus (varṇamālā order)

{varna_full()}

---

## Cross-check vs legacy `Все лигатуры.xlsx`

{cross_check()}

## Provenance

Source: DCS CoNLL-U mirror, {prov['pin']}. Input: {prov['input']}.
Transliteration: {prov['transliteration']}. Generated by
[`build_akshara_ligature_freq.py`](build_akshara_ligature_freq.py) in {prov['seconds']}s.
Fully reproducible, offline.

_Dr. Mārcis Gasūns_
"""

open(os.path.join(HERE, "README.md"), "w", encoding="utf-8").write(readme)
print("wrote README.md")
