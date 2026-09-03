#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Split the two pooled nominal declension classes with an EXTERNAL lexical signal (H3984, GAPS 14).

`gen_paradigm_nominal.py` buckets nominal lemmas by the orthographic shape of their
citation form.  Two of its buckets are known pools that the master (`dcs_full.sqlite`)
cannot resolve on its own, because DCS tags case/number/gender but never a declension
class:

  ii   65,332 tokens — POOLS the polysyllabic devī/nadī type with the monosyllabic
                       śrī/strī/dhī type, which takes different strong-case endings.
  ant  48,074 tokens — POOLS genuine -ant/-vant/-mant stems with the master's OWN
                       -at/-vat/-mat citation variants of the very same stems
                       (bhagavant / bhagavat are two lemma_ids for one lexeme).

H1472 deliberately shipped the pools rather than guess a character rule.  This script
closes the gap the way GAPS 14 names it: by bringing an external signal to each pool.

  Signal A (ii)  — a transliteration-aware syllable count over the IAST citation form.
                   A Sanskrit syllable has exactly one vowel nucleus, so the count is
                   the number of IAST nuclei (`ai` and `au` are ONE nucleus each, and
                   `ā ī ū ṛ ṝ ḷ ḹ e o` are one each).  Monosyllabic ⇒ the śrī/strī/dhī
                   type; polysyllabic ⇒ the devī/nadī type.  This is the classical
                   criterion, and it is a property of the word's phonology, not of a
                   spelling accident.

  Signal B (ant) — dictionary headword attestation in Monier-Williams and the
                   Petersburg Dictionary (Böhtlingk-Roth), read from the committed
                   csl-json exports.  For every DCS lemma in the bucket both the -at
                   and the -ant spelling of the same stem are looked up in Devanagari.
                   A stem the dictionaries cite under exactly ONE of the two spellings
                   is one lexeme, and the DCS lemma_id carrying the other spelling is a
                   citation variant of it.  A stem cited under BOTH is genuinely two
                   headwords.  A stem cited under NEITHER gets NO rule: it stays
                   pooled and is reported as unresolved.

Nothing here is inferred from character shape alone.  A lemma the external signal does
not reach is reported, never guessed — re-introducing a plausible-looking rule is worse
than the open gap (H1472).

Scope, stated up front: the substrate is Sangram G2's `lemma_cell_coverage.csv`, which
is the COMPLETE unfloored `upos='NOUN'` universe read from the same pinned master with
the same lemma_id keying.  The ADJ surplus this asset carries beyond G2 has no
per-lemma inventory outside the master, so its share of each pool is reported as an
unreached remainder rather than split.

Outputs:
  reports/nominal_pooled_class_split.md        — method, re-bucketed table, unresolved
  visual/paradigm_nominal_class_split.json     — machine-readable split
  reports/nominal_g2_reconciliation_split.md   — the G2 reconciliation, re-run

Usage:  python src/DCS-data-2026/split_pooled_nominal_classes.py [--check]
        --check exits 1 if any total fails to reconcile.
