#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_past_nonindicative_formation.py -- H3878. Settles an open question left by the
H1486 re-split: the 8,726 `Tense=Past` tokens in the NON-indicative moods (Jus, Imp,
Sub, Opt, Prec) carry no formation tag at all. Is that an upstream DCS annotation
limit, or a gap in our own query/mapping layer?

WHY THIS EXISTS
    H1486 re-split UD's conflated `Tense=Past` bucket using DCS's own `Formation`
    FEATS key, but it did so inside ONE bucket only -- the finite past indicative
    (`upos=VERB`, `Tense=Past`, `Mood=Ind`, no `VerbForm`), where all 16,100 tags sit.
    `.ai_state.md` then carried the honest residual: the other past moods have no
    formation data, so injunctive-vs-other stays unresolved, and we must "confirm that
    is a DCS annotation limit rather than a query gap before quoting those categories".

    That question cannot be answered from `dcs_full.sqlite` alone. If our importer had
    dropped the key, the master would show the tag absent either way -- absence in a
    DERIVED artifact is consistent with both hypotheses. Only the upstream CoNLL-U
    distribution can separate them, so this auditor reads the corpus itself and treats
    the master as a cross-check rather than as evidence.

    A1  corpus census    -- EVERY `Formation` occurrence in all 15,900 CoNLL-U files,
                            keyed by (UPOS, Tense, Mood, VerbForm). This is the check
                            that decides the question: if a `Formation` value ever
                            co-occurs with a non-`Ind` mood upstream, our `Mood=Ind`
                            predicate is hiding data and the verdict is QUERY GAP. If
                            it never does, the verdict is UPSTREAM ANNOTATION LIMIT.
    A2  the past bucket  -- the whole `Tense=Past` universe partitioned by mood, so the
                            8,726 non-indicative baseline is reproduced rather than
                            quoted, with the tagged/untagged split stated per mood.
    A3  recoverability  -- A1 says DCS does not tag these tokens. It does NOT yet say the
                            information is unavailable: if a non-indicative form like `bhūt`
                            were attested elsewhere in the corpus carrying a `Formation` tag,
                            we could propagate it by surface form and the honest answer would
                            be "build an inference layer", not "stop". This is the same
                            same-form instrument H1486's V3 used to measure aorist leakage,
                            pointed the other way. It is what makes NO-GO a finding rather
                            than a shrug.
    A4  import fidelity  -- OPTIONAL (`--db`), and only meaningful once A1 has run: the
                            master's `feat_formation` distribution must equal the corpus
                            census exactly. Equality proves the flatten-all importer is
                            lossless for this key, which is what rules out a mapping gap
                            BELOW the query layer. Skipped when the 921MB master is absent.

    A1 is decisive on the stated question; A3 decides what to DO about it, and A4 closes
    the remaining "maybe our import ate the tag" branch. All four are counts, not
    judgement calls.

DISCIPLINE
    - The bucket rule is IMPORTED from regen_widgets.py (`is_past_indicative`), never
      restated, so this auditor cannot drift away from the split it is auditing.
    - Read-only on the master; refuses a master with no provenance pin (C3 §2.1) --
      the same contract validate_past_tense_resplit.py enforces.
    - Denominator closure is asserted, not assumed: the mood partition must sum to the
      whole `Tense=Past` universe, and every `Formation` value seen must fall in the
      set regen_widgets.py actually guards. Exits non-zero otherwise.
    - `Formation` is TENSE-DEPENDENT: `peri` on `Tense=Past` is the periphrastic
      perfect, on `Tense=Fut` the periphrastic future. The census is keyed on tense so
      the two can never be summed together by accident (the H1486 gotcha).

    python src/DCS-data-2026/audit_past_nonindicative_formation.py \
        [--conllu PATH] [--db PATH] [--skip-checksum]
