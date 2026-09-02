#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""test_past_nonindicative_formation.py — guards the H3878 verdict.

H3878 asked whether the 8,726 `Tense=Past` Jus/Imp/Sub/Opt/Prec tokens lack a formation
tag because DCS never assigns one (upstream limit) or because our predicate hides it
(query gap). The auditor answered UPSTREAM ANNOTATION LIMIT and closed the question as an
evidence-backed NO-GO. Two things can silently un-answer it later, so both are tested here:

  1. **The instrument.** `audit_past_nonindicative_formation.py` runs over the pinned
     1.2 GB corpus, which no CI box has. So the census functions are re-run against a
     committed fixture of REAL corpus sentences instead — if the scanner stops seeing
     `Formation`, stops skipping multiword range lines, or starts counting future `peri`
     as past evidence, that shows up here rather than in a report nobody regenerates.
  2. **The verdict.** The committed JSON report is checked for internal consistency —
     the mood partition still sums to the past universe, the non-indicative bucket is
     still 8,726 with zero tags, and the indicative bucket still matches H1486's
     93,329 / 16,100. A hand-edit or a stale regeneration fails the run.

What is deliberately NOT asserted: the A3 recoverability percentages. They are a
measurement over the corpus, not a contract, and pinning them would turn a future corpus
bump into a red test instead of a new number.

    python src/DCS-data-2026/test_past_nonindicative_formation.py
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

from audit_past_nonindicative_formation import (  # noqa: E402
    GUARDED_FORMATIONS,
    NONIND_MOODS,
    a3_recoverability,
    scan_corpus,
    verdict,
)
from regen_widgets import AORIST_FORMATIONS, is_past_indicative  # noqa: E402

FIXTURE = os.path.join(HERE, "fixtures", "past_nonindicative_formation.conllu")
REPORT_JSON = os.path.join(HERE, "reports", "past_nonindicative_formation_audit.json")

# H1486's committed figures. The audit must reproduce them exactly or one of the two
# reports is stale — that disagreement is the thing worth catching.
H1486_BUCKET = 93329
H1486_TAGGED = 16100
BASELINE_NONIND = 8726

failures = []


def check(cond, msg):
    if cond:
        print(f"  ok   {msg}")
    else:
        failures.append(msg)
        print(f"  FAIL {msg}")
    return cond


# -- 1. The scanner, against real sentences ------------------------------------------
print("1. Scanner over the committed fixture...")
check(os.path.exists(FIXTURE), f"fixture present: {os.path.relpath(FIXTURE, HERE)}")
scan = scan_corpus(os.path.dirname(FIXTURE))

cases = set()
with open(FIXTURE, encoding="utf-8") as fh:
    for line in fh:
        if line.startswith("# fixture-case:"):
            cases.add(line.split(":", 1)[1].strip())
check(len(cases) == 14, f"fixture covers 14 branches (found {len(cases)})")

# Every non-indicative mood is represented, and every one of them is untagged — the
# fixture would not be able to detect a regression on a mood it never carries.
for mood in NONIND_MOODS:
    n = sum(scan["past"].get((mood, tagged), 0) for tagged in (True, False))
    check(n > 0, f"fixture carries {mood} past tokens ({n})")
    check(scan["past"].get((mood, True), 0) == 0,
          f"no {mood} token is formation-tagged (the whole finding)")

# Every past formation the aorist rule covers, plus `peri`, is attested in the fixture,
# so a scanner that stopped reading FEATS could not pass by finding nothing.
past_values = {k[0] for k in scan["values"] if k[1] == "Past"}
check(past_values == GUARDED_FORMATIONS,
      f"fixture attests every guarded past formation: {sorted(past_values)}")
check(set(AORIST_FORMATIONS) <= past_values, "aorist formations all present")

# The trap: `peri` on Tense=Fut is the periphrastic FUTURE and must never be summed with
# the periphrastic perfect (H1486). The census is tense-keyed, so the two stay apart.
fut_peri = sum(n for k, n in scan["values"].items() if k[0] == "peri" and k[1] == "Fut")
past_peri = sum(n for k, n in scan["values"].items() if k[0] == "peri" and k[1] == "Past")
check(fut_peri > 0 and past_peri > 0,
      f"both senses of `peri` present (Fut {fut_peri}, Past {past_peri})")
