#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regen_widgets.py — M7 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Regenerates the VisualDCS dashboard data from the 2026 master (dcs.sqlite /
dcs_full.sqlite) and writes a 2021->2026 deltas report. Does NOT touch the HTML.

Outputs (to ./widgets/, gitignored — regenerable):
  corpus_stats.json        summary morpho-statistics
  verb_forms_ud.json       verb distribution by native UD (Tense/Voice/Mood/VerbForm) plus DCS's
                           own Formation feature + Pareto
  verb_forms_38cat.json    verb distribution mapped to the legacy 38 DCS categories + Pareto
  morph_pn.json            finite-verb person x number per tense
  tense_case.json          nominal case x number distribution
  coll_compact.json        top collocations (same-sentence lemma co-occurrence)
  conc_totals.json         form -> total corpus occurrences

The 38-category map is data-driven: it reuses M4's learned 15.csv-code <-> UD map.

NOT regenerable from the master (documented in the report, not produced here):
  dcs_genres / dcs_scatter   need per-text genre + date metadata (not in the CoNLL-U)
  anki_compact / passage_library   hand-curated

Stdlib only. Run after the import (M2/M6).
    python regen_widgets.py --db dcs_full.sqlite
"""

import argparse
import json
import os
import re
import sqlite3
import sys
from collections import Counter, defaultdict

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from export_master import learn_code_map                  # noqa: E402  (M4 code map)

OUT = os.path.join(HERE, "widgets")
REPORT = os.path.join(HERE, "reports", "m7_widgets.md")
REL_2021 = os.path.join(HERE, "..", "DCS-data-2021")

# Independently documented 2021 verbal headline (README.md, CLAUDE.md), from the Excel
# source rather than from timws.csv — so it is a real cross-check, not a restatement.
# timws.csv's 42 codes sum to 781,618; the 2 difference is a source-side rounding the
# A38 correction block documents. See read_2021_verbcats() guard 2.
TIMWS_DOCUMENTED_TOTAL = 781_616
TIMWS_TOTAL_TOLERANCE = 10


def dump(name, obj):
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, name), "w", encoding="utf-8") as fh:
        json.dump(obj, fh, ensure_ascii=False, indent=1)
    return os.path.getsize(os.path.join(OUT, name))


def pareto(pairs):
    """pairs = [(label, count)] sorted desc -> add cumulative %%."""
    total = sum(c for _, c in pairs) or 1
    out, run = [], 0
    for label, c in pairs:
        run += c
        out.append({"label": label, "count": c, "pct": round(100 * c / total, 2),
                    "cum_pct": round(100 * run / total, 2)})
    return out, total


def corpus_stats(conn):
    q = lambda s: conn.execute(s).fetchone()[0]
    upos = dict(conn.execute("SELECT upos, COUNT(*) FROM token WHERE upos IS NOT NULL GROUP BY upos ORDER BY 2 DESC"))
    return {
        "texts": q("SELECT COUNT(*) FROM text"),
        "treebank_texts": q("SELECT COUNT(*) FROM text WHERE has_dependencies=1"),
        "sentences": q("SELECT COUNT(*) FROM sentence"),
        "tokens": q("SELECT COUNT(*) FROM token"),
        "distinct_lemmas": q("SELECT COUNT(DISTINCT lemma_id) FROM token WHERE lemma_id IS NOT NULL"),
        "upos": upos,
        "verbs": upos.get("VERB", 0),
    }


def ud_to_category(conn):
    """Build {(tense,voice,mood): 38-category name} from M4's learned code<->UD map."""
    rows, _timws = learn_code_map(conn)
    m = {}
    norm = lambda v: None if v in ("None", "", None) else v   # M4 stringifies None -> "None"
    if rows:
        for code, name, n15, ncombo, ud in rows:
            mm = re.match(r"Tense=(.*)\|Voice=(.*)\|Mood=(.*)", ud or "")
            if mm and "no pilot match" not in (ud or ""):
                key = (norm(mm.group(1)), norm(mm.group(2)), norm(mm.group(3)))   # (Tense, Voice, Mood)
                m.setdefault(key, name)               # first (most frequent code) wins
    # UD Tense=Past conflates Sanskrit aorist+perfect (no UD value separates them), and the auto-map
    # mislabels Past-indicative as "Imperfect"; override with honest labels, keep true Impf distinct.
    # The Past-Ind entry is the PRE-re-split label, and as of H2294 it is DEAD for finite
    # past-indicative rows in BOTH consumers: verb_forms() and gen_paradigm_attested.py each
    # override it per token via past_class() (feat_formation), because this map is keyed on
    # (Tense,Voice,Mood) and structurally cannot carry a per-token feature. It stays only as
    # the honest fallback for a consumer that does not apply the split -- do not "fix" it to
    # a split label, which would silently claim a resolution this key cannot make.
    # See reports/past_tense_resplit_validation.md for the split's measured error bars.
    for voice, lab in ((None, "Active"), ("Pass", "Passive"), ("Mid", "Middle")):
        m[("Past", voice, "Ind")] = f"Perfect/Aorist {lab}"
        m[("Impf", voice, "Ind")] = f"Imperfect {lab}"
    return m


