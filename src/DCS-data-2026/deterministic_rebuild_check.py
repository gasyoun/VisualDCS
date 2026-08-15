"""deterministic_rebuild_check.py — rebuild v1 payloads to scratch and compare to published.

Never writes visual/contracts/v1/. H2499: the previous in-place rebuild could clobber
the published release on a failed or interrupted run.
"""
import hashlib
import subprocess
import sys
import tempfile
from pathlib import Path

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

REPO = Path(__file__).resolve().parents[2]
CONTRACTS = REPO / "visual" / "contracts" / "v1"
PAYLOADS = ["verb-trainer.json", "nominal-trainer.json", "concordance-passage.json"]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


print("Pass 1: capturing hashes of published v1/...")
published = {f: sha(CONTRACTS / f) for f in PAYLOADS}
for f, h in published.items():
    print(f"  {f}: {h[:16]}...")

scratch = Path(tempfile.mkdtemp(prefix="vdcs-v1-rebuild-"))
print(f"Pass 2: rebuilding to scratch {scratch} (published v1/ untouched)...")
result = subprocess.run(
    [sys.executable, "src/DCS-data-2026/build_learner_contracts.py", "--out-dir", str(scratch)],
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

all_ok = True
for f in PAYLOADS:
    rebuilt = sha(scratch / f)
    if published[f] == rebuilt:
        print(f"  ok  {f}")
    else:
        print(f"  MISMATCH {f}")
        print(f"    published: {published[f]}")
        print(f"    rebuilt:   {rebuilt}")
        all_ok = False

if all_ok:
    print("PASS — scratch rebuild is byte-identical to published v1/ (v1/ not written).")
    sys.exit(0)
else:
    print("FAIL — rebuild differs from published v1/; check packager or source-pin drift.")
    sys.exit(1)
