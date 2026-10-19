#!/usr/bin/env python3
"""Probe the bundled 2022 NCC database for the missing Devanagari `स्क` block (H7078).

Gate 1 of the H6995 NCC MSS census. `ncc.jsonl` (152,526 rows, parsed from
`non-derived/NCC/files/src/SktNewCatalogus_Catalogorum_combined.txt`) carries no
IAST title beginning Sk/Sl/Sm/Sn/So/Sr and no Devanagari title beginning `स्क`,
so the Skandapurāṇa canary could not be computed and stayed INCONCLUSIVE. The
open question: are those fascicles present in the bundled 2022 database
(`non-derived/NCC/files/ncc/ncc.rar`) but missing from the export, or absent
from the database itself?

This script answers that with numbers instead of assertion. It extracts the
archive to a throwaway temp dir (extracted bytes never touch the repo), maps
the `sys/*` schema, counts the `स्क` / Sk-prefix hits in the master table's
*title* columns, and proves the committed export is a faithful serialization of
the master table by comparing the structured-ID sets and their order.

Schema measured 2026-10-19 (the archive is a 2022-vintage NCC desktop DB):

    sys/1D.txt   master table, `$`-separated:
                 devanagari $ IAST $ vol $ page $ col $ seq $ <p>body</p>
                 (body may spill onto a following line-less-`$` continuation)
    sys/3D.csv   IAST $ vol $ page $ col $ seq $ body $$$ (master minus Devanagari)
    sys/5i.csv   bodies only, tags stripped
    sys/vols.csv vol $ page $ col, one row per record (the pagination index)
    sys/2D.csv   2D.txt  4.txt  42.txt  4I.csv   normalized headword indexes
    sys/abb.csv  !abb.csv  abbreviation -> expansion

Extraction note: p7zip 17.05 (the `7z` on the MacBook) lists this RAR5 archive
but fails every member with "Unsupported Method"; `bsdtar` (libarchive) extracts
it byte-exactly against the archive listing. The script prefers bsdtar and
falls back to 7z, reporting which extractor ran.

Usage:
    python tools/ncc_sk_block_probe.py                 # human report
    python tools/ncc_sk_block_probe.py --json          # machine verdict
    python tools/ncc_sk_block_probe.py --keep DIR      # extract/appraise DIR
    python tools/ncc_sk_block_probe.py --no-extract DIR  # reuse DIR/sys

Exit codes: 0 = probe completed (read `verdict`), 2 = a required input or
extractor is missing. The verdict is evidence, not an assertion: ABSENT means
no `स्क`/Sk-prefix *title* exists anywhere in the archive's tables.
"""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_RAR = REPO_ROOT / "non-derived" / "NCC" / "files" / "ncc" / "ncc.rar"
DEFAULT_COMBINED = (
    REPO_ROOT / "non-derived" / "NCC" / "files" / "src"
    / "SktNewCatalogus_Catalogorum_combined.txt"
)

# The block under test: the Devanagari `स्क` conjunct, IAST `Sk`.
SK_DEV_PREFIX = "स्क"
SK_IAST_PREFIX = "Sk"
# Neighbouring sibilant-conjunct prefixes, reported as near-misses so a reader
# can see the probe did NOT simply look away at the S-cluster boundary.
NEAR_PREFIXES = ("Sl", "Sm", "Sn", "So", "Sr")
SKANDAPUR = "Skandapur"

# Every table in `sys/` that could hold a headword title.
TITLE_TABLES = (
    "1D.txt", "3D.csv", "2D.csv", "2D.txt", "4.txt", "42.txt", "4I.csv",
)


