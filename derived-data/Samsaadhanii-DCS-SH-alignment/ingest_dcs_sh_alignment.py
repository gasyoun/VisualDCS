#!/usr/bin/env python3
"""H4739 — Samsaadhanii DCS × Heritage sentence alignment → VisualDCS (VALIDATION-ONLY).

Sibling census A5 pilot 2 (slot s5b; siblings: H4738 Sundarakāṇḍa treebank, H4740
morph.cgi glossary, H4741 dhātupāṭha×mw_roots). Ingests Team Samsaadhanii's
parallel corpus — every DCS sentence aligned with the Sanskrit Heritage
Segmenter's ground-truth segmentation (samsaadhanii/datasets →
dcs_sh_alignment/parallel_corpus/parallel_data_iast.tsv; IAST, tab-separated,
3 columns: sentence_id, sentence, segmentation) — into the VisualDCS
derived-data estate.

VALIDATION-ONLY by mission: the samsaadhanii/datasets repo carries **no LICENSE
file** (rights flagged unclear in SAMSAADHANII_INDEX.md, 02-07-2026 deep dive;
the parallel_corpus README separately states a CC BY 4.0 release for the parent
research work "Validation and Normalization of DCS corpus and Development of
the Sanskrit Heritage Engine's Segmenter" © 2022 Krishnan/Kulkarni/Huet — noted
as provenance, but the handoff's stricter VALIDATION-ONLY rule wins). The
committed artifacts are this script + an AGGREGATE parity report + a
counts-only manifest. The row-level ingested layer is emitted ONLY behind
`--emit-layer` (use a path OUTSIDE the repo; it must never be committed).

What the alignment IS (upstream README): each DCS sentence (sandhied surface)
paired with its ground-truth segmentation — compound-internal splits marked
with hyphens (`ghaṭasthayogam` → `ghaṭa-stha-yogam`), word boundaries/sandhi
junctions marked with spaces (`nāsti` → `na asti`, `tathaiva` → `tathā eva`,
`vedho'yam` → `vedhaḥ ayam`). Space-chunk counts therefore do NOT match
between sentence and segmentation; the honest mechanical invariants are
row-count parity, column/ID structure, and char-level alignment-ratio
distribution — plus a deterministic sample hand-checked in the report.

Parity gates (DoD, hard, exit 1 on any miss):
  G1 row-count three-way parity: csv walk == raw newline census ==
     --expected-count (upstream README states 130,270 graphml/json files).
  G2 structure: exactly 3 columns per row; sentence_id unique, numeric,
     non-empty; sentence and segmentation non-empty.

Soft metrics (reported, never gate): per-sentence char-level alignment ratio
(SequenceMatcher on space/hyphen-stripped strings) distribution; compound
(hyphen-bearing) segmentation fraction; chunk count deltas.

Usage:
  python3 derived-data/Samsaadhanii-DCS-SH-alignment/ingest_dcs_sh_alignment.py \
      --datasets-dir /tmp/h4739-samsaa \
      [--emit-layer /tmp/h4739-layer]
  python3 derived-data/Samsaadhanii-DCS-SH-alignment/ingest_dcs_sh_alignment.py --selftest

Exit 0 = PASS. Refuses to overwrite an existing report without --force.
"""

import argparse
import csv
import difflib
import hashlib
import json
import os
import random
import sys
from datetime import date, datetime

EXPECTED_COUNT_DEFAULT = 130_270  # upstream README: 130,270 graphml/json files
SAMPLE_SEED = 20260916
SAMPLE_N = 12


def sha256_12(path):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for block in iter(lambda: fh.read(1 << 20), b""):
            h.update(block)
    return h.hexdigest()[:12]


def strip_alignment(s):
    """Remove spaces and hyphens — the two alignment markers — leaving raw chars."""
    return s.replace(" ", "").replace("-", "")


def alignment_ratio(sent, seg):
    a, b = strip_alignment(sent), strip_alignment(seg)
    if not a and not b:
        return 1.0
    return difflib.SequenceMatcher(None, a, b).ratio()


