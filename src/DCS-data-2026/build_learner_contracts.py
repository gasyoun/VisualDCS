"""build_learner_contracts.py — VisualDCS v1 learner-contract packager (H2481).

Packages verb-trainer, nominal-trainer and concordance-passage payloads plus a
release manifest with SHA-256 and byte-size checksums.

Usage:
    python src/DCS-data-2026/build_learner_contracts.py          # full build
    python src/DCS-data-2026/build_learner_contracts.py --check  # validate existing files only
    python src/DCS-data-2026/build_learner_contracts.py --verb-only | --nominal-only | --conc-only
"""
import argparse
import hashlib
import json
import re
import sys
from datetime import datetime, timezone
from pathlib import Path

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
VISUAL = REPO / "visual"
CONTRACTS_DIR = VISUAL / "contracts" / "v1"
SCHEMA_DIR = CONTRACTS_DIR / "schemas"
REPORTS_DIR = HERE / "reports"

sys.path.insert(0, str(HERE))
from contract_ids import verb_cell_id, nominal_cell_id, passage_id  # noqa: E402

CONTRACT_VERSION = "1.0.0"

ATTESTED_JSON = VISUAL / "paradigm_attested.json"
NOMINAL_JSON = VISUAL / "paradigm_nominal_lemmas.json"
CONC_JS = VISUAL / "conc_data.js"
PASSAGE_JSON = REPO / "passage_library.json"


# -- I/O helpers ---------------------------------------------------------------

def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def write_json(path: Path, obj) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(obj, ensure_ascii=False, separators=(",", ":"), sort_keys=False),
        encoding="utf-8",
    )


def load_conc_data(path: Path):
    text = path.read_text(encoding="utf-8")
    prefix = "window.CONC_DATA = "
    idx = text.index(prefix) + len(prefix)
    raw = text[idx:].rstrip().rstrip(";")
    return json.loads(raw)


_TRAILING_IDX_RE = re.compile(r"^(.+):\s*\d+$")


def _passage_prefix_index(passages):
    """Citation-prefix → [passage, ...] from passage_library src strings."""
    idx: dict = {}
    for p in passages:
        src = p["src"]
        m = _TRAILING_IDX_RE.match(src)
        prefix = m.group(1).strip() if m else src.strip()
        idx.setdefault(prefix, []).append(p)
    return idx


def validate_payload(path: Path, schema_path: Path) -> list:
    import jsonschema
    schema = json.loads(schema_path.read_text(encoding="utf-8"))
    payload = json.loads(path.read_text(encoding="utf-8"))
    validator = jsonschema.Draft7Validator(schema)
    return [f"{list(e.path)}: {e.message}" for e in validator.iter_errors(payload)]


# -- packagers -----------------------------------------------------------------

def pack_verb(attested_data):
    roots_in = attested_data["roots"]
    cell_evidence = attested_data.get("cellEvidence", {})
    roots_out = []
    for root_id, v in roots_in.items():
        cells = []
        for cat, by_num in v.get("finite", {}).items():
            for num, by_person in by_num.items():
                for person, forms in by_person.items():
                    if not forms:
                        continue
                    cid = verb_cell_id(root_id, cat, num, person)
                    total = sum(c for c, _ in forms)
                    cells.append({
                        "cellId": cid, "kind": "finite",
                        "category": cat, "number": num, "person": person,
                        "evidence": cell_evidence.get(cat),
                        "totalTokens": total, "forms": forms,
                    })
        for cat, forms in v.get("nonfinite", {}).items():
            if not forms:
                continue
            cid = verb_cell_id(root_id, cat)
            total = sum(c for c, _ in forms)
            cells.append({
                "cellId": cid, "kind": "nonfinite",
                "category": cat, "number": None, "person": None,
                "evidence": None, "totalTokens": total, "forms": forms,
            })
        roots_out.append({
            "rootId": root_id, "rank": v["rank"], "tier": v["tier"],
            "totalTokens": v["totalTokens"], "cells": cells,
        })
    return {
        "contractVersion": CONTRACT_VERSION,
        "corpusRelease": attested_data.get("corpusRelease", "DCS-2026"),
        "generatedBy": "src/DCS-data-2026/build_learner_contracts.py (H2481)",
        "tierBoundary": attested_data.get("tierBoundary", 100),
        "frequencyFloor": attested_data.get("frequencyFloor", 2),
        "ceilingNote": attested_data.get("ceilingNote", ""),
        "cellEvidenceNote": attested_data.get("cellEvidenceNote", ""),
        "rootCount": len(roots_out),
        "roots": roots_out,
    }


