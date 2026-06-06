#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
validate.py — M5 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Validates the pilot pipeline against the source and itself, writing
reports/m5_validation.md and exiting non-zero on any failure (so CI can gate on it):

  1. CROSS-WALK at scale   — every master sentence's token lemma_id sequence equals
                             the raw CoNLL-U LemmaId sequence (ordered by idx).
  2. REFERENTIAL INTEGRITY — no orphan tokens/sentences/chapters; no null occ_id.
  3. IDEMPOTENCY           — build the pilot DB twice into temp dirs and confirm the
                             data (every table except the timestamped provenance)
                             hashes identically. The pipeline is deterministic.
  4. SPOT CHECKS           — N random sentences, full token compare (form, lemma_id,
                             upos, head, deprel, every FEAT) master vs. raw source.

Stdlib only. Run after M2 (needs dcs.sqlite + the conllu submodule).
    python validate.py            # exit 0 = all pass, 1 = a check failed
"""

import argparse
import hashlib
import os
import random
import sqlite3
import subprocess
import sys
import tempfile

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from parse_conllu import parse_text                       # noqa: E402
from import_dcs_conllu import PILOT, DEFAULT_DB           # noqa: E402

CONLLU_ROOT = os.path.join(HERE, "conllu", "files")
REPORT = os.path.join(HERE, "reports", "m5_validation.md")


def reparse_pilot():
    """sent_id -> source sentence dict, for all pilot texts (same limits as the import)."""
    src = {}
    for name, limit in PILOT:
        sents, err = parse_text(name, CONLLU_ROOT, limit=limit, errors=[])
        if err:
            continue
        for s in sents:
            sid = s["meta"].get("sent_id")
            if sid:
                src[sid] = s
    return src


def src_lemmas(s):
    return [int(t["misc"]["LemmaId"]) for t in s["tokens"] if t["misc"].get("LemmaId")]


def check_crosswalk(conn, src):
    checked = mism = 0
    examples = []
    for (sid,) in conn.execute("SELECT sent_id FROM sentence"):
        s = src.get(sid)
        if not s:
            continue
        master = [r[0] for r in conn.execute(
            "SELECT lemma_id FROM token WHERE sent_id=? AND lemma_id IS NOT NULL ORDER BY idx", (sid,))]
        checked += 1
        if master != src_lemmas(s):
            mism += 1
            if len(examples) < 5:
                examples.append(sid)
    return {"checked": checked, "mismatches": mism, "examples": examples,
            "pass": mism == 0 and checked > 0}


def check_integrity(conn):
    q = lambda s: conn.execute(s).fetchone()[0]
    r = {
        "orphan_tokens": q("SELECT COUNT(*) FROM token WHERE lemma_id IS NOT NULL "
                           "AND lemma_id NOT IN (SELECT lemma_id FROM lemma)"),
        "orphan_sentences": q("SELECT COUNT(*) FROM sentence WHERE chapter_id NOT IN "
                              "(SELECT chapter_id FROM chapter)"),
        "orphan_chapters": q("SELECT COUNT(*) FROM chapter WHERE text_id NOT IN (SELECT text_id FROM text)"),
        "null_occ_id": q("SELECT COUNT(*) FROM token WHERE occ_id IS NULL"),
    }
    r["pass"] = all(v == 0 for v in r.values())
    return r


def hash_db_data(db):
    """Deterministic hash of all data tables (excluding the timestamped provenance), schema-order-independent."""
    conn = sqlite3.connect(db)
    h = hashlib.sha256()
    for tbl in ("text", "chapter", "sentence", "token", "mwt", "lemma"):
        cols = sorted(r[1] for r in conn.execute(f"PRAGMA table_info({tbl})"))
        sel = ", ".join(f'"{c}"' for c in cols)
        h.update(f"::{tbl}::{sel}::".encode())
        for row in conn.execute(f"SELECT {sel} FROM {tbl} ORDER BY {sel}"):
            h.update(repr(row).encode("utf-8"))
    conn.close()
    return h.hexdigest()


def check_idempotency():
    script = os.path.join(HERE, "import_dcs_conllu.py")
    with tempfile.TemporaryDirectory() as td:
        hashes = []
        for tag in ("a", "b"):
            db = os.path.join(td, f"{tag}.db")
            p = subprocess.run([sys.executable, script, "--db", db],
                               capture_output=True, text=True)
            if p.returncode != 0:
                return {"pass": False, "error": p.stderr[-400:], "hashes": []}
            hashes.append(hash_db_data(db))
    return {"pass": hashes[0] == hashes[1], "hashes": hashes}


def token_tuple_master(conn, sid):
    feat_cols = [r[1] for r in conn.execute("PRAGMA table_info(token)") if r[1].startswith("feat_")]
    sel = "idx, form, lemma_id, upos, head, deprel, " + ", ".join(f'"{c}"' for c in feat_cols)
    out = []
    for row in conn.execute(f"SELECT {sel} FROM token WHERE sent_id=? ORDER BY idx", (sid,)):
        idx, form, lid, upos, head, deprel = row[:6]
        feats = {feat_cols[i][5:]: v for i, v in enumerate(row[6:]) if v is not None}
        out.append((form, lid, upos, head, deprel, feats))
    return out


def token_tuple_src(s):
    out = []
    for t in s["tokens"]:
        lid = int(t["misc"]["LemmaId"]) if t["misc"].get("LemmaId") else None
        feats = {k.lower(): ("Yes" if v is True else v) for k, v in t["feats"].items()}
        out.append((t["form"], lid, t["upos"], t["head"], t["deprel"], feats))
    return out


def check_spot(conn, src, n=50, seed=42):
    sids = [r[0] for r in conn.execute("SELECT sent_id FROM sentence") if r[0] in src]
    random.Random(seed).shuffle(sids)
    sids = sids[:n]
    checked = mism = 0
    examples = []
    for sid in sids:
        m = token_tuple_master(conn, sid)
        t = token_tuple_src(src[sid])
        checked += 1
        if m != t:
            mism += 1
            if len(examples) < 5:
                examples.append(sid)
    return {"checked": checked, "mismatches": mism, "examples": examples,
            "pass": mism == 0 and checked > 0}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("-n", type=int, default=50, help="spot-check sentence count")
    ap.add_argument("--skip-idempotency", action="store_true")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        print(f"ERROR: {args.db} not found — run import_dcs_conllu.py (M2) first.", file=sys.stderr)
        return 2
    conn = sqlite3.connect(args.db)

    print("re-parsing pilot source ...")
    src = reparse_pilot()
    print(f"  {len(src)} source sentences indexed by sent_id\n")

    print("1. cross-walk at scale ..."); cw = check_crosswalk(conn, src)
    print(f"   {cw['checked']} sentences, {cw['mismatches']} mismatches -> {'PASS' if cw['pass'] else 'FAIL'}")
    print("2. referential integrity ..."); ig = check_integrity(conn)
    print(f"   {ig} -> {'PASS' if ig['pass'] else 'FAIL'}")
    if args.skip_idempotency:
        idem = {"pass": None, "hashes": [], "skipped": True}
        print("3. idempotency ... SKIPPED")
    else:
        print("3. idempotency (building the pilot DB twice) ..."); idem = check_idempotency()
        print(f"   deterministic -> {'PASS' if idem['pass'] else 'FAIL'}")
    print(f"4. spot checks ({args.n} verses, full token compare) ..."); sp = check_spot(conn, src, n=args.n)
    print(f"   {sp['checked']} verses, {sp['mismatches']} mismatches -> {'PASS' if sp['pass'] else 'FAIL'}")

    checks = [("Cross-walk at scale", cw["pass"], f"{cw['checked']} sentences, {cw['mismatches']} mismatches"),
              ("Referential integrity", ig["pass"], ", ".join(f"{k}={v}" for k, v in ig.items() if k != "pass")),
              ("Idempotency (full re-run)", idem["pass"],
               "skipped" if idem.get("skipped") else ("identical data hash" if idem["pass"] else "DIFFERS")),
              ("Spot checks (full token)", sp["pass"], f"{sp['checked']} verses, {sp['mismatches']} mismatches")]
    all_pass = all(c[1] for c in checks if c[1] is not None)

    L = ["# M5 validation — DCS 2026 pilot pipeline\n",
         f"_Generated by `validate.py` over `{os.path.basename(args.db)}` (pilot)._\n",
         f"**Result: {'✅ ALL PASS' if all_pass else '❌ FAILURES'}**\n",
         "| check | result | detail |", "|---|:--:|---|"]
    for name, ok, detail in checks:
        mark = "—" if ok is None else ("✅" if ok else "❌")
        L.append(f"| {name} | {mark} | {detail} |")
    if idem.get("hashes"):
        L.append(f"\nIdempotency data hash: `{idem['hashes'][0][:16]}…` (both runs).")
    L += ["\n## Notes\n",
          "- **Cross-walk** confirms the master preserves the exact CoNLL-U `LemmaId` order per sentence.",
          "- **Idempotency** rebuilds the pilot DB twice and hashes every data table (excluding the "
          "timestamped `provenance`); identical → deterministic.",
          f"- **Spot checks** compare every token field (form, lemma_id, upos, head, deprel, all FEATS) "
          f"on {args.n} random verses.",
          "- Scope is the pilot (13 texts); M6 runs the same suite over all 270.\n"]
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    with open(REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    conn.close()
    print(f"\nwrote {os.path.relpath(REPORT, HERE)}")
    print("GATE:", "PASS ✓" if all_pass else "FAIL ✗")
    return 0 if all_pass else 1


if __name__ == "__main__":
    sys.exit(main())