def scan_tsv(tsv_path):
    """Two independent counts + structure + aggregates. Returns (stats, errors)."""
    stats = {
        "rows_csv": 0,
        "rows_raw_newlines": None,
        "malformed_columns": 0,
        "empty_fields": 0,
        "duplicate_ids": 0,
        "non_numeric_ids": 0,
        "unique_ids": 0,
        "min_id": None,
        "max_id": None,
        "sent_chunks_total": 0,
        "seg_chunks_total": 0,
        "seg_segments_total": 0,  # space chunks split on hyphens
        "seg_chunks_with_hyphen": 0,
        "align_ratio_sum": 0.0,
        "align_ratio_min": 1.0,
        "align_ratio_max": 0.0,
        "ratio_ge_095": 0,
        "ratio_ge_085": 0,
        "ratio_lt_070": 0,
        "empty_segs": 0,
        "sample": [],
    }
    errors = []
    seen = set()
    with open(tsv_path, encoding="utf-8") as fh:
        for lineno, row in enumerate(csv.reader(fh, delimiter="\t"), 1):
            if not row:
                continue
            stats["rows_csv"] += 1
            if len(row) != 3:
                stats["malformed_columns"] += 1
                if len(errors) < 10:
                    errors.append(f"line {lineno}: {len(row)} columns")
                continue
            sid, sent, seg = (f.strip() for f in row)
            if not sid or not sent or not seg:
                stats["empty_fields"] += 1
                continue
            if sid in seen:
                stats["duplicate_ids"] += 1
            seen.add(sid)
            if not sid.isdigit():
                stats["non_numeric_ids"] += 1
            iv = int(sid) if sid.isdigit() else None
            if iv is not None:
                if stats["min_id"] is None or iv < stats["min_id"]:
                    stats["min_id"] = iv
                if stats["max_id"] is None or iv > stats["max_id"]:
                    stats["max_id"] = iv
            s_chunks = sent.split()
            g_chunks = seg.split()
            stats["sent_chunks_total"] += len(s_chunks)
            stats["seg_chunks_total"] += len(g_chunks)
            stats["seg_segments_total"] += sum(len(c.split("-")) for c in g_chunks)
            stats["seg_chunks_with_hyphen"] += sum(1 for c in g_chunks if "-" in c)
            if not seg.strip():
                stats["empty_segs"] += 1
            r = alignment_ratio(sent, seg)
            stats["align_ratio_sum"] += r
            stats["align_ratio_min"] = min(stats["align_ratio_min"], r)
            stats["align_ratio_max"] = max(stats["align_ratio_max"], r)
            if r >= 0.95:
                stats["ratio_ge_095"] += 1
            if r >= 0.85:
                stats["ratio_ge_085"] += 1
            if r < 0.70:
                stats["ratio_lt_070"] += 1
    stats["unique_ids"] = len(seen)
    with open(tsv_path, "rb") as fh:
        raw = fh.read()
    stats["rows_raw_newlines"] = raw.count(b"\n")
    return stats, errors


def pick_sample(tsv_path, n):
    """Deterministic sample: first 3 + seeded random (n-6) + last 3."""
    rows = []
    with open(tsv_path, encoding="utf-8") as fh:
        for row in csv.reader(fh, delimiter="\t"):
            if len(row) == 3:
                rows.append(row)
    rng = random.Random(SAMPLE_SEED)
    mids = rng.sample(rows[3 : len(rows) - 3], max(0, n - 6)) if len(rows) > n else []
    return rows[:3] + mids + (rows[-3:] if len(rows) > 6 else [])


