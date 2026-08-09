"""test_learner_contracts.py — acceptance tests for the v1 learner-contract payloads (H2481).

Checks: schema validation, ID uniqueness, reference closure, SHA-256 vs manifest, record counts.
Usage: python src/DCS-data-2026/test_learner_contracts.py
Exit 0 = all pass; exit 1 = failures.
"""
import hashlib
import json
import sys
from pathlib import Path

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

import jsonschema

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
CONTRACTS = REPO / "visual" / "contracts" / "v1"
SCHEMAS = CONTRACTS / "schemas"

VERB = CONTRACTS / "verb-trainer.json"
NOMINAL = CONTRACTS / "nominal-trainer.json"
CONC = CONTRACTS / "concordance-passage.json"
MANIFEST = CONTRACTS / "manifest.json"

failures = []


def fail(msg):
    failures.append(msg)
    print(f"  FAIL {msg}")


def ok(msg):
    print(f"  ok   {msg}")


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


# -- 1. Schema validation -------------------------------------------------------
print("1. Schema validation...")
pairs = [
    (VERB, SCHEMAS / "verb-trainer.schema.json"),
    (NOMINAL, SCHEMAS / "nominal-trainer.schema.json"),
    (CONC, SCHEMAS / "concordance-passage.schema.json"),
    (MANIFEST, SCHEMAS / "manifest.schema.json"),
]
for payload, schema_path in pairs:
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    data = json.loads(payload.read_text(encoding="utf-8"))
    errs = list(jsonschema.Draft7Validator(schema).iter_errors(data))
    if errs:
        for e in errs[:3]:
            fail(f"schema {payload.name}: {list(e.path)}: {e.message}")
    else:
        ok(f"{payload.name} passes schema")

# -- 2. ID uniqueness -----------------------------------------------------------
print("2. ID uniqueness...")
verb_data = json.loads(VERB.read_text(encoding="utf-8"))
cell_ids = [c["cellId"] for r in verb_data["roots"] for c in r["cells"]]
if len(cell_ids) != len(set(cell_ids)):
    dupes = [x for x in set(cell_ids) if cell_ids.count(x) > 1]
    fail(f"verb-trainer: {len(dupes)} duplicate cellIds: {dupes[:3]}")
else:
    ok(f"verb-trainer: {len(cell_ids)} unique cellIds")

nom_data = json.loads(NOMINAL.read_text(encoding="utf-8"))
nom_cell_ids = [c["cellId"] for l in nom_data["lemmas"] for c in l["cells"]]
if len(nom_cell_ids) != len(set(nom_cell_ids)):
    dupes = [x for x in set(nom_cell_ids) if nom_cell_ids.count(x) > 1]
    fail(f"nominal-trainer: {len(dupes)} duplicate cellIds: {dupes[:3]}")
else:
    ok(f"nominal-trainer: {len(nom_cell_ids)} unique cellIds")

conc_data = json.loads(CONC.read_text(encoding="utf-8"))
passage_ids = [p["passageId"] for p in conc_data["passages"]]
if len(passage_ids) != len(set(passage_ids)):
    fail("concordance-passage: duplicate passageIds")
else:
    ok(f"concordance-passage: {len(passage_ids)} unique passageIds")

# -- 3. Reference closure (links → passages) ------------------------------------
print("3. Reference closure...")
passage_id_set = set(passage_ids)
bad_refs = [lnk["passageId"] for lnk in conc_data["links"] if lnk["passageId"] not in passage_id_set]
if bad_refs:
    fail(f"concordance-passage: {len(bad_refs)} links reference unknown passageIds: {bad_refs[:3]}")
else:
    ok(f"concordance-passage: all {len(conc_data['links'])} links resolve to known passages")

# -- 4. SHA-256 vs manifest -----------------------------------------------------
print("4. SHA-256 hashes vs manifest...")
mf = json.loads(MANIFEST.read_text(encoding="utf-8"))
for rel_path, expected_hash in mf["sha256"].items():
    actual = sha256(REPO / rel_path)
    if actual != expected_hash:
        fail(f"manifest sha256 mismatch: {rel_path}\n    expected {expected_hash}\n    got      {actual}")
    else:
        ok(f"{Path(rel_path).name}: sha256 ok")

# -- 5. Record counts vs manifest -----------------------------------------------
print("5. Record counts vs manifest...")
for rel_path, expected_count in mf["recordCount"].items():
    obj = json.loads((REPO / rel_path).read_text(encoding="utf-8"))
    actual = (obj.get("rootCount") or obj.get("lemmaCount") or obj.get("passageCount"))
    if actual != expected_count:
        fail(f"manifest recordCount mismatch {rel_path}: expected {expected_count} got {actual}")
    else:
        ok(f"{Path(rel_path).name}: recordCount {actual} ok")

# -- 6. contractVersion present everywhere -------------------------------------
print("6. contractVersion field...")
for payload in [VERB, NOMINAL, CONC, MANIFEST]:
    obj = json.loads(payload.read_text(encoding="utf-8"))
    cv = obj.get("contractVersion")
    if cv != "1.0.0":
        fail(f"{payload.name}: contractVersion expected '1.0.0', got {cv!r}")
    else:
        ok(f"{payload.name}: contractVersion={cv!r}")

print()
if failures:
    print(f"FAIL — {len(failures)} failure(s).")
    sys.exit(1)
else:
    print("PASS — all checks passed.")
