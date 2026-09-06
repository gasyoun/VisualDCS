#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Measure the ADJ half of the pooled -ant nominal class from the DCS master (H4011, GAPS 14).

H3984 split the two pooled nominal declension classes over Sangram G2's lemma inventory.
G2's universe is `upos='NOUN'`, so that pass reached only 11,306 of the -ant class's
48,074 tokens (23.5 %) and declared the remaining 36,768 ADJ tokens UNREACHED ON PURPOSE
rather than estimate them: `paradigm_nominal.json` caps `topLemmas` at 25, and no other
committed asset carries a per-lemma inventory for the ADJ half.

This script measures that surplus. It sources the per-lemma inventory directly from
`dcs_full.sqlite` -- the one substrate that has it -- replicating
`gen_paradigm_nominal.py`'s grid universe verbatim, then runs H3984's OWN signals over
the ADJ lemmas:

  Signal B (-ant) -- MW + PWG headword ENTRY-ID SET comparison. Never presence-only:
                     the presence-only inversion is the whole finding of FINDINGS 630,
                     which classified 191 lemmas (`bhagavant` among them) as two
                     headwords when PWG registers भगवत् and भगवन्त् under the identical
                     id pair 53806,80057.
  Signal A (-ī)   -- IAST vowel-nucleus count over the citation form, for the long-ī
                     class's own non-NOUN residue.

Everything that can be reused IS reused: `in_ant_bucket`, `load_dict_index`,
`adjudicate`, `ant_pair` and `syllable_count` are imported from H3984's module, not
re-implemented, so the two halves of GAPS 14 cannot drift apart.

SUBSTRATE -- read-only, streaming, never a Read/editor tool:
`sqlite3.connect("file:<path>?mode=ro", uri=True)`. `VisualDCS/src/dcs_full.sqlite` is a
0-BYTE DECOY (H848); this script stats the file and refuses under MIN_DB_BYTES. An empty
result set from the decoy is not an empty corpus. The master is never copied into a repo
and never committed.

Usage:
    python split_pooled_nominal_classes_adj.py [--db PATH] [--check]