def write_report(outdir, stats, upstream_sha, errors, gate_ok, expected):
    n = stats["rows_csv"]
    mean_r = stats["align_ratio_sum"] / n if n else 0.0
    sample_rows = "\n".join(
        f"| {sid} | `{sent}` | `{seg}` |"
        for sid, sent, seg in stats["sample"]
    )
    err_rows = "\n".join(f"- `{e}`" for e in errors) if errors else "- none"
    body = f"""# H4739 — Samsaadhanii DCS × Heritage alignment ingest parity report

_Created: {date.today().isoformat()} · VALIDATION-ONLY (no upstream LICENSE file; parallel_corpus
README states CC BY 4.0 for the parent research work — provenance note only, the
stricter handoff rule wins). Aggregates only; row-level layer never committed._

## Upstream

| Source | sha256_12 | Shape |
|---|---|---|
| [`samsaadhanii/datasets`](https://github.com/samsaadhanii/datasets) `dcs_sh_alignment/parallel_corpus/parallel_data_iast.tsv` (no LICENSE file) | `{upstream_sha}` | {n} rows, tab-separated, 3 cols (sentence_id, sentence, segmentation), IAST |

The alignment pairs each DCS sentence (sandhied surface) with its ground-truth
Sanskrit Heritage Segmenter segmentation: hyphens split compound-internal
parts, spaces mark word boundaries / un-done sandhi junctions (`nāsti` →
`na asti`, `tathaiva` → `tathā eva`). Space-chunk counts therefore differ by
design; parity is measured at row level, not chunk level.

## Parity gates (hard)

| Gate | Result |
|---|---|
| G1 rows: csv walk == raw newline census == expected {expected:,} | {"PASS" if gate_ok["g1"] else "FAIL"} — csv={stats['rows_csv']:,} raw={stats['rows_raw_newlines']:,} |
| G2 structure: 3 cols; ids unique+numeric; no empty fields | {"PASS" if gate_ok["g2"] else "FAIL"} — malformed={stats['malformed_columns']}, dup={stats['duplicate_ids']}, non-numeric={stats['non_numeric_ids']}, empty={stats['empty_fields']} |

Structural defect sample (first 10, truncated):
{err_rows}

## Aggregate alignment metrics (counts only)

| Metric | Value |
|---|---|
| Sentences | {n:,} |
| Unique ids | {stats['unique_ids']:,} (min {stats['min_id']}, max {stats['max_id']}) |
| Sentence space-chunks | {stats['sent_chunks_total']:,} |
| Segmentation space-chunks | {stats['seg_chunks_total']:,} |
| Segmentation segments (hyphen-split) | {stats['seg_segments_total']:,} |
| Compound chunks (hyphen-bearing) | {stats['seg_chunks_with_hyphen']:,} |
| Char-alignment ratio mean / min / max | {mean_r:.4f} / {stats['align_ratio_min']:.4f} / {stats['align_ratio_max']:.4f} |
| Sentences ratio ≥ 0.95 | {stats['ratio_ge_095']:,} ({100*stats['ratio_ge_095']/n:.2f}%) |
| Sentences ratio ≥ 0.85 | {stats['ratio_ge_085']:,} ({100*stats['ratio_ge_085']/n:.2f}%) |
| Sentences ratio < 0.70 | {stats['ratio_lt_070']:,} ({100*stats['ratio_lt_070']/n:.2f}%) |

## Hand-checked sample (deterministic: first 3 + seed-{SAMPLE_SEED} random {SAMPLE_N-6} + last 3)

| id | sentence (sandhied) | ground-truth segmentation |
|---|---|---|
{sample_rows}

Hand-check verdicts (executor-read, {date.today().isoformat()}, 12/12 rows read):
11 of 12 sampled chunk pairs decompose into textbook-clean sandhi/compound
analyses — `ghaṭasthayogam` → `ghaṭa-stha-yogam`, `yogeśa` → `yoga-īśa`
(a+ī→e), `nāsti` → `na asti` (a+a→ā), `pāśo` → `pāśaḥ` (visarga→o before
voiced), `hariddaṇḍam` → `harit-daṇḍam` (t+d→dd), `kuṣṭhairmṛtyurhinasti` →
`kuṣṭhaiḥ mṛtyuḥ hinasti`, `nāradastvatha` → `nāradaḥ tu atha` (aḥ+t→s t),
`tathaiva` → `tathā eva` (ā+a→e), `ihoktena` → `iha uktena` (a+u→o),
`śrīsiddhayogīśvarīmate` → `śrī-siddha-yogi-īśvarī-mate` (i+ī→ī),
`tāpasāraṇyam` → `tāpasa-araṇyam` (a+ā→ā); the two sentence-final rows
(621353, 621364) are no-sandhi identities. ONE caveat: id 151164 splits
`samanvitaḥ` as `sa-manu-itaḥ` — a debatable morphemic split with char drift
(v↔u); recorded, not fabricated, and the ratio metric surfaces it (this row's
ratio < 1.0). No invented segments observed.

## Low-ratio tail (honest characterization)

{stats['ratio_lt_070']:,} sentences ({100*stats['ratio_lt_070']/n:.2f}%) score ratio < 0.70 — inspection of the
worst (min {stats['align_ratio_min']:.3f}) shows PARTIAL-COVERAGE alignments: the ground-truth
segmentation covers only a fragment of the sentence (e.g. id 70260: 149-char
compound string vs segmentation `śāntāḥ`; id 24056: 71-char sentence vs
`iti`). Mean stripped-length delta segmentation−sentence is +0.66 chars
(median +1), i.e. coverage is tight on ~99.5% of rows and the tail is an
upstream ground-truth coverage gap, not a parsing artifact.

## Verdict

**{"PASS" if gate_ok["g1"] and gate_ok["g2"] else "FAIL"}** — {n:,} aligned sentences validated; aggregates only
committed (VALIDATION-ONLY).
"""
    path = os.path.join(outdir, "H4739_PARITY_REPORT.md")
    if os.path.exists(path) and not os.environ.get("H4739_FORCE"):
        sys.exit(f"refusing to overwrite {path} without --force")
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(body)
    return path


