#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
test_paradigm_attested.py -- H1299 regression script (VisualDCS acceptance step 6).

Pins two things against visual/paradigm_attested.json so a future data-build
regression is caught, not silently shipped:
  1. The top-100 root list (frequency ranking) -- exact set + order.
  2. The 6 hand-picked roots (kr/bhu/as/gam/vac/da) spot-checked against the
     legacy sanskrit_pxn_v4.html RD object: every corpus-attested key form the
     6-root browser itself carries a real DCS form-id for (FID) must appear
     SOMEWHERE in this script's attested data for that root (a floor, not a
     byte-diff -- the two datasets model cells differently, see H1299 plan
     decision #2/#4; the RD grid is textbook forms with corpus IDs attached,
     this dataset is corpus-attested-only).
  3. The DCS-class-ambiguity discipline: no root record anywhere may carry a
     Panini class number (never fabricate cell resolution the corpus can't
     give -- the H1299 target-specific constraint).
  4. The H1486/H2294 past-tense re-split contract: the merged "Perfect/Aorist"
     label is gone; the split categories are present; and EVERY emitted past
     category carries a cellEvidence verdict, with "Perfect *" marked
     `defaulted` (it is the untagged residue -- an inference, not an
     attestation). This is the check that stops a future regeneration from
     silently shipping an inferred category to a learner as an attested one.