"""

import csv
import json
import os
import re
import sys
import unicodedata

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
GITHUB = os.path.abspath(os.path.join(REPO, ".."))

G2_CSV = os.path.join(GITHUB, "SanskritGrammar", "sangram", "data",
                      "declension_cell_coverage", "lemma_cell_coverage.csv")
NOMINAL_JSON = os.path.join(REPO, "visual", "paradigm_nominal.json")
CSL_DIR = os.path.join(GITHUB, "csl-json", "ashtadhyayi.com")

OUT_MD = os.path.join(REPO, "reports", "nominal_pooled_class_split.md")
OUT_JSON = os.path.join(REPO, "visual", "paradigm_nominal_class_split.json")
OUT_RECON = os.path.join(REPO, "reports", "nominal_g2_reconciliation_split.md")

SCHEMA_VERSION = "1.0.0"

# ---------------------------------------------------------------- Signal A


# IAST vowel nuclei, longest-first: `ai` / `au` are single nuclei, never a+i / a+u.
NUCLEUS_RE = re.compile("ai|au|[aāiīuūṛṝḷḹeo]")


def syllable_count(iast):
    """Number of vowel nuclei in an IAST string = its syllable count.

    Sanskrit has no vowel-less syllable, so nucleus count IS syllable count.  Input is
    NFC-normalised first: the master writes ā/ī/ṛ as precomposed characters, but a
    decomposed a+U+0304 would otherwise be counted as a bare `a` and silently make a
    polysyllable look monosyllabic.
    """
    return len(NUCLEUS_RE.findall(unicodedata.normalize("NFC", iast.lower())))


# ---------------------------------------------------------------- Signal B


def iast_to_devanagari(iast):
    from indic_transliteration import sanscript
    return sanscript.transliterate(unicodedata.normalize("NFC", iast),
                                   sanscript.IAST, sanscript.DEVANAGARI)


def load_dict_index(name):
    """Return {Devanagari headword -> frozenset of entry ids} for a csl-json export.

    The export is {name, source, data:{words:{headword: "id,id,..."}, text:{...}}}.
    Only the `words` index is read — the entry prose is never parsed, so no gloss is
    being pattern-matched here.

    The **entry ids matter, not merely membership.** PWG indexes भगवत् and भगवन्त्
    under the identical id pair 53806,80057: the dictionary is declaring one lexeme
    reachable under two spellings, not two headwords. Comparing id sets is what turns
    this index into a signal about lexeme identity; comparing presence alone would
    read that same evidence as "two distinct headwords" and get the pinned
    bhagavant/bhagavat case exactly backwards.
    """
    path = os.path.join(CSL_DIR, name + ".json")
    with open(path, encoding="utf-8") as fh:
        blob = json.load(fh)
    idx = {unicodedata.normalize("NFC", w): frozenset(ids.split(","))
           for w, ids in blob["data"]["words"].items()}
    return idx, blob.get("source", "")


def adjudicate(at_dev, ant_dev, dicts):
    """Verdict on whether the -at and -ant spellings are one lexeme or two.

    dicts is {name: headword->ids}. Per dictionary:
      both spellings, ids overlap    -> that dictionary says ONE lexeme
      both spellings, ids disjoint   -> that dictionary says TWO headwords
      one spelling only              -> that dictionary knows one lexeme, under it
      neither                        -> that dictionary is silent
    A dictionary that is silent contributes nothing; silence in all of them is
    `unresolved` and gets no rule.
    """
    per = {}
    for name, idx in dicts.items():
        a, n = idx.get(at_dev), idx.get(ant_dev)
        if a is not None and n is not None:
            per[name] = "one_lexeme_two_spellings" if a & n else "two_headwords"
        elif a is not None:
            per[name] = "at_only"
        elif n is not None:
            per[name] = "ant_only"
        else:
            per[name] = "silent"
    voices = {v for v in per.values() if v != "silent"}
    if not voices:
        verdict = "unresolved"
    elif "two_headwords" in voices:
        # A dictionary keeping them apart outranks one that merges them: a genuine
        # homonym pair must not be collapsed on another lexicon's indexing habit.
        verdict = "two_headwords"
    elif "one_lexeme_two_spellings" in voices:
        verdict = "one_lexeme_two_spellings"
    elif voices == {"at_only"}:
        verdict = "at_only"
    elif voices == {"ant_only"}:
        verdict = "ant_only"
    else:
        verdict = "one_lexeme_two_spellings"   # at_only in one, ant_only in another
    return verdict, per


def ant_pair(lemma):
    """(at_form, ant_form) for a lemma in the -ant bucket, else None.

    -vant/-mant and -vat/-mat are the same alternation and fall out of this.
    """
    if lemma.endswith("ant"):
        return lemma[:-3] + "at", lemma
    if lemma.endswith("at"):
        return lemma, lemma[:-2] + "ant"
    return None


# ---------------------------------------------------------------- substrate


def load_g2():
    rows = []
    with open(G2_CSV, encoding="utf-8", newline="") as fh:
        for r in csv.DictReader(fh):
            r["tokens"] = int(r["tokens"])
            r["cells_attested"] = int(r["cells_attested"])
            r["lemma_id"] = int(r["lemma_id"])
            r["lemma"] = unicodedata.normalize("NFC", r["lemma"])
            rows.append(r)
    return rows


def in_ant_bucket(lemma):
    """The H1472 -ant extension's membership test, verbatim: `ant` before `at`."""
    return lemma.endswith("ant") or lemma.endswith("at")


