#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
compare_dcs_formats.py — compare the two distributions of the Digital Corpus of
Sanskrit (DCS):

  1. The **relational-database export** in this folder (the ~2021 dump): normalized
     tables linked by integer IDs — `0.csv` (sentences), `10.csv` (word analyses),
     `_8.csv` (lemma frequencies), `12.csv`/`15.csv` (verbal forms), ...
  2. The current **CoNLL-U** distribution:
     https://github.com/OliverHellwig/sanskrit/tree/master/dcs/data/conllu
     one file per text/chapter, one token per line, 10 tab-separated columns,
     Universal-Dependencies morphology in FEATS, DCS IDs in MISC.

The script parses the first record of the relational `0.csv` and a bundled real
CoNLL-U file for the SAME text (Abhidhānacintāmaṇi, chapter "AbhCint, 1"), then:

  * summarises the structure of each format,
  * demonstrates the **ID cross-walk**: the integer list stored per sentence in
    `0.csv` is exactly the sequence of `LemmaId=` values in the CoNLL-U `MISC`
    column — i.e. both serialisations share the same DCS lemma IDs,
  * reports aggregate stats over the CoNLL-U sample (tokens, multiword spans,
    UPOS / FEATS inventory, how much of the dependency layer is populated).

Stdlib only. Run from anywhere:

    python compare_dcs_formats.py
    python compare_dcs_formats.py --rel . --conllu sample_conllu/Abhidhanacintamani-AbhCint-1.conllu

