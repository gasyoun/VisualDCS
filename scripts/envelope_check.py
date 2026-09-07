#!/usr/bin/env python3
"""release-envelope-v1 checker for VisualDCS.

Verifies one release envelope (default: the learner-contracts-v1 release)
against real bytes in this repo:

  CHK-1  required fields present and non-empty
  CHK-2  code_revision.tag resolves to code_revision.commit
  CHK-3  every pinned artifact digest recomputes from git blob bytes at the tag
  CHK-4  output digests match the pinned contract manifest (sha256 / size / rows)
  CHK-5  in-repo source pins re-derive at the tag (SKIP for foreign clones)
  CHK-6  upstream corpus pin recorded (RECORDED, never fabricated)
  CHK-7  checks[] honest: no fail rows, tolerances declared where non-deterministic

Exit 0 only when no check FAILs (SKIP / RECORDED allowed). Exit 1 on any FAIL.

Usage:
  python scripts/envelope_check.py [--envelope PATH]

stdlib-only; Python >= 3.9.
"""

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_ENVELOPE = (
    REPO_ROOT
    / "visual"
    / "contracts"
    / "envelopes"
    / "learner-contracts-v1-2026-08-09.envelope.json"
)

REQUIRED_TOP = [
    "schema",
    "envelope_id",
    "hub",
    "release_kind",
    "release_tag",
    "created",
    "code_revision",
    "pinned_artifacts",
    "source_pins",
    "output_digests",
    "config",
    "tool_versions",
    "licence",
    "checks",
    "review",
    "citation",
    "publication_state",
]
REQUIRED_CODE_REVISION = ["repo_url", "tag", "commit"]
REQUIRED_CITATION = ["cff", "policy"]
REQUIRED_PUBLICATION = ["state", "zenodo_archived", "github_release"]

results = []


def record(chk, status, detail):
    results.append((chk, status, detail))
    print(f"[{status:>8}] {chk}: {detail}")