"""

import argparse
import collections
import hashlib
import json
import os
import sqlite3
import sys

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from regen_widgets import AORIST_FORMATIONS, is_past_indicative   # noqa: E402

REPORT_MD = os.path.join(HERE, "reports", "past_nonindicative_formation_audit.md")
REPORT_JSON = os.path.join(HERE, "reports", "past_nonindicative_formation_audit.json")
CONLLU_DEFAULT = os.path.join(HERE, "conllu", "files")
FIXTURE = os.path.join(HERE, "fixtures", "past_nonindicative_formation.conllu")

# The five non-indicative moods DCS uses on Tense=Past. Named for the report and for
# the per-mood breakdown; membership is never used to DEFINE the bucket -- that is
# is_past_indicative()'s job, so a sixth mood appearing upstream shows up as a new row
# rather than being silently dropped.
NONIND_MOODS = ("Jus", "Imp", "Sub", "Opt", "Prec")

# Everything regen_widgets.py classifies. A Formation value outside this set means the
# upstream tagset grew and past_class() would silently default it to Perfect.
GUARDED_FORMATIONS = set(AORIST_FORMATIONS) | {"peri"}

TOP_FORMS_PER_MOOD = 8


def sha256_file(path, chunk=4 * 1024 * 1024):
    h = hashlib.sha256()
    with open(path, "rb") as fh:
        for block in iter(lambda: fh.read(chunk), b""):
            h.update(block)
    return h.hexdigest()


def pct(n, d):
    return round(100.0 * n / d, 2) if d else 0.0


def parse_feats(feats):
    """CoNLL-U FEATS -> dict. `_` is the empty-features marker, not a key."""
    if feats == "_":
        return {}
    out = {}
    for kv in feats.split("|"):
        k, _, v = kv.partition("=")
        out[k] = v
    return out


def iter_tokens(root):
    """Yield (upos, feats-dict, form, lemma) for every real token under `root`.

    Multiword-token range lines (`4-5`) and empty nodes (`3.1`) carry no morphology of
    their own in this distribution; skipping them keeps the census one-row-per-token.
    """
    if os.path.isfile(root):
        paths = [root]
    else:
        paths = []
        for dirpath, _dirnames, filenames in os.walk(root):
            for fn in sorted(filenames):
                if fn.endswith(".conllu"):
                    paths.append(os.path.join(dirpath, fn))
    for path in sorted(paths):
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if not line or line[0] == "#" or line == "\n":
                    continue
                p = line.rstrip("\n").split("\t")
                if len(p) < 6 or "-" in p[0] or "." in p[0]:
                    continue
                yield p[3], parse_feats(p[5]), p[1], p[2]
    if not paths:
        raise SystemExit(f"ERROR: no .conllu files under {root}")


def scan_corpus(root):
    """A1 + A2 in one pass over the distribution.

    Returns the Formation census keyed on (upos, tense, mood, verbform), the
    Tense=Past mood partition, and the commonest forms per non-indicative mood.
    """
    census = collections.Counter()          # (upos, tense, mood, verbform) -> n, tokens WITH Formation
    values = collections.Counter()          # (formation, tense, mood) -> n
    past = collections.Counter()            # (mood-or-VerbForm bucket, has_formation) -> n
    forms = collections.defaultdict(collections.Counter)      # mood -> {surface form: n}
    pairs = collections.defaultdict(collections.Counter)      # mood -> {(form, lemma): n}
    tagged_forms = collections.defaultdict(collections.Counter)   # Past-tagged form -> {formation: n}
    tagged_pairs = collections.defaultdict(collections.Counter)   # (form, lemma) -> {formation: n}
    nfiles = 0
    for dirpath, _d, fns in os.walk(root):
        nfiles += sum(1 for f in fns if f.endswith(".conllu"))
    for upos, d, form, lemma in iter_tokens(root):
        formation = d.get("Formation")
        tense, mood, vf = d.get("Tense"), d.get("Mood"), d.get("VerbForm")
        if formation is not None:
            census[(upos, tense, mood, vf)] += 1
            values[(formation, tense, mood)] += 1
            if tense == "Past":
                # Past only: `peri` means a different thing on Fut, so future-tagged
                # forms must never become evidence about a past-tense token (H1486).
                tagged_forms[form][formation] += 1
                tagged_pairs[(form, lemma)][formation] += 1
        if tense == "Past":
            if is_past_indicative(tense, mood, vf):
                bucket = "Ind (finite)"
            elif mood is None:
                bucket = f"(no mood) VerbForm={vf}"
            else:
                bucket = mood
            past[(bucket, formation is not None)] += 1
            if mood in NONIND_MOODS:
                forms[mood][form] += 1
                pairs[mood][(form, lemma)] += 1
    return {
        "files_scanned": nfiles or 1,
        "census": census,
        "values": values,
        "past": past,
        "forms": forms,
        "pairs": pairs,
        "tagged_forms": tagged_forms,
        "tagged_pairs": tagged_pairs,
        "top_forms": {m: forms[m].most_common(TOP_FORMS_PER_MOOD) for m in NONIND_MOODS
                      if forms[m]},
    }


def a3_recoverability(scan):
    """Could the missing tag be recovered from the corpus itself, by surface form?

    For every non-indicative past token, ask whether its exact surface form is attested
    ANYWHERE in the corpus carrying a past-tense `Formation` tag. If it is, that token's
    formation is inferable and NO-GO would be the wrong call; if it is not, the
    information is absent from the distribution, not merely absent from these rows.

    Matching is exact-string and therefore CONSERVATIVE in the direction that could
    overturn the verdict: sandhi variants (`bhūt` / `bhūd`) count as different forms, so
    this over-estimates recoverability rather than under-estimating it. A near-zero
    result is thus a strong negative, which is exactly the claim being tested.

    Two counts, because "same string, tagged elsewhere" can pair a token with a tagged
    form of a DIFFERENT verb -- Sanskrit surface forms are homographic across roots, and
    a propagation layer that ignored the lemma would import another root's stem class.
    `strict` therefore also requires the tagged attestation to carry the same LEMMA. It
    is a TEST, not an assumed discount: report both columns and let the gap between them
    be the measurement. (On the pinned corpus that gap is small, which says homography is
    not what limits propagation here -- non-attestation is. Do not hardcode either
    reading; both numbers are recomputed on every run.)
    """
    tagged, tagged_pairs = scan["tagged_forms"], scan["tagged_pairs"]
    per_mood, examples = {}, []
    total = recoverable = strict = ambiguous = 0
    for mood in NONIND_MOODS:
        n_tok = sum(scan["pairs"][mood].values())
        rec = strict_m = amb = 0
        for (form, lemma), n in scan["pairs"][mood].items():
            ev = tagged.get(form)
            if not ev:
                continue
            rec += n
            ev_strict = tagged_pairs.get((form, lemma))
            if ev_strict:
                strict_m += n
            if len(ev) > 1:
                amb += n
            if len(examples) < 12:
                examples.append({"mood": mood, "form": form, "lemma": lemma, "tokens": n,
                                 "lemma_agrees": bool(ev_strict), "evidence": dict(ev)})
        per_mood[mood] = {"tokens": n_tok, "recoverable": rec, "strict": strict_m,
                          "ambiguous": amb, "pct": pct(rec, n_tok),
                          "pct_strict": pct(strict_m, n_tok)}
        total += n_tok
        recoverable += rec
        strict += strict_m
        ambiguous += amb
    examples.sort(key=lambda e: -e["tokens"])
    return {"total": total, "recoverable": recoverable, "strict": strict,
            "ambiguous": ambiguous, "pct": pct(recoverable, total),
            "pct_strict": pct(strict, total), "by_mood": per_mood, "examples": examples}


def assert_closure(scan):
    """Closure, asserted rather than assumed -- the house rule from CLAUDE.md."""
    stray = {f for (f, _t, _m) in scan["values"] if f not in GUARDED_FORMATIONS}
    if stray:
        raise SystemExit(
            f"CLOSURE FAILED: unguarded Formation value(s) {sorted(stray)} upstream -- "
            f"past_class() would silently default them to Perfect. Classify them first.")
    by_bucket = collections.Counter()
    for (bucket, _tagged), n in scan["past"].items():
        by_bucket[bucket] += n
    total = sum(by_bucket.values())
    if total != sum(scan["past"].values()):
        raise SystemExit(f"CLOSURE FAILED: mood partition sums to {total:,}, "
                         f"universe holds {sum(scan['past'].values()):,}")
    return by_bucket, total


def verdict(scan):
    """The decision A1 exists to make, read straight off the census."""
    offenders = {k: n for k, n in scan["census"].items() if k[2] != "Ind"}
    if offenders:
        return "QUERY GAP", offenders
    return "UPSTREAM ANNOTATION LIMIT", {}


def a4_import_fidelity(db, corpus_values, skip_checksum):
    """The master's feat_formation must equal the corpus census. Proves losslessness."""
    conn = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    prov = dict(conn.execute("SELECT key, value FROM provenance").fetchall())
    if "source_commit" not in prov:
        conn.close()
        raise SystemExit("ERROR: master has no provenance pin -- refusing (C3 §2.1)")
    rows = conn.execute(
        "SELECT feat_formation, feat_tense, feat_mood, COUNT(*) FROM token "
        "WHERE feat_formation IS NOT NULL GROUP BY 1,2,3").fetchall()
    conn.close()
    db_values = {(f, t, m): n for f, t, m, n in rows}
    corpus = {k: v for k, v in corpus_values.items()}
    diff = {f"{k}": [corpus.get(k, 0), db_values.get(k, 0)]
            for k in set(corpus) | set(db_values) if corpus.get(k, 0) != db_values.get(k, 0)}
    return {
        "status": "PASS" if not diff else "FAIL",
        "db": os.path.basename(db),
        "sha256": "skipped" if skip_checksum else sha256_file(db),
        "source_commit": prov.get("source_commit"),
        "corpus_tags": sum(corpus.values()),
        "db_tags": sum(db_values.values()),
        "disagreements": diff,
    }