def main():
    check = "--check" in sys.argv
    nominal = json.load(open(NOMINAL_JSON, encoding="utf-8"))
    classes = nominal["classes"]
    before_ii, before_ant = classes["ii"], classes["ant"]

    g2 = load_g2()
    # G2's own tag for the long-ī class; the -ant stems sit in its other_consonant residue.
    ii_rows = [r for r in g2 if r["stem_final"] == "ii"]
    ant_rows = [r for r in g2 if r["stem_final"] == "other_consonant"
                and in_ant_bucket(r["lemma"])]

    # ---- Signal A: split the ī pool by syllable count -----------------------
    mono, poly = [], []
    for r in ii_rows:
        (mono if syllable_count(r["lemma"]) == 1 else poly).append(r)

    # ---- Signal B: adjudicate the -ant pool by dictionary headword ----------
    mw, mw_src = load_dict_index("mw")
    pwg, pwg_src = load_dict_index("pwg")
    dicts = {"mw": mw, "pwg": pwg}

    VERDICTS = ["one_lexeme_two_spellings", "two_headwords",
                "at_only", "ant_only", "unresolved"]
    verdicts = {v: [] for v in VERDICTS}
    per_lemma = {}
    for r in ant_rows:
        at_form, ant_form = ant_pair(r["lemma"])
        at_dev, ant_dev = iast_to_devanagari(at_form), iast_to_devanagari(ant_form)
        v, per = adjudicate(at_dev, ant_dev, dicts)
        verdicts[v].append(r)
        per_lemma[r["lemma_id"]] = {
            "lemma": r["lemma"], "lemma_id": r["lemma_id"], "tokens": r["tokens"],
            "dcsSpelling": "ant" if r["lemma"].endswith("ant") else "at",
            "verdict": v, "perDictionary": per,
            "at_form": at_form, "ant_form": ant_form,
            "at_devanagari": at_dev, "ant_devanagari": ant_dev,
        }

    # ---- what the pool hides -----------------------------------------------
    # Two shapes of hidden merge, both read off the dictionary, neither guessed:
    #  (1) two DCS lemma_ids sharing one stem, which the dictionary treats as one
    #      lexeme -> the asset counts one lexeme twice;
    #  (2) a single DCS lemma_id whose citation SPELLING is not the one the
    #      dictionaries use for that lexeme -> the asset's citation form is the
    #      master's variant, and the class label rests on it.
    by_stem = {}
    for r in ant_rows:
        by_stem.setdefault(ant_pair(r["lemma"])[0], []).append(r)
    merged_pairs = []
    for at_form, rs in sorted(by_stem.items()):
        if len(rs) < 2:
            continue
        v = per_lemma[rs[0]["lemma_id"]]["verdict"]
        if v == "two_headwords":
            continue          # the dictionary keeps them apart; so do we
        merged_pairs.append({
            "stem": at_form, "verdict": v,
            # Two distinct DCS lemma_ids for one stem come in two shapes, and conflating
            # them would overstate the -at/-ant merge: `spelling_pair` is the one GAPS 14
            # describes (`saṃvat` + `saṃvant`), `duplicate_lemma_id` is the master holding
            # two ids under the *same* citation form — a separate defect, reported apart.
            "kind": ("spelling_pair"
                     if len({x["lemma"] for x in rs}) > 1 else "duplicate_lemma_id"),
            "lemma_ids": [{"lemma_id": x["lemma_id"], "lemma": x["lemma"],
                           "tokens": x["tokens"]} for x in
                          sorted(rs, key=lambda y: -y["tokens"])],
            "tokens": sum(x["tokens"] for x in rs),
        })
    merged_pairs.sort(key=lambda m: -m["tokens"])

    variant_citations = sorted(
        (d for d in per_lemma.values()
         if (d["verdict"] == "at_only" and d["dcsSpelling"] == "ant")
         or (d["verdict"] == "ant_only" and d["dcsSpelling"] == "at")),
        key=lambda d: -d["tokens"])

    # The pair GAPS 14 pins by name. `bhagavat` is tagged ADJ in the master, so it is
    # outside G2's NOUN universe and cannot be paired here from the substrate — but the
    # dictionary question it poses is answerable and is answered.
    pin_at, pin_ant = "भगवत्", "भगवन्त्"
    pinned = {
        "stem": "bhagavat / bhagavant",
        "verdict": adjudicate(pin_at, pin_ant, dicts)[0],
        "perDictionary": adjudicate(pin_at, pin_ant, dicts)[1],
        "mwIds": {"at": sorted(mw.get(pin_at, ())), "ant": sorted(mw.get(pin_ant, ()))},
        "pwgIds": {"at": sorted(pwg.get(pin_at, ())), "ant": sorted(pwg.get(pin_ant, ()))},
        "inNounUniverse": [ {"lemma_id": r["lemma_id"], "lemma": r["lemma"],
                             "tokens": r["tokens"]}
                            for r in by_stem.get("bhagavat", []) ],
        "note": "the DCS `bhagavat` lemma_id is tagged ADJ and is therefore outside "
                "G2's NOUN universe; the dictionary verdict below stands regardless",
    }

    # ---- reconciliation ----------------------------------------------------
    def tot(rs):
        return sum(r["tokens"] for r in rs)

    recon = []
    recon.append(("ī pool, NOUN token count vs G2", tot(ii_rows),
                  before_ii["upos"].get("NOUN", 0)))
    recon.append(("ī pool, subclasses sum to the pool", tot(mono) + tot(poly), tot(ii_rows)))
    recon.append(("ī pool, subclass lemma_ids sum to the pool",
                  len(mono) + len(poly), len(ii_rows)))
    recon.append(("-ant pool, NOUN token count vs G2", tot(ant_rows),
                  before_ant["upos"].get("NOUN", 0)))
    recon.append(("-ant pool, verdicts sum to the pool",
                  sum(tot(v) for v in verdicts.values()), tot(ant_rows)))
    recon.append(("-ant pool, verdict lemma_ids sum to the pool",
                  sum(len(v) for v in verdicts.values()), len(ant_rows)))
    ok = all(a == b for _, a, b in recon)

    payload = {
        "schemaVersion": SCHEMA_VERSION,
        "generatedBy": "src/DCS-data-2026/split_pooled_nominal_classes.py (H3984, GAPS 14)",
        "substrate": {
            "file": "SanskritGrammar/sangram/data/declension_cell_coverage/lemma_cell_coverage.csv",
            "universe": "upos='NOUN', unfloored, lemma_id-keyed (Sangram G2, H1048)",
            "adjNotSplit": True,
        },
        "signals": {
            "ii": {"kind": "transliteration-aware syllable count",
                   "rule": "IAST vowel-nucleus count over the citation form; ai/au are one nucleus",
                   "source": "phonological property of the citation form (no dictionary lookup)"},
            "ant": {"kind": "dictionary headword-index entry-id comparison",
                    "rule": "the -at and -ant Devanagari spellings of one stem are looked up "
                            "in the MW and PWG headword indexes and their ENTRY-ID SETS are "
                            "compared: shared ids = the dictionary declares one lexeme under "
                            "two spellings; disjoint ids = two headwords; one spelling only = "
                            "that spelling is the dictionary's citation form",
                    "source": {"mw": mw_src, "pwg": pwg_src,
                               "mwHeadwords": len(mw), "pwgHeadwords": len(pwg)}},
        },
        "before": {
            "ii": {k: before_ii[k] for k in ("n", "lemmas", "upos")},
            "ant": {k: before_ant[k] for k in ("n", "lemmas", "upos")},
        },
        "after": {
            "ii_monosyllabic": {"tokens": tot(mono), "lemmas": len(mono),
                                "exemplars": [r["lemma"] for r in
                                              sorted(mono, key=lambda x: -x["tokens"])[:12]]},
            "ii_polysyllabic": {"tokens": tot(poly), "lemmas": len(poly),
                                "exemplars": [r["lemma"] for r in
                                              sorted(poly, key=lambda x: -x["tokens"])[:12]]},
            "ant_by_dictionary_verdict": {
                v: {"tokens": tot(rs), "lemmas": len(rs),
                    "exemplars": [r["lemma"] for r in
                                  sorted(rs, key=lambda x: -x["tokens"])[:12]]}
                for v, rs in verdicts.items()},
        },
        "mergedPairs": merged_pairs,
        "variantCitations": variant_citations,
        "pinnedPair": pinned,
        "unresolved": sorted(
            ({"lemma_id": r["lemma_id"], "lemma": r["lemma"], "tokens": r["tokens"]}
             for r in verdicts["unresolved"]), key=lambda d: -d["tokens"]),
        "unreached": {
            "ii_adj_tokens": before_ii["upos"].get("ADJ", 0),
            "ant_adj_tokens": before_ant["upos"].get("ADJ", 0),
            "reason": "G2's universe is upos='NOUN'; the ADJ surplus has no per-lemma "
                      "inventory outside dcs_full.sqlite, which is not present on this box",
        },
        "reconciliation": [{"check": c, "got": a, "want": b, "ok": a == b}
                           for c, a, b in recon],
        "reconciles": ok,
        "perLemmaAnt": [per_lemma[k] for k in sorted(per_lemma)],
    }

    os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as fh:
        json.dump(payload, fh, ensure_ascii=False, indent=1, sort_keys=True)
        fh.write("\n")
    print("wrote %s" % OUT_JSON)

    write_report(payload, mono, poly, verdicts, merged_pairs, recon, ok)
    write_reconciliation(payload, recon, ok, ii_rows, ant_rows, mono, poly, verdicts)

    if check and not ok:
        print("FAIL: a total does not reconcile", file=sys.stderr)
        return 1
    print("reconciles: %s" % ok)
    return 0