# -- the aorist/perfect re-split (H1486) ------------------------------------------
# UD has no Aorist tense value, but DCS's own `feat_formation` does carry the traditional
# past-stem formation on the finite past indicative. The seven values below are Whitney's
# seven aorist types (ch. IX §§824-930); `peri` on Tense=Past is the PERIPHRASTIC PERFECT
# (on Tense=Fut the same string is the periphrastic future — hence the tense guard).
# The simple (reduplicated) perfect is DCS's UNMARKED past formation and carries no tag,
# so NULL -> Perfect is a default, not an observation. It is validated — not assumed — by
# validate_past_tense_resplit.py; read its report for the measured error bars before
# quoting either class as exact.
AORIST_FORMATIONS = ("root", "them", "red", "s", "is", "sis", "sa")


def past_class(formation):
    """feat_formation -> the past-stem class, for a Tense=Past Mood=Ind finite token."""
    if formation in AORIST_FORMATIONS:
        return "Aorist"
    if formation == "peri":
        return "Periphrastic Perfect"
    return "Perfect"                 # unmarked default — the simple/reduplicated perfect


def is_past_indicative(tense, mood, verbform):
    """The one bucket feat_formation actually populates (16,100 of its 93,329 tokens)."""
    return tense == "Past" and mood == "Ind" and verbform is None


# participle morphology heuristic (for VerbForm=Part tokens that carry no Tense tag) --
# UD marks present participles with Tense=Pres, so the no-Tense bucket is dominated by the
# -ta/-na past passive participle; carve out the rare -māna/-māṇa (present middle) by ending.
_PRES_MID = re.compile(r"m[āa][nṇ][aā]")
_PPP_END = re.compile(r"[tn][aāeiou][ḥṃmnṇ]?$|[tn][aā](ni|bhiḥ|bhyaḥ|bhyām|su|yoḥ|sya|smai|smāt|smin|nām|ya)$")
_PRES_ACT = re.compile(r"(ant|at)(|am|aḥ|aṃ|ā|āni|e|au|oḥ|su|bhiḥ)$|an$")


def participle_cat(form):
    f = form or ""
    if _PRES_MID.search(f):
        return "Present Participle"
    if _PPP_END.search(f):
        return "Past Passive Participle"
    if _PRES_ACT.search(f):
        return "Present Participle"
    return "Participle (unclassified)"


