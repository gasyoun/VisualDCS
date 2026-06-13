"""Validate dcs_lemma_summary.json against the csl-atlas consumption contract.

Checks the COMMITTED artifact only — no DCS corpus / Git LFS source needed — so
CI can gate every change to the file or its generator. Mirrors the contract in
csl-atlas docs/VISUALDCS_CONSUMPTION_CONTRACT.md:

  - valid UTF-8 JSON, no BOM, <= ~10 MB
  - required top-level fields present; lemmaCount (if present) == #lemmas
  - every key is a normalized SLP1 headword ([A-Za-z]+ — case-preserved)
  - every record: freqBand int 1..5 (required), attested bool (required),
    formCount int (optional), firstAttestationEra in the era enum (optional)
  - all contract anchor lemmas resolve

Usage:  python validate_dcs_lemma_summary.py [path]   (default: dcs_lemma_summary.json)
Exits 0 when valid, 1 (with a list of violations) otherwise.
"""

import json
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

PATH = sys.argv[1] if len(sys.argv) > 1 else "dcs_lemma_summary.json"
ANCHORS = ("gam", "Darma", "rAma", "iti", "boDisattva")
ERA_ENUM = {"vedic", "epic", "classical", "late", "unknown"}
KEY_RE = re.compile(r"[A-Za-z]+\Z")
MAX_BYTES = 10 * 1024 * 1024  # contract size budget: ~10 MB uncompressed


def _is_int(x):
    # bool is a subclass of int; the contract means a true integer.
    return isinstance(x, int) and not isinstance(x, bool)


def main():
    errors = []

    with open(PATH, "rb") as fh:
        data_bytes = fh.read()
    if data_bytes[:3] == b"\xef\xbb\xbf":
        errors.append("file begins with a UTF-8 BOM (contract requires no BOM)")
    if len(data_bytes) > MAX_BYTES:
        errors.append(f"file is {len(data_bytes)/1e6:.1f} MB, over the ~10 MB contract budget")

    try:
        data = json.loads(data_bytes.decode("utf-8"))
    except (UnicodeDecodeError, json.JSONDecodeError) as e:
        sys.exit(f"FAIL: {PATH} is not valid UTF-8 JSON: {e}")

    for field in ("schemaVersion", "generatedBy", "corpusRelease", "generatedAt", "lemmas"):
        if field not in data:
            errors.append(f"missing required top-level field {field!r}")

    lemmas = data.get("lemmas")
    if not isinstance(lemmas, dict):
        sys.exit("FAIL: 'lemmas' is missing or not an object")

    if "lemmaCount" in data and data["lemmaCount"] != len(lemmas):
        errors.append(f"lemmaCount {data['lemmaCount']} != actual lemma count {len(lemmas)}")

    bad_keys = []
    bad_records = []
    for k, v in lemmas.items():
        if not KEY_RE.match(k):
            bad_keys.append(k)
        if not isinstance(v, dict):
            bad_records.append((k, "record is not an object"))
            continue
        fb = v.get("freqBand")
        if not _is_int(fb) or not (1 <= fb <= 5):
            bad_records.append((k, f"freqBand={fb!r} is not an int in 1..5"))
        if not isinstance(v.get("attested"), bool):
            bad_records.append((k, f"attested={v.get('attested')!r} is not a bool"))
        if "formCount" in v and not _is_int(v["formCount"]):
            bad_records.append((k, f"formCount={v['formCount']!r} is not an int"))
        if "firstAttestationEra" in v and v["firstAttestationEra"] not in ERA_ENUM:
            bad_records.append((k, f"firstAttestationEra={v['firstAttestationEra']!r} not in {sorted(ERA_ENUM)}"))

    if bad_keys:
        errors.append(f"{len(bad_keys)} non-SLP1 keys (must match [A-Za-z]+), e.g. {bad_keys[:10]}")
    if bad_records:
        errors.append(f"{len(bad_records)} malformed records, e.g. {bad_records[:5]}")

    missing = [a for a in ANCHORS if a not in lemmas]
    if missing:
        errors.append(f"contract anchor lemmas missing: {missing}")

    if errors:
        print(f"FAIL: {PATH} violates the csl-atlas consumption contract:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)

    print(
        f"OK: {PATH} — {len(lemmas):,} lemmas, {len(data_bytes)/1024:.0f} KB, "
        f"all {len(ANCHORS)} anchors present, all keys SLP1, schema valid."
    )


if __name__ == "__main__":
    main()