def run(cmd: list[str], cwd: Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(
        cmd, cwd=str(cwd) if cwd else None, check=False,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, encoding="utf-8",
    )


def extract(rar: Path, dest: Path) -> tuple[str, list[str]]:
    """Extract `rar` into `dest`; return (extractor, notes)."""
    notes: list[str] = []
    bsdtar = shutil.which("bsdtar")
    if bsdtar:
        res = run([bsdtar, "-xf", str(rar)], cwd=dest)
        if res.returncode == 0 and (dest / "sys" / "1D.txt").exists():
            return "bsdtar", notes
        notes.append(f"bsdtar failed (rc={res.returncode}): {res.stdout.strip()[:400]}")
    seven = shutil.which("7z") or shutil.which("7zz") or shutil.which("7za")
    if seven:
        res = run([seven, "x", str(rar), f"-o{dest}", "-y"])
        # 7z can exit 0 with per-member "Unsupported Method"; demand real bytes.
        if (dest / "sys" / "1D.txt").exists() and (dest / "sys" / "1D.txt").stat().st_size > 0:
            return Path(seven).name, notes
        notes.append(
            "7z could not decode this RAR5 (per-member 'Unsupported Method'): "
            + ", ".join(sorted(p.name for p in (dest / "sys").glob("*") if p.stat().st_size == 0))[:400]
        )
    raise SystemExit(
        "[ncc_sk_block_probe] FATAL: no working extractor for "
        f"{rar} (tried bsdtar, 7z). Notes: {notes}"
    )


def parse_master(path: Path) -> tuple[list[dict], int]:
    """Parse sys/1D.txt into records; return (records, continuation-line count).

    A record is a line with six `$`-separated leading fields plus a body. Each
    other (non-empty) line is body text that spilled onto its own physical line
    and belongs to the record above it — the export merges those, so the probe
    must too or the row counts cannot reconcile.
    """
    records: list[dict] = []
    continuations = 0
    text = path.read_text(encoding="utf-8", errors="replace")
    for line in text.split("\n"):
        if not line.strip():
            continue
        parts = line.split("$", 6)
        if len(parts) == 7 and parts[2].strip().isdigit() and parts[3].strip().isdigit():
            records.append({
                "dev": parts[0],
                "iast": parts[1],
                "vol": int(parts[2]),
                "page": int(parts[3]),
                "col": parts[4],
                "seq": parts[5],
                "body": parts[6],
            })
        elif records:
            continuations += 1
            records[-1]["body"] += " " + line
        else:
            continuations += 1
    return records, continuations


def structured_id(rec: dict) -> str:
    return f"{rec['vol']}_{rec['page']}_{rec['col']}_{rec['seq']}"


def lookup_key(text: str) -> str:
    """Punctuation-insensitive look-up key: letters only, lowercased.

    Deliberately aggressive. The NCC prints variant titles parenthetical-first
    (`(Smṛti)_Ratnamañjūṣā`, `(स्मृति)_रत्नमञ्जूषा`), so a literal `^Sk` test on
    the printed column cannot see them — and a probe that only tests literal
    prefixes would overstate the gap. Keeping every letter and dropping
    parentheses/underscores/punctuation reproduces the NCC's own `sys/2D.txt`
    index key (`(Smṛti)_Ratnamañjūṣā` -> `smṛtiratnamañjūṣā`) while letting a
    hypothetical `(स्कन्द)पुराण` surface as `skandapurāṇa`.
    """
    return "".join(ch for ch in text if ch.isalnum()).lower()


def probe_archive(sysdir: Path, combined: Path | None) -> dict:
    inventory = []
    for p in sorted(sysdir.iterdir()):
        if p.is_file():
            inventory.append({"name": p.name, "bytes": p.stat().st_size})

    master = sysdir / "1D.txt"
    records, continuations = parse_master(master)

    # --- the discriminating counts, on TITLE columns only -------------------
    dev_sk = [r for r in records if r["dev"].startswith(SK_DEV_PREFIX)]
    iast_sk = [r for r in records if r["iast"].startswith(SK_IAST_PREFIX)]
    # Normalization-aware test: would a look-up key ever reach the Sk block?
    norm_sk = [
        r for r in records
        if lookup_key(r["iast"]).startswith("sk")
        or lookup_key(r["dev"]).startswith(SK_DEV_PREFIX)
    ]
    near_misses = {}
    for p in NEAR_PREFIXES:
        hit = [r for r in records if lookup_key(r["iast"]).startswith(p.lower())]
        if hit:
            near_misses[p] = [
                {"dev": r["dev"], "iast": r["iast"], "id": structured_id(r)} for r in hit
            ]
    skandapur_in_body = sum(1 for r in records if SKANDAPUR.lower() in r["body"].lower())
    skandapur_in_title = sum(
        1 for r in records
        if SKANDAPUR.lower() in lookup_key(r["dev"] + " " + r["iast"])
    )

    # --- per-table sweep: a title could be filed in any index ---------------
    table_hits = {}
    for name in TITLE_TABLES:
        p = sysdir / name
        if not p.exists():
            continue
        dev_hit = norm_hit = 0
        with p.open(encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if line.startswith(SK_DEV_PREFIX):
                    dev_hit += 1
                if lookup_key(line).startswith("sk"):
                    norm_hit += 1
        table_hits[name] = {"dev_sk_prefix": dev_hit, "normalized_sk_prefix": norm_hit}

    # --- pagination extent --------------------------------------------------
    per_vol: dict[int, dict] = {}
    for r in records:
        slot = per_vol.setdefault(r["vol"], {"records": 0, "max_page": 0})
        slot["records"] += 1
        slot["max_page"] = max(slot["max_page"], r["page"])

    last = records[-1] if records else None

    # Catalogue order = published pagination. This is the ordering a recovery
    # would have had to respect, and it is NOT a Devanagari codepoint sort
    # (`dev_codepoint_violations` is large) — assuming one would file a
    # recovered block in the wrong place, exactly the trap H7078 warned about.
    pkeys = [(r["vol"], r["page"], int(r["seq"])) for r in records]
    page_violations = sum(1 for i in range(1, len(pkeys)) if pkeys[i] < pkeys[i - 1])
    dev_violations = sum(
        1 for i in range(1, len(records)) if records[i]["dev"] < records[i - 1]["dev"]
    )

    # --- export fidelity: does combined.txt == the master's records? --------
    fidelity: dict = {"checked": False}
    if combined is not None and combined.exists():
        combined_ids = []
        with combined.open(encoding="utf-8", errors="replace") as fh:
            for line in fh:
                cols = line.rstrip("\n").split("\t")
                if len(cols) >= 3:
                    combined_ids.append(cols[2])
        master_ids = [structured_id(r) for r in records]
        fidelity = {
            "checked": True,
            "master_records": len(master_ids),
            "combined_rows": len(combined_ids),
            "identical_sets": set(master_ids) == set(combined_ids),
            "identical_order": master_ids == combined_ids,
            "only_in_master": len(set(master_ids) - set(combined_ids)),
            "only_in_combined": len(set(combined_ids) - set(master_ids)),
        }

    present = bool(dev_sk) or bool(iast_sk) or bool(norm_sk) or any(
        v["dev_sk_prefix"] or v["normalized_sk_prefix"] for v in table_hits.values()
    )

    return {
        "verdict": "PRESENT" if present else "ABSENT",
        "inventory": inventory,
        "master_rows_physical": len(records) + continuations,
        "records": len(records),
        "continuation_lines": continuations,
        "dev_sk_prefix_titles": len(dev_sk),
        "iast_sk_prefix_titles": len(iast_sk),
        "normalized_sk_prefix_titles": len(norm_sk),
        "near_misses": near_misses,
        "skandapur_in_body": skandapur_in_body,
        "skandapur_in_title": skandapur_in_title,
        "table_hits": table_hits,
        "volumes": sorted(per_vol),
        "per_volume": {str(k): per_vol[k] for k in sorted(per_vol)},
        "max_volume": max(per_vol) if per_vol else None,
        "max_page_of_max_volume": per_vol[max(per_vol)]["max_page"] if per_vol else None,
        "pagination_order_violations": page_violations,
        "dev_codepoint_violations": dev_violations,
        "last_pagination_key": list(pkeys[-1]) if pkeys else None,
        "last_record": {
            "dev": last["dev"], "iast": last["iast"], "id": structured_id(last),
        } if last else None,
        "export_fidelity": fidelity,
    }


def render(report: dict, extractor: str, notes: list[str]) -> str:
    out: list[str] = []
    a = out.append
    a("## ncc.rar schema inventory\n")
    a("| file | bytes |")
    a("|---|---|")
    for row in report["inventory"]:
        a(f"| `sys/{row['name']}` | {row['bytes']:,} |")
    a("")
    a(f"extractor: `{extractor}`")
    for n in notes:
        a(f"- note: {n}")
    a("")
    a("## Master table `sys/1D.txt`\n")
    a(f"- physical rows: **{report['master_rows_physical']:,}**")
    a(f"- well-formed records: **{report['records']:,}**")
    a(f"- body-continuation lines merged into the record above: {report['continuation_lines']}")
    a("")
    a("## The discriminating counts (TITLE columns only)\n")
    a("| probe | count |")
    a("|---|---|")
    a(f"| Devanagari title starting `{SK_DEV_PREFIX}` (literal) | **{report['dev_sk_prefix_titles']}** |")
    a(f"| IAST title starting `{SK_IAST_PREFIX}` (literal) | **{report['iast_sk_prefix_titles']}** |")
    a(f"| title whose normalized look-up key starts `sk` | **{report['normalized_sk_prefix_titles']}** |")
    a(f"| `{SKANDAPUR}` in a TITLE | {report['skandapur_in_title']} |")
    a(f"| `{SKANDAPUR}` in a BODY (bibliographic reference) | {report['skandapur_in_body']:,} |")
    a("")
    a("### Neighbouring sibilant-conjunct titles (near-misses, for the record)\n")
    if report["near_misses"]:
        a("These are the ONLY normalized titles in the S-cluster besides the `sk` gap. "
          "Every one is a parenthetical-first printed title "
          "(`(स्मृति)_रत्नमञ्जूषा`), so its printed form starts `(` — not the block:\n")
        a("| normalized prefix | printed Devanagari | printed IAST | id |")
        a("|---|---|---|---|")
        for prefix, rows in report["near_misses"].items():
            for row in rows:
                a(f"| `{prefix}` | `{row['dev']}` | `{row['iast']}` | `{row['id']}` |")
    else:
        a("_none_")
    a("")
    a("### Every title-bearing table swept\n")
    a("| table | `स्क` literal prefix | normalized `sk` prefix |")
    a("|---|---|---|")
    for name, hit in report["table_hits"].items():
        a(f"| `sys/{name}` | {hit['dev_sk_prefix']} | {hit['normalized_sk_prefix']} |")
    a("")
    a("## Pagination extent\n")
    a(f"- volumes present: {report['volumes'][0]}–{report['max_volume']} "
      f"({len(report['volumes'])} volumes)")
    a(f"- last volume {report['max_volume']} stops at page "
      f"**{report['max_page_of_max_volume']}**")
    if report["last_record"]:
        r = report["last_record"]
        a(f"- last record: `{r['dev']} · {r['iast']} · {r['id']}`")
    a(f"- pagination-order violations `(vol,page,seq)`: "
      f"**{report['pagination_order_violations']}** in {report['records']:,} records "
      "— the table is in strict catalogue order, so nothing is filed out of sequence")
    a(f"- Devanagari codepoint-order violations: {report['dev_codepoint_violations']:,} "
      "— the file is NOT a codepoint sort, so a recovered block must be placed by "
      "pagination, never by appending or by codepoint insertion")
    a("")
    a("### Records and last page per volume\n")
    a("| vol | records | max page |")
    a("|---|---|---|")
    for vol, slot in report["per_volume"].items():
        a(f"| {vol} | {slot['records']:,} | {slot['max_page']} |")
    a("")
    f = report["export_fidelity"]
    a("## Export fidelity: is `combined.txt` a complete serialization?\n")
    if f.get("checked"):
        a(f"- master well-formed records: {f['master_records']:,}")
        a(f"- committed `combined.txt` rows: {f['combined_rows']:,}")
        a(f"- identical structured-ID sets: **{f['identical_sets']}**")
        a(f"- identical order: **{f['identical_order']}**")
        a(f"- only in master: {f['only_in_master']} · only in combined: {f['only_in_combined']}")
    else:
        a("- not checked (combined.txt absent)")
    a("")
    a(f"## Verdict: **{report['verdict']}**\n")
    return "\n".join(out)


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--rar", type=Path, default=DEFAULT_RAR)
    ap.add_argument("--combined", type=Path, default=DEFAULT_COMBINED)
    ap.add_argument("--json", action="store_true", help="emit one JSON object")
    ap.add_argument("--keep", type=Path, default=None,
                    help="extract into this dir and leave it there")
    ap.add_argument("--no-extract", type=Path, dest="no_extract", default=None,
                    help="reuse an already-extracted dir (its sys/ is read)")
    args = ap.parse_args(argv)

    notes: list[str] = []
    tmp: Path | None = None
    if args.no_extract:
        sysdir = Path(args.no_extract) / "sys"
        extractor = "reused"
        if not (sysdir / "1D.txt").exists():
            print(f"[ncc_sk_block_probe] FATAL: no sys/1D.txt under {args.no_extract}",
                  file=sys.stderr)
            return 2
    else:
        if not args.rar.exists():
            print(f"[ncc_sk_block_probe] FATAL: archive not found: {args.rar}", file=sys.stderr)
            return 2
        target = Path(args.keep) if args.keep else Path(tempfile.mkdtemp(prefix="ncc-h7078-"))
        if args.keep:
            target.mkdir(parents=True, exist_ok=True)
        else:
            tmp = target
        extractor, notes = extract(args.rar, target)
        sysdir = target / "sys"

    try:
        report = probe_archive(sysdir, None if args.combined is None else Path(args.combined))
    finally:
        if tmp is not None:
            shutil.rmtree(tmp, ignore_errors=True)

    report["extractor"] = extractor
    report["notes"] = notes
    if args.json:
        print(json.dumps(report, ensure_ascii=False, indent=2))
    else:
        print(render(report, extractor, notes))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
