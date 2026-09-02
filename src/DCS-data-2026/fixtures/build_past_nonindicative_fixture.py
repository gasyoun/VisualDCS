#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Extract real CoNLL-U sentences for the H3878 fixture.

Picks, from the pinned corpus, the smallest set of REAL sentences that exercises every
branch the auditor decides on:

  * one sentence per non-indicative past mood (Jus, Imp, Sub, Opt, Prec) -- untagged
  * one tagged past indicative per Formation value the aorist rule covers, plus `peri`
  * one `Tense=Fut` + `peri` sentence -- the tense-dependence trap (H1486)

Nothing is synthesised; every line is copied byte-for-byte from the distribution.

    python src/DCS-data-2026/fixtures/build_past_nonindicative_fixture.py \
        <conllu-root> src/DCS-data-2026/fixtures/past_nonindicative_formation.conllu
"""
import io
import os
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.stderr.reconfigure(encoding="utf-8", errors="replace")

NONIND = ("Jus", "Imp", "Sub", "Opt", "Prec")
PAST_FORMATIONS = ("root", "them", "red", "s", "is", "sis", "sa", "peri")


def feats(s):
    if s == "_":
        return {}
    return dict(kv.split("=", 1) for kv in s.split("|") if "=" in kv)


def sentences(path):
    buf = []
    with io.open(path, encoding="utf-8") as fh:
        for line in fh:
            if line.strip() == "":
                if buf:
                    yield buf
                    buf = []
            else:
                buf.append(line.rstrip("\n"))
    if buf:
        yield buf


def main():
    root, out = sys.argv[1], sys.argv[2]
    want = {f"nonind:{m}": None for m in NONIND}
    want.update({f"past:{f}": None for f in PAST_FORMATIONS})
    want["fut:peri"] = None

    for dirpath, _, names in os.walk(root):
        for name in sorted(names):
            if not name.endswith(".conllu"):
                continue
            path = os.path.join(dirpath, name)
            for sent in sentences(path):
                rows = []
                for line in sent:
                    if line.startswith("#"):
                        continue
                    p = line.split("\t")
                    if len(p) < 6 or "-" in p[0] or "." in p[0]:
                        continue
                    rows.append((p[3], feats(p[5])))
                if not rows or len(sent) > 30:
                    continue
                keys = []
                for upos, d in rows:
                    t, m, fo = d.get("Tense"), d.get("Mood"), d.get("Formation")
                    if t == "Past" and m in NONIND and fo is None:
                        keys.append(f"nonind:{m}")
                    if t == "Past" and m == "Ind" and fo:
                        keys.append(f"past:{fo}")
                    if t == "Fut" and fo == "peri":
                        keys.append("fut:peri")
                for k in keys:
                    if k in want and want[k] is None:
                        rel = os.path.relpath(path, root).replace(os.sep, "/")
                        want[k] = (k, rel, sent)
                if all(v is not None for v in want.values()):
                    dump(want, out, root)
                    return 0
    missing = [k for k, v in want.items() if v is None]
    print("MISSING:", missing)
    dump(want, out, root)
    return 1


def dump(want, out, root):
    L = [
        "# H3878 fixture -- real sentences from the Digital Corpus of Sanskrit (CC BY 4.0).",
        "# Source: gasyoun/dcs-conllu pin 04e0778d3dc971030229179e25eea043d06ff397.",
        "# Extracted verbatim by build_past_nonindicative_fixture.py; do not hand-edit -- each",
        "# block is one unmodified sentence, kept so the auditor's rules can be exercised",
        "# without the 1.2 GB corpus. `# fixture-case:` names the branch the block covers.",
        "",
    ]
    for key, v in want.items():
        if v is None:
            continue
        _, rel, sent = v
        L.append(f"# fixture-case: {key}")
        L.append(f"# fixture-source: {rel}")
        L.extend(sent)
        L.append("")
    with io.open(out, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(L))
    print(f"wrote {out} -- {sum(1 for v in want.values() if v)} cases")


if __name__ == "__main__":
    raise SystemExit(main())