Findings are written up in DCS_FORMAT_COMPARISON.md.
"""

import argparse
import os
import sys
import unicodedata
from collections import Counter

# Windows / console-encoding safety (see ../../CLAUDE.md).
try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_CONLLU = os.path.join(HERE, "sample_conllu",
                              "Abhidhanacintamani-AbhCint-1.conllu")


# --------------------------------------------------------------------------- #
# Relational side
# --------------------------------------------------------------------------- #
def is_lfs_pointer(first_line: str) -> bool:
    return first_line.startswith("version https://git-lfs")


def read_relational_first_record(rel_dir: str):
    """Read the first data row of 0.csv (the DCS 'sentences' table export).

    Row layout (semicolon-delimited):
        "TextName";reference;index;<comma-separated lemma IDs>,;<IAST text>
    """
    path = os.path.join(rel_dir, "0.csv")
    if not os.path.exists(path):
        return None, f"not found: {path}"
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        first = fh.readline().rstrip("\n")
    if is_lfs_pointer(first):
        return None, (f"{path} is an unresolved Git LFS pointer — run "
                      f"`git lfs pull` to materialise it.")
    parts = first.split(";")
    if len(parts) < 5:
        return None, f"unexpected 0.csv layout: {first[:80]!r}"
    name, ref, idx, idlist, text = parts[0], parts[1], parts[2], parts[3], parts[4]
    ids = [int(x) for x in idlist.split(",") if x.strip().lstrip("-").isdigit()]
    return {
        "text": name.strip('"'),
        "reference": ref.strip(),
        "index": idx.strip(),
        "lemma_ids": ids,
        "iast": text.strip(),
    }, None


# --------------------------------------------------------------------------- #
# CoNLL-U side
# --------------------------------------------------------------------------- #
def parse_misc(misc: str):
    out = {}
    if misc and misc != "_":
        for kv in misc.split("|"):
            if "=" in kv:
                k, v = kv.split("=", 1)
                out[k] = v
    return out


def parse_feats(feats: str):
    return [kv.split("=", 1)[0] for kv in feats.split("|")] if feats and feats != "_" else []


def parse_conllu(path: str):
    """Parse a CoNLL-U file into sentences + aggregate stats."""
    if not os.path.exists(path):
        return None, f"not found: {path}"

    doc_meta, sentences = {}, []
    cur_meta, cur_tokens, cur_mwt = {}, [], []
    upos = Counter()
    feats_keys = Counter()
    n_head = 0
    n_lemmaid = n_occid = n_unsandhied = n_recon = 0

    def flush():
        if cur_tokens or cur_meta:
            sentences.append({"meta": dict(cur_meta),
                              "tokens": list(cur_tokens),
                              "mwt": list(cur_mwt)})

    with open(path, "r", encoding="utf-8") as fh:
        for raw in fh:
            line = raw.rstrip("\n")
            if line.startswith("##"):                     # document-level metadata
                if ":" in line:
                    k, v = line[2:].split(":", 1)
                    doc_meta[k.strip()] = v.strip()
            elif line.startswith("#"):                    # sentence-level metadata
                if "=" in line:
                    k, v = line[1:].split("=", 1)
                    cur_meta[k.strip()] = v.strip()
            elif not line.strip():                        # sentence boundary
                flush()
                cur_meta, cur_tokens, cur_mwt = {}, [], []
            else:
                cols = line.split("\t")
                if len(cols) != 10:
                    continue
                tid, form, lemma, upos_, xpos, feats, head, deprel, deps, misc = cols
                if "-" in tid:                            # multiword-token span
                    cur_mwt.append({"range": tid, "form": form})
                    continue
                m = parse_misc(misc)
                tok = {"id": tid, "form": form, "lemma": lemma, "upos": upos_,
                       "feats": feats, "head": head, "deprel": deprel,
                       "lemma_id": m.get("LemmaId"), "occ_id": m.get("OccId"),
                       "unsandhied": m.get("Unsandhied")}
                cur_tokens.append(tok)
                upos[upos_] += 1
                for fk in parse_feats(feats):
                    feats_keys[fk] += 1
                if head not in ("_", ""):
                    n_head += 1
                if m.get("LemmaId"):
                    n_lemmaid += 1
                if m.get("OccId"):
                    n_occid += 1
                if "Unsandhied" in m:
                    n_unsandhied += 1
                if m.get("UnsandhiedReconstructed") == "True":
                    n_recon += 1
        flush()

    n_tokens = sum(len(s["tokens"]) for s in sentences)
    n_mwt = sum(len(s["mwt"]) for s in sentences)
    stats = {
        "doc_meta": doc_meta,
        "n_sentences": len(sentences),
        "n_tokens": n_tokens,
        "n_mwt": n_mwt,
        "upos": upos,
        "feats_keys": feats_keys,
        "n_head_populated": n_head,
        "n_lemmaid": n_lemmaid,
        "n_occid": n_occid,
        "n_unsandhied": n_unsandhied,
        "n_unsandhied_reconstructed": n_recon,
    }
    return {"sentences": sentences, "stats": stats}, None


# --------------------------------------------------------------------------- #
# Cross-walk
# --------------------------------------------------------------------------- #
def cross_walk(rel_ids, conllu):
    """Accumulate CoNLL-U LemmaIds sentence by sentence until we have as many as
    the relational record lists, then compare the two integer sequences."""
    acc, used = [], 0
    for s in conllu["sentences"]:
        ids = [int(t["lemma_id"]) for t in s["tokens"] if t["lemma_id"]]
        acc.extend(ids)
        used += 1
        if len(acc) >= len(rel_ids):
            break
    return {
        "relational": rel_ids,
        "conllu": acc,
        "conllu_sentences_consumed": used,
        "equal": acc == rel_ids,
    }


# --------------------------------------------------------------------------- #
# Reporting
# --------------------------------------------------------------------------- #
def hr(title):
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


def anusvara_note(rel_text, conllu):
    """Surface the ṁ (U+1E41) vs ṃ (U+1E43) anusvāra-normalisation difference."""
    rel_has = "ṁ" in rel_text
    conllu_has = any("ṃ" in (s["meta"].get("text", "")) for s in conllu["sentences"])
    return rel_has, conllu_has


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--rel", default=os.path.join(HERE, "..", "DCS-data-2021"),
                    help="relational dump dir (has 0.csv); default ../DCS-data-2021")
    ap.add_argument("--conllu", default=DEFAULT_CONLLU, help="a .conllu file")
    args = ap.parse_args()

    hr("DCS FORMAT COMPARISON — relational-DB export  vs  CoNLL-U")

    rel, rel_err = read_relational_first_record(args.rel)
    con, con_err = parse_conllu(args.conllu)

    # ---- relational side ----
    hr("1. Relational export — first record of 0.csv (DCS 'sentences' table)")
    if rel_err:
        print("  [skipped] " + rel_err)
    else:
        print(f"  text       : {rel['text']}")
        print(f"  reference  : {rel['reference']}")
        print(f"  lemma IDs  : {len(rel['lemma_ids'])} ints -> {rel['lemma_ids']}")
        print(f"  IAST text  : {rel['iast']}")
        print("  note       : morphology lives in SEPARATE tables (10.csv words, "
              "12/15.csv verb forms); 0.csv stores only the lemma-ID sequence + the "
              "sandhied text string.")

    # ---- conllu side ----
    hr("2. CoNLL-U — bundled sample for the SAME text/chapter")
    if con_err:
        print("  [skipped] " + con_err)
    else:
        st = con["stats"]
        dm = st["doc_meta"]
        print(f"  document   : {dm.get('text')}  (text_id={dm.get('text_id')}, "
              f"chapter={dm.get('chapter')}, chapter_id={dm.get('chapter_id')})")
        print(f"  sentences  : {st['n_sentences']}")
        print(f"  tokens     : {st['n_tokens']}  (+ {st['n_mwt']} multiword-token "
              f"spans for sandhi/compound splits)")
        print(f"  UPOS       : " + ", ".join(f"{k}={v}" for k, v in st["upos"].most_common()))
        print(f"  FEATS keys : " + ", ".join(f"{k}({v})" for k, v in st["feats_keys"].most_common()))
        dep = st["n_head_populated"]
        print(f"  dependency : HEAD populated on {dep}/{st['n_tokens']} tokens "
              f"-> {'PRESENT' if dep else 'EMPTY in this file (DCS syntax coverage is partial - some texts have it)'}")
        print(f"  DCS IDs    : LemmaId on {st['n_lemmaid']}, OccId on {st['n_occid']}, "
              f"Unsandhied on {st['n_unsandhied']} "
              f"({st['n_unsandhied_reconstructed']} reconstructed)")

    # ---- cross-walk ----
    hr("3. ID cross-walk — are these the SAME data?")
    if rel and con:
        cw = cross_walk(rel["lemma_ids"], con)
        print(f"  0.csv lemma-ID list ({len(cw['relational'])}):")
        print(f"    {cw['relational']}")
        print(f"  CoNLL-U LemmaId sequence, first {cw['conllu_sentences_consumed']} "
              f"sentence(s) ({len(cw['conllu'])}):")
        print(f"    {cw['conllu']}")
        verdict = ("IDENTICAL — the relational 'sentence' = these CoNLL-U sentences; "
                   "both serialisations share the same DCS lemma IDs."
                   if cw["equal"] else "MISMATCH (see sequences above)")
        print(f"\n  VERDICT: {verdict}")
        rel_has, con_has = anusvara_note(rel["iast"], con)
        if rel_has and con_has:
            print("  encoding: anusvāra differs — 0.csv uses 'ṁ' (U+1E41), "
                  "CoNLL-U uses 'ṃ' (U+1E43). Normalise before string-matching across "
                  "the two distributions.")
    else:
        print("  [skipped] need both sides present.")

    hr("Done. Narrative write-up: DCS_FORMAT_COMPARISON.md")


if __name__ == "__main__":
    main()
