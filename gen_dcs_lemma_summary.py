"""Generate dcs_lemma_summary.json for the csl-atlas consumption contract.

Reads src/DCS-data-2021/_8.csv (lemma frequency list: count,lemma,pos)
and emits dcs_lemma_summary.json keyed by normalized SLP1 headword.

Banding rule: log10 order-of-magnitude bands by raw corpus count —
  band 1 = hapax (count 1)      band 4 = common (100-999)
  band 2 = rare (2-9)           band 5 = very common (1000+)
  band 3 = uncommon (10-99)
These bands are deliberately NOT equal-population: the corpus is Zipfian,
so band 1 holds ~43% of lemmas and band 5 well under 1%. The exact rule
string is written into the output's "bandingRule" field so the file is
self-documenting.

See csl-atlas docs/VISUALDCS_CONSUMPTION_CONTRACT.md for the full schema.
Run from the VisualDCS repo root:
    python gen_dcs_lemma_summary.py
"""

import datetime
import json
import os
import re
import sys
import unicodedata

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

SRC = "src/DCS-data-2021/_8.csv"
OUT = "dcs_lemma_summary.json"
SCHEMA_VERSION = "1.0.0"
CORPUS_RELEASE = "DCS-2021"
GENERATED_AT = datetime.date.today().isoformat()  # real run date, not frozen

# Contract anchor lemmas (see VISUALDCS_CONSUMPTION_CONTRACT.md). The run fails
# loudly if any of these does not resolve — a guard against silent encoding
# regressions that would ship a JSON missing its guaranteed keys.
CONTRACT_ANCHORS = ("gam", "Darma", "rAma", "iti", "boDisattva")

# A well-formed normalized SLP1 headword is pure ASCII letters: no stray
# anusvara/diacritics, no source mojibake (U+FFB1/…), no backslash/asterisk.
SLP1_KEY_RE = re.compile(r"[A-Za-z]+\Z")

# ── IAST Unicode → SLP1 ──────────────────────────────────────────────────────
# Order matters: longer/diacritic sequences before plain ASCII.
_IAST_SLP1 = [
    # Diphthongs (before simple vowels to avoid partial matches)
    ("ai", "E"), ("au", "O"),
    # Long vowels
    ("ā", "A"), ("ī", "I"), ("ū", "U"),
    # Vocalic r/l
    ("ṛ", "f"), ("ṝ", "F"), ("ḷ", "x"),
    # Anusvara (both ṁ U+1E41 dot-above — the DCS/_8.csv convention — and
    # ṃ U+1E43 dot-below, the academic IAST form), visarga
    ("ṁ", "M"), ("ṃ", "M"), ("ḥ", "H"),
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
# Single source of truth for the log10 order-of-magnitude bands: a count below
# `upper` (and at/above the previous bound) falls in that band; `upper=None` is
# the open-ended top band. Both freq_band() and the self-documenting BAND_RULE
# string are derived from this list so they can never drift apart.
_BANDS = [
    (2, "hapax(1)"),          # band 1: count 1
    (10, "rare(2-9)"),        # band 2
    (100, "uncommon(10-99)"),  # band 3
    (1000, "common(100-999)"),  # band 4
    (None, "very-common(1000+)"),  # band 5: 1000+
]
BAND_RULE = "log10-orders: " + ", ".join(
    f"{i}={label}" for i, (_upper, label) in enumerate(_BANDS, 1)
)


def freq_band(count):
    for i, (upper, _label) in enumerate(_BANDS, 1):
        if upper is None or count < upper:
            return i
    return len(_BANDS)


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    # Parse _8.csv (count,lemma(IAST),pos), aggregating directly into `agg`:
    # rows whose normalized SLP1 key collides (homonym indices, POS variants)
    # sum into the form's total corpus frequency.
    agg = {}
    parsed = 0
    skipped = 0
    dropped = 0
    dropped_samples = []
    with open(SRC, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            parts = line.split(",", 2)
            if len(parts) < 2:
                skipped += 1
                continue
            try:
                count = int(parts[0])
            except ValueError:
                skipped += 1
                continue
            if count <= 0:  # corrupt non-positive frequency — not a real attestation
                skipped += 1
                continue
            lemma_iast = parts[1].strip()
            slp1 = normalize_slp1(iast_to_slp1(lemma_iast))
            if not slp1:
                skipped += 1
                continue
            # Validation gate: reject anything that is not pure SLP1 (stray
            # diacritics or source mojibake) before it can enter the contract.
            if not SLP1_KEY_RE.match(slp1):
                dropped += 1
                if len(dropped_samples) < 20:
                    dropped_samples.append((lemma_iast, slp1))
                continue
            agg[slp1] = agg.get(slp1, 0) + count
            parsed += 1

    print(f"Parsed {parsed:,} rows into {len(agg):,} unique keys, "
          f"skipped {skipped} malformed rows, dropped {dropped} non-SLP1 keys")
    for lemma_iast, slp1 in dropped_samples:
        print(f"  dropped non-SLP1: {lemma_iast!r} -> {slp1!r}")

    if not agg:
        sys.exit(
            f"ERROR: parsed 0 usable lemmas from {SRC!r}. Is the source present "
            "(Git LFS pulled, split parts reassembled) and non-empty? Refusing "
            "to overwrite the committed contract with an empty file."
        )

    # Build lemma map sorted by key. `attested` is a REQUIRED contract field
    # (csl-atlas reads it and its test asserts attested===true). It is always
    # True here because this generator only emits corpus-attested lemmas; the
    # field exists so a future version can add attested:false rows for
    # dictionary-only lemmas with no corpus hit. Do not "optimize" it away.
    lemmas = {}
    band_counts = [0] * 5
    for norm in sorted(agg):
        b = freq_band(agg[norm])
        lemmas[norm] = {"freqBand": b, "attested": True}
        band_counts[b - 1] += 1

    print(f"Band distribution: {dict(enumerate(band_counts, 1))}")

    # Verify anchor lemmas from the contract — fail loudly if any is missing.
    for anchor in CONTRACT_ANCHORS:
        print(f"  anchor {anchor!r}: {lemmas.get(anchor)}")
    missing = [a for a in CONTRACT_ANCHORS if a not in lemmas]
    if missing:
        sys.exit(f"ERROR: contract anchor lemmas missing from output: {missing}")

    # Invariant: every emitted key must be well-formed SLP1. The parse-time gate
    # should guarantee this; assert it so a future regression cannot ship.
    bad_keys = [k for k in lemmas if not SLP1_KEY_RE.match(k)]
    assert not bad_keys, f"non-SLP1 keys leaked into output: {bad_keys[:10]}"

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

    size_kb = os.path.getsize(OUT) / 1024
    print(f"\nWrote {OUT}: {len(lemmas):,} lemmas, {size_kb:.0f} KB")


if __name__ == "__main__":
    main()
