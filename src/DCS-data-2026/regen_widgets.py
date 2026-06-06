#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regen_widgets.py — M7 of the DCS CoNLL-U import (see DCS_CONLLU_IMPORT_PLAN.md).

Regenerates the VisualDCS dashboard data from the 2026 master (dcs.sqlite /
dcs_full.sqlite) and writes a 2021->2026 deltas report. Does NOT touch the HTML.

Outputs (to ./widgets/, gitignored — regenerable):
  corpus_stats.json        summary morpho-statistics
  verb_forms_ud.json       verb distribution by native UD (Tense/Voice/Mood/VerbForm) + Pareto
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
    for voice, lab in ((None, "Active"), ("Pass", "Passive"), ("Mid", "Middle")):
        m[("Past", voice, "Ind")] = f"Perfect/Aorist {lab}"
        m[("Impf", voice, "Ind")] = f"Imperfect {lab}"
    return m


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
    # native UD: (VerbForm, Tense, Mood, Voice)
    ud_rows = conn.execute(
        "SELECT feat_verbform, feat_tense, feat_mood, feat_voice, COUNT(*) "
        "FROM token WHERE upos='VERB' GROUP BY 1,2,3,4 ORDER BY 5 DESC").fetchall()
    ud_pairs = [(f"VerbForm={vf or '-'}|Tense={te or '-'}|Mood={mo or '-'}|Voice={vo or '-'}", c)
                for vf, te, mo, vo, c in ud_rows]
    ud_pareto, ud_total = pareto(ud_pairs)

    cat_map = ud_to_category(conn)
    cats = Counter()
    # non-participle verbs: bin at the (tense, voice, mood) group level
    for vf, te, mo, vo, c in conn.execute(
            "SELECT feat_verbform, feat_tense, feat_mood, feat_voice, COUNT(*) FROM token "
            "WHERE upos='VERB' AND (feat_verbform IS NULL OR feat_verbform != 'Part') GROUP BY 1,2,3,4"):
        if vf == "Conv":
            name = "Absolutive"
        elif vf == "Inf":
            name = "Infinitive"
        elif vf == "Gdv":
            name = "Future passive participle"
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
    """timws.csv -> {category_name: 2021 frequency}."""
    out = {}
    p = os.path.join(path, "timws.csv")
    if not os.path.isfile(p):
        return out
    with open(p, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(":")
            if len(parts) >= 3 and parts[0].strip().isdigit():
                out[parts[1].strip()] = int(parts[2].strip()) if parts[2].strip().isdigit() else 0
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
          "- **UD past-tense conflation:** UD `Tense` has no Aorist/Perfect value — both surface as "
          "`Tense=Past` (102k), distinct only from `Tense=Impf` (47k). So 2026 reports **Perfect/Aorist** "
          "as one bucket where 2021 split aorist vs perfect; `feat_formation` (root/peri/s/red…) is present "
          "on <2% of verbs, too sparse to re-split them.",
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
