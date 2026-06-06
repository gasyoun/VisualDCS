#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
validate.py — M5/M6 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Validates the master against the source and itself, writing a report and exiting
non-zero on any failure (so CI can gate on it):

  1. CROSS-WALK   — every sentence's token lemma_id sequence equals the raw CoNLL-U
                    LemmaId sequence. Aligned by POSITION (i-th sentence of each text),
                    because the corpus reuses sent_id even within a chapter — so the
                    master keys sentences by a synthetic id, not sent_id.
  2. INTEGRITY    — no orphan tokens/sentences/chapters (incl. token -> sentence FK).
  3. IDEMPOTENCY  — (pilot only) build the DB twice -> identical data hash.
  4. SPOT CHECKS  — N random sentences, full token compare (form, lemma_id, upos,
                    head, deprel, all FEATS) master vs. raw source.
  5. COVERAGE     — (--all) master texts/lemmas/tokens vs. the upstream corpus.

Stdlib only. Run after the import (needs the master DB + the conllu submodule).
    python validate.py                                     # pilot master
    python validate.py --all --db dcs_full.sqlite -n 200   # full master
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


def src_lemmas(s):
    return [int(t["misc"]["LemmaId"]) for t in s["tokens"] if t["misc"].get("LemmaId")]


def token_tuple_src(s):
    out = []
    for t in s["tokens"]:
        lid = int(t["misc"]["LemmaId"]) if t["misc"].get("LemmaId") else None
        feats = {k.lower(): ("Yes" if v is True else v) for k, v in t["feats"].items()}
        out.append((t["form"], lid, t["upos"], t["head"], t["deprel"], feats))
    return out


def feat_cols(conn):
    return [r[1] for r in conn.execute("PRAGMA table_info(token)") if r[1].startswith("feat_")]


def master_text_lemmas(conn, text_id):
    """Ordered [(sentence_id, [lemma_ids])] for one text (light — ids + lemma seqs only)."""
    out, cur, lem = [], None, []
    for sid, lid in conn.execute(
            """SELECT s.id, t.lemma_id FROM sentence s
               LEFT JOIN token t ON t.sentence_id = s.id
               JOIN chapter ch ON s.chapter_id = ch.chapter_id
               WHERE ch.text_id = ? ORDER BY s.id, t.idx""", (text_id,)):
        if sid != cur:
            if cur is not None:
                out.append((cur, lem))
            cur, lem = sid, []
        if lid is not None:
            lem.append(lid)
    if cur is not None:
        out.append((cur, lem))
    return out


def master_tuple(conn, sentence_id, fcols):
    """Full token tuples for one sentence (for the spot sample)."""
    sel = "form, lemma_id, upos, head, deprel, " + ", ".join(f'"{c}"' for c in fcols)
    out = []
    for row in conn.execute(f"SELECT {sel} FROM token WHERE sentence_id=? ORDER BY idx", (sentence_id,)):
        feats = {fcols[i][5:]: v for i, v in enumerate(row[5:]) if v is not None}
        out.append((row[0], row[1], row[2], row[3], row[4], feats))
    return out


def validate_texts(conn, root, plan, n_spot, seed=42):
    """Position-based cross-walk + reservoir-sampled full-token spot over a (name, limit) plan."""
    rng = random.Random(seed)
    cw_checked = cw_mism = 0
    cw_ex, reservoir = [], []
    for name, limit in plan:
        sents, err = parse_text(name, root, limit=limit, errors=[])
        if err or not sents:
            continue
        tid = sents[0]["doc"].get("text_id")
        if not (tid and tid.isdigit()):
            continue
        mlem = master_text_lemmas(conn, int(tid))
        for i, s in enumerate(sents):
            cw_checked += 1
            msid, m_seq = (mlem[i] if i < len(mlem) else (None, None))
            if m_seq != src_lemmas(s):
                cw_mism += 1
                if len(cw_ex) < 5:
                    cw_ex.append(f"{name}[{i}] sent_id={s['meta'].get('sent_id')}")
            if msid is not None:
                item = (msid, token_tuple_src(s))
                if len(reservoir) < n_spot:
                    reservoir.append(item)
                else:
                    j = rng.randint(0, cw_checked - 1)
                    if j < n_spot:
                        reservoir[j] = item
    fcols = feat_cols(conn)
    sp_mism, sp_ex = 0, []
    for msid, srctup in reservoir:
        if master_tuple(conn, msid, fcols) != srctup:
            sp_mism += 1
            if len(sp_ex) < 5:
                sp_ex.append(msid)
    cw = {"checked": cw_checked, "mismatches": cw_mism, "examples": cw_ex,
          "pass": cw_mism == 0 and cw_checked > 0}
    sp = {"checked": len(reservoir), "mismatches": sp_mism, "examples": sp_ex,
          "pass": sp_mism == 0 and len(reservoir) > 0}
    return cw, sp


def check_integrity(conn):
    q = lambda s: conn.execute(s).fetchone()[0]
    r = {
        "orphan_tokens_lemma": q("SELECT COUNT(*) FROM token WHERE lemma_id IS NOT NULL "
                                 "AND lemma_id NOT IN (SELECT lemma_id FROM lemma)"),
        "orphan_tokens_sent": q("SELECT COUNT(*) FROM token WHERE sentence_id NOT IN (SELECT id FROM sentence)"),
        "orphan_sentences": q("SELECT COUNT(*) FROM sentence WHERE chapter_id NOT IN "
                              "(SELECT chapter_id FROM chapter)"),
        "orphan_chapters": q("SELECT COUNT(*) FROM chapter WHERE text_id NOT IN (SELECT text_id FROM text)"),
    }
    r["pass"] = all(v == 0 for v in r.values())
    return r


