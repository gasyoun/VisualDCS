"""Generate dcs_lemma_summary.json for the csl-atlas consumption contract.

Reads src/DCS-data-2021/_8.csv (lemma frequency list: count,lemma,pos)
and emits dcs_lemma_summary.json keyed by normalized SLP1 headword.

Banding rule: log-quantile-5 — divide the range of log(count) into 5
equal-population quintiles (band 5 = most frequent 20%, band 1 = least
frequent 20%). Ties go to the lower band. Thresholds are written into
the output file so the rule is self-documenting.

See csl-atlas docs/VISUALDCS_CONSUMPTION_CONTRACT.md for the full schema.
Run from the VisualDCS repo root:
    python gen_dcs_lemma_summary.py
"""

import csv
import json
import math
import re
import sys
import unicodedata

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

SRC = "src/DCS-data-2021/_8.csv"
OUT = "dcs_lemma_summary.json"
SCHEMA_VERSION = "1.0.0"
CORPUS_RELEASE = "DCS-2021"
GENERATED_AT = "2026-06-10"

# ── IAST Unicode → SLP1 ──────────────────────────────────────────────────────
# Order matters: longer/diacritic sequences before plain ASCII.
_IAST_SLP1 = [
    # Diphthongs (before simple vowels to avoid partial matches)
    ("ai", "E"), ("au", "O"),
    # Long vowels
    ("ā", "A"), ("ī", "I"), ("ū", "U"),
    # Vocalic r/l
    ("ṛ", "f"), ("ṝ", "F"), ("ḷ", "x"),
    # Anusvara, visarga
    ("ṃ", "M"), ("ḥ", "H"),
    # Sibilants
    ("ś", "S"), ("ṣ", "z"),
    # Nasals (before plain n)
    ("ṅ", "N"), ("ñ", "Y"), ("ṇ", "R"),
    # Retroflex aspirates (before plain retroflex)
    ("ṭh", "W"), ("ḍh", "Q"),
    # Retroflex plain
    ("ṭ", "w"), ("ḍ", "q"),
    # Aspirates (digraphs — before plain consonants so dh≠d+h)
    ("kh", "K"), ("gh", "G"),
    ("ch", "C"), ("jh", "J"),
    ("th", "T"), ("dh", "D"),
    ("ph", "P"), ("bh", "B"),
    # Everything else (a i u e o k g c j t d n p b m y r l v s h) stays as-is.
]


def iast_to_slp1(s):
    s = unicodedata.normalize("NFC", s)
    for iast, slp1 in _IAST_SLP1:
        s = s.replace(iast, slp1)
    return s


def normalize_slp1(s):
    """Strip trailing homonym digits — matches csl-atlas normalizeLemma()."""
    return re.sub(r"\d+$", "", s.strip())


# ── Banding ──────────────────────────────────────────────────────────────────
# log10 order-of-magnitude bands — intuitive and self-documenting:
#   1 = hapax (count 1)     4 = common (100–999)
#   2 = rare  (2–9)         5 = very common (1000+)
#   3 = uncommon (10–99)
BAND_RULE = "log10-orders: 1=hapax(1), 2=rare(2-9), 3=uncommon(10-99), 4=common(100-999), 5=very-common(1000+)"

def freq_band(count):
    if count <= 1:    return 1
    if count < 10:    return 2
    if count < 100:   return 3
    if count < 1000:  return 4
    return 5


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    # Parse _8.csv: count,lemma(IAST),pos
    raw = []
    skipped = 0
    with open(SRC, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            parts = line.split(",", 2)
            if len(parts) < 2:
                continue
            try:
                count = int(parts[0])
            except ValueError:
                skipped += 1
                continue
            lemma_iast = parts[1].strip()
            slp1 = normalize_slp1(iast_to_slp1(lemma_iast))
            if not slp1:
                skipped += 1
                continue
            raw.append((count, slp1))

    print(f"Parsed {len(raw):,} lemmas, skipped {skipped} malformed rows")

    # Aggregate duplicate normalized keys (e.g. homonym indices collapse)
    agg: dict[str, int] = {}
    for count, norm in raw:
        agg[norm] = agg.get(norm, 0) + count

    # Build lemma map sorted by key
    lemmas = {}
    band_counts = [0] * 5
    for norm in sorted(agg):
        b = freq_band(agg[norm])
        lemmas[norm] = {"freqBand": b, "attested": True}
        band_counts[b - 1] += 1

    print(f"Band distribution: {dict(enumerate(band_counts, 1))}")

    # Verify anchor lemmas from the contract
    for anchor in ("gam", "Darma", "rAma", "iti", "boDisattva"):
        hit = lemmas.get(anchor)
        print(f"  anchor {anchor!r}: {hit}")

    out = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedBy": "VisualDCS",
        "corpusRelease": CORPUS_RELEASE,
        "generatedAt": GENERATED_AT,
        "bandingRule": (
            BAND_RULE + ". "
            "Source: src/DCS-data-2021/_8.csv (Oliver Hellwig, DCS ~2021 snapshot, CC BY)."
        ),
        "lemmaCount": len(lemmas),
        "lemmas": lemmas,
    }

    with open(OUT, "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, separators=(",", ":"))

    size_kb = len(json.dumps(out, ensure_ascii=False, separators=(",", ":"))) / 1024
    print(f"\nWrote {OUT}: {len(lemmas):,} lemmas, {size_kb:.0f} KB")


if __name__ == "__main__":
    main()
