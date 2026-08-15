"""h2499_dual_run_rebuild.py — independent Grok rebuild of v1 learner contracts.

Does NOT write to visual/contracts/v1/. Two packager runs go to a scratch
directory; hashes, source-pin parity and published-#110 byte diffs are printed
as JSON + a human table. Linguistic facts in the four H2481 source pins are
not recomputed.

Usage:
    python src/DCS-data-2026/h2499_dual_run_rebuild.py
    python src/DCS-data-2026/h2499_dual_run_rebuild.py --scratch DIR
"""
from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
VISUAL = REPO / "visual"
PUBLISHED = VISUAL / "contracts" / "v1"

sys.path.insert(0, str(HERE))
from build_learner_contracts import (  # noqa: E402
    ATTESTED_JSON,
    CONC_JS,
    NOMINAL_JSON,
    PASSAGE_JSON,
    load_conc_data,
    pack_concordance,
    pack_nominal,
    pack_verb,
    write_json,
)
from contract_ids import nominal_cell_id, passage_id, verb_cell_id  # noqa: E402

PAYLOADS = ("verb-trainer.json", "nominal-trainer.json", "concordance-passage.json")


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return sha256_bytes(path.read_bytes())


def source_sha(path: Path) -> str:
    return sha256_file(path)


def independent_verb_parity(attested: dict, packed: dict) -> list[str]:
    """Walk paradigm_attested independently; do not trust pack_verb counts."""
    errors: list[str] = []
    src_roots = attested["roots"]
    if packed["rootCount"] != len(src_roots):
        errors.append(
            f"verb rootCount {packed['rootCount']} != source {len(src_roots)}"
        )
    if packed["tierBoundary"] != attested.get("tierBoundary", 100):
        errors.append("verb tierBoundary drifted from source")
    if packed["frequencyFloor"] != attested.get("frequencyFloor", 2):
        errors.append("verb frequencyFloor drifted from source")
    packed_by_id = {r["rootId"]: r for r in packed["roots"]}
    if set(packed_by_id) != set(src_roots):
        missing = set(src_roots) - set(packed_by_id)
        extra = set(packed_by_id) - set(src_roots)
        errors.append(
            f"verb root-id set mismatch missing={len(missing)} extra={len(extra)}"
        )
        return errors
    for root_id, src in src_roots.items():
        out = packed_by_id[root_id]
        for field in ("rank", "tier", "totalTokens"):
            if out[field] != src[field]:
                errors.append(f"verb {root_id}.{field}: {out[field]!r} != {src[field]!r}")
        expected_cells: dict[str, dict] = {}
        for cat, by_num in src.get("finite", {}).items():
            for num, by_person in by_num.items():
                for person, forms in by_person.items():
                    if not forms:
                        continue
                    cid = verb_cell_id(root_id, cat, num, person)
                    expected_cells[cid] = {
                        "kind": "finite",
                        "category": cat,
                        "number": num,
                        "person": person,
                        "totalTokens": sum(c for c, _ in forms),
                        "forms": forms,
                    }
        for cat, forms in src.get("nonfinite", {}).items():
            if not forms:
                continue
            cid = verb_cell_id(root_id, cat)
            expected_cells[cid] = {
                "kind": "nonfinite",
                "category": cat,
                "number": None,
                "person": None,
                "totalTokens": sum(c for c, _ in forms),
                "forms": forms,
            }
        got_cells = {c["cellId"]: c for c in out["cells"]}
        if set(got_cells) != set(expected_cells):
            errors.append(
                f"verb {root_id} cell-id set mismatch "
                f"src={len(expected_cells)} packed={len(got_cells)}"
            )
            continue
        for cid, exp in expected_cells.items():
            got = got_cells[cid]
            for field in ("kind", "category", "number", "person", "totalTokens"):
                if got[field] != exp[field]:
                    errors.append(
                        f"verb {cid}.{field}: {got[field]!r} != {exp[field]!r}"
                    )
            if got["forms"] != exp["forms"]:
                errors.append(f"verb {cid}.forms drifted from source")
    return errors


def independent_nominal_parity(nominal: dict, packed: dict) -> list[str]:
    errors: list[str] = []
    src_lemmas = nominal["lemmas"]
    if packed["lemmaCount"] != len(src_lemmas):
        errors.append(
            f"nominal lemmaCount {packed['lemmaCount']} != source {len(src_lemmas)}"
        )
    packed_by_id = {row["lemmaId"]: row for row in packed["lemmas"]}
    if set(packed_by_id) != set(src_lemmas):
        missing = set(src_lemmas) - set(packed_by_id)
        extra = set(packed_by_id) - set(src_lemmas)
        errors.append(
            f"nominal lemma-id set mismatch missing={len(missing)} extra={len(extra)}"
        )
        return errors
    for lemma_id, src in src_lemmas.items():
        out = packed_by_id[lemma_id]
        for field in (
            "lemma",
            "domGender",
            "stemFinal",
            "tokens",
            "cellsAttested",
            "rank",
            "tier",
        ):
            if out[field] != src[field]:
                errors.append(
                    f"nominal {lemma_id}.{field}: {out[field]!r} != {src[field]!r}"
                )
        expected: dict[str, list] = {}
        for cell_name, forms in src.get("cells", {}).items():
            if not forms:
                continue
            expected[nominal_cell_id(lemma_id, cell_name)] = forms
        got = {c["cellId"]: c for c in out["cells"]}
        if set(got) != set(expected):
            errors.append(
                f"nominal {lemma_id} cell-id set mismatch "
                f"src={len(expected)} packed={len(got)}"
            )
            continue
        for cid, forms in expected.items():
            if got[cid]["forms"] != forms:
                errors.append(f"nominal {cid}.forms drifted from source")
    return errors


