# -*- coding: utf-8 -*-
"""build_uttarapada_dict_vs_corpus.py -- H1328.

Join the MW uttarapada (final-member) index against the DCS Kompozity compound
split-list, to expose *dictionary productivity vs corpus attestation* for each
compound final member -- the one thing neither side records alone.

Dictionary side (final-member keyed):
  MWderivations/issue15/compounds_reverse_classified.tsv
  cols: uttarapada <TAB> n_left_members <TAB> class <TAB> left_members(space-sep)
  Kept classes: UTTARAPADA, KRT_STEM_MEMBER  (TADDHITA_SUFFIX* are bound
  morphemes, NOT compound members -- excluded upstream by design; see issue15).

Corpus side (surface-form keyed):
  derived-data/Kompozity/cmps.csv    surface; m1 m2 ...            (~399k forms, no freq)
  derived-data/Kompozity/names.csv   surface; m1 m2 ...;n;totalFreq;<per-period>  (168k with freq)
  names.csv surfaces are a strict subset of cmps.csv (verified), so cmps.csv is
  the compound-form universe and names.csv annotates a subset with DCS token freq.

TWO transliteration/markup mismatches sit between the sides and MUST be folded
or the divergence is fake (verified empirically before trusting -- H1328 traps):
  1. anusvara: MW writes m-dot-below (U+1E43), DCS m-dot-above (U+1E41).
  2. markup in MW keys: '@' join marker, '-' internal hyphen, leading avagraha
     "'" = elided initial a  (e.g. "'bja" -> abja, "sU@kta" -> sukta).
okey() below folds ONLY these orthographic artifacts -- it does NOT fold
vowel-length / gender / junction-sandhi differences (sena vs sena-long, cchada
vs chada, ssTha vs stha): those are morphological, and collapsing them would
manufacture matches. Instead they are DIAGNOSED (form_variant) so a corpus-absent
final is never falsely asserted absent when only its citation form differs.

Corpus-absent != ghost word. Per SanskritLexicography FINDINGS the pwg/mw
"ghost-word" residue is dominated by corpus gaps and the kosa-only lexical
stratum, not spurious words; and FINDINGS s86 already showed grammarians'
canonical samasas are largely corpus-unattested. So the MW-only stratum here is
reported as *dictionary-only (corpus-unattested)* -- a LOWER BOUND on real absence.

Usage:
  python build_uttarapada_dict_vs_corpus.py            # writes TSV + prints diagnostics
  python build_uttarapada_dict_vs_corpus.py --mw-tsv <path> --cmps <path> --names <path>
"""
import sys, os, csv, argparse, unicodedata
from collections import Counter, defaultdict
sys.stdout.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
# VisualDCS/derived-data/Kompozity -> GitHub/ is three levels up
GH = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
DEF_MW    = os.path.join(GH, "MWderivations", "issue15", "compounds_reverse_classified.tsv")
DEF_CMPS  = os.path.join(HERE, "cmps.csv")
DEF_NAMES = os.path.join(HERE, "names.csv")
OUT_TSV   = os.path.join(HERE, "uttarapada_dict_vs_corpus.tsv")

KEEP_CLASSES = {"UTTARAPADA", "KRT_STEM_MEMBER"}
ANUS_ABOVE, ANUS_BELOW = "ṁ", "ṃ"  # m-dot-above (DCS), m-dot-below (MW/IAST)


def nfc(s):
    return unicodedata.normalize("NFC", s.strip())


def okey(s):
    """Orthographic normalization only (both sides). Non-lossy for lexical identity."""
    s = nfc(s).replace("@", "")
    if s.startswith("'"):
        s = "a" + s[1:]                     # avagraha = elided initial a
    return s.replace("-", "").replace(ANUS_ABOVE, ANUS_BELOW)