def _tbl(rows):
    return "\n".join(rows)


def _ids(seq):
    return "`%s`" % ",".join(sorted(seq)) if seq else "—"


def _pin_prose(pin):
    """Answer the pinned bhagavant/bhagavat question in full, from the index itself."""
    said = {"mw": pin["perDictionary"].get("mw"), "pwg": pin["perDictionary"].get("pwg")}
    inuni = pin["inNounUniverse"]
    parts = [
        "MW indexes भगवत् under %s and भगवन्त् under %s (verdict: `%s`)."
        % (_ids(pin["mwIds"]["at"]), _ids(pin["mwIds"]["ant"]), said["mw"]),
        "PWG indexes भगवत् under %s and भगवन्त् under %s (verdict: `%s`)."
        % (_ids(pin["pwgIds"]["at"]), _ids(pin["pwgIds"]["ant"]), said["pwg"]),
        "Combined verdict: **`%s`**." % pin["verdict"],
    ]
    if pin["verdict"] == "one_lexeme_two_spellings":
        parts.append(
            "The two PWG spellings resolve to the **same entry ids**, so the dictionary"
            " itself states that `bhagavat` and `bhagavant` are one lexeme written two"
            " ways. This is the external signal GAPS 14 asked for, and it is a declaration"
            " in the lexicon, not a character rule inferred from the endings.")
    parts.append(
        "In G2's NOUN universe this stem appears as %s. %s"
        % (", ".join("`%s` (lemma_id %d, %d tokens)"
                     % (x["lemma"], x["lemma_id"], x["tokens"]) for x in inuni)
           if inuni else "**no lemma_id at all**",
           "The DCS `bhagavat` lemma_id is tagged **ADJ**, and G2 carries only NOUN, so the"
           " two-lemma_id merge itself cannot be counted from this substrate — the"
           " dictionary verdict above stands regardless, and the uncountable half is"
           " declared INCONCLUSIVE rather than guessed."))
    return " ".join(parts)