check(all(k[1] is not None for k in scan["values"]),
      "every Formation occurrence is keyed by a tense, never by the bare value")

# The verdict function itself: on this fixture, as on the corpus, no Formation may occur
# outside Mood=Ind. If it ever does, the function must say QUERY GAP.
v, offenders = verdict(scan)
check(v == "UPSTREAM ANNOTATION LIMIT", f"fixture verdict is {v}")
check(not offenders, "no Formation occurrence outside Mood=Ind in the fixture")

# Multiword range lines (`2-4`) and empty nodes carry no morphology; counting them would
# double-count the tokens they expand to.
with open(FIXTURE, encoding="utf-8") as fh:
    ranges = sum(1 for ln in fh
                 if ln[:1].isdigit() and "-" in ln.split("\t")[0])
check(ranges > 0, f"fixture exercises multiword range lines ({ranges} of them)")

# is_past_indicative is IMPORTED, never restated — this asserts the import is live.
check(is_past_indicative("Past", "Ind", None) is True, "is_past_indicative accepts finite past Ind")
check(is_past_indicative("Past", "Jus", None) is False, "is_past_indicative rejects Jus")
check(is_past_indicative("Past", "Ind", "Part") is False, "is_past_indicative rejects participles")

# A3 must run and must not invent recoverability out of an empty match set.
a3 = a3_recoverability(scan)
check(a3["strict"] <= a3["recoverable"] <= a3["total"],
      f"A3 counts nest correctly ({a3['strict']} <= {a3['recoverable']} <= {a3['total']})")

# -- 2. The committed report, for internal consistency --------------------------------
print("2. Committed report...")
check(os.path.exists(REPORT_JSON), "report JSON present")
with open(REPORT_JSON, encoding="utf-8") as fh:
    rep = json.load(fh)

check(rep["verdict"] == "UPSTREAM ANNOTATION LIMIT",
      f"report verdict is {rep['verdict']}")

part = rep["past_partition"]
nonind = {m: part[m] for m in NONIND_MOODS if m in part}
check(len(nonind) == len(NONIND_MOODS), "all five non-indicative moods in the report")

total_nonind = sum(b["tokens"] for b in nonind.values())
check(total_nonind == BASELINE_NONIND == rep["nonindicative_total"],
      f"baseline reproduced: {total_nonind:,} non-indicative past tokens")
check(all(b["tagged"] == 0 for b in nonind.values()) and rep["nonindicative_tagged"] == 0,
      "zero formation tags across all five non-indicative moods")

ind = part["Ind (finite)"]
check(ind["tokens"] == H1486_BUCKET, f"H1486 bucket unchanged: {ind['tokens']:,}")
check(ind["tagged"] == H1486_TAGGED, f"H1486 tag count unchanged: {ind['tagged']:,}")

# Denominator closure: the mood partition must exhaust the past universe, and the tagged
# rows must exhaust the tags. H1472 lost 8,542 tokens to exactly this kind of gap.
check(sum(b["tokens"] for b in part.values()) == rep["past_universe"],
      f"mood partition closes on {rep['past_universe']:,} Tense=Past tokens")
check(sum(b["tagged"] for b in part.values()) == rep["past_tagged"] == H1486_TAGGED,
      "every past-tense formation tag lands in the indicative bucket")

# The report's own census must agree that Formation never leaves Mood=Ind — the claim the
# whole handoff turns on, re-checked against the artifact rather than the code path. Keys
# are flattened `UPOS|Tense|Mood|VerbForm` so the JSON stays a plain object.
rows = [k.split("|") for k in rep["census"]]
check(all(r[2] == "Ind" for r in rows), "report census: no Formation row outside Mood=Ind")
check(all(r[1] in ("Past", "Fut") for r in rows), "report census: Formation only on Past and Fut")
check(all(r[0] == "VERB" and r[3] == "None" for r in rows),
      "report census: Formation only on finite VERB, never a participle")
check(not rep["census_offenders"], "report records no census offenders")
check(sum(n for k, n in rep["census"].items() if k.split("|")[1] == "Past") == H1486_TAGGED,
      f"report census sums to the {H1486_TAGGED:,} past tags")

print()
if failures:
    print(f"FAILED — {len(failures)} check(s):")
    for f in failures:
        print(f"  - {f}")
    sys.exit(1)
print("All checks passed.")