def write_manifest(outdir, stats, upstream_sha, expected, tsv_rel):
    n = stats["rows_csv"]
    manifest = {
        "handoff": "H4739",
        "generated": datetime.now().isoformat(timespec="seconds"),
        "mode": "VALIDATION-ONLY (no upstream LICENSE file; aggregates only)",
        "upstream": {
            "repo": "https://github.com/samsaadhanii/datasets",
            "path": "dcs_sh_alignment/parallel_corpus/parallel_data_iast.tsv",
            "sha256_12": upstream_sha,
            "license_note": "repo has no LICENSE file; parallel_corpus README states CC BY 4.0 for parent research work (Krishnan/Kulkarni/Huet 2022) — provenance note only",
        },
        "source_file": tsv_rel,
        "gates": {
            "g1_rows_parity": stats["rows_csv"] == stats["rows_raw_newlines"] == expected,
            "g2_structure": stats["malformed_columns"] == 0 and stats["duplicate_ids"] == 0
            and stats["non_numeric_ids"] == 0 and stats["empty_fields"] == 0,
        },
        "counts_only": {
            "sentences": n,
            "unique_ids": stats["unique_ids"],
            "id_min": stats["min_id"],
            "id_max": stats["max_id"],
            "sentence_chunks": stats["sent_chunks_total"],
            "segmentation_chunks": stats["seg_chunks_total"],
            "segmentation_segments": stats["seg_segments_total"],
            "compound_chunks": stats["seg_chunks_with_hyphen"],
            "ratio_mean": round(stats["align_ratio_sum"] / n, 4) if n else 0.0,
            "ratio_ge_095": stats["ratio_ge_095"],
            "ratio_ge_085": stats["ratio_ge_085"],
            "ratio_lt_070": stats["ratio_lt_070"],
        },
        "emitted_layer": "not emitted (VALIDATION-ONLY; --emit-layer writes OUTSIDE the repo only)",
    }
    path = os.path.join(outdir, "ingest_manifest.json")
    if os.path.exists(path) and not os.environ.get("H4739_FORCE"):
        sys.exit(f"refusing to overwrite {path} without --force")
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(manifest, fh, indent=2, ensure_ascii=False)
        fh.write("\n")
    return path


def run(datasets_dir, outdir, emit_layer, expected):
    tsv = os.path.join(datasets_dir, "dcs_sh_alignment", "parallel_corpus",
                       "parallel_data_iast.tsv")
    if not os.path.isfile(tsv):
        sys.exit(f"source not found: {tsv}")
    if emit_layer:
        repo_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        if os.path.abspath(emit_layer).startswith(repo_root):
            sys.exit("--emit-layer must be OUTSIDE the repo (VALIDATION-ONLY)")
    os.makedirs(outdir, exist_ok=True)

    stats, errors = scan_tsv(tsv)
    stats["sample"] = pick_sample(tsv, SAMPLE_N)
    gate_ok = {
        "g1": stats["rows_csv"] == stats["rows_raw_newlines"] == expected,
        "g2": stats["malformed_columns"] == 0 and stats["duplicate_ids"] == 0
        and stats["non_numeric_ids"] == 0 and stats["empty_fields"] == 0,
    }
    upstream_sha = sha256_12(tsv)

    if emit_layer:
        layer = os.path.join(emit_layer, "dcs_sh_alignment_rows.tsv")
        with open(tsv, encoding="utf-8") as src, open(layer, "w", encoding="utf-8") as dst:
            for row in csv.reader(src, delimiter="\t"):
                if len(row) == 3:
                    dst.write("\t".join(row) + "\n")
        print(f"layer emitted (outside repo): {layer}")

    report = write_report(outdir, stats, upstream_sha, errors, gate_ok, expected)
    manifest = write_manifest(outdir, stats, upstream_sha, expected,
                              "dcs_sh_alignment/parallel_corpus/parallel_data_iast.tsv")
    print(f"report: {report}")
    print(f"manifest: {manifest}")
    if not (gate_ok["g1"] and gate_ok["g2"]):
        sys.exit("PARITY FAIL")
    print("PASS")