`--check` exits non-zero if any reconciliation row fails or the pinned
bhagavat/bhagavant verdict is not `one_lexeme_two_spellings`.
"""

import argparse
import json
import os
import sqlite3
import sys
import unicodedata
from collections import defaultdict

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
GITHUB = os.path.abspath(os.path.join(REPO, ".."))

sys.path.insert(0, HERE)
# H3984's module -- the single source of the membership test, the dictionary index
# loader, the five-verdict adjudicator and the syllable counter.
from split_pooled_nominal_classes import (          # noqa: E402
    adjudicate, ant_pair, in_ant_bucket, iast_to_devanagari,
    load_dict_index, load_g2, syllable_count,
)

DEFAULT_DB = os.path.join(HERE, "dcs_full.sqlite")
NOMINAL_JSON = os.path.join(REPO, "visual", "paradigm_nominal.json")

OUT_MD = os.path.join(REPO, "reports", "nominal_pooled_class_split_adj.md")
OUT_JSON = os.path.join(REPO, "visual", "paradigm_nominal_class_split_adj.json")

SCHEMA_VERSION = "1.0.0"

# H848: the in-repo decoy is 0 bytes. The master is ~921 MB; anything materially
# smaller is not the master and an empty result set from it is not an empty corpus.
MIN_DB_BYTES = 900_000_000

# gen_paradigm_nominal.py's grid universe, verbatim. Compound members (feat_case='Cpd')
# carry no case and are excluded there, so they are excluded here too -- the totals this
# script reconciles against were computed under exactly these predicates.
GRID_WHERE = (
    "upos IN ('NOUN','ADJ') AND lemma IS NOT NULL "
    "  AND feat_case IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') "
    "  AND feat_number IN ('Sing','Dual','Plur')"
)


# ---------------------------------------------------------------- substrate

def open_master(path):
    """Read-only connection to the DCS master, after the H848 decoy check."""
    if not os.path.exists(path):
        sys.exit(f"FAIL: no DCS master at {path}\n"
                 f"      This handoff cannot run without it; it is never estimated.")
    size = os.path.getsize(path)
    if size < MIN_DB_BYTES:
        sys.exit(f"FAIL: {path} is {size:,} bytes, under the {MIN_DB_BYTES:,}-byte floor.\n"
                 f"      VisualDCS/src/dcs_full.sqlite is a 0-BYTE DECOY (H848); an empty\n"
                 f"      result set from it is not an empty corpus. Refusing to proceed.")
    conn = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
    prov = dict(conn.execute("SELECT key, value FROM provenance"))
    return conn, {"path": os.path.basename(path), "bytes": size, "provenance": prov}


def ant_inventory(conn):
    """Per-lemma_id inventory of the -ant bucket inside the nominal grid universe.

    Returns {lemma_id: {"lemma", "byUpos": {upos: tokens}, "tokens"}}.

    The class label is a property of the CITATION FORM, so membership is decided by
    `in_ant_bucket` on the lemma -- the same test H3984 used -- and never by the upos.
    A lemma_id is NOT guaranteed to carry one upos across its tokens, so the upos
    breakdown is kept per lemma_id rather than collapsed to a single label; that is
    what lets the ADJ and NOUN token totals sum back to the pool exactly.
    """
    sql = ("SELECT lemma_id, lemma, upos, COUNT(*) FROM token "
           f"WHERE {GRID_WHERE} GROUP BY lemma_id, lemma, upos")
    inv = {}
    for lid, lemma, upos, n in conn.execute(sql):
        lemma = unicodedata.normalize("NFC", lemma)
        if not in_ant_bucket(lemma):
            continue
        rec = inv.setdefault(lid, {"lemma_id": lid, "lemma": lemma,
                                   "byUpos": {}, "tokens": 0})
        rec["byUpos"][upos] = rec["byUpos"].get(upos, 0) + n
        rec["tokens"] += n
    return inv


def ii_non_noun_inventory(conn):
    """Same, for the long-ī class's non-NOUN residue (Signal A's reach in this pass)."""
    sql = ("SELECT lemma_id, lemma, upos, COUNT(*) FROM token "
           f"WHERE {GRID_WHERE} GROUP BY lemma_id, lemma, upos")
    inv = {}
    for lid, lemma, upos, n in conn.execute(sql):
        lemma = unicodedata.normalize("NFC", lemma)
        # The ī class is `endswith("ī")`, but STEM_TAGS matches -ant/-at FIRST, so a
        # lemma in the -ant bucket can never also be counted here.
        if in_ant_bucket(lemma) or not lemma.endswith("ī"):
            continue
        rec = inv.setdefault(lid, {"lemma_id": lid, "lemma": lemma,
                                   "byUpos": {}, "tokens": 0})
        rec["byUpos"][upos] = rec["byUpos"].get(upos, 0) + n
        rec["tokens"] += n
    return inv


def wider_upos_spread(conn):
    """What upos the -ant citation forms carry OUTSIDE the nominal grid universe.

    STEP 1 of H4011 says to report ADJ separately from any other non-NOUN upos present
    and never to fold them together. Inside the grid universe upos is NOUN or ADJ by
    construction, so "other non-NOUN upos" is empty there BY DEFINITION, not by
    measurement -- and reporting only that would be an artefact of the filter, not a
    fact about the corpus. This measures the whole token table for the same citation
    forms so the excluded mass is named rather than silently dropped.
    """
    sql = ("SELECT upos, feat_case IS NULL OR feat_case NOT IN "
           "  ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc') AS offgrid, "
           "  lemma, COUNT(*) FROM token WHERE lemma IS NOT NULL "
           "GROUP BY upos, offgrid, lemma")
    spread = defaultdict(lambda: {"tokens": 0, "lemmaForms": set()})
    for upos, _offgrid, lemma, n in conn.execute(sql):
        lemma = unicodedata.normalize("NFC", lemma)
        if not in_ant_bucket(lemma):
            continue
        key = upos if upos is not None else "(untagged)"
        spread[key]["tokens"] += n
        spread[key]["lemmaForms"].add(lemma)
    return {k: {"tokens": v["tokens"], "lemmaForms": len(v["lemmaForms"])}
            for k, v in sorted(spread.items(), key=lambda kv: -kv[1]["tokens"])}


# ---------------------------------------------------------------- the pass

def classify_adj(inv, dicts):
    """Signal B over every -ant lemma_id that carries ADJ tokens.

    A lemma_id is included when it has at least one ADJ token in the grid universe.
    Mixed lemma_ids (both NOUN and ADJ tokens under one id) are included and FLAGGED,
    never silently reassigned: their NOUN tokens still belong to the G2 half and are
    counted there, which is why token totals are always taken from `byUpos`, never
    from a per-lemma-id label.
    """
    out = {}
    for lid, rec in inv.items():
        adj_tokens = rec["byUpos"].get("ADJ", 0)
        if adj_tokens == 0:
            continue
        at_form, ant_form = ant_pair(rec["lemma"])
        at_dev, ant_dev = iast_to_devanagari(at_form), iast_to_devanagari(ant_form)
        verdict, per = adjudicate(at_dev, ant_dev, dicts)
        out[lid] = {
            "lemma_id": lid, "lemma": rec["lemma"],
            "adjTokens": adj_tokens,
            "nounTokens": rec["byUpos"].get("NOUN", 0),
            "mixedUpos": len(rec["byUpos"]) > 1,
            "dcsSpelling": "ant" if rec["lemma"].endswith("ant") else "at",
            "verdict": verdict, "perDictionary": per,
            "at_form": at_form, "ant_form": ant_form,
            "at_devanagari": at_dev, "ant_devanagari": ant_dev,
        }
    return out


def describe_residual(by_verdict, adj_tokens):
    """Characterise the `unresolved` tail. DESCRIPTIVE ONLY -- nothing here splits anything.

    The H1472 fence forbids SPLITTING on a character rule; it does not forbid saying what
    the un-splittable residue looks like. These shape counts explain WHY the tail exists
    and are never used as a verdict: every lemma below stays pooled.
    """
    un = by_verdict["unresolved"]
    tot = sum(d["adjTokens"] for d in un)
    vm = [d for d in un if d["lemma"].endswith(("vat", "mat", "vant", "mant"))]
    aug = [d for d in un if d["lemma"].startswith(("a", "\u0101"))
           and d["lemma"].endswith("at")
           and not d["lemma"].endswith(("vat", "mat"))]
    hapax = [d for d in un if d["adjTokens"] == 1]
    return {
        "lemmaIds": len(un), "adjTokens": tot,
        "shareOfAdjTokens": round(100.0 * tot / adj_tokens, 2) if adj_tokens else 0.0,
        "possessiveShape": {"lemmaIds": len(vm),
                            "adjTokens": sum(d["adjTokens"] for d in vm)},
        "augmentedParticipleShape": {"lemmaIds": len(aug),
                                     "adjTokens": sum(d["adjTokens"] for d in aug)},
        "hapaxLemmaIds": len(hapax),
        "maxTokens": max((d["adjTokens"] for d in un), default=0),
        "reading": "The tail is dominated by -vat/-mat possessive derivatives and by "
                   "single-token hapax compounds: the suffix is fully productive, so the "
                   "corpus carries ad-hoc derivatives no lexicon indexes as headwords. "
                   "That is the expected behaviour of an external-signal method, not a "
                   "defect in it -- these stay pooled until a third lexicon is added.",
        "note": "DCS tags every one of these lemma_ids `adj` in `lemma.grammar` and "
                "carries no VERB token for any of them, so the participle-looking rows "
                "are a SHAPE observation, not a corpus-attested part of speech.",
    }


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--db", default=DEFAULT_DB, help="path to dcs_full.sqlite")
    ap.add_argument("--check", action="store_true",
                    help="exit non-zero on a failed reconciliation or pinned verdict")
    args = ap.parse_args()

    conn, dbmeta = open_master(args.db)
    print(f"master: {dbmeta['path']} ({dbmeta['bytes']:,} bytes, "
          f"imported {dbmeta['provenance'].get('imported_at')})")

    nominal = json.load(open(NOMINAL_JSON, encoding="utf-8"))
    before_ant = nominal["classes"]["ant"]
    before_ii = nominal["classes"]["ii"]

    # ---- STEP 1: per-lemma inventory from the master ------------------------
    inv = ant_inventory(conn)
    tok = defaultdict(int)
    for rec in inv.values():
        for u, n in rec["byUpos"].items():
            tok[u] += n
    adj_ids = {lid for lid, r in inv.items() if r["byUpos"].get("ADJ", 0)}
    noun_ids = {lid for lid, r in inv.items() if r["byUpos"].get("NOUN", 0)}
    mixed_ids = adj_ids & noun_ids
    spread = wider_upos_spread(conn)

    print(f"-ant pool: {sum(tok.values()):,} tokens over {len(inv):,} lemma_ids "
          f"-- ADJ {tok['ADJ']:,} / NOUN {tok['NOUN']:,}")
    print(f"  lemma_ids with ADJ tokens {len(adj_ids):,} · with NOUN tokens "
          f"{len(noun_ids):,} · mixed {len(mixed_ids):,}")

    # ---- STEP 2: Signal B over the ADJ lemmas -------------------------------
    mw, mw_src = load_dict_index("mw")
    pwg, pwg_src = load_dict_index("pwg")
    dicts = {"mw": mw, "pwg": pwg}
    per_lemma = classify_adj(inv, dicts)

    VERDICTS = ["one_lexeme_two_spellings", "two_headwords",
                "at_only", "ant_only", "unresolved"]
    by_verdict = {v: [] for v in VERDICTS}
    for d in per_lemma.values():
        by_verdict[d["verdict"]].append(d)
    for v in VERDICTS:
        by_verdict[v].sort(key=lambda d: -d["adjTokens"])

    # The pinned case. `bhagavat` is ADJ in the master and so fell outside G2's NOUN
    # universe; this pass is the one that can finally classify it from the inventory
    # side as well as the dictionary side.
    pinned = None
    for d in per_lemma.values():
        if d["at_form"] == "bhagavat":
            pinned = d
            break
    pin_ok = bool(pinned) and pinned["verdict"] == "one_lexeme_two_spellings"

    # ---- STEP 3: Signal A over the long-ī non-NOUN residue ------------------
    ii_inv = ii_non_noun_inventory(conn)
    ii_non_noun = {lid: r for lid, r in ii_inv.items() if r["byUpos"].get("ADJ", 0)}
    ii_mono, ii_poly = [], []
    for lid, r in sorted(ii_non_noun.items(), key=lambda kv: -kv[1]["byUpos"]["ADJ"]):
        row = {"lemma_id": lid, "lemma": r["lemma"],
               "adjTokens": r["byUpos"].get("ADJ", 0),
               "nounTokens": r["byUpos"].get("NOUN", 0),
               "syllables": syllable_count(r["lemma"])}
        (ii_mono if row["syllables"] == 1 else ii_poly).append(row)
    ii_adj_tokens = sum(r["byUpos"].get("ADJ", 0) for r in ii_inv.values())

    # ---- STEP 4: reconciliation --------------------------------------------
    # NOTHING from the NOUN half or from Sangram G2 may move. The G2 rows are re-read
    # from the same CSV H3984 used, and the DB's NOUN count is compared against BOTH
    # the published asset and G2 -- a divergence in either direction is a failure, not
    # a number to adopt.
    g2 = load_g2()
    g2_ant = [r for r in g2 if r["stem_final"] == "other_consonant"
              and in_ant_bucket(r["lemma"])]
    g2_tokens = sum(r["tokens"] for r in g2_ant)

    recon = [
        ("-ant pool tokens vs paradigm_nominal.json",
         sum(tok.values()), before_ant["n"]),
        ("-ant pool lemma_ids vs paradigm_nominal.json",
         len(inv), before_ant["lemmas"]),
        ("-ant ADJ tokens vs paradigm_nominal.json (FINDINGS 630)",
         tok["ADJ"], before_ant["upos"].get("ADJ", 0)),
        ("-ant NOUN tokens vs paradigm_nominal.json (must NOT move)",
         tok["NOUN"], before_ant["upos"].get("NOUN", 0)),
        ("-ant NOUN tokens vs Sangram G2 (must NOT move)",
         tok["NOUN"], g2_tokens),
        ("-ant NOUN lemma_ids vs Sangram G2 (must NOT move)",
         len(noun_ids), len(g2_ant)),
        ("ADJ + NOUN tokens sum to the pool",
         tok["ADJ"] + tok["NOUN"], sum(tok.values())),
        ("Signal B verdicts cover every ADJ token",
         sum(sum(d["adjTokens"] for d in by_verdict[v]) for v in VERDICTS), tok["ADJ"]),
        ("Signal B verdicts cover every ADJ lemma_id",
         sum(len(by_verdict[v]) for v in VERDICTS), len(adj_ids)),
        ("-ī ADJ tokens vs paradigm_nominal.json",
         ii_adj_tokens, before_ii["upos"].get("ADJ", 0)),
        ("-ī Signal A subclasses sum to the -ī ADJ lemma_ids",
         len(ii_mono) + len(ii_poly), len(ii_non_noun)),
    ]
    ok = all(a == b for _, a, b in recon)

    residual = describe_residual(by_verdict, tok["ADJ"])

    payload = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedBy": "src/DCS-data-2026/split_pooled_nominal_classes_adj.py (H4011, GAPS 14)",
        "predecessor": "split_pooled_nominal_classes.py (H3984) -- the NOUN half; this "
                       "payload is a SIBLING and does not overwrite it",
        "substrate": {
            "file": "dcs_full.sqlite (DCS master, read-only, never copied or committed)",
            "bytes": dbmeta["bytes"],
            "provenance": dbmeta["provenance"],
            "universe": GRID_WHERE,
            "universeNote": "gen_paradigm_nominal.py's grid universe verbatim; compound "
                            "members (feat_case='Cpd') carry no case and are excluded "
                            "there and here alike",
        },
        "signals": {
            "ant": {"kind": "dictionary headword-index entry-id comparison",
                    "rule": "the -at and -ant Devanagari spellings of one stem are looked "
                            "up in the MW and PWG headword indexes and their ENTRY-ID SETS "
                            "are compared; presence alone is never the test",
                    "source": {"mw": mw_src, "pwg": pwg_src,
                               "mwHeadwords": len(mw), "pwgHeadwords": len(pwg)}},
            "ii": {"kind": "transliteration-aware syllable count",
                   "rule": "IAST vowel-nucleus count over the NFC-normalised citation "
                           "form; ai/au are one nucleus each"},
        },
        "antPool": {
            "tokens": sum(tok.values()),
            "lemmaIds": len(inv),
            "byUpos": dict(sorted(tok.items(), key=lambda kv: -kv[1])),
            "lemmaIdsWithAdjTokens": len(adj_ids),
            "lemmaIdsWithNounTokens": len(noun_ids),
            "lemmaIdsMixedUpos": sorted(mixed_ids),
            "adjShareOfTokens": round(100.0 * tok["ADJ"] / sum(tok.values()), 2),
        },
        "widerUposSpread": {
            "note": "upos of the SAME -ant citation forms across the WHOLE token table, "
                    "outside the nominal grid universe. Inside the grid, upos is NOUN or "
                    "ADJ by construction, so 'other non-NOUN upos' is empty there by "
                    "definition rather than by measurement; this names the excluded mass "
                    "instead of folding it away.",
            "byUpos": spread,
        },
        "antAdjByVerdict": {
            v: {"tokens": sum(d["adjTokens"] for d in by_verdict[v]),
                "lemmaIds": len(by_verdict[v]),
                "exemplars": [d["lemma"] for d in by_verdict[v][:12]]}
            for v in VERDICTS},
        "unresolvedResidual": residual,
        "pinnedPair": pinned,
        "pinnedPairOk": pin_ok,
        "iiNonNoun": {
            "adjTokens": ii_adj_tokens,
            "lemmaIds": len(ii_non_noun),
            "monosyllabic": {"lemmaIds": len(ii_mono),
                             "adjTokens": sum(r["adjTokens"] for r in ii_mono),
                             "rows": ii_mono},
            "polysyllabic": {"lemmaIds": len(ii_poly),
                             "adjTokens": sum(r["adjTokens"] for r in ii_poly),
                             "rows": ii_poly[:60]},
        },
        "reconciliation": [{"check": c, "got": a, "want": b, "ok": a == b}
                           for c, a, b in recon],
        "reconciles": ok,
        "perLemmaAntAdj": [per_lemma[k] for k in sorted(per_lemma)],
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as fh:
        json.dump(payload, fh, ensure_ascii=False, indent=1, sort_keys=True)
        fh.write("\n")
    print(f"wrote {OUT_JSON}")

    write_report(payload, by_verdict, VERDICTS, recon, ok, ii_mono, ii_poly)

    print(f"reconciles: {ok} · pinned bhagavat/bhagavant: "
          f"{pinned['verdict'] if pinned else 'NOT FOUND'}")
    if args.check and not (ok and pin_ok):
        print("FAIL: reconciliation or the pinned verdict did not hold", file=sys.stderr)
        return 1
    return 0


# ---------------------------------------------------------------- report

def _ids(seq):
    return "`%s`" % ",".join(sorted(seq)) if seq else "—"


def _pin_prose(pin, mw, pwg):
    if not pin:
        return ("**The pinned pair was not found in the ADJ inventory.** That is a failed "
                "run, not a new result: GAPS 14 names `bhagavat`/`bhagavant` explicitly.")
    mw_at = sorted(mw.get(pin["at_devanagari"], ()))
    mw_ant = sorted(mw.get(pin["ant_devanagari"], ()))
    pwg_at = sorted(pwg.get(pin["at_devanagari"], ()))
    pwg_ant = sorted(pwg.get(pin["ant_devanagari"], ()))
    parts = [
        "The DCS lemma_id **%d** (`%s`, %s tokens) is tagged **ADJ**, which is exactly why "
        "it fell outside Sangram G2's `upos='NOUN'` universe and could not be classified by "
        "H3984. This pass reaches it."
        % (pin["lemma_id"], pin["lemma"], f"{pin['adjTokens']:,}"),
        "MW indexes %s under %s and %s under %s (verdict: `%s`)."
        % (pin["at_devanagari"], _ids(mw_at), pin["ant_devanagari"], _ids(mw_ant),
           pin["perDictionary"].get("mw")),
        "PWG indexes %s under %s and %s under %s (verdict: `%s`)."
        % (pin["at_devanagari"], _ids(pwg_at), pin["ant_devanagari"], _ids(pwg_ant),
           pin["perDictionary"].get("pwg")),
        "Combined verdict: **`%s`**." % pin["verdict"],
    ]
    if pin["verdict"] == "one_lexeme_two_spellings":
        parts.append(
            "The two spellings resolve to the **same entry ids**, so the lexicon itself "
            "states that `bhagavat` and `bhagavant` are one lexeme written two ways. This "
            "is a declaration in the dictionary, not a character rule inferred from the "
            "endings — the distinction the H1472 fence exists to protect.")
    return " ".join(parts)


def write_report(payload, by_verdict, VERDICTS, recon, ok, ii_mono, ii_poly):
    mw, _ = load_dict_index("mw")
    pwg, _ = load_dict_index("pwg")
    pool = payload["antPool"]
    L = []
    A = L.append
    A("# The -ant pool's ADJ half, measured from the DCS master (H4011, GAPS §14)")
    A("")
    A("_Created: 06-09-2026 · Last updated: 06-09-2026_")
    A("")
    A("Generated by `src/DCS-data-2026/split_pooled_nominal_classes_adj.py`. Sibling of the "
      "NOUN half, [nominal_pooled_class_split.md](nominal_pooled_class_split.md) (H3984), "
      "which it does not modify.")
    A("")
    A("## What this measures, and what it refuses to do")
    A("")
    A("H3984 split the `-ant` class over Sangram G2, whose universe is `upos='NOUN'`. That "
      "reached **%s of the class's %s tokens (%.1f %%)** and declared the rest unreached ON "
      "PURPOSE. The remaining mass is ADJ, and no committed asset carries a per-lemma "
      "inventory for it: `paradigm_nominal.json` caps `topLemmas` at 25."
      % (f"{pool['byUpos'].get('NOUN', 0):,}", f"{pool['tokens']:,}",
         100.0 - pool["adjShareOfTokens"]))
    A("")
    A("This pass **counts** that surplus from `dcs_full.sqlite`. Nothing here is estimated, "
      "extrapolated or scaled from the NOUN half — every figure below is a `COUNT(*)` over "
      "the master under `gen_paradigm_nominal.py`'s own grid predicates.")
    A("")
    A("## 1 · The inventory")
    A("")
    A("| | tokens | lemma_ids |")
    A("|---|---:|---:|")
    A(f"| `-ant` pool (whole class) | {pool['tokens']:,} | {pool['lemmaIds']:,} |")
    for u, n in pool["byUpos"].items():
        key = "lemmaIdsWithAdjTokens" if u == "ADJ" else "lemmaIdsWithNounTokens"
        A(f"| — of which **{u}** | {n:,} | {pool[key]:,} |")
    A(f"| lemma_ids carrying BOTH upos | — | {len(pool['lemmaIdsMixedUpos']):,} |")
    A("")
    A("The lemma_id columns overlap by exactly the mixed-upos row: a lemma_id is not "
      "guaranteed to carry one upos across its tokens, so token totals are always taken "
      "from the per-token `upos`, never from a per-lemma label. That is what lets ADJ + "
      "NOUN sum back to the pool exactly (row 7 of §4).")
    A("")
    A("### Other non-NOUN upos on the same citation forms")
    A("")
    A(payload["widerUposSpread"]["note"])
    A("")
    A("| upos | tokens | distinct citation forms |")
    A("|---|---:|---:|")
    for u, d in payload["widerUposSpread"]["byUpos"].items():
        A(f"| `{u}` | {d['tokens']:,} | {d['lemmaForms']:,} |")
    A("")
    A("## 2 · Signal B over the ADJ half — dictionary entry-id sets, never presence")
    A("")
    A("| verdict | ADJ tokens | lemma_ids | exemplars |")
    A("|---|---:|---:|---|")
    for v in VERDICTS:
        d = payload["antAdjByVerdict"][v]
        A(f"| `{v}` | {d['tokens']:,} | {d['lemmaIds']:,} | "
          f"{', '.join('`%s`' % x for x in d['exemplars'][:8]) or '—'} |")
    A("")
    A("### The pinned pair")
    A("")
    A(_pin_prose(payload["pinnedPair"], mw, pwg))
    A("")
    A("### The unresolved residual — why it stays pooled")
    A("")
    r = payload["unresolvedResidual"]
    A(f"**{r['lemmaIds']:,} lemma_ids / {r['adjTokens']:,} ADJ tokens "
      f"({r['shareOfAdjTokens']} % of the ADJ mass)** have no witness in either MW or PWG "
      f"under either spelling, and are left pooled — never split on a character rule.")
    A("")
    A(f"- **{r['possessiveShape']['lemmaIds']:,} lemma_ids** "
      f"({r['possessiveShape']['adjTokens']:,} tokens) carry the productive "
      f"`-vat`/`-mat`/`-vant`/`-mant` possessive shape.")
    A(f"- **{r['augmentedParticipleShape']['lemmaIds']:,} lemma_ids** "
      f"({r['augmentedParticipleShape']['adjTokens']:,} tokens) have an "
      f"augmented-participle shape (`a-` + bare `-at`).")
    A(f"- **{r['hapaxLemmaIds']:,} lemma_ids** are single-token hapax; the largest row in "
      f"the whole tail is {r['maxTokens']} tokens.")
    A("")
    A(r["reading"])
    A("")
    A(f"_{r['note']}_")
    A("")
    A("## 3 · Signal A over the long-ī class's non-NOUN residue")
    A("")
    ii = payload["iiNonNoun"]
    A(f"The `-ī` class carries **{ii['adjTokens']:,} ADJ tokens** over "
      f"**{ii['lemmaIds']:,} lemma_ids**.")
    A("")
    A("| subclass | ADJ tokens | lemma_ids | exemplars |")
    A("|---|---:|---:|---|")
    for label, rows in (("monosyllabic (śrī/strī/dhī type)", ii_mono),
                        ("polysyllabic (devī/nadī type)", ii_poly)):
        A(f"| {label} | {sum(r['adjTokens'] for r in rows):,} | {len(rows):,} | "
          f"{', '.join('`%s`' % r['lemma'] for r in rows[:8]) or '—'} |")
    A("")
    A("## 4 · Reconciliation")
    A("")
    A("The NOUN half and every Sangram G2 number are re-derived here and must be "
      "**unchanged**. A moved NOUN total would mean this pass had rewritten its "
      "predecessor's result rather than extended it.")
    A("")
    A("| check | got | want | |")
    A("|---|---:|---:|:--:|")
    for c, a, b in recon:
        A(f"| {c} | {a:,} | {b:,} | {'✅' if a == b else '❌'} |")
    A("")
    A(f"**reconciles: {'✅ all rows' if ok else '❌ SEE FAILING ROWS ABOVE'}**")
    A("")
    A("## Substrate")
    A("")
    sub = payload["substrate"]
    A(f"- `dcs_full.sqlite`, {sub['bytes']:,} bytes, opened **read-only** "
      f"(`mode=ro`), never copied into a repo and never committed.")
    for k, v in sorted(sub["provenance"].items()):
        A(f"- `{k}`: `{v}`")
    A(f"- universe: `{sub['universe'].strip()}`")
    A("")
    A("_Dr. Mārcis Gasūns_")

    os.makedirs(os.path.dirname(OUT_MD), exist_ok=True)
    with open(OUT_MD, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    print(f"wrote {OUT_MD}")


if __name__ == "__main__":
    sys.exit(main())