def fold_variants(s):
    """Diagnostic-only: candidate corpus forms if the mismatch is morphological /
    junction-sandhi rather than orthographic. Used to classify absences, never to
    join. Returns a set of candidate okeys."""
    cands = {s}
    if s.startswith("cch"):  cands.add(s[1:])          # patra+cchada written cchada -> chada
    if s.startswith("jj"):   cands.add(s[1:])
    if s.startswith("ssh") or s.startswith("ṣṭh"):  # ssTha
        cands.add("sth" + s[3:])
    if s.startswith("ṣṭ"):                   # ssT -> st
        cands.add("st" + s[2:])
    if s.startswith("ṣ"):                          # ss -> s (retroflexion of s at junction)
        cands.add("s" + s[1:])
    if s.startswith("ṇ"):                          # nn -> n
        cands.add("n" + s[1:])
    out = set()
    for x in list(cands):
        out.add(x)
        for a, b in [("ā", "a"), ("a", "ā"), ("ī", "i"),
                     ("ī", "a"), ("ū", "u")]:  # a<->long-a, long-i->i/a, long-u->u
            if x.endswith(a):
                out.add(x[:-1] + b)
        if x and x[-1] in "āīū":          # strip a trailing long vowel (fem marker)
            out.add(x[:-1])
    out.discard(s)
    return out


# ---------------------------------------------------------------- load MW side
def load_mw(path):
    finals = {}   # okey -> dict(n_left_raw, classes:set, first:set(okey))
    with open(path, encoding="utf-8") as f:
        f.readline()  # header
        for line in f:
            p = line.rstrip("\n").split("\t")
            if len(p) < 4 or p[2] not in KEEP_CLASSES:
                continue
            k = okey(p[0])
            firsts = set(okey(x) for x in p[3].split() if x.strip())
            d = finals.get(k)
            if d is None:
                finals[k] = {"n_left_raw": int(p[1]), "classes": {p[2]}, "first": set(firsts)}
            else:
                d["n_left_raw"] = max(d["n_left_raw"], int(p[1]))
                d["classes"].add(p[2])
                d["first"] |= firsts
    return finals


# ------------------------------------------------------------ load corpus side
def load_corpus(cmps_path, names_path):
    # freq by raw surface (names.csv)
    freq = {}
    with open(names_path, encoding="utf-8") as f:
        for line in f:
            r = line.rstrip("\n").split(";")
            if len(r) >= 4:
                try:
                    freq[nfc(r[0])] = int(r[3])
                except ValueError:
                    pass
    # dedupe cmps by surface so each distinct compound word-form counts once
    surf_members = {}
    with open(cmps_path, encoding="utf-8") as f:
        for line in f:
            r = line.rstrip("\n").split(";")
            if len(r) < 2:
                continue
            members = [okey(x) for x in r[1].split() if x.strip()]
            if members:
                surf_members[nfc(r[0])] = members
    final_forms = Counter()          # okey final -> distinct compound-form count
    final_tokens = Counter()         # okey final -> summed DCS token freq
    final_firsts = defaultdict(set)  # okey final -> set of okey penults
    anymember = set()                # every okey member seen anywhere
    for surf, members in surf_members.items():
        for m in members:
            anymember.add(m)
        if len(members) >= 2:
            U = members[-1]
            final_forms[U] += 1
            final_tokens[U] += freq.get(surf, 0)
            final_firsts[U].add(members[-2])
    return {"forms": final_forms, "tokens": final_tokens, "firsts": final_firsts,
            "anymember": anymember, "n_surfaces": len(surf_members),
            "n_freq_surfaces": len(freq)}