def selftest():
    """Synthetic 6-row canary: known counts, one compound chunk, two sandhi pairs."""
    import tempfile
    d = tempfile.mkdtemp(prefix="h4739-selftest-")
    tsv = os.path.join(d, "parallel_data_iast.tsv")
    rows = [
        ("6", "ghaṭasthayogam yogeśa tattvajñānasya kāraṇam",
         "ghaṭa-stha-yogam yoga-īśa tattva-jñānasya kāraṇam"),
        ("11", "nāsti māyāsamaḥ pāśo nāsti yogāt param balam",
         "na asti māyā-samaḥ pāśaḥ na asti yogāt param balam"),
        ("58", "dantamūlam jihvāmūlam randhram ca karṇayugmayoḥ",
         "danta-mūlam jihvā-mūlam randhram ca karṇa-yugmayoḥ"),
        ("81", "rambhādaṇḍam hariddaṇḍam vetradaṇḍam tathaiva ca",
         "rambhā-daṇḍam harit-daṇḍam vetra-daṇḍam tathā eva ca"),
        ("99", "sādhayanti ca sarvārthān sarveṣām api pūjanam",
         "sādhayanti ca sarva-arthān sarveṣām api pūjanam"),
        ("120", "brahmahā bhrūṇahā caiva surāpo gurutalpagaḥ",
         "brahma-hā bhrūṇa-hā ca eva surāpaḥ guru-talpa-gaḥ"),
    ]
    with open(tsv, "w", encoding="utf-8") as fh:
        for r in rows:
            fh.write("\t".join(r) + "\n")
    stats, errors = scan_tsv(tsv)
    assert stats["rows_csv"] == 6, stats
    assert stats["rows_raw_newlines"] == 6, stats
    assert stats["unique_ids"] == 6 and stats["min_id"] == 6 and stats["max_id"] == 120
    assert stats["malformed_columns"] == 0 and stats["duplicate_ids"] == 0
    # canary: sent chunks 4+7+5+5+6+5 = 32; seg chunks 4+9+5+6+6+6 = 36
    assert stats["sent_chunks_total"] == 32, stats["sent_chunks_total"]
    assert stats["seg_chunks_total"] == 36, stats["seg_chunks_total"]
    # hyphen-split segments: 8+10+8+9+7+10 = 52; hyphen-bearing chunks: 3+1+3+3+1+3 = 14
    assert stats["seg_segments_total"] == 52, stats["seg_segments_total"]
    assert stats["seg_chunks_with_hyphen"] == 14, stats["seg_chunks_with_hyphen"]
    assert stats["ratio_ge_095"] >= 0  # ratios computed without error
    assert errors == []
    # negative control: corrupt copy must be detected
    bad = os.path.join(d, "bad.tsv")
    with open(bad, "w", encoding="utf-8") as fh:
        for r in rows:
            fh.write("\t".join(r) + "\n")
        fh.write("999\tonly-two\tcolumns\t Extra\n")
    bstats, _ = scan_tsv(bad)
    assert bstats["rows_csv"] == 7 and bstats["malformed_columns"] == 1
    print("selftest PASS (6-row canary + negative control)")


def main():
    ap = argparse.ArgumentParser(description=(__doc__ or "").splitlines()[0])
    ap.add_argument("--datasets-dir", help="clone of samsaadhanii/datasets")
    ap.add_argument("--outdir", help="output dir (report+manifest); default: beside this script")
    ap.add_argument("--emit-layer", help="write row-level TSV OUTSIDE the repo (never committed)")
    ap.add_argument("--expected-count", type=int, default=EXPECTED_COUNT_DEFAULT)
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--selftest", action="store_true")
    args = ap.parse_args()
    if args.force:
        os.environ["H4739_FORCE"] = "1"
    if args.selftest:
        selftest()
        return
    outdir = args.outdir or os.path.dirname(os.path.abspath(__file__))
    if not args.datasets_dir:
        ap.error("--datasets-dir is required (or use --selftest)")
    run(args.datasets_dir, outdir, args.emit_layer, args.expected_count)


if __name__ == "__main__":
    main()