def check_coverage(conn, root):
    folders = sum(1 for x in os.listdir(root) if os.path.isdir(os.path.join(root, x)))
    texts = conn.execute("SELECT COUNT(*) FROM text").fetchone()[0]
    lemmas = conn.execute("SELECT COUNT(DISTINCT lemma_id) FROM token WHERE lemma_id IS NOT NULL").fetchone()[0]
    toks = conn.execute("SELECT COUNT(*) FROM token").fetchone()[0]
    return {"corpus_folders": folders, "master_texts": texts, "distinct_lemmas": lemmas,
            "tokens": toks, "pass": texts >= folders * 0.98}


def hash_db_data(db):
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
            p = subprocess.run([sys.executable, script, "--db", db], capture_output=True, text=True)
            if p.returncode != 0:
                return {"pass": False, "error": p.stderr[-400:], "hashes": []}
            hashes.append(hash_db_data(db))
    return {"pass": hashes[0] == hashes[1], "hashes": hashes}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=DEFAULT_DB)
    ap.add_argument("-n", type=int, default=50, help="spot-check sentence count")
    ap.add_argument("--skip-idempotency", action="store_true")
    ap.add_argument("--all", action="store_true", help="validate the FULL master (all texts)")
    args = ap.parse_args()

    if not os.path.exists(args.db):
        print(f"ERROR: {args.db} not found — run import_dcs_conllu.py first.", file=sys.stderr)
        return 2
    conn = sqlite3.connect(args.db)

    plan = ([(d, None) for d in sorted(os.listdir(CONLLU_ROOT))
             if os.path.isdir(os.path.join(CONLLU_ROOT, d))] if args.all else PILOT)
    print(f"validating {'FULL (all texts)' if args.all else 'PILOT'} master: {os.path.basename(args.db)}\n")

    checks = []
    if args.all:
        cov = check_coverage(conn, CONLLU_ROOT)
        print(f"0. coverage: {cov['master_texts']} texts / {cov['distinct_lemmas']} lemmas / "
              f"{cov['tokens']} tokens (folders={cov['corpus_folders']}) -> {'PASS' if cov['pass'] else 'FAIL'}")
        checks.append(("Coverage vs upstream", cov["pass"],
                       f"{cov['master_texts']} texts / {cov['distinct_lemmas']:,} lemmas / {cov['tokens']:,} tokens"))

    print("1+4. cross-walk + spot (position-based, per-text) ...")
    cw, sp = validate_texts(conn, CONLLU_ROOT, plan, n_spot=args.n)
    print(f"   cross-walk: {cw['checked']:,} sentences, {cw['mismatches']} mismatches -> {'PASS' if cw['pass'] else 'FAIL'}")
    print(f"   spot: {sp['checked']} verses, {sp['mismatches']} mismatches -> {'PASS' if sp['pass'] else 'FAIL'}")
    for e in cw["examples"]:
        print(f"     mismatch: {e}")

    print("2. referential integrity ..."); ig = check_integrity(conn)
    print(f"   {ig} -> {'PASS' if ig['pass'] else 'FAIL'}")

    if args.all or args.skip_idempotency:
        idem = {"pass": None, "skipped": True}
        print("3. idempotency ... SKIPPED" + (" (full scale)" if args.all else ""))
    else:
        print("3. idempotency (building the pilot DB twice) ..."); idem = check_idempotency()
        print(f"   deterministic -> {'PASS' if idem['pass'] else 'FAIL'}")

    checks += [("Cross-walk at scale", cw["pass"], f"{cw['checked']:,} sentences, {cw['mismatches']} mismatches"),
               ("Referential integrity", ig["pass"], ", ".join(f"{k}={v}" for k, v in ig.items() if k != "pass")),
               ("Idempotency (full re-run)", idem["pass"],
                "skipped" if idem.get("skipped") else ("identical data hash" if idem["pass"] else "DIFFERS")),
               ("Spot checks (full token)", sp["pass"], f"{sp['checked']} verses, {sp['mismatches']} mismatches")]
    all_pass = all(c[1] for c in checks if c[1] is not None)

    scope = "full corpus (all 270 texts)" if args.all else "pilot pipeline (13 texts)"
    milestone = "M6" if args.all else "M5"
    report_path = os.path.join(HERE, "reports", "m6_validation.md" if args.all else "m5_validation.md")
    L = [f"# {milestone} validation — DCS 2026 {scope}\n",
         f"_Generated by `validate.py` over `{os.path.basename(args.db)}`._\n",
         f"**Result: {'✅ ALL PASS' if all_pass else '❌ FAILURES'}**\n",
         "| check | result | detail |", "|---|:--:|---|"]
    for name, ok, detail in checks:
        mark = "—" if ok is None else ("✅" if ok else "❌")
        L.append(f"| {name} | {mark} | {detail} |")
    if not args.all and idem.get("hashes"):
        L.append(f"\nIdempotency data hash: `{idem['hashes'][0][:16]}…` (both runs).")
    L += ["\n## Notes\n",
          "- **Cross-walk** is **position-based** (i-th sentence of each text) — the corpus reuses "
          "`sent_id` even within a chapter, so it is not a key; the master keys sentences by a synthetic id.",
          "- **Spot checks** compare every token field (form, lemma_id, upos, head, deprel, all FEATS).",
          f"- Scope: {scope}.\n"]
    os.makedirs(os.path.dirname(report_path), exist_ok=True)
    with open(report_path, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    conn.close()
    print(f"\nwrote {os.path.relpath(report_path, HERE)}")
    print("GATE:", "PASS ✓" if all_pass else "FAIL ✗")
    return 0 if all_pass else 1


if __name__ == "__main__":
    sys.exit(main())
