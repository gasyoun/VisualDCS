#!/usr/bin/env python3
"""Reproducible akshara / varṇa / ligature frequency over the DCS corpus.

Reads every ``# text = …`` surface (sandhied) line from the pinned DCS CoNLL-U
mirror, transliterates IAST → SLP1 (one ASCII char per phoneme, unambiguous),
segments each word into orthographic units, and counts:

  * aksharas  — orthographic syllables  C* V M*   (or a word-final C+ coda)
  * varṇas    — individual letters (each phoneme occurrence)
  * ligatures — maximal consonant clusters of length >= 2 (conjuncts)
  * ligatures2 — the 2-consonant subset of the above

Counts are kept corpus-wide AND per DCS time slot (1..5, oldest..latest),
mapped per chapter file from lookup/chapter-info.xml.

Source: DCS (Oliver Hellwig), CC BY 4.0. Pinned commit in ../PROVENANCE.md.
Output: CSVs + provenance.json in this directory. Reproducible, no network.

Phoneme classes + slp1_words()/segment()/load_slots() live in the shared
`dcs_phono_engine` module (H926), co-located in this directory — also
consumed by SanskritGrammar's dcs_text_phonostats.py.
"""
import sys, os, csv, json, unicodedata, collections, glob, time
sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")
from indic_transliteration import sanscript
from indic_transliteration.sanscript import transliterate as tr

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from dcs_phono_engine import VOWELS, MODIF, slp1_words, segment, load_slots

ROOT = r"C:/Users/user/Documents/GitHub/VisualDCS/src/DCS-data-2026/conllu"
FILES = os.path.join(ROOT, "files")
CHAPTER_INFO = os.path.join(ROOT, "lookup", "chapter-info.xml")
OUT = r"C:/Users/user/Documents/GitHub/VisualDCS/derived-data/Fonetika/regen-2026"
os.makedirs(OUT, exist_ok=True)

def main():
    t0 = time.time()
    slots = load_slots(CHAPTER_INFO)
    print(f"chapter->slot entries: {len(slots)}", file=sys.stderr)

    SLOT_KEYS = ["1", "2", "3", "4", "5"]
    # counters[dim]['all'] and counters[dim][slot]
    dims = ["akshara", "varna", "ligature", "ligature2"]
    counters = {d: {k: collections.Counter() for k in ["all"] + SLOT_KEYS} for d in dims}
    stats = collections.Counter()

    files = glob.glob(os.path.join(FILES, "**", "*.conllu"), recursive=True)
    print(f"conllu files: {len(files)}", file=sys.stderr)
    unmatched = 0
    for fi, path in enumerate(files):
        base = unicodedata.normalize("NFC", os.path.basename(path))
        slot = slots.get(base)
        if slot not in SLOT_KEYS:
            slot = None
            unmatched += 1
        try:
            data = open(path, encoding="utf-8").read()
        except Exception:
            continue
        for line in data.splitlines():
            if not line.startswith("# text = "):
                continue
            stats["text_lines"] += 1
            for w in slp1_words(line[9:]):
                ak, va, lg, lg2 = segment(w)
                stats["words"] += 1
                for dim, items in (("akshara", ak), ("varna", va),
                                    ("ligature", lg), ("ligature2", lg2)):
                    counters[dim]["all"].update(items)
                    if slot:
                        counters[dim][slot].update(items)
        if fi % 2000 == 0:
            print(f"  {fi}/{len(files)} files, {stats['words']} words, "
                  f"{time.time()-t0:.0f}s", file=sys.stderr)

    print(f"unmatched-slot files: {unmatched}", file=sys.stderr)

    # --- render + write CSVs ------------------------------------------------
    def dev(slp, kind):
        if kind == "varna":
            if slp in VOWELS:
                return tr(slp, sanscript.SLP1, sanscript.DEVANAGARI)       # independent vowel
            if slp in MODIF:
                return {"M": "ं", "H": "ः", "~": "ँ"}[slp]
            return tr(slp, sanscript.SLP1, sanscript.DEVANAGARI)            # bare consonant already carries virāma
        if kind in ("ligature", "ligature2"):
            joined = tr(slp + "a", sanscript.SLP1, sanscript.DEVANAGARI)    # recognisable form (pra)
            halant = tr(slp, sanscript.SLP1, sanscript.DEVANAGARI)          # pure cluster (pr + virāma)
            return joined, halant
        return tr(slp, sanscript.SLP1, sanscript.DEVANAGARI)               # akshara as-is

    def iast(slp):
        return tr(slp, sanscript.SLP1, sanscript.IAST)

    for dim in dims:
        allc = counters[dim]["all"]
        total = sum(allc.values())
        rows = []
        for slp, cnt in allc.most_common():
            row = {"slp1": slp, "iast": iast(slp), "count": cnt,
                   "pct": round(100.0 * cnt / total, 4)}
            if dim in ("ligature", "ligature2"):
                j, h = dev(slp, dim); row["devanagari"] = j; row["devanagari_halant"] = h
                row["n_consonants"] = len(slp)
            else:
                row["devanagari"] = dev(slp, dim)
            for k in SLOT_KEYS:
                row[f"slot{k}"] = counters[dim][k].get(slp, 0)
            rows.append(row)
        # frequency order
        fields = (["devanagari", "iast", "slp1", "count", "pct"]
                  + (["devanagari_halant", "n_consonants"] if dim in ("ligature", "ligature2") else [])
                  + [f"slot{k}" for k in SLOT_KEYS])
        with open(os.path.join(OUT, f"{dim}_freq.csv"), "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=fields); w.writeheader(); w.writerows(rows)
        # varṇamālā (traditional) order — SLP1 canonical order
        ORDER = "aAiIuUfFxXeEoOMHkKgGNcCjJYwWqQRtTdDnpPbBmyrlvSzshL~"
        def key(r):
            s = r["slp1"]
            return tuple(ORDER.index(ch) if ch in ORDER else 99 for ch in s)
        with open(os.path.join(OUT, f"{dim}_varnamala.csv"), "w", newline="", encoding="utf-8") as f:
            w = csv.DictWriter(f, fieldnames=fields); w.writeheader()
            w.writerows(sorted(rows, key=key))
        print(f"{dim}: {len(rows)} distinct, total {total}", file=sys.stderr)

    prov = {
        "generated_by": "build_akshara_ligature_freq.py",
        "source": "DCS CoNLL-U (Oliver Hellwig), CC BY 4.0",
        "pin": "see ../PROVENANCE.md (commit 04e0778…, pin 2026-03-05)",
        "input": "# text = surface (sandhied) lines, files/**/*.conllu",
        "transliteration": "IAST -> SLP1 via indic_transliteration; Devanagari for display",
        "counts": {d: {"distinct": len(counters[d]["all"]),
                        "total": sum(counters[d]["all"].values())} for d in dims},
        "text_lines": stats["text_lines"], "words": stats["words"],
        "unmatched_slot_files": unmatched,
        "time_slots": "DCS dcsTimeSlot 1..5 (1 oldest/Vedic .. 5 latest); per chapter",
        "seconds": round(time.time() - t0, 1),
    }
    json.dump(prov, open(os.path.join(OUT, "provenance.json"), "w", encoding="utf-8"),
              ensure_ascii=False, indent=2)
    print("DONE", prov["counts"], file=sys.stderr)

if __name__ == "__main__":
    main()