def verb_forms(conn):
    """Verb distribution two ways: native UD, and mapped to the 38 DCS categories."""
    # native UD: (VerbForm, Tense, Mood, Voice) + DCS's own Formation, which is what
    # separates aorist from perfect inside Tense=Past (H1486).
    ud_rows = conn.execute(
        "SELECT feat_verbform, feat_tense, feat_mood, feat_voice, feat_formation, COUNT(*) "
        "FROM token WHERE upos='VERB' GROUP BY 1,2,3,4,5 ORDER BY 6 DESC").fetchall()
    ud_pairs = [(f"VerbForm={vf or '-'}|Tense={te or '-'}|Mood={mo or '-'}|Voice={vo or '-'}"
                 f"|Formation={fm or '-'}", c)
                for vf, te, mo, vo, fm, c in ud_rows]
    ud_pareto, ud_total = pareto(ud_pairs)

    cat_map = ud_to_category(conn)
    cats = Counter()
    voice_label = {None: "Active", "Pass": "Passive", "Mid": "Middle"}
    # non-participle verbs: bin at the (tense, voice, mood) group level, except the finite
    # past indicative, which additionally splits on feat_formation (aorist vs perfect).
    for vf, te, mo, vo, fm, c in conn.execute(
            "SELECT feat_verbform, feat_tense, feat_mood, feat_voice, feat_formation, COUNT(*) "
            "FROM token WHERE upos='VERB' AND (feat_verbform IS NULL OR feat_verbform != 'Part') "
            "GROUP BY 1,2,3,4,5"):
        if vf == "Conv":
            name = "Absolutive"
        elif vf == "Inf":
            name = "Infinitive"
        elif vf == "Gdv":
            name = "Future passive participle"
        elif is_past_indicative(te, mo, vf):             # the re-split bucket
            name = f"{past_class(fm)} {voice_label.get(vo, vo)}"
        else:                                            # finite -> learned (Tense,Voice,Mood) map
            name = cat_map.get((te, vo, mo)) or f"({te or '-'}/{mo or '-'}/{vo or '-'})"
        cats[name] += c
    # participles: use Tense when tagged, else the per-form morphology heuristic
    for form, te, c in conn.execute(
            "SELECT form, feat_tense, COUNT(*) FROM token WHERE upos='VERB' AND feat_verbform='Part' "
            "GROUP BY form, feat_tense"):
        if te == "Pres":
            name = "Present Participle"
        elif te == "Fut":
            name = "Future Participle"
        elif te == "Past":
            name = "Past Passive Participle"
        else:
            name = participle_cat(form)
        cats[name] += c
    cat_pareto, cat_total = pareto(sorted(cats.items(), key=lambda kv: -kv[1]))
    return ({"total": ud_total, "distribution": ud_pareto},
            {"total": cat_total, "distribution": cat_pareto})


def morph_pn(conn):
    rows = conn.execute(
        "SELECT feat_tense, feat_person, feat_number, COUNT(*) FROM token "
        "WHERE upos='VERB' AND feat_person IS NOT NULL GROUP BY 1,2,3 ORDER BY 4 DESC").fetchall()
    out = defaultdict(dict)
    for te, pe, nu, c in rows:
        out[te or "-"][f"{pe}{(nu or '')[:2]}"] = c
    return out


def tense_case(conn):
    rows = conn.execute(
        "SELECT feat_case, feat_number, COUNT(*) FROM token "
        "WHERE feat_case IS NOT NULL GROUP BY 1,2 ORDER BY 3 DESC").fetchall()
    out = defaultdict(dict)
    for ca, nu, c in rows:
        out[ca][nu or "-"] = c
    return out


def conc_totals(conn, limit=8000):
    return dict(conn.execute(
        "SELECT form, COUNT(*) c FROM token WHERE upos='VERB' GROUP BY form ORDER BY c DESC LIMIT ?",
        (limit,)).fetchall())


def collocations(conn, top_lemmas=400, per=20):
    """Same-sentence lemma co-occurrence for the most frequent content lemmas."""
    top = [r[0] for r in conn.execute(
        "SELECT lemma_id FROM token WHERE lemma_id IS NOT NULL AND upos IN ('NOUN','VERB','ADJ') "
        "GROUP BY lemma_id ORDER BY COUNT(*) DESC LIMIT ?", (top_lemmas,))]
    names = dict(conn.execute("SELECT lemma_id, lemma FROM lemma WHERE lemma_id IN (%s)"
                              % ",".join("?" * len(top)), top))
    topset = set(top)
    co = defaultdict(Counter)
    # stream tokens grouped by sentence
    cur_sid, bag = None, []
    for sid, lid in conn.execute(
            "SELECT sentence_id, lemma_id FROM token WHERE lemma_id IS NOT NULL "
            "AND upos IN ('NOUN','VERB','ADJ') ORDER BY sentence_id"):
        if sid != cur_sid:
            uniq = set(bag)
            for a in uniq & topset:
                for b in uniq:
                    if a != b:
                        co[a][b] += 1
            cur_sid, bag = sid, []
        bag.append(lid)
    out = {}
    for lid in top:
        out[names.get(lid, str(lid))] = [
            {"lemma": names.get(b, str(b)), "n": n} for b, n in co[lid].most_common(per)]
    return out


