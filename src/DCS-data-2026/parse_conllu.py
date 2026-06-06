#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
parse_conllu.py — M1 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

A full, **lossless** CoNLL-U reader for the DCS distribution mounted at ./conllu/
(the gasyoun/dcs-conllu submodule). It parses each text into staging JSONL — one
JSON object per sentence — capturing everything:

  - document/chapter metadata  (## text / text_id / chapter / chapter_id)
  - sentence metadata          (# text / sent_id / sent_counter / sent_subcounter / …)
  - tokens: id, form, lemma, upos, xpos, feats{}, head, deprel, deps, misc{}
            (misc captured generically: LemmaId, OccId, Unsandhied,
             UnsandhiedReconstructed, WordSem, Annotator, IsMantra, Punctuation, …)
  - multiword-token spans (sandhi/compound) and empty nodes, if present
  - HEAD/DEPREL where populated (Vedic Treebank chapters, e.g. Ṛgveda)

Stdlib only. Output → ./staging/<TextName>.jsonl (gitignored). M2 loads the JSONL
into the SQLite master.

Usage:
    python parse_conllu.py                      # parse the gate set (small + treebank)
    python parse_conllu.py Meghadūta Ṛgveda     # named texts
    python parse_conllu.py Ṛgveda --limit 10    # first 10 chapter files only
    python parse_conllu.py --all                # every text under conllu/files (big!)
    python parse_conllu.py Meghadūta --no-write  # report only

Exit code 0 = zero column errors (gate pass), 1 = column errors, 2 = setup error.
"""

import argparse
import glob
import json
import os
import re
import sys
from collections import Counter

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_ROOT = os.path.join(HERE, "conllu", "files")
DEFAULT_OUT = os.path.join(HERE, "staging")
GATE_TEXTS = ["Meghadūta", "Ṛgveda"]   # a small morphological text + the Vedic treebank

DOC_META_RE = re.compile(r"^##\s*([^:]+):\s*(.*)$")
SENT_META_RE = re.compile(r"^#\s*([^=]+?)\s*=\s*(.*)$")


def parse_kv(field):
    """FEATS / MISC field -> dict ('_' -> {}). Bare flags map to True."""
    out = {}
    if field and field != "_":
        for kv in field.split("|"):
            if "=" in kv:
                k, v = kv.split("=", 1)
                out[k] = v
            elif kv:
                out[kv] = True
    return out


def parse_conllu_file(path, errors):
    """Yield sentence dicts from one .conllu chapter file."""
    doc = {}
    meta, tokens, mwt, empties = {}, [], [], []
    lineno = 0

    def flush():
        if tokens or meta:
            return {"doc": dict(doc), "meta": dict(meta),
                    "tokens": list(tokens), "mwt": list(mwt),
                    "empty_nodes": list(empties)}
        return None

    with open(path, "r", encoding="utf-8") as fh:
        for raw in fh:
            lineno += 1
            line = raw.rstrip("\n").rstrip("\r")
            if line.startswith("##"):                       # document/chapter metadata
                m = DOC_META_RE.match(line)
                if m:
                    doc[m.group(1).strip()] = m.group(2).strip()
            elif line.startswith("#"):                      # sentence metadata
                m = SENT_META_RE.match(line)
                if m:
                    meta[m.group(1).strip()] = m.group(2).strip()
            elif not line.strip():                          # sentence boundary
                s = flush()
                if s:
                    yield s
                meta, tokens, mwt, empties = {}, [], [], []
            else:                                           # token / MWT / empty-node row
                cols = line.split("\t")
                if len(cols) != 10:
                    errors.append(f"{os.path.basename(path)}:{lineno}: "
                                  f"{len(cols)} columns (expected 10)")
                    continue
                tid, form, lemma, upos, xpos, feats, head, deprel, deps, misc = cols
                if "-" in tid:                              # multiword-token span
                    mwt.append({"range": tid, "form": form, "misc": parse_kv(misc)})
                elif "." in tid:                            # empty node
                    empties.append({"id": tid, "form": form, "lemma": lemma,
                                    "upos": upos, "feats": parse_kv(feats),
                                    "misc": parse_kv(misc)})
                else:                                       # ordinary token
                    tokens.append({
                        "id": int(tid),
                        "form": form,
                        "lemma": (None if lemma == "_" else lemma),
                        "upos": (None if upos == "_" else upos),
                        "xpos": (None if xpos == "_" else xpos),
                        "feats": parse_kv(feats),
                        "head": (None if head == "_" else int(head)),
                        "deprel": (None if deprel == "_" else deprel),
                        "deps": (None if deps == "_" else deps),
                        "misc": parse_kv(misc),
                    })
        s = flush()
        if s:
            yield s


def parse_text(name, root, limit=None, errors=None):
    """Parse all chapter files of one text (sorted). Returns (sentences, error|None)."""
    folder = os.path.join(root, name)
    if os.path.isdir(folder):
        files = sorted(glob.glob(os.path.join(folder, "*.conllu")))
    elif os.path.isfile(name) and name.endswith(".conllu"):
        files = [name]
    else:
        return None, f"text not found under {root}: {name}"
    if limit:
        files = files[:limit]
    sents = []
    for f in files:
        for s in parse_conllu_file(f, errors):
            sents.append(s)
    return sents, None


def stats_for(sents):
    upos, feats_keys, misc_keys = Counter(), Counter(), Counter()
    n_tok = n_mwt = n_head = n_empty = 0
    for s in sents:
        n_mwt += len(s["mwt"])
        n_empty += len(s["empty_nodes"])
        for t in s["tokens"]:
            n_tok += 1
            upos[t["upos"]] += 1
            for k in t["feats"]:
                feats_keys[k] += 1
            for k in t["misc"]:
                misc_keys[k] += 1
            if t["head"] is not None:
                n_head += 1
    return {"sentences": len(sents), "tokens": n_tok, "mwt": n_mwt,
            "empty_nodes": n_empty, "head_populated": n_head,
            "upos": upos, "feats_keys": feats_keys, "misc_keys": misc_keys}


def write_jsonl(sents, out_dir, name):
    os.makedirs(out_dir, exist_ok=True)
    path = os.path.join(out_dir, name.replace("/", "_") + ".jsonl")
    with open(path, "w", encoding="utf-8") as fh:
        for s in sents:
            fh.write(json.dumps(s, ensure_ascii=False) + "\n")
    return path


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("texts", nargs="*", help="text folder names (default: gate set)")
    ap.add_argument("--conllu-root", default=DEFAULT_ROOT)
    ap.add_argument("--out", default=DEFAULT_OUT)
    ap.add_argument("--limit", type=int, default=None, help="first N chapter files per text")
    ap.add_argument("--all", action="store_true", help="parse every text under conllu/files")
    ap.add_argument("--no-write", action="store_true", help="report only; don't write JSONL")
    args = ap.parse_args()

    root = args.conllu_root
    if not os.path.isdir(root):
        print(f"ERROR: CoNLL-U root not found: {root}\n"
              f"Run: git submodule update --init src/DCS-data-2026/conllu", file=sys.stderr)
        return 2

    if args.all:
        texts = sorted(d for d in os.listdir(root) if os.path.isdir(os.path.join(root, d)))
    else:
        texts = args.texts or GATE_TEXTS

    all_errors, grand = [], Counter()
    print(f"CoNLL-U root: {root}")
    print(f"texts: {len(texts)}   output: {'(none)' if args.no_write else args.out}\n")
    for name in texts:
        errors = []
        sents, err = parse_text(name, root, limit=args.limit, errors=errors)
        if err:
            print(f"  [skip] {err}")
            continue
        st = stats_for(sents)
        all_errors += errors
        dm = sents[0]["doc"] if sents else {}
        print(f"■ {name}  (text_id={dm.get('text_id', '?')})")
        print(f"    sentences={st['sentences']}  tokens={st['tokens']}  "
              f"mwt={st['mwt']}  empty_nodes={st['empty_nodes']}")
        print(f"    HEAD populated: {st['head_populated']}/{st['tokens']} "
              f"-> {'TREEBANK (syntax)' if st['head_populated'] else 'morphological only'}")
        print(f"    UPOS: " + ", ".join(f"{k}={v}" for k, v in st['upos'].most_common(6)))
        print(f"    FEATS keys: " + ", ".join(sorted(st['feats_keys'])))
        print(f"    MISC keys:  " + ", ".join(sorted(st['misc_keys'])))
        print(f"    column errors: {len(errors)}")
        if not args.no_write:
            print(f"    -> {os.path.relpath(write_jsonl(sents, args.out, name), HERE)}")
        print()
        for k in ("sentences", "tokens", "mwt"):
            grand[k] += st[k]
        grand["head"] += st["head_populated"]

    print("=" * 64)
    print(f"TOTAL: {grand['sentences']} sentences · {grand['tokens']} tokens · "
          f"{grand['mwt']} MWT spans · {grand['head']} dependency arcs")
    print(f"COLUMN ERRORS: {len(all_errors)}  -> "
          + ("GATE PASS" if not all_errors else "GATE FAIL"))
    for e in all_errors[:20]:
        print("  " + e)
    return 0 if not all_errors else 1


if __name__ == "__main__":
    sys.exit(main())
