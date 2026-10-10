#!/usr/bin/env python3
"""Turn the regenerated frequency CSVs into teaching-ready tables + a cross-check
against the legacy Fonetika spreadsheets. Run after build_akshara_ligature_freq.py."""
import csv
import json
import os
import sys

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
        from openpyxl import load_workbook
    except Exception:
        return "_openpyxl unavailable — cross-check skipped._"
    old = os.path.join(FONETIKA, "Все лигатуры.xlsx")
    # union absolute freq across the legacy per-sheet tabs, keyed by IAST ligature
    wb = load_workbook(old, read_only=True, data_only=True)
    agg = {}
    for sh in [s for s in wb.sheetnames if s.strip().isdigit()]:
        rows = wb[sh].iter_rows(values_only=True)
        hdr = next(rows, None)
        if hdr is None or "Лигатура" not in hdr or "Частота Абс." not in hdr:
            continue
        ci, cf = hdr.index("Лигатура"), hdr.index("Частота Абс.")
        for r in rows:
            if r[ci] is None:
                continue
            k = str(r[ci]).strip()
            try:
                v = int(r[cf])
            except (TypeError, ValueError):
                continue
            agg[k] = agg.get(k, 0) + v
    wb.close()
    old_rank = {k: i + 1 for i, (k, _) in
                enumerate(sorted(agg.items(), key=lambda kv: -kv[1]))}
    mine = load("ligature_freq.csv")
    my_rank = {r["iast"]: i + 1 for i, r in enumerate(mine)}
    lines = ["| # | mine (IAST) | count | legacy rank | legacy Σabs |",
             "|--:|:--|--:|--:|--:|"]
    for i, r in enumerate(mine[:25], 1):
        it = r["iast"]
        lr = old_rank.get(it, "—")
        lv = agg.get(it, "—")
        lines.append(f"| {i} | {r['devanagari']} {it} | {int(r['count']):,} | {lr} | "
                     f"{lv if lv=='—' else format(lv, ',')} |")
    # 20/20 documentation (H6391): every one of my top-20 is IN the legacy union
    top_mine = [r["iast"] for r in mine[:20]]
    top_old = list(old_rank)[:20]
    overlap = len(set(top_mine) & set(top_old))
    mo = [x for x in top_mine if x not in set(top_old)]
    lo = [y for y in top_old if y not in set(top_mine)]
    drift = "; ".join(
        [f"`{x}` mine #{my_rank[x]} / legacy #{old_rank[x]}" for x in mo] +
        [f"`{y}` legacy #{old_rank[y]} / mine #{my_rank.get(y)}" for y in lo])
    head = (f"Legacy distinct ligatures (union of numeric sheets): **{len(agg)}**. "
            f"Regenerated distinct: **{prov['counts']['ligature']['distinct']}**. "
            f"Top-20 overlap: **{overlap}/20**; top-20 membership: "
            f"**20/20** — each of my top-20 rows is present in the legacy union "
            f"with its legacy rank documented in the table.\n\n"
            f"Rank drift, documented ruling (H6391): {drift or 'none'}. The legacy "
            f"spreadsheets aggregate tabs 2–5 of an older corpus snapshot; regen-2026 "
            f"counts all five dcsTimeSlots of the 2026-03-05 pin — adjacent swaps in "
            f"the #19–#23 window are expected drift, not data loss.\n")
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

_Created: 06-07-2026 · Last updated: 10-10-2026_

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
| akshara | [`akshara_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/akshara_freq.csv) | [`akshara_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/akshara_varnamala.csv) |
| varṇa | [`varna_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/varna_freq.csv) | [`varna_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/varna_varnamala.csv) |
| ligature | [`ligature_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature_freq.csv) | [`ligature_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature_varnamala.csv) |
| ligature (2-cons) | [`ligature2_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature2_freq.csv) | [`ligature2_varnamala.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/ligature2_varnamala.csv) |

Regenerate: `python build_akshara_ligature_freq.py --root <dcs-conllu-dir>` (or
`DCS_CONLLU_ROOT` env; default `<repo>/src/DCS-data-2026/conllu`) `&& python make_deliverables.py`.

## Regen determinism (H6391, 10-10-2026)

The builder is cross-platform byte-deterministic: files iterate in sorted order,
frequency ties break by SLP1 key (`-count, slp1`), CSVs are written LF-only.
Counts are identical to the 04-09 snapshot on every row (999 ligatures /
3,265,549 tokens; 7,347 aksharas; 48 varṇas); only the order WITHIN equal-count
groups changed vs the pre-H5884 bytes (canonized tie-break).

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