Run from repo root:  python src/DCS-data-2026/test_paradigm_attested.py
Exits 1 on any failure, printing every mismatch (never silently passes).
"""

import json
import os
import re
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
DATA = os.path.join(REPO, "visual", "paradigm_attested.json")

# Pinned top-100 root list (root -> rank), snapshotted at H1299 build time.
# If the corpus/DB changes and this drifts, the diff below tells you exactly
# which roots moved -- update deliberately, never silence this check.
PINNED_TOP100 = None  # filled at first run via --pin; see main()

SIX_ROOTS = ["kṛ", "bhū", "as", "gam", "vac", "dā"]
# A handful of real, corpus-attested forms the 6-root RD grid in
# sanskrit_pxn_v4.html carries a DCS form-id for (FID map) -- i.e. genuinely
# attested, not just textbook-derived. Each must surface somewhere in this
# root's attested finite-cell forms.
SIX_ROOT_SPOT_FORMS = {
    "kṛ": ["karomi", "karoti", "kurute", "kuruṣe"],
    "bhū": ["bhavati", "babhūva"],
    "as": ["asmi", "asti"],
    "gam": ["jagāma", "gacchati"],
    "vac": ["uvāca", "ucyate"],
    "dā": ["dadāmi", "dadāti"],
}


def load():
    if not os.path.isfile(DATA):
        print(f"BLOCKED: {DATA} not found -- run gen_paradigm_attested.py first.", file=sys.stderr)
        sys.exit(2)
    with open(DATA, encoding="utf-8") as fh:
        return json.load(fh)


def root_all_forms(rec):
    forms = set()
    for cat, grid in rec.get("finite", {}).items():
        for nk in ("sg", "du", "pl"):
            for pers, arr in grid.get(nk, {}).items():
                for _n, f in arr:
                    forms.add(f)
    for _bucket, arr in rec.get("nonfinite", {}).items():
        for _n, f in arr:
            forms.add(f)
    return forms


def main():
    argv = sys.argv[1:]
    d = load()
    roots = d["roots"]
    failures = []

    # ---- 1. top-100 pin ----
    ranked = sorted(roots.items(), key=lambda kv: kv[1]["rank"])
    top100 = [r for r, _rec in ranked[:100]]
    pin_path = os.path.join(HERE, "PINNED_TOP100.json")
    if "--pin" in argv or not os.path.isfile(pin_path):
        with open(pin_path, "w", encoding="utf-8") as fh:
            json.dump(top100, fh, ensure_ascii=False, indent=1)
        print(f"wrote pin file {pin_path} ({len(top100)} roots) -- re-run without --pin to check against it.")
    else:
        with open(pin_path, encoding="utf-8") as fh:
            pinned = json.load(fh)
        if pinned != top100:
            added = [r for r in top100 if r not in pinned]
            dropped = [r for r in pinned if r not in top100]
            failures.append(f"top-100 root list drifted from the pin: +{added} -{dropped}"
                             if (added or dropped) else "top-100 root ORDER drifted (same set, different rank order)")
        else:
            print(f"OK: top-100 root list matches the pin ({len(top100)} roots).")

    # ---- 2. 6-root spot-check (10-root acceptance bullet: the 6 + 4 more high-rank roots) ----
    high_rank_extra = [r for r, _rec in sorted(roots.items(), key=lambda kv: kv[1]["rank"])
                        if r not in SIX_ROOTS][:4]
    spot_roots = SIX_ROOTS + high_rank_extra
    for root in spot_roots:
        if root not in roots:
            failures.append(f"spot-check: √{root} missing entirely from paradigm_attested.json")
            continue
        have = root_all_forms(roots[root])
        if not have:
            failures.append(f"spot-check: √{root} has zero attested forms in either finite or nonfinite -- "
                             "an admitted root must show at least one real corpus form.")
        for form in SIX_ROOT_SPOT_FORMS.get(root, []):
            if form not in have:
                failures.append(f"6-root spot-check: √{root} form {form!r} (known-attested, DCS form-id in "
                                 "sanskrit_pxn_v4.html's FID map) not found in scaled attested data")
    print(f"OK: {len(spot_roots)}-root spot-check ran ({', '.join('√'+r for r in spot_roots)}).")

    # ---- 3. never-fabricate-class discipline ----
    class_re = re.compile(r"\bclass\s*[IVX0-9]", re.IGNORECASE)
    bad = []
    for root, rec in roots.items():
        blob = json.dumps(rec, ensure_ascii=False)
        if class_re.search(blob):
            bad.append(root)
    if bad:
        failures.append(f"class-number discipline violated for {len(bad)} roots (sample: {bad[:5]}) -- "
                         "no root record may claim a Panini class number (DCS cannot resolve I/VI or IV/passive).")
    else:
        print(f"OK: no root record claims a Panini class number ({len(roots)} roots checked).")

    # ---- 4. past-tense re-split contract (H1486 -> H2294) ----
    all_cats = set()
    for rec in roots.values():
        all_cats.update(rec.get("finite", {}).keys())
    merged = sorted(c for c in all_cats if "Perfect/Aorist" in c)
    if merged:
        failures.append(f"the merged pre-H2294 label is still emitted: {merged} -- "
                         "gen_paradigm_attested.py must apply past_class() per token, not read "
                         "the (Tense,Voice,Mood)-keyed ud_to_category label (a re-run alone "
                         "reproduces the merged bucket verbatim).")
    else:
        print("OK: no 'Perfect/Aorist' merged category remains.")

    evidence = d.get("cellEvidence")
    if not evidence:
        failures.append("cellEvidence missing from dataset root -- the bound on the past-tense "
                         "split must ship WITH the data. A consumer cannot tell an inferred "
                         "'Perfect' cell from an attested 'Aorist' one without it.")
    else:
        past_cats = sorted(c for c in all_cats
                            if c.startswith(("Aorist ", "Perfect ", "Periphrastic Perfect ")))
        if not past_cats:
            failures.append("no split past-indicative category (Aorist/Perfect/Periphrastic "
                             "Perfect) present at all -- the H1486 re-split did not propagate.")
        for cat in past_cats:
            verdict = evidence.get(cat)
            if verdict not in ("formation-attested", "defaulted"):
                failures.append(f"past category {cat!r} carries no cellEvidence verdict "
                                 f"(got {verdict!r}) -- every split category must declare "
                                 "whether it was read off feat_formation or defaulted.")
            elif cat.startswith("Perfect ") and verdict != "defaulted":
                failures.append(f"{cat!r} is marked {verdict!r}, but 'Perfect' IS the untagged "
                                 "residue (feat_formation IS NULL) and can only ever be "
                                 "'defaulted'. Marking it attested would present an assumption "
                                 "to a learner as an attestation.")
            elif cat.startswith(("Aorist ", "Periphrastic Perfect ")) and verdict != "formation-attested":
                failures.append(f"{cat!r} is marked {verdict!r}, but it is read directly off "
                                 "feat_formation and must be 'formation-attested'.")
        if not [f for f in failures if "cellEvidence" in f or "past category" in f]:
            print(f"OK: past-split evidence contract holds for {len(past_cats)} categories "
                  f"({', '.join(past_cats)}).")
    if not d.get("cellEvidenceNote"):
        failures.append("cellEvidenceNote missing -- the defaulted/attested distinction must "
                         "ship with a prose explanation, not just a bare enum.")

    if d.get("ceilingNote", "") == "":
        failures.append("ceilingNote missing from dataset root -- the I/VI, IV/passive, Tense=Past "
                         "caveat must always ship with the data, not just in docs.")
    else:
        print("OK: ceilingNote present in dataset root.")

    if failures:
        print(f"\n{len(failures)} FAILURE(S):", file=sys.stderr)
        for f in failures:
            print(f"  - {f}", file=sys.stderr)
        sys.exit(1)
    print(f"\nAll checks passed. {d['rootCount']} roots, tier full={sum(1 for r in roots.values() if r['tier']=='full')}.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