def read_2021_verbcats(path):
    """timws.csv -> {category_name: 2021 frequency}.

    Category NAMES repeat in timws.csv — it has two `Aorist Active` codes (583 + 721),
    two `Aorist Medium` (1,056 + 92) and two `Imperfect Active` (35,921 + 4,442), because
    a 38-CODE inventory is being read into a name-keyed map. Sum the collisions; the
    earlier last-wins assignment silently reported 2021 Imperfect Active as 4,442 instead
    of 40,363 and Aorist Active as 721 instead of 1,304 (H1486 — surfaced once the
    re-split gave the 2026 side a matching `Aorist Active` row to compare against).
    """
    out = {}
    p = os.path.join(path, "timws.csv")
    if not os.path.isfile(p):
        return out
    collisions, n_codes, parsed_total = defaultdict(list), 0, 0
    with open(p, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(":")
            if len(parts) >= 3 and parts[0].strip().isdigit():
                code = int(parts[0].strip())
                name = parts[1].strip()
                n = int(parts[2].strip()) if parts[2].strip().isdigit() else 0
                n_codes += 1
                parsed_total += n
                collisions[name].append((code, n))
                out[name] = out.get(name, 0) + n

    # Guard 1 — name collisions are EXPECTED here, but they must be visible. A silent
    # shrink from 42 codes to 30 names is exactly how H1486 shipped a wrong number:
    # nothing in the output hinted that rows had been merged. Print, never swallow.
    dupes = {k: v for k, v in collisions.items() if len(v) > 1}
    if dupes:
        print(f"  timws.csv: {n_codes} codes -> {len(out)} names; "
              f"{len(dupes)} name(s) carry >1 code (summed, not overwritten):")
        for name, hits in sorted(dupes.items(), key=lambda kv: -sum(n for _, n in kv[1])):
            detail = " + ".join(f"{n:,}(code {c})" for c, n in hits)
            print(f"    {name!r}: {detail} = {sum(n for _, n in hits):,}")

    # Guard 2 — reconcile the reconstructed total against the independently documented
    # headline (README.md / CLAUDE.md: 781,616 verbal examples from the Excel source).
    # H1486's corrupted 741,782 sat 39,836 below this for years while a paper explained
    # the gap away as "a separate aggregation"; the two agree to within 2 once summed.
    if parsed_total and abs(parsed_total - TIMWS_DOCUMENTED_TOTAL) > TIMWS_TOTAL_TOLERANCE:
        print(f"  WARNING: timws.csv sums to {parsed_total:,}, but README.md/CLAUDE.md "
              f"document {TIMWS_DOCUMENTED_TOTAL:,} verbal examples "
              f"(delta {parsed_total - TIMWS_DOCUMENTED_TOTAL:+,}, tolerance "
              f"±{TIMWS_TOTAL_TOLERANCE}). Do NOT explain this gap away — reconcile it.",
              file=sys.stderr)
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--db", default=os.path.join(HERE, "dcs.sqlite"))
    ap.add_argument("--no-coll", action="store_true", help="skip the (slow) collocations widget")
    args = ap.parse_args()
    if not os.path.exists(args.db):
        print(f"ERROR: {args.db} not found.", file=sys.stderr)
        return 2
    conn = sqlite3.connect(args.db)

    print(f"regenerating widgets from {os.path.basename(args.db)} ...")
    stats = corpus_stats(conn);            dump("corpus_stats.json", stats)
    ud, cat = verb_forms(conn)
    dump("verb_forms_ud.json", ud);        dump("verb_forms_38cat.json", cat)
    dump("morph_pn.json", morph_pn(conn))
    dump("tense_case.json", tense_case(conn))
    dump("conc_totals.json", conc_totals(conn))
    sizes = {"corpus_stats": 1, "verb_forms_ud": len(ud["distribution"]),
             "verb_forms_38cat": len(cat["distribution"])}
    if not args.no_coll:
        print("  collocations (streaming) ...")
        dump("coll_compact.json", collocations(conn))

    # deltas vs 2021
    old = read_2021_verbcats(REL_2021)
    new = {d["label"]: d["count"] for d in cat["distribution"]}
    old_total = sum(old.values())

    L = ["# M7 — dashboard widgets regenerated from the 2026 master\n",
         f"_Generated by `regen_widgets.py` over `{os.path.basename(args.db)}`. HTML untouched._\n",
         "## Corpus headline\n", "| metric | value |", "|---|---:|"]
    for k in ("texts", "treebank_texts", "sentences", "tokens", "distinct_lemmas", "verbs"):
        L.append(f"| {k} | {stats[k]:,} |")
    L += ["\n## Verb forms — 2021 (38-cat) vs 2026\n",
          f"- 2021 verbal examples (timws.csv): **{old_total:,}** across {len(old)} categories",
          f"- 2026 verbal tokens (UPOS=VERB): **{cat['total']:,}** across {len(new)} categories\n",
          "| category | 2021 | 2026 | Δ |", "|---|---:|---:|---:|"]
    for label, c in sorted(new.items(), key=lambda kv: -kv[1])[:20]:
        o = old.get(label, 0)
        L.append(f"| {label} | {o:,} | {c:,} | {c - o:+,} |")
    L += ["\n## Pareto (2026, 38-category)\n", "| top-N forms | coverage |", "|---|---:|"]
    for n in (2, 5, 11, 20):
        if n <= len(cat["distribution"]):
            L.append(f"| {n} | {cat['distribution'][n-1]['cum_pct']}% |")
    L += ["\n## Regenerated (in `widgets/`, gitignored)\n",
          "- `corpus_stats.json`, `verb_forms_ud.json`, `verb_forms_38cat.json`, `morph_pn.json`, "
          "`tense_case.json`, `conc_totals.json`" + ("" if args.no_coll else ", `coll_compact.json`"),
          "\n## NOT regenerable from the master (need external inputs)\n",
          "- `dcs_genres.json` / `dcs_scatter.json` — need per-text **genre + date** metadata (the "
          "CoNLL-U carries neither). Source these from the DCS text catalogue or the 2021 `texts.csv`.",
          "- `anki_compact.json` / `passage_library.json` — **hand-curated**; not derivable.",
          "- `form_lookup.json` / `paradigm_endings.json` — derivable but tied to the paradigm browser's "
          "exact schema; deferred to the dashboard-wiring pass (no HTML touched in M7).\n",
          "## Caveats — the 38-category map is best-effort; `verb_forms_ud.json` is the faithful view\n",
          "- **Corpus growth:** 2026 totals exceed 2021's — the corpus grew (5.69M tokens, +Vedic) and "
          "2026 counts every UPOS=VERB token directly, vs 2021's category-binned extract. Δ = growth + "
          "methodology, not error.",
          "- **UD past-tense conflation — re-split, with bounds (H1486):** UD `Tense` has no "
          "Aorist/Perfect value; both surface as `Tense=Past`, distinct only from `Tense=Impf` "
          "(47k). DCS's own `feat_formation` does carry the past-stem formation, so the bucket is "
          "no longer reported merged: the seven Whitney aorist formations (root/them/red/s/is/sis/"
          "sa) give **Aorist**, `peri` gives **Periphrastic Perfect**, and the untagged remainder "
          "defaults to **Perfect** (DCS leaves the simple perfect unmarked). The tag covers 17.25% "
          "of the finite past indicative — the superseded '<2% of verbs, too sparse' claim divided "
          "by ALL verbs (1.60%) instead of by the bucket it has to split. **Both classes are "
          "bounds, not exact counts:** Aorist is a lower bound and Perfect an upper bound. See "
          "`reports/past_tense_resplit_validation.md` for the measured error bars.",
          "- **Participles:** present participles carry `Tense=Pres`; the no-Tense bucket is split by a "
          "form-ending heuristic (-ta/-na → PPP, -māna/-māṇa/-ant → present). ~58k compound-member "
          "participles whose surface form lacks a clean ending fall to *Participle (unclassified)*.\n"]
    os.makedirs(os.path.dirname(REPORT), exist_ok=True)
    with open(REPORT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(L) + "\n")
    conn.close()
    print(f"wrote widgets/*.json and {os.path.relpath(REPORT, HERE)}")
    print(f"  corpus: {stats['tokens']:,} tokens, {stats['verbs']:,} verbs")
    print(f"  verb forms: UD={len(ud['distribution'])} combos, 38-cat={len(cat['distribution'])} categories")
    return 0


if __name__ == "__main__":
    sys.exit(main())