def pack_nominal(nominal_data):
    lemmas_in = nominal_data["lemmas"]
    lemmas_out = []
    for lemma_id, v in lemmas_in.items():
        cells_out = []
        for cell_name, forms in v.get("cells", {}).items():
            if not forms:
                continue
            cid = nominal_cell_id(lemma_id, cell_name)
            cells_out.append({"cellId": cid, "cell": cell_name, "forms": forms})
        lemmas_out.append({
            "lemmaId": lemma_id, "lemma": v["lemma"],
            "domGender": v["domGender"], "stemFinal": v["stemFinal"],
            "tokens": v["tokens"], "cellsAttested": v["cellsAttested"],
            "rank": v["rank"], "tier": v["tier"], "cells": cells_out,
        })
    return {
        "contractVersion": CONTRACT_VERSION,
        "corpusRelease": nominal_data.get("corpusRelease", "DCS-2026"),
        "generatedBy": "src/DCS-data-2026/build_learner_contracts.py (H2481)",
        "frequencyFloor": nominal_data.get("frequencyFloor", 2),
        "tierBoundary": nominal_data.get("tierBoundary", 100),
        "ceilingNote": nominal_data.get("ceilingNote", ""),
        "cases": nominal_data.get("cases", []),
        "numbers": nominal_data.get("numbers", []),
        "cellNames": nominal_data.get("cells", []),
        "lemmaCount": len(lemmas_out),
        "lemmas": lemmas_out,
    }


def pack_concordance(conc_data, passages):
    prefix_idx = _passage_prefix_index(passages)
    links = []
    resolved_count = 0
    unresolved_count = 0
    resolved_passage_ids: set = set()
    unresolved_citations: set = set()
    for form, (total, examples) in conc_data["forms"].items():
        for ex in examples:
            cite = ex[0]
            if cite in prefix_idx:
                resolved_count += 1
                for pentry in prefix_idx[cite]:
                    pid = passage_id(pentry["title"], pentry["id"])
                    resolved_passage_ids.add(pentry["id"])
                    body = " ".join(str(x) for x in ex[1:])
                    links.append({
                        "form": form, "passageId": pid,
                        "exampleText": body, "occurrences": total,
                    })
            else:
                unresolved_count += 1
                unresolved_citations.add(cite)
    passage_link_count: dict = {}
    for lnk in links:
        passage_link_count[lnk["passageId"]] = passage_link_count.get(lnk["passageId"], 0) + 1
    passages_out = []
    for p in passages:
        pid = passage_id(p["title"], p["id"])
        passages_out.append({
            "passageId": pid, "sourceId": p["id"],
            "title": p["title"], "genre": p["genre"], "diff": p["diff"],
            "desc": p["desc"], "src": p["src"], "txt": p["txt"], "vd": p["vd"],
            "linkedFormCount": passage_link_count.get(pid, 0),
        })
    zero_link_ids = sorted(p["id"] for p in passages if p["id"] not in resolved_passage_ids)
    return {
        "contractVersion": CONTRACT_VERSION,
        "corpusRelease": conc_data.get("generatedBy", ""),
        "generatedBy": "src/DCS-data-2026/build_learner_contracts.py (H2481)",
        "passageCount": len(passages_out),
        "passages": passages_out, "links": links,
        "unresolved": {
            "totalCitationsScanned": resolved_count + unresolved_count,
            "resolvedCitations": resolved_count,
            "unresolvedCitations": unresolved_count,
            "distinctUnresolvedCitationStrings": len(unresolved_citations),
            "passagesWithZeroLinks": zero_link_ids,
            "note": (
                "Citation prefix-match (trailing ': N' stripped) against passage_library src. "
                "Unresolved citations are named gaps per H2481 plan — never fuzzy-linked."
            ),
        },
    }


def build_manifest(source_pins, payloads, schemas):
    files = sorted(str(p.relative_to(REPO).as_posix()) for p in payloads)
    schema_rel = sorted(str(s.relative_to(REPO).as_posix()) for s in schemas)
    sha256 = {f: sha256_file(REPO / f) for f in files}
    bytes_map = {f: (REPO / f).stat().st_size for f in files}
    record_counts: dict = {}
    for p in payloads:
        obj = json.loads(p.read_text(encoding="utf-8"))
        f = str(p.relative_to(REPO).as_posix())
        if "rootCount" in obj:
            record_counts[f] = obj["rootCount"]
        elif "lemmaCount" in obj:
            record_counts[f] = obj["lemmaCount"]
        elif "passageCount" in obj:
            record_counts[f] = obj["passageCount"]
    return {
        "contractVersion": CONTRACT_VERSION,
        "releaseId": f"vdcs-learner-v1-{datetime.now(timezone.utc).strftime('%Y%m%d')}",
        "generatedAt": datetime.now(timezone.utc).isoformat(),
        "sourcePins": source_pins,
        "files": files,
        "schemas": schema_rel,
        "sha256": sha256,
        "bytes": bytes_map,
        "recordCount": record_counts,
        "compatibility": {
            "policy": "additive-only within v1; breaking changes require v2 contractVersion",
            "previousRelease": None,
        },
        "provenance": {
            "handoff": "H2481 (Grok 4.5) — VisualDCS learner-contract release, dual-run override by Claude Sonnet 5",
            "builtBy": "Claude Sonnet 5 (claude-sonnet-5)",
            "plan": "docs/PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md",
        },
    }


