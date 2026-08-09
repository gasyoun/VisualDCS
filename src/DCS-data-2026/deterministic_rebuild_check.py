"""deterministic_rebuild_check.py — verify two sequential builds of the v1 contracts are byte-identical (manifest excluded)."""
import hashlib
import json
import subprocess
import sys
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

REPO = Path(__file__).resolve().parents[2]
CONTRACTS = REPO / "visual" / "contracts" / "v1"
PAYLOADS = ["verb-trainer.json", "nominal-trainer.json", "concordance-passage.json"]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def snapshot():
    return {f: sha(CONTRACTS / f) for f in PAYLOADS}


print("Pass 1: capturing hashes of existing build...")
before = snapshot()
for f, h in before.items():
    print(f"  {f}: {h[:16]}...")

print("Pass 2: rebuilding...")
result = subprocess.run(
    [sys.executable, "src/DCS-data-2026/build_learner_contracts.py"],
    capture_output=True,
    text=True,
    encoding="utf-8",
    cwd=str(REPO),
)
if result.returncode != 0:
    print("BUILD FAILED:")
    print(result.stdout)
    print(result.stderr)
    sys.exit(1)

after = snapshot()
all_ok = True
for f in PAYLOADS:
    if before[f] == after[f]:
        print(f"  ok  {f}")
    else:
        print(f"  MISMATCH {f}")
        print(f"    before: {before[f]}")
        print(f"    after:  {after[f]}")
        all_ok = False

if all_ok:
    print("PASS — two sequential builds are byte-identical.")
    sys.exit(0)
else:
    print("FAIL — builds differ; check non-determinism in packager.")
    sys.exit(1)