def write_report(p, mono, poly, verdicts, merged_pairs, recon, ok):
    a = p["after"]
    b = p["before"]
    ex = lambda k: ", ".join("`%s`" % s for s in a[k]["exemplars"][:8])
    vex = lambda v: ", ".join("`%s`" % s for s in
                              a["ant_by_dictionary_verdict"][v]["exemplars"][:8])
    av = a["ant_by_dictionary_verdict"]
    n_un = av["unresolved"]
    total_ant = sum(av[v]["lemmas"] for v in av)
    reached = total_ant - n_un["lemmas"]

    lines = [
        "# Nominal paradigm — the two pooled declension classes, split (H3984, GAPS 14)",
        "",
        "_Created: 03-09-2026 · Last updated: 03-09-2026_",
        "",
        "_Auto-generated by [`split_pooled_nominal_classes.py`]"
        "(https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/split_pooled_nominal_classes.py)."
        " Do not hand-edit._",
        "",
        "[GAPS 14](https://github.com/gasyoun/SanskritLexicography/blob/master/GAPS.md) records that"
        " [`paradigm_nominal.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal.json)"
        " ships two buckets that pool distinct declension classes, because the master"
        " tags case/number/gender but never a class. H1472 shipped the pools rather than"
        " guess a character rule. This report splits both with an **external lexical"
        " signal**, and reports every lemma the signal does not reach instead of guessing it.",
        "",
        "## Substrate and its limit",
        "",
        "The lemma inventory is Sangram G2's"
        " [`lemma_cell_coverage.csv`](https://github.com/gasyoun/SanskritGrammar/blob/main/sangram/data/declension_cell_coverage/lemma_cell_coverage.csv)"
        " (H1048) — the complete, unfloored `upos='NOUN'` universe read from the same"
        " pinned master with the same `lemma_id` keying. G2's universe is NOUN-only; the"
        " ADJ surplus this asset carries beyond it has no per-lemma inventory outside"
        " `dcs_full.sqlite`, which is **not present on this box**. That surplus is"
        " therefore reported as an unreached remainder below, never split on a guess:",
        "",
        "| pool | NOUN tokens (split here) | ADJ tokens (not reached) | pool total |",
        "|---|--:|--:|--:|",
        "| `ii` | %d | %d | %d |" % (b["ii"]["upos"].get("NOUN", 0),
                                     b["ii"]["upos"].get("ADJ", 0), b["ii"]["n"]),
        "| `ant` | %d | %d | %d |" % (b["ant"]["upos"].get("NOUN", 0),
                                      b["ant"]["upos"].get("ADJ", 0), b["ant"]["n"]),
        "",
        "The `ii` pool is **%.1f %%** NOUN by token mass, so the split below covers"
        " almost all of it. The `ant` pool is only **%.1f %%** NOUN, because most"
        " -vant/-mant stems are tagged ADJ; its lemma-level result is complete for the"
        " NOUN universe and explicitly incomplete for the corpus as a whole."
        % (100.0 * b["ii"]["upos"].get("NOUN", 0) / b["ii"]["n"],
           100.0 * b["ant"]["upos"].get("NOUN", 0) / b["ant"]["n"]),
        "",
        "## Signal A — the long-ī pool, split by syllable count",
        "",
        "A Sanskrit syllable has exactly one vowel nucleus, so the syllable count of a"
        " citation form is the number of IAST vowel nuclei in it (`ai` and `au` are one"
        " nucleus each; `ā ī ū ṛ ṝ ḷ ḹ e o` one each). Monosyllabic long-ī stems"
        " (śrī, strī, dhī) take the strong-case endings the polysyllabic devī/nadī type"
        " does not; that is the classical criterion, and it is a phonological property"
        " of the word, not a spelling accident. Input is NFC-normalised first, so a"
        " decomposed `ī` cannot be miscounted.",
        "",
        "| subclass | lemma_ids | tokens | exemplars (by frequency) |",
        "|---|--:|--:|---|",
        "| `ii_monosyllabic` — śrī/strī/dhī type | %d | %d | %s |"
        % (a["ii_monosyllabic"]["lemmas"], a["ii_monosyllabic"]["tokens"], ex("ii_monosyllabic")),
        "| `ii_polysyllabic` — devī/nadī type | %d | %d | %s |"
        % (a["ii_polysyllabic"]["lemmas"], a["ii_polysyllabic"]["tokens"], ex("ii_polysyllabic")),
        "| **pool (NOUN)** | **%d** | **%d** | |"
        % (a["ii_monosyllabic"]["lemmas"] + a["ii_polysyllabic"]["lemmas"],
           a["ii_monosyllabic"]["tokens"] + a["ii_polysyllabic"]["tokens"]),
        "",
        "## Signal B — the -ant pool, adjudicated by dictionary headword-index entry ids",
        "",
        "The pool merges genuine -ant/-vant/-mant stems with the master's own"
        " -at/-vat/-mat citations of the same stems. The external signal is the **headword"
        " index of Monier-Williams and the Petersburg Dictionary**, read from the"
        " committed csl-json exports"
        " (`csl-json/ashtadhyayi.com/mw.json`, %d headwords, and `pwg.json`, %d headwords;"
        " source of record: [%s](%s) and [%s](%s)). For every lemma in the pool BOTH the"
        " -at and the -ant Devanagari spelling of the same stem is looked up. Only the"
        " headword index is read — no gloss prose is pattern-matched."
        % (p["signals"]["ant"]["source"]["mwHeadwords"],
           p["signals"]["ant"]["source"]["pwgHeadwords"],
           "mw.json", p["signals"]["ant"]["source"]["mw"],
           "pwg.json", p["signals"]["ant"]["source"]["pwg"]),
        "",
        "**The entry ids matter, not merely membership.** A csl-json `words` index maps a"
        " headword to the ids of the entries reachable under it, and both spellings of one"
        " stem routinely appear — pointing at the *same* ids. PWG registers both भगवत् and"
        " भगवन्त् under the identical pair `53806,80057`: that is the dictionary declaring"
        " **one lexeme under two spellings**, not two headwords. A presence-only test reads"
        " the same evidence as \"two distinct headwords\" and gets the pinned"
        " `bhagavant` / `bhagavat` case exactly backwards, so the adjudication below"
        " compares entry-id **sets**. Where two dictionaries disagree, the one that keeps"
        " the spellings apart wins: a genuine homonym pair must not be collapsed on another"
        " lexicon's indexing habit.",
        "",
        "| verdict | what the dictionary is saying | lemma_ids | tokens | exemplars |",
        "|---|---|--:|--:|---|",
        "| `one_lexeme_two_spellings` | both spellings are indexed **and share entry ids**"
        " — one lexeme, two citation spellings; a DCS `-at` and `-ant` lemma_id for it are"
        " the same word | %d | %d | %s |"
        % (av["one_lexeme_two_spellings"]["lemmas"],
           av["one_lexeme_two_spellings"]["tokens"], vex("one_lexeme_two_spellings")),
        "| `two_headwords` | both spellings are indexed with **disjoint** entry ids — the"
        " dictionary keeps them apart, so this asset must too | %d | %d | %s |"
        % (av["two_headwords"]["lemmas"], av["two_headwords"]["tokens"],
           vex("two_headwords")),
        "| `at_only` | indexed **only** as `-at`; that is the dictionary's citation form,"
        " and a DCS `-ant` lemma_id for it carries the variant spelling | %d | %d | %s |"
        % (av["at_only"]["lemmas"], av["at_only"]["tokens"], vex("at_only")),
        "| `ant_only` | indexed **only** as `-ant`; a DCS `-at` lemma_id for it carries the"
        " variant spelling | %d | %d | %s |"
        % (av["ant_only"]["lemmas"], av["ant_only"]["tokens"], vex("ant_only")),
        "| `unresolved` | **no external signal** — neither spelling is a headword in either"
        " dictionary; stays pooled, no rule encoded | %d | %d | %s |"
        % (n_un["lemmas"], n_un["tokens"], vex("unresolved")),
        "| **pool (NOUN)** | | **%d** | **%d** | |"
        % (total_ant, sum(av[v]["tokens"] for v in av)),
        "",
        "**Reach: %d of %d NOUN lemma_ids (%.1f %%) are adjudicated by the signal;"
        " %d are left pooled and named below.**"
        % (reached, total_ant, 100.0 * reached / total_ant if total_ant else 0.0,
           n_un["lemmas"]),
        "",
        "### `bhagavant` / `bhagavat` — the pair GAPS 14 pins by name",
        "",
        "%s" % _pin_prose(p["pinnedPair"]),
        "",
        "### The merge the pool hides",
        "",
        "Stems the master carries under **two** `lemma_id`s where the dictionary indexes"
        " **one** lexeme. Rows where a `two_headwords` verdict says the dictionary keeps"
        " the spellings apart are excluded — a genuine homonym pair is not a merge:",
        "",
    ]
    spell = [m for m in merged_pairs if m["kind"] == "spelling_pair"]
    dupes = [m for m in merged_pairs if m["kind"] == "duplicate_lemma_id"]
    if merged_pairs:
        def _rows(ms):
            out = ["| stem | dictionary verdict | DCS lemma_ids | tokens |",
                   "|---|---|---|--:|"]
            for m in ms:
                ids = " + ".join("`%s` (%d, %d tok)"
                                 % (x["lemma"], x["lemma_id"], x["tokens"])
                                 for x in m["lemma_ids"])
                out.append("| `%s` | `%s` | %s | %d |"
                           % (m["stem"], m["verdict"], ids, m["tokens"]))
            return out
        lines.append("**The `-at` / `-ant` spelling pairs** — the merge GAPS 14 names."
                     " The dictionary indexes one lexeme; the master carries two"
                     " `lemma_id`s, one per spelling:")
        lines.append("")
        lines += _rows(spell) if spell else ["_None in the NOUN universe._"]
        lines.append("")
        lines.append("**Same citation form, two `lemma_id`s** — a distinct defect found on"
                     " the way, kept separate so it does not inflate the count above. The"
                     " master holds two ids under one spelling; the dictionary knows one"
                     " lexeme:")
        lines.append("")
        lines += _rows(dupes) if dupes else ["_None in the NOUN universe._"]
        lines.append("")
        lines.append("**%d stem(s)** are split across two `lemma_id`s by spelling"
                     " (%d tokens) and **%d** by duplicate id under one spelling"
                     " (%d tokens); together %d `lemma_id`s stand for %d lexemes."
                     % (len(spell), sum(m["tokens"] for m in spell),
                        len(dupes), sum(m["tokens"] for m in dupes),
                        sum(len(m["lemma_ids"]) for m in merged_pairs),
                        len(merged_pairs)))
    else:
        lines.append(
            "_None found — and that is a finding, not an empty result._ A double-counted"
            " pair needs **two** DCS `lemma_id`s for one stem *inside G2's NOUN universe*."
            " The master resolves each stem to a single citation form per `lemma_id`, and"
            " the second member of a pair like `bhagavat` is tagged **ADJ**, which G2 does"
            " not carry. The merge GAPS 14 describes is therefore real but not *countable*"
            " from this substrate; what is countable is the citation-form mismatch below,"
            " which is the same defect seen from the lemma side.")
    lines += [
        "",
        "### DCS citation spelling vs the dictionary's",
        "",
        "Lemmas whose DCS citation form is **not** the spelling the dictionaries index the"
        " lexeme under. The class label rests on that spelling, so each row is a lemma"
        " whose `-ant` bucket membership is decided by the master's own orthographic"
        " choice rather than by the lexicon:",
        "",
    ]
    vc = p["variantCitations"]
    if vc:
        lines += ["| DCS lemma | lemma_id | tokens | DCS cites | dictionary cites |",
                  "|---|--:|--:|---|---|"]
        for d in vc[:40]:
            lines.append("| `%s` | %d | %d | `-%s` (%s) | `-%s` (%s) |"
                         % (d["lemma"], d["lemma_id"], d["tokens"], d["dcsSpelling"],
                            d["at_devanagari"] if d["dcsSpelling"] == "at"
                            else d["ant_devanagari"],
                            "at" if d["verdict"] == "at_only" else "ant",
                            d["at_devanagari"] if d["verdict"] == "at_only"
                            else d["ant_devanagari"]))
        if len(vc) > 40:
            lines.append("")
            lines.append("_… and %d more, in the JSON under `variantCitations`._"
                         % (len(vc) - 40))
        lines.append("")
        lines.append("**%d of %d adjudicated lemma_ids (%d tokens) cite the stem under a"
                     " spelling the dictionaries do not use as the headword.**"
                     % (len(vc), reached, sum(d["tokens"] for d in vc)))
    else:
        lines.append("_None — every adjudicated lemma cites the stem under the spelling the"
                     " dictionaries index it by._")
    lines += [
        "",
        "### Left pooled — no external signal",
        "",
        "These lemma_ids are in neither dictionary under either spelling. **No rule is"
        " encoded for them.** Naming them is the deliverable; guessing them is the"
        " failure mode GAPS 14 exists to prevent.",
        "",
    ]
    un = p["unresolved"]
    if un:
        lines += ["| lemma | lemma_id | tokens |", "|---|--:|--:|"]
        for u in un[:40]:
            lines.append("| `%s` | %d | %d |" % (u["lemma"], u["lemma_id"], u["tokens"]))
        if len(un) > 40:
            lines.append("")
            lines.append("_… and %d more; the full list is in"
                         " [`visual/paradigm_nominal_class_split.json`]"
                         "(https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal_class_split.json)"
                         " under `unresolved`._" % (len(un) - 40))
    else:
        lines.append("_None — the signal reached every lemma in the pool._")
    lines += [
        "",
        "## Reconciliation",
        "",
        "Totals must **reconcile**, not merely change. Every check below compares a"
        " number computed here against a number this asset already published or that G2"
        " already ships:",
        "",
        "| check | got | want | |",
        "|---|--:|--:|---|",
    ]
    for c, got, want in recon:
        lines.append("| %s | %d | %d | %s |" % (c, got, want, "✅" if got == want else "❌"))
    lines += [
        "",
        "**%s** — no G2 total moved: the split relabels lemma_ids inside this asset and"
        " changes no token count, no lemma count, and no attested-cell count."
        % ("All checks pass" if ok else "RECONCILIATION FAILED"),
        "",
        "_Dr. Mārcis Gasūns_",
    ]
    os.makedirs(os.path.dirname(OUT_MD), exist_ok=True)
    with open(OUT_MD, "w", encoding="utf-8") as fh:
        fh.write(_tbl(lines) + "\n")
    print("wrote %s" % OUT_MD)