def independent_concordance_parity(conc: dict, passages: list, packed: dict) -> list[str]:
    errors: list[str] = []
    if packed["passageCount"] != len(passages):
        errors.append(
            f"passageCount {packed['passageCount']} != source {len(passages)}"
        )
    src_ids = {p["id"] for p in passages}
    packed_ids = {p["sourceId"] for p in packed["passages"]}
    if src_ids != packed_ids:
        errors.append(
            f"passage sourceId set mismatch src={len(src_ids)} packed={len(packed_ids)}"
        )
    expected_ids = {passage_id(p["title"], p["id"]) for p in passages}
    got_ids = {p["passageId"] for p in packed["passages"]}
    if expected_ids != got_ids:
        errors.append("passageId grammar mismatch vs contract_ids.passage_id")
    # Independent citation prefix-match — same rule as pack_concordance, re-derived.
    import re

    trailing = re.compile(r"^(.+):\s*\d+$")
    prefix_idx: dict[str, list] = {}
    for p in passages:
        src = p["src"]
        m = trailing.match(src)
        prefix = m.group(1).strip() if m else src.strip()
        prefix_idx.setdefault(prefix, []).append(p)
    expected_links = 0
    expected_resolved = 0
    expected_unresolved = 0
    resolved_passage_ids: set = set()
    for _form, (_total, examples) in conc["forms"].items():
        for ex in examples:
            cite = ex[0]
            if cite in prefix_idx:
                expected_resolved += 1
                expected_links += len(prefix_idx[cite])
                for pentry in prefix_idx[cite]:
                    resolved_passage_ids.add(pentry["id"])
            else:
                expected_unresolved += 1
    if len(packed["links"]) != expected_links:
        errors.append(
            f"link count {len(packed['links'])} != independent {expected_links}"
        )
    u = packed["unresolved"]
    if u["resolvedCitations"] != expected_resolved:
        errors.append(
            f"resolvedCitations {u['resolvedCitations']} != independent {expected_resolved}"
        )
    if u["unresolvedCitations"] != expected_unresolved:
        errors.append(
            f"unresolvedCitations {u['unresolvedCitations']} != independent {expected_unresolved}"
        )
    expected_zero = sorted(p["id"] for p in passages if p["id"] not in resolved_passage_ids)
    if u["passagesWithZeroLinks"] != expected_zero:
        errors.append(
            f"zero-link passages {u['passagesWithZeroLinks']} != independent {expected_zero}"
        )
    bad_refs = [
        lnk["passageId"]
        for lnk in packed["links"]
        if lnk["passageId"] not in got_ids
    ]
    if bad_refs:
        errors.append(f"{len(bad_refs)} links fail reference closure")
    return errors