def main():
    ap = argparse.ArgumentParser(description="Build VisualDCS v1 learner contracts (H2481)")
    ap.add_argument("--check", action="store_true", help="Validate existing files only; do not write")
    ap.add_argument("--verb-only", action="store_true")
    ap.add_argument("--nominal-only", action="store_true")
    ap.add_argument("--conc-only", action="store_true")
    args = ap.parse_args()

    do_all = not (args.verb_only or args.nominal_only or args.conc_only)

    print("Loading source assets...", flush=True)
    attested_data = json.loads(ATTESTED_JSON.read_text(encoding="utf-8"))
    nominal_data = json.loads(NOMINAL_JSON.read_text(encoding="utf-8"))
    conc_raw = load_conc_data(CONC_JS)
    passages = json.loads(PASSAGE_JSON.read_text(encoding="utf-8"))

    source_pins = {
        "paradigm_attested_schemaVersion": attested_data.get("schemaVersion", ""),
        "paradigm_attested_corpusRelease": attested_data.get("corpusRelease", ""),
        "paradigm_attested_generatedBy": attested_data.get("generatedBy", ""),
        "paradigm_nominal_corpusRelease": nominal_data.get("corpusRelease", ""),
        "paradigm_nominal_generatedBy": nominal_data.get("generatedBy", ""),
        "conc_data_generatedBy": conc_raw.get("generatedBy", ""),
        "conc_data_formCount": str(conc_raw.get("formCount", "")),
        "passage_library_count": str(len(passages)),
    }

    verb_path = CONTRACTS_DIR / "verb-trainer.json"
    nominal_path = CONTRACTS_DIR / "nominal-trainer.json"
    conc_path = CONTRACTS_DIR / "concordance-passage.json"
    manifest_path = CONTRACTS_DIR / "manifest.json"

    if not args.check:
        if do_all or args.verb_only:
            print("Packaging verb-trainer...", flush=True)
            vp = pack_verb(attested_data)
            write_json(verb_path, vp)
            print(f"  wrote {verb_path.relative_to(REPO)}, rootCount={vp['rootCount']}")

        if do_all or args.nominal_only:
            print("Packaging nominal-trainer...", flush=True)
            np_ = pack_nominal(nominal_data)
            write_json(nominal_path, np_)
            print(f"  wrote {nominal_path.relative_to(REPO)}, lemmaCount={np_['lemmaCount']}")

        if do_all or args.conc_only:
            print("Packaging concordance-passage...", flush=True)
            cp = pack_concordance(conc_raw, passages)
            write_json(conc_path, cp)
            u = cp["unresolved"]
            print(f"  wrote {conc_path.relative_to(REPO)}, passages={cp['passageCount']}, "
                  f"links={len(cp['links'])}, resolved={u['resolvedCitations']}, "
                  f"unresolved={u['unresolvedCitations']}, zeroLinkPassages={len(u['passagesWithZeroLinks'])}")

        if do_all:
            print("Building manifest...", flush=True)
            schemas = sorted(SCHEMA_DIR.glob("*.schema.json"))
            payloads = [verb_path, nominal_path, conc_path]
            mf = build_manifest(source_pins, payloads, schemas)
            write_json(manifest_path, mf)
            print(f"  wrote {manifest_path.relative_to(REPO)}, releaseId={mf['releaseId']}")

    # always validate when all payloads present
    if do_all:
        print("Validating against schemas...", flush=True)
        pairs = [
            (verb_path, SCHEMA_DIR / "verb-trainer.schema.json"),
            (nominal_path, SCHEMA_DIR / "nominal-trainer.schema.json"),
            (conc_path, SCHEMA_DIR / "concordance-passage.schema.json"),
            (manifest_path, SCHEMA_DIR / "manifest.schema.json"),
        ]
        all_ok = True
        for p, s in pairs:
            if not p.exists():
                print(f"  MISSING {p.name} — run without --check to build first")
                all_ok = False
                continue
            errs = validate_payload(p, s)
            if errs:
                all_ok = False
                print(f"  FAIL {p.name}: {len(errs)} error(s)")
                for e in errs[:5]:
                    print(f"    {e}")
            else:
                print(f"  ok  {p.name}")
        if not all_ok:
            sys.exit(1)

    print("Done.", flush=True)


if __name__ == "__main__":
    main()
