#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""test_published_figures.py — guards the H2298 cross-repo figure contract asset.

`dcs_published_figures.json` exists so a sibling repo (SanskritGrammar) can gate on our
numbers without a clone of this one. That makes its SHAPE load-bearing, not cosmetic:

  * a LIST of records, never a `{name: value}` object — the name-keyed shape is what let
    `Imperfect Active` publish 4,442 (code 8, last-wins) instead of 40,363 (codes 4+8) for
    months (H1486);
  * unique `id`s, so a consumer that does build a dict cannot silently lose a row;
  * `unit` + `basis` + `source_codes` on every row, so the consumer can refuse to compare
    two figures that are not measuring the same thing.

Also pins the refactor that made `_parse_timws` the single parse: the name-summed view
(`read_2021_verbcats`) and the code-explicit view (`published_figures`) must agree, or the
collision handling has drifted between them again.

    python test_published_figures.py
"""
import json
import os
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import regen_widgets as rw                                   # noqa: E402

REQUIRED = ("id", "label", "value", "unit", "basis", "tolerance",
            "source_file", "source_codes", "corpus_release", "generated_by")

# The name collisions the H1486 defect hid. Values verified against timws.csv by hand.
EXPECTED = {
    "dcs2021_present_active":   (157_003, [1]),
    "dcs2021_imperfect_active": (40_363,  [4, 8]),
    "dcs2021_aorist_active":    (1_304,   [10, 12]),
    "dcs2021_aorist_medium":    (1_148,   [11, 13]),
    "dcs2021_perfect_active":   (61_986,  [15]),
    "dcs2021_verbal_total":     (781_618, None),
}


def check(cond, msg):
    if not cond:
        print(f"  FAIL: {msg}")
    return bool(cond)


def main():
    ok = True
    rows = rw.published_figures()

    ok &= check(isinstance(rows, list), "figures must be a LIST, not a name-keyed object")
    ids = [r["id"] for r in rows]
    ok &= check(len(ids) == len(set(ids)), f"duplicate figure id(s) in {ids}")

    for r in rows:
        missing = [k for k in REQUIRED if k not in r]
        ok &= check(not missing, f"{r.get('id')}: missing field(s) {missing}")
        ok &= check(r.get("unit"), f"{r.get('id')}: `unit` is mandatory, not decoration")
        ok &= check(r.get("basis"), f"{r.get('id')}: `basis` must name the denominator")
        ok &= check(isinstance(r.get("source_codes"), list) and r["source_codes"],
                    f"{r.get('id')}: `source_codes` must list the codes summed")

    by_id = {r["id"]: r for r in rows}
    for fid, (value, codes) in EXPECTED.items():
        r = by_id.get(fid)
        if not check(r is not None, f"{fid} missing from the asset"):
            ok = False
            continue
        ok &= check(r["value"] == value, f"{fid}: {r['value']:,} != expected {value:,}")
        if codes is not None:
            ok &= check(r["source_codes"] == codes,
                        f"{fid}: codes {r['source_codes']} != expected {codes}")

    # The retrodiction: the pre-H1486 published value must NOT be what we publish now.
    ok &= check(by_id["dcs2021_imperfect_active"]["value"] != 4_442,
                "Imperfect Active is 4,442 again — the name-collision last-wins bug is back")

    # Single-parse pin: the two views of timws.csv must agree.
    name_summed = rw.read_2021_verbcats(rw.REL_2021)
    for fid, name in rw.PUBLISHED_2021_FIGURES:
        ok &= check(by_id[fid]["value"] == name_summed.get(name),
                    f"{fid}: code-explicit {by_id[fid]['value']:,} != name-summed "
                    f"{name_summed.get(name)} — the two timws views have drifted")
    ok &= check(by_id["dcs2021_verbal_total"]["value"] == sum(name_summed.values()),
                "the published total disagrees with the name-summed total")

    # The committed asset must match what the generator produces right now.
    out = rw.PUBLISHED_FIGURES_OUT
    if os.path.isfile(out):
        with open(out, encoding="utf-8") as fh:
            doc = json.load(fh)
        ok &= check(isinstance(doc.get("figures"), list), "committed `figures` is not a list")
        ok &= check(doc["figures"] == rows,
                    "committed dcs_published_figures.json is STALE — re-run "
                    "`python regen_widgets.py --figures-only` and commit the result")
    else:
        ok &= check(False, f"{out} not committed — the contract asset must be in the repo")

    print("PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