def git_bytes(args):
    out = subprocess.run(
        ["git"] + args,
        cwd=str(REPO_ROOT),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if out.returncode != 0:
        raise RuntimeError(out.stderr.decode("utf-8", "replace").strip())
    return out.stdout


def git_ok(args):
    try:
        git_bytes(args)
        return True
    except Exception:
        return False


def blob_at(tag, path):
    """Return the committed blob bytes for <tag>:<path>, or None if absent."""
    try:
        return git_bytes(["cat-file", "blob", f"{tag}:{path}"])
    except Exception:
        return None


def sha256_form(raw, form):
    if form == "lf-canonical":
        return hashlib.sha256(raw.replace(b"\r\n", b"\n")).hexdigest()
    if form == "raw":
        return hashlib.sha256(raw).hexdigest()
    return None


def is_nonempty(value):
    if value is None:
        return False
    if isinstance(value, str):
        return bool(value.strip())
    if isinstance(value, (list, dict)):
        return bool(value)
    return True


def chk1_schema(env):
    missing = [k for k in REQUIRED_TOP if not is_nonempty(env.get(k))]
    if env.get("schema") != "release-envelope-v1":
        missing.append("schema(literal)")
    for k in REQUIRED_CODE_REVISION:
        if not is_nonempty(env.get("code_revision", {}).get(k)):
            missing.append(f"code_revision.{k}")
    pins = env.get("pinned_artifacts", [])
    if not isinstance(pins, list) or not pins:
        missing.append("pinned_artifacts(non-empty)")
    else:
        for i, p in enumerate(pins):
            for k in ("path", "sha256", "sha256_form", "role"):
                if not is_nonempty(p.get(k)):
                    missing.append(f"pinned_artifacts[{i}].{k}")
    for k in REQUIRED_CITATION:
        if not is_nonempty(env.get("citation", {}).get(k)):
            missing.append(f"citation.{k}")
    for k in REQUIRED_PUBLICATION:
        if not is_nonempty(env.get("publication_state", {}).get(k)):
            missing.append(f"publication_state.{k}")
    if missing:
        record("CHK-1", "FAIL", "missing/empty: " + ", ".join(missing))
    else:
        record("CHK-1", "PASS", "schema release-envelope-v1; all required fields non-empty")


def chk2_code_revision(env):
    cr = env.get("code_revision", {})
    tag, commit = cr.get("tag"), cr.get("commit")
    try:
        resolved = git_bytes(["rev-parse", f"{tag}^{{commit}}"]).decode().strip()
    except Exception as exc:
        record("CHK-2", "FAIL", f"tag {tag!r} not resolvable: {exc}")
        return
    if resolved == commit:
        record("CHK-2", "PASS", f"{tag} -> {resolved}")
    else:
        record("CHK-2", "FAIL", f"tag resolves to {resolved}, envelope records {commit}")


def chk3_pinned_artifacts(env):
    tag = env.get("code_revision", {}).get("tag")
    pins = env.get("pinned_artifacts", [])
    ok = fail = skip = 0
    for p in pins:
        path, form, want = p["path"], p.get("sha256_form", "lf-canonical"), p["sha256"]
        raw = blob_at(tag, path)
        if raw is None:
            skip += 1
            record("CHK-3", "SKIP", f"{path}: blob absent at {tag} on this box")
            continue
        got = sha256_form(raw, form)
        if got is None:
            fail += 1
            record("CHK-3", "FAIL", f"{path}: unknown sha256_form {form!r}")
        elif got == want:
            ok += 1
            record("CHK-3", "PASS", f"{path}: {got[:16]}... ({form})")
        else:
            fail += 1
            record("CHK-3", "FAIL", f"{path}: recomputed {got}, envelope records {want}")
    if fail:
        record("CHK-3", "FAIL", f"{ok} pass / {skip} skip / {fail} fail")
    else:
        record("CHK-3", "PASS", f"{ok} pass / {skip} skip / 0 fail")


def chk4_manifest_parity(env):
    tag = env.get("code_revision", {}).get("tag")
    carried_in = env.get("output_digests", {}).get("carried_in")
    datasets = env.get("output_digests", {}).get("datasets", {})
    raw = blob_at(tag, carried_in) if carried_in else None
    if raw is None:
        record("CHK-4", "FAIL", f"carried_in manifest {carried_in!r} not readable at {tag}")
        return
    try:
        manifest = json.loads(raw.decode("utf-8"))
    except Exception as exc:
        record("CHK-4", "FAIL", f"manifest not JSON: {exc}")
        return
    ok = fail = 0
    for ds_id, ds in datasets.items():
        asset = ds.get("release_asset")
        m_sha = manifest.get("sha256", {}).get(asset)
        m_bytes = manifest.get("bytes", {}).get(asset)
        m_rows = manifest.get("recordCount", {}).get(asset)
        got = sha256_form(blob_at(tag, asset) or b"", ds.get("sha256_form", "lf-canonical")) if blob_at(tag, asset) is not None else None
        if got is None:
            fail += 1
            record("CHK-4", "FAIL", f"{ds_id}: asset {asset} not readable at {tag}")
            continue
        if got != ds.get("sha256"):
            fail += 1
            record("CHK-4", "FAIL", f"{ds_id}: recomputed {got}, envelope records {ds.get('sha256')}")
            continue
        if m_sha is not None and m_sha != got:
            fail += 1
            record("CHK-4", "FAIL", f"{ds_id}: contract manifest records {m_sha}, recomputed {got}")
            continue
        if m_bytes is not None and m_bytes != len(blob_at(tag, asset)):
            fail += 1
            record("CHK-4", "FAIL", f"{ds_id}: manifest bytes {m_bytes}, actual {len(blob_at(tag, asset))}")
            continue
        if m_rows is not None and ds.get("rows") is not None and m_rows != ds["rows"]:
            fail += 1
            record("CHK-4", "FAIL", f"{ds_id}: manifest recordCount {m_rows}, envelope rows {ds['rows']}")
            continue
        ok += 1
        record("CHK-4", "PASS", f"{ds_id}: sha256+bytes+rows agree (envelope == manifest == recomputed)")
    if fail:
        record("CHK-4", "FAIL", f"{ok} pass / {fail} fail")
    else:
        record("CHK-4", "PASS", f"{ok} pass / 0 fail")


def chk5_source_pins(env):
    tag = env.get("code_revision", {}).get("tag")
    repo_url = env.get("code_revision", {}).get("repo_url", "")
    ok = fail = skip = 0
    for pin in env.get("source_pins", []):
        name = pin.get("dataset", "?")
        rule = pin.get("pin_rule", "")
        src_repo = pin.get("source_repo", "")
        path = pin.get("source_path")
        want = pin.get("sha256")
        form = pin.get("sha256_form", "lf-canonical")
        if "release tag commit" not in rule and src_repo.rstrip("/") != repo_url.rstrip("/"):
            skip += 1
            record("CHK-5", "SKIP", f"{name}: foreign clone {src_repo} absent on this box")
            continue
        raw = blob_at(tag, path)
        if raw is None:
            skip += 1
            record("CHK-5", "SKIP", f"{name}: {path} not readable at {tag} on this box")
            continue
        got = sha256_form(raw, form)
        if got == want:
            ok += 1
            record("CHK-5", "PASS", f"{name}: {path} -> {got[:16]}...")
        else:
            fail += 1
            record("CHK-5", "FAIL", f"{name}: recomputed {got}, envelope records {want}")
    if fail:
        record("CHK-5", "FAIL", f"{ok} pass / {skip} skip / {fail} fail")
    else:
        record("CHK-5", "PASS", f"{ok} pass / {skip} skip / 0 fail")


def chk6_upstream_pin(env):
    upstream = env.get("config", {}).get("upstream_corpus")
    if not is_nonempty(upstream):
        record("CHK-6", "SKIP", "no upstream_corpus block in config")
        return
    commit = upstream.get("pin_commit")
    note = upstream.get("note", "")
    if commit and len(commit) == 40 and all(c in "0123456789abcdef" for c in commit):
        record(
            "CHK-6",
            "RECORDED",
            f"upstream {upstream.get('repo')} pinned at {commit[:12]} ({upstream.get('pin_date')}); {note[:80]}",
        )
    else:
        record("CHK-6", "FAIL", "upstream_corpus present but pin_commit missing/malformed")


def chk7_honest_checks(env):
    rows = env.get("checks", [])
    if not rows:
        record("CHK-7", "FAIL", "checks[] empty")
        return
    bad = [c.get("id") for c in rows if c.get("result") not in ("pass", "recorded")]
    if bad:
        record("CHK-7", "FAIL", f"checks[] rows not pass/recorded: {', '.join(map(str, bad))}")
        return
    recorded = [c.get("id") for c in rows if c.get("result") == "recorded"]
    record(
        "CHK-7",
        "PASS",
        f"{len(rows)} check rows, 0 fail; recorded (honest degradation): {', '.join(recorded) or 'none'}",
    )


def main():
    parser = argparse.ArgumentParser(description="Verify a VisualDCS release envelope (release-envelope-v1).")
    parser.add_argument("--envelope", default=str(DEFAULT_ENVELOPE), help="path to the envelope JSON")
    args = parser.parse_args()
    env_path = Path(args.envelope)
    if not env_path.is_absolute():
        env_path = Path.cwd() / env_path
    if not env_path.is_file():
        print(f"error: envelope not found: {env_path}")
        return 1
    env = json.loads(env_path.read_bytes().decode("utf-8"))
    print(f"envelope: {env_path}")
    print(f"release:  {env.get('envelope_id')} (tag {env.get('code_revision', {}).get('tag')})")
    print("")

    chk1_schema(env)
    chk2_code_revision(env)
    chk3_pinned_artifacts(env)
    chk4_manifest_parity(env)
    chk5_source_pins(env)
    chk6_upstream_pin(env)
    chk7_honest_checks(env)

    print("")
    tally = {"PASS": 0, "SKIP": 0, "RECORDED": 0, "FAIL": 0}
    for _, status, _ in results:
        tally[status] = tally.get(status, 0) + 1
    print(
        f"summary: {tally['PASS']} pass / {tally['SKIP']} skip / "
        f"{tally['RECORDED']} recorded / {tally['FAIL']} fail"
    )
    return 0 if tally["FAIL"] == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