def write_reconciliation(p, recon, ok, ii_rows, ant_rows, mono, poly, verdicts):
    a = p["after"]
    lines = [
        "# Nominal paradigm — Sangram G2 reconciliation, re-run after the H3984 split",
        "",
        "_Created: 03-09-2026 · Last updated: 03-09-2026_",
        "",
        "_Auto-generated by [`split_pooled_nominal_classes.py`]"
        "(https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/split_pooled_nominal_classes.py)."
        " Companion to the pre-split"
        " [`nominal_g2_reconciliation.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_g2_reconciliation.md)"
        " written by `gen_paradigm_nominal.py`._",
        "",
        "## Before (unchanged, carried from `nominal_g2_reconciliation.md`)",
        "",
        "| G2 `stem_final` | this asset | lemma_ids | intended? |",
        "|---|---|--:|---|",
        "| `other_consonant` | `ant` | 279 | yes — `-ant` extension |",
        "",
        "57,144 lemma_ids agreed exactly on token count and attested-cell count; 0"
        " disagreed; 0 absent on either side; 21,802 ADJ-only lemma_ids were this"
        " asset's surplus, outside G2's NOUN universe by design.",
        "",
        "## After",
        "",
        "The split is a **relabelling within this asset**. It reads G2's CSV as its"
        " lemma inventory and writes no new token, lemma or cell count, so the shared"
        " NOUN subset above is untouched by construction — the numbers below prove it"
        " rather than assert it.",
        "",
        "| G2 `stem_final` | this asset, after the split | lemma_ids | tokens | intended? |",
        "|---|---|--:|--:|---|",
        "| `ii` | `ii_monosyllabic` | %d | %d | yes — Signal A, syllable count |"
        % (a["ii_monosyllabic"]["lemmas"], a["ii_monosyllabic"]["tokens"]),
        "| `ii` | `ii_polysyllabic` | %d | %d | yes — Signal A, syllable count |"
        % (a["ii_polysyllabic"]["lemmas"], a["ii_polysyllabic"]["tokens"]),
    ]
    for v in ("one_lexeme_two_spellings", "two_headwords", "at_only", "ant_only",
              "unresolved"):
        d = a["ant_by_dictionary_verdict"][v]
        note = ("no — left pooled, no external signal" if v == "unresolved"
                else "yes — Signal B, MW/PWG headword-index entry ids")
        lines.append("| `other_consonant` | `ant` / `%s` | %d | %d | %s |"
                     % (v, d["lemmas"], d["tokens"], note))
    lines += [
        "",
        "| check | got | want | |",
        "|---|--:|--:|---|",
    ]
    for c, got, want in recon:
        lines.append("| %s | %d | %d | %s |" % (c, got, want, "✅" if got == want else "❌"))
    lines += [
        "",
        "**%s.** The G2 shared-NOUN-subset figures (57,144 agree / 0 disagree / 0"
        " absent either way / 21,802 ADJ-only surplus) are unchanged: this pass adds"
        " labels, and adds no lemma_id to and removes none from either universe."
        % ("Every total reconciles" if ok else "A TOTAL FAILED TO RECONCILE"),
        "",
        "_Dr. Mārcis Gasūns_",
    ]
    with open(OUT_RECON, "w", encoding="utf-8") as fh:
        fh.write(_tbl(lines) + "\n")
    print("wrote %s" % OUT_RECON)


if __name__ == "__main__":
    sys.exit(main())