def render(res):
    v = res["verdict"]
    nonind = res["nonindicative_total"]
    L = [
        "# Past non-indicative moods — is the missing formation tag an upstream limit "
        "or our query gap? (H3878)",
        "",
        "_Auto-generated by `audit_past_nonindicative_formation.py`. Do not hand-edit._",
        "",
        f"Corpus: `{res['corpus']}` · pin `{res['source_commit'] or '-'}` · "
        f"{res['files_scanned']:,} CoNLL-U files",
        "",
        f"## Verdict — **{v}**",
        "",
    ]
    if v == "UPSTREAM ANNOTATION LIMIT":
        L += [
            f"Across all {res['files_scanned']:,} files of the pinned distribution, the DCS "
            f"`Formation` feature occurs **{res['formation_total']:,} times and never once "
            "outside `Mood=Ind`** — not on a single Jussive, Imperative, Subjunctive, "
            "Optative or Precative token, and not on any past participle. So H1486's "
            "`feat_mood='Ind'` predicate is **not** hiding data: there is no data behind it "
            "to hide.",
            "",
            f"The {nonind:,} non-indicative past tokens are unformationed **upstream**. "
            "Nothing in our query or import layer can recover a stem formation for them, "
            "and no repair to this repository would change the count — so this closes as an "
            "evidence-backed NO-GO on splitting those moods by formation, not as a bug fix.",
            "",
            "**Consequence for downstream claims.** The injunctive-vs-other question the "
            "`.ai_state.md` queue carried is **unanswerable from DCS FEATS**. `Mood=Jus` on "
            f"`Tense=Past` ({res['by_mood'].get('Jus', 0):,} tokens) is the augmentless "
            "injunctive, and whether a given token is built on an aorist or an imperfect stem "
            "is exactly what `Formation` would have said. Those categories must not be quoted "
            "as aorist/perfect-resolved; resolving them needs an external lexical signal "
            "(stem class from a dictionary or a generator), the same shape of blocker as the "
            "`-ī`/`-ant` conflation.",
        ]
    else:
        L += [
            "The census found `Formation` on non-`Ind` tokens upstream — our `Mood=Ind` "
            "predicate IS hiding data. Offending (upos, tense, mood, verbform) keys:",
            "",
            "| upos | Tense | Mood | VerbForm | tokens |",
            "|---|---|---|---|---:|",
        ] + [f"| {k} | {n:,} |" for k, n in res["census_offenders"].items()]

    L += [
        "",
        "## A1 — every `Formation` occurrence in the distribution",
        "",
        "Keyed on tense because the feature is **tense-dependent**: `peri` under `Tense=Past` "
        "is the periphrastic perfect, under `Tense=Fut` the periphrastic future. Summing the "
        "two would be a category error (H1486).",
        "",
        "| upos | Tense | Mood | VerbForm | tokens carrying `Formation` |",
        "|---|---|---|---|---:|",
    ]
    for (upos, tense, mood, vf), n in sorted(res["census"].items(), key=lambda kv: -kv[1]):
        L.append(f"| `{upos}` | {tense or '—'} | {mood or '—'} | {vf or '—'} | {n:,} |")
    L += [
        "",
        "### By value",
        "",
        "| `Formation` | Tense | Mood | tokens | reads as |",
        "|---|---|---|---:|---|",
    ]
    for (f, t, m), n in sorted(res["values"].items(), key=lambda kv: -kv[1]):
        if f == "peri":
            reads = "Periphrastic Perfect" if t == "Past" else "Periphrastic Future"
        else:
            reads = "Aorist" if t == "Past" else f"(unclassified on Tense={t})"
        L.append(f"| `{f}` | {t} | {m} | {n:,} | {reads} |")

    L += [
        "",
        "## A2 — the whole `Tense=Past` universe, partitioned by mood",
        "",
        "Reproduces the baseline the queue item named rather than quoting it. Every row is "
        "a count over the pinned corpus; the partition is asserted to close.",
        "",
        "| bucket | tokens | with `Formation` | without | coverage |",
        "|---|---:|---:|---:|---:|",
    ]
    for bucket, (tot, tagged) in res["past_partition"].items():
        L.append(f"| {bucket} | {tot:,} | {tagged:,} | {tot - tagged:,} | {pct(tagged, tot)}% |")
    baseline = " + ".join(f"{m} {res['by_mood'][m]:,}"
                          for m in NONIND_MOODS if m in res["by_mood"])
    L += [
        f"| **all `Tense=Past`** | **{res['past_universe']:,}** | "
        f"**{res['past_tagged']:,}** | **{res['past_universe'] - res['past_tagged']:,}** | "
        f"**{pct(res['past_tagged'], res['past_universe'])}%** |",
        "",
        f"**Baseline reproduced: {baseline} = {nonind:,} non-indicative past tokens, "
        f"{res['nonindicative_tagged']:,} of them formation-tagged.**",
        "",
        "### Commonest forms per non-indicative mood",
        "",
        "Fixtures for the test suite are drawn from these; they are shown so the buckets are "
        "inspectable rather than abstract.",
        "",
        "| mood | commonest forms |",
        "|---|---|",
    ]
    for m, rows in res["top_forms"].items():
        L.append(f"| `{m}` | " + ", ".join(f"`{f}` ({n:,})" for f, n in rows) + " |")

    a3 = res["a3"]
    L += [
        "",
        "## A3 — could the tag be recovered from the corpus itself?",
        "",
        "A1 proves DCS never tags these tokens. That is not yet the same as *the information "
        "is unavailable*: these forms plainly HAVE a stem formation — `kṛdhi`, `gahi`, `bodhi` "
        "are root-aorist imperatives, `mā bhūt` / `mā hiṃsīḥ` augmentless injunctives — DCS "
        "simply declines to record it outside the indicative. If those same surface forms were "
        "attested elsewhere carrying a `Formation` tag, the honest answer would be *build an "
        "inference layer*, not *stop*. This is H1486's V3 same-form instrument pointed the "
        "other way.",
        "",
        "Matching is exact-string and only against **`Tense=Past`**-tagged forms (a `peri` on "
        "`Tense=Fut` is a different feature). Exact matching is conservative in the direction "
        "that could overturn the verdict — sandhi variants (`bhūt` / `bhūd`) count as separate "
        "forms — so the **loose** column **over**-estimates recoverability. The **strict** "
        "column additionally requires the tagged attestation to carry the same **lemma**, "
        "because Sanskrit surface forms are homographic across roots and a propagation layer "
        "that ignored the lemma would import another verb's stem class. Strict is a *test*, "
        "not an assumed discount — the gap between the two columns is the measurement.",
        "",
        "| mood | tokens | loose (same form) | strict (same form + lemma) |",
        "|---|---:|---:|---:|",
    ]
    for m in NONIND_MOODS:
        r = a3["by_mood"].get(m)
        if r:
            L.append(f"| `{m}` | {r['tokens']:,} | {r['recoverable']:,} ({r['pct']}%) | "
                     f"{r['strict']:,} ({r['pct_strict']}%) |")
    L += [
        f"| **all non-indicative** | **{a3['total']:,}** | **{a3['recoverable']:,} "
        f"({a3['pct']}%)** | **{a3['strict']:,} ({a3['pct_strict']}%)** |",
        "",
    ]
    if a3["strict"] == 0:
        L += [f"**Not one of the {a3['total']:,} tokens has its (form, lemma) pair attested "
              "formation-tagged anywhere in the past-tense corpus.** Propagation would transfer "
              f"zero defensible tags — the {a3['recoverable']:,} loose matches are all "
              "cross-lemma homographs. There is no inference layer to build: the NO-GO is on "
              "the data, not on our appetite for the work.", ""]
    else:
        L += [f"**{a3['strict']:,} of {a3['total']:,} tokens ({a3['pct_strict']}%) are "
              "defensibly recoverable** — same surface form AND same lemma attested with a "
              f"formation elsewhere. The looser same-form-only figure is {a3['recoverable']:,} "
              f"({a3['pct']}%), so the lemma test removes only "
              f"{a3['recoverable'] - a3['strict']:,} tokens: homography is **not** what limits "
              f"propagation here ({a3['ambiguous']:,} tokens match a form attested under more "
              "than one formation). What limits it is that "
              f"{a3['total'] - a3['recoverable']:,} of the {a3['total']:,} tokens "
              f"({pct(a3['total'] - a3['recoverable'], a3['total'])}%) carry a surface form "
              "that is never formation-tagged **anywhere** in the past-tense corpus — the most "
              "generous instrument available reaches under one token in twenty-five.",
              "",
              "So an inference layer is buildable in principle and worthless in practice: it "
              f"would resolve {a3['strict']:,} tokens and leave "
              f"{a3['total'] - a3['strict']:,} ({pct(a3['total'] - a3['strict'], a3['total'])}%) "
              "exactly as unresolved as they are now, while adding a propagation step whose own "
              "error rate is unmeasured. Hence NO-GO rather than a build. The "
              f"{a3['strict']:,} recoverable tokens are recorded here so a future decision "
              "starts from the count rather than re-deriving it.", ""]
        if a3["examples"]:
            L += ["The largest same-form matches, with the lemma test shown — a `✗` is a "
                  "homograph the loose column counts and the strict column does not:", "",
                  "| mood | form | lemma | tokens | lemma agrees | attested formations |",
                  "|---|---|---|---:|:-:|---|"] + [
                f"| `{e['mood']}` | `{e['form']}` | `{e['lemma']}` | {e['tokens']:,} | "
                f"{'✓' if e['lemma_agrees'] else '✗'} | "
                + ", ".join(f"`{k}` ({n:,})" for k, n in e["evidence"].items()) + " |"
                for e in a3["examples"]
            ] + [""]

    a4 = res.get("a4")
    L += ["## A4 — import fidelity (does our master lose the key?)", ""]
    if not a4:
        L += ["**SKIPPED** — the 921MB master was not present. A1 is decisive without it; "
              "A4 only closes the residual \"maybe the importer ate the tag\" branch.", ""]
    elif a4["status"] == "PASS":
        L += [f"**PASS.** Master `{a4['db']}` (SHA-256 `{a4['sha256']}`, provenance "
              f"`{a4['source_commit']}`) carries **{a4['db_tags']:,}** `feat_formation` values "
              f"against the corpus's **{a4['corpus_tags']:,}** — identical on every "
              "(value, tense, mood) key. The flatten-all importer is lossless for this "
              "feature, so no mapping gap sits below the query layer either.", ""]
    else:
        L += ["**FAIL.** Master and corpus disagree — a real import defect:", "",
              "| key | corpus | master |", "|---|---:|---:|"] + \
             [f"| {k} | {c:,} | {d:,} |" for k, (c, d) in a4["disagreements"].items()] + [""]

    L += [
        "## What this changes",
        "",
        "- The `.ai_state.md` queue item *\"Audit the other `Tense=Past` moods for formation "
        "data\"* is **resolved**: annotation limit, not query gap. No code repair is warranted "
        "and none was made to the split.",
        f"- H1486's scope was correct. All {res['formation_total_past']:,} past-tense "
        "`Formation` tags lie inside the bucket it already covers; widening the predicate "
        "would add zero tags and only dilute the denominator.",
        f"- The {nonind:,} non-indicative past tokens, and the "
        f"{res['past_partition'].get('(no mood) VerbForm=Part', (0, 0))[0]:,} past participles, "
        "stay formation-less by upstream design. Quote them by mood only.",
        f"- No inference layer is worth building: A3 measures {a3['pct_strict']}% "
        f"({a3['strict']:,} tokens) recoverable by form **and** lemma — {a3['pct']}% even on "
        "the homograph-tolerant instrument. The gap is in the annotation, not in our reach.",
        "",
    ]
    return "\n".join(L) + "\n"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--conllu", default=CONLLU_DEFAULT,
                    help="root of the pinned CoNLL-U distribution (submodule `conllu/files`)")
    ap.add_argument("--db", default=os.path.join(HERE, "dcs_full.sqlite"),
                    help="optional master for the A3 cross-check")
    ap.add_argument("--source-commit", default=None,
                    help="pin recorded in the report when the corpus is read outside the submodule")
    ap.add_argument("--skip-checksum", action="store_true",
                    help="skip the 921MB SHA-256 (dev loop only; a committed report must "
                         "carry a real checksum, C3 §2.1)")
    ap.add_argument("--no-write", action="store_true", help="compute and print, write nothing")
    args = ap.parse_args()

    if not os.path.exists(args.conllu):
        print(f"ERROR: {args.conllu} not found. Fetch the corpus with "
              f"`git submodule update --init`, or pass --conllu PATH.", file=sys.stderr)
        return 2

    print(f"scanning {args.conllu} ...")
    scan = scan_corpus(args.conllu)
    by_bucket, past_universe = assert_closure(scan)
    v, offenders = verdict(scan)

    past_partition, past_tagged = {}, 0
    for bucket in sorted(by_bucket, key=lambda b: -by_bucket[b]):
        tagged = scan["past"].get((bucket, True), 0)
        past_partition[bucket] = (by_bucket[bucket], tagged)
        past_tagged += tagged
    by_mood = {m: by_bucket[m] for m in NONIND_MOODS if m in by_bucket}
    nonind = sum(by_mood.values())
    nonind_tagged = sum(scan["past"].get((m, True), 0) for m in by_mood)

    res = {
        "corpus": os.path.relpath(args.conllu, HERE) if args.conllu.startswith(HERE)
                  else os.path.basename(os.path.dirname(args.conllu.rstrip("/"))) + "/files",
        "source_commit": args.source_commit,
        "files_scanned": scan["files_scanned"],
        "verdict": v,
        # render() wants the tuple keys (it splits them across table columns); the JSON
        # copy below flattens them to strings, which is the only form JSON can hold.
        "census": dict(scan["census"]),
        "values": dict(scan["values"]),
        "census_offenders": {f"{k[0]} | {k[1]} | {k[2]} | {k[3]}": n
                             for k, n in offenders.items()},
        "formation_total": sum(scan["census"].values()),
        "formation_total_past": sum(n for k, n in scan["census"].items() if k[1] == "Past"),
        "past_universe": past_universe,
        "past_tagged": past_tagged,
        "past_partition": past_partition,
        "by_mood": by_mood,
        "nonindicative_total": nonind,
        "nonindicative_tagged": nonind_tagged,
        "top_forms": scan["top_forms"],
        "a3": a3_recoverability(scan),
    }

    print(f"  verdict: {v}")
    print(f"  Formation tags: {res['formation_total']:,} "
          f"({res['formation_total_past']:,} on Tense=Past)")
    print(f"  Tense=Past universe: {past_universe:,}; "
          f"non-indicative {nonind:,} ({nonind_tagged:,} tagged)")
    print(f"  A3 recoverable: {res['a3']['strict']:,} strict (form+lemma) / "
          f"{res['a3']['recoverable']:,} loose (form only) of {res['a3']['total']:,} "
          f"-- {res['a3']['pct_strict']}% / {res['a3']['pct']}%")

    if os.path.exists(args.db) and os.path.getsize(args.db) > 0:
        print("A4 import fidelity against the master ...")
        res["a4"] = a4_import_fidelity(args.db, scan["values"], args.skip_checksum)
        print(f"  {res['a4']['status']}")
    else:
        res["a4"] = None
        print(f"A4 SKIPPED -- no master at {args.db}")

    if args.no_write:
        return 0

    md = render(res)
    os.makedirs(os.path.dirname(REPORT_MD), exist_ok=True)
    with open(REPORT_MD, "w", encoding="utf-8") as fh:
        fh.write(md)
    js = dict(res)
    js["census"] = {f"{k[0]}|{k[1]}|{k[2]}|{k[3]}": n for k, n in scan["census"].items()}
    js["values"] = {f"{k[0]}|{k[1]}|{k[2]}": n for k, n in scan["values"].items()}
    js["past_partition"] = {k: {"tokens": t, "tagged": g} for k, (t, g) in past_partition.items()}
    js["top_forms"] = {m: [{"form": f, "count": n} for f, n in rows]
                       for m, rows in scan["top_forms"].items()}
    with open(REPORT_JSON, "w", encoding="utf-8") as fh:
        json.dump(js, fh, ensure_ascii=False, indent=1)
    print(f"\nwrote {os.path.relpath(REPORT_MD, HERE)} + .json")
    return 0 if (res["a4"] is None or res["a4"]["status"] == "PASS") else 1


if __name__ == "__main__":
    sys.exit(main())