def classify(k, corpus):
    if k in corpus["forms"]:
        return "final"
    if any(v in corpus["forms"] for v in fold_variants(k)):
        return "form_variant"
    if k in corpus["anymember"]:
        return "nonfinal_only"
    return "absent"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mw-tsv", default=DEF_MW)
    ap.add_argument("--cmps", default=DEF_CMPS)
    ap.add_argument("--names", default=DEF_NAMES)
    ap.add_argument("--out", default=OUT_TSV)
    args = ap.parse_args()

    mw = load_mw(args.mw_tsv)
    corpus = load_corpus(args.cmps, args.names)

    rows = []
    status_counts = Counter()
    for k, d in mw.items():
        mw_first = d["first"]
        c_first = corpus["firsts"].get(k, set())
        status = classify(k, corpus)
        status_counts[status] += 1
        cls = ("MERGED" if len(d["classes"]) > 1 else next(iter(d["classes"])))
        rows.append({
            "final_member": k,
            "mw_class": cls,
            "mw_first_members": len(mw_first),
            "corpus_compounds": corpus["forms"].get(k, 0),
            "corpus_tokens": corpus["tokens"].get(k, 0),
            "corpus_first_members": len(c_first),
            "overlap_first": len(mw_first & c_first),
            "mw_only_first": len(mw_first - c_first),
            "corpus_only_first": len(c_first - mw_first),
            "corpus_status": status,
        })
    rows.sort(key=lambda r: (-r["mw_first_members"], r["final_member"]))

    cols = ["final_member", "mw_class", "mw_first_members", "corpus_compounds",
            "corpus_tokens", "corpus_first_members", "overlap_first",
            "mw_only_first", "corpus_only_first", "corpus_status"]
    with open(args.out, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols, delimiter="\t")
        w.writeheader()
        w.writerows(rows)

    # ---------------------------------------------------------- diagnostics
    print(f"MW-kept final members (okey-merged): {len(mw)}")
    print(f"corpus: {corpus['n_surfaces']} distinct compound word-forms, "
          f"{corpus['n_freq_surfaces']} freq-annotated; "
          f"{len(corpus['forms'])} distinct final members")
    print("corpus_status distribution:", dict(status_counts))
    print(f"wrote {args.out} ({len(rows)} rows)\n")

    print("=== DIRECTION A: MW-productive, corpus-UNATTESTED (status=absent), by mw_first_members ===")
    a = [r for r in rows if r["corpus_status"] == "absent"]
    for r in a[:40]:
        print(f"   {r['final_member']:20s} mw_first={r['mw_first_members']:4d} class={r['mw_class']}")
    print(f"   ... {len(a)} absent total")

    print("\n=== (caveat) top status=form_variant (NOT absent -- morphological form differs) ===")
    fv = [r for r in rows if r["corpus_status"] == "form_variant"]
    fv.sort(key=lambda r: -r["mw_first_members"])
    for r in fv[:15]:
        print(f"   {r['final_member']:20s} mw_first={r['mw_first_members']:4d}")
    print(f"   ... {len(fv)} form_variant total")

    print("\n=== DIRECTION B: corpus-frequent finals, MW-thin ===")
    # corpus-side junk head to exclude: bound taddhita suffixes MW dropped +
    # enclitic particles + pronoun stems + a few bare high-freq roots.
    STOP = {
        # taddhita (bound; MW excluded them by design -> always look MW-thin)
        "tva", "tā", "vat", "mat", "maya", "tara", "tama", "in", "min", "vin", "ya",
        # enclitics / particles
        "ca", "vā", "tu", "hi", "eva", "api", "iva", "atha", "na", "ha", "sma",
        "u", "uta", "iti", "kila", "khalu", "nu", "vai", "cid", "cana", "aho", "are", "tatas",
        # pronoun stems
        "tad", "idam", "etad", "adas", "tvad", "mad", "asmad", "yuṣmad", "enad",
        "yad", "ka", "kim", "aham", "tvam", "ena", "anya",
        # bare verb roots DCS splits as members (not lexical uttarapada)
        "kṛ", "bhū", "as", "gam", "vac", "dā", "jan", "han", "dṛś",
        "yuj", "i", "ah", "āgam", "upe",
    }
    mw_first_by_final = {k: len(d["first"]) for k, d in mw.items()}
    corpus_finals = [(m, corpus["forms"][m], corpus["tokens"][m])
                     for m in corpus["forms"]]
    # rank by DCS tokens (auto-suppresses zero-token particle/root splits)
    corpus_finals.sort(key=lambda x: -x[2])
    print("(ranked by corpus_tokens; MW-thin = mw_first<=20; stoplist applied)")
    shown = 0
    for m, forms, tok in corpus_finals:
        if m in STOP:
            continue
        nl = mw_first_by_final.get(m, 0)
        if nl <= 20:
            print(f"   {m:16s} tokens={tok:6d} forms={forms:6d} mw_first={nl}")
            shown += 1
        if shown >= 35:
            break

    print("\n=== corpus junk head (documentation): top finals by FORM count with tokens ===")
    for m, forms in corpus["forms"].most_common(20):
        tag = "STOP" if m in STOP else ("MW" if m in mw else "--")
        print(f"   {m:14s} forms={forms:6d} tokens={corpus['tokens'][m]:7d} {tag}")


if __name__ == "__main__":
    main()