def dump_payloads(scratch: Path, verb, nominal, conc) -> dict[str, Path]:
    scratch.mkdir(parents=True, exist_ok=True)
    paths = {
        "verb-trainer.json": scratch / "verb-trainer.json",
        "nominal-trainer.json": scratch / "nominal-trainer.json",
        "concordance-passage.json": scratch / "concordance-passage.json",
    }
    write_json(paths["verb-trainer.json"], verb)
    write_json(paths["nominal-trainer.json"], nominal)
    write_json(paths["concordance-passage.json"], conc)
    return paths


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--scratch",
        type=Path,
        default=Path(r"C:\Users\user\AppData\Local\Temp\h2499-rebuild"),
        help="scratch directory for two rebuilds (never visual/contracts/v1/)",
    )
    args = ap.parse_args()
    scratch = args.scratch.resolve()
    run_a = scratch / "run-a"
    run_b = scratch / "run-b"

    print("Loading four H2481 source pins...", flush=True)
    attested = json.loads(ATTESTED_JSON.read_text(encoding="utf-8"))
    nominal_src = json.loads(NOMINAL_JSON.read_text(encoding="utf-8"))
    conc_src = load_conc_data(CONC_JS)
    passages = json.loads(PASSAGE_JSON.read_text(encoding="utf-8"))

    pins = {
        "paradigm_attested": {
            "path": str(ATTESTED_JSON.relative_to(REPO).as_posix()),
            "sha256": source_sha(ATTESTED_JSON),
            "bytes": ATTESTED_JSON.stat().st_size,
            "schemaVersion": attested.get("schemaVersion"),
            "corpusRelease": attested.get("corpusRelease"),
            "generatedBy": attested.get("generatedBy"),
            "rootCount": len(attested["roots"]),
        },
        "paradigm_nominal_lemmas": {
            "path": str(NOMINAL_JSON.relative_to(REPO).as_posix()),
            "sha256": source_sha(NOMINAL_JSON),
            "bytes": NOMINAL_JSON.stat().st_size,
            "corpusRelease": nominal_src.get("corpusRelease"),
            "generatedBy": nominal_src.get("generatedBy"),
            "lemmaCount": len(nominal_src["lemmas"]),
        },
        "conc_data": {
            "path": str(CONC_JS.relative_to(REPO).as_posix()),
            "sha256": source_sha(CONC_JS),
            "bytes": CONC_JS.stat().st_size,
            "generatedBy": conc_src.get("generatedBy"),
            "formCount": conc_src.get("formCount"),
        },
        "passage_library": {
            "path": str(PASSAGE_JSON.relative_to(REPO).as_posix()),
            "sha256": source_sha(PASSAGE_JSON),
            "bytes": PASSAGE_JSON.stat().st_size,
            "passageCount": len(passages),
        },
    }

    print("Pack run A...", flush=True)
    verb_a = pack_verb(attested)
    nom_a = pack_nominal(nominal_src)
    conc_a = pack_concordance(conc_src, passages)
    paths_a = dump_payloads(run_a, verb_a, nom_a, conc_a)

    print("Pack run B...", flush=True)
    verb_b = pack_verb(attested)
    nom_b = pack_nominal(nominal_src)
    conc_b = pack_concordance(conc_src, passages)
    paths_b = dump_payloads(run_b, verb_b, nom_b, conc_b)

    hash_table = []
    two_run_match = True
    vs_published = {}
    for name in PAYLOADS:
        ha = sha256_file(paths_a[name])
        hb = sha256_file(paths_b[name])
        pub = PUBLISHED / name
        hp = sha256_file(pub) if pub.exists() else None
        row = {
            "file": name,
            "run_a_sha256": ha,
            "run_b_sha256": hb,
            "run_a_bytes": paths_a[name].stat().st_size,
            "run_b_bytes": paths_b[name].stat().st_size,
            "two_runs_identical": ha == hb,
            "published_sha256": hp,
            "published_bytes": pub.stat().st_size if pub.exists() else None,
            "rebuild_vs_published_identical": ha == hp,
        }
        hash_table.append(row)
        if ha != hb:
            two_run_match = False
        vs_published[name] = ha == hp
        print(
            f"  {name}: a={ha[:16]} b={hb[:16]} pub={str(hp)[:16] if hp else None} "
            f"a==b={ha == hb} a==pub={ha == hp}",
            flush=True,
        )

    print("Independent source-pin parity...", flush=True)
    parity_errors = []
    parity_errors.extend(independent_verb_parity(attested, verb_a))
    parity_errors.extend(independent_nominal_parity(nominal_src, nom_a))
    parity_errors.extend(independent_concordance_parity(conc_src, passages, conc_a))
    # Cap printed errors; keep full count.
    print(f"  parity errors: {len(parity_errors)}", flush=True)
    for err in parity_errors[:20]:
        print(f"    {err}")

    published_manifest = json.loads((PUBLISHED / "manifest.json").read_text(encoding="utf-8"))
    result = {
        "handoff": "H2499",
        "lane": "Grok 4.6 (grok-4.6)",
        "override_lane": "Claude Sonnet 5 (claude-sonnet-5) / VisualDCS #110",
        "scratch": str(scratch),
        "published_dir": str(PUBLISHED),
        "published_releaseId": published_manifest.get("releaseId"),
        "source_pins": pins,
        "hash_table": hash_table,
        "two_rebuilds_match": two_run_match,
        "rebuild_vs_published": vs_published,
        "empty_delta_keep_110": two_run_match and all(vs_published.values()),
        "parity_error_count": len(parity_errors),
        "parity_errors_head": parity_errors[:20],
        "packed_counts": {
            "verb_roots": verb_a["rootCount"],
            "nominal_lemmas": nom_a["lemmaCount"],
            "passages": conc_a["passageCount"],
            "links": len(conc_a["links"]),
            "resolvedCitations": conc_a["unresolved"]["resolvedCitations"],
            "unresolvedCitations": conc_a["unresolved"]["unresolvedCitations"],
            "zeroLinkPassages": conc_a["unresolved"]["passagesWithZeroLinks"],
        },
    }
    out_json = scratch / "h2499_rebuild_result.json"
    out_json.write_text(
        json.dumps(result, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(f"Wrote {out_json}", flush=True)
    if not two_run_match or parity_errors or not all(vs_published.values()):
        print("RESULT: DELTA_OR_FAIL", flush=True)
        return 1
    print("RESULT: EMPTY_DELTA_KEEP_110", flush=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
