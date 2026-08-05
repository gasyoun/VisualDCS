"""
delta_stats.py — H686: DCS 2021 -> 2026 corpus delta statistics.

Compares the 2021 relational export (src/DCS-data-2021/) against the 2026
CoNLL-U master (src/DCS-data-2026/dcs_full.sqlite, built by M1-M8 of
DCS_CONLLU_IMPORT_PLAN.md) on: corpus growth (texts/sentences/tokens/lemmas),
top-200 lemma frequency drift, and POS distribution shift.

Reuses the exact cross-walk already established by M3 (coverage_diff.py):
0.csv's integer lemma-ID lists ARE the 2026 CoNLL-U LemmaIds (DCS_FORMAT_
COMPARISON.md). Known caveat carried over unchanged: UD Tense=Past conflates
aorist/perfect on the 2026 side (standing project memory) -- not re-derived
here, just noted where it matters (POS/tense bucketing is left at the UD
coarse-POS level, which sidesteps this).

Sources:
  2021: src/DCS-data-2021/0.csv   (sentence rows: name;ref;...;lemma-id-list)
        src/DCS-data-2021/_8.csv  (count,lemma(IAST),pos -- corpus-wide lemma
                                    frequency list, ALL POS not just verbs)
  2026: src/DCS-data-2026/dcs_full.sqlite (text/sentence/token/lemma tables)

Run from repo root:
    python derived-data/Corpus-Delta-2021-2026/delta_stats.py
Writes derived-data/Corpus-Delta-2021-2026/REPORT.md.
"""

import os
import re
import sqlite3
import subprocess
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
REL_2021_SENT = os.path.join(REPO_ROOT, "src", "DCS-data-2021", "0.csv")
REL_2021_FREQ = os.path.join(REPO_ROOT, "src", "DCS-data-2021", "_8.csv")
OUT = os.path.join(HERE, "REPORT.md")


def _find_db_2026():
    """dcs_full.sqlite is gitignored (regenerable, ~900MB) so it only exists in
    whichever checkout actually built it. Try this checkout first, then fall
    back to the main repo checkout (git worktrees don't share gitignored
    files) via `git rev-parse --git-common-dir`."""
    candidates = [os.path.join(REPO_ROOT, "src", "DCS-data-2026", "dcs_full.sqlite")]
    try:
        common_dir = subprocess.run(
            ["git", "rev-parse", "--git-common-dir"], cwd=REPO_ROOT,
            capture_output=True, text=True, encoding="utf-8", check=True,
        ).stdout.strip()
        main_root = os.path.abspath(os.path.join(REPO_ROOT, common_dir, ".."))
        candidates.append(os.path.join(main_root, "src", "DCS-data-2026", "dcs_full.sqlite"))
    except Exception:
        pass
    for c in candidates:
        if os.path.isfile(c):
            return c
    return candidates[0]


DB_2026 = _find_db_2026()

TOP_N = 200

# 2021 _8.csv POS tags -> coarse UD-comparable bucket. Verb tags are
# "<class>.<voice>" (e.g. "2.Ā.") or a derivational marker (Denom./Desid./Int.);
# nominal tags are bare gender letters; 'ind'/'pron'/'adj' are self-explanatory.
_VERB_TAG_RE = re.compile(r"^(\d+\.(Ā|P)\.|Denom\.|Desid\.|Int\.)")
_NOUN_TAGS = {"m", "f", "n", "mn", "mf", "mfn", "nr", "fn"}


def bucket_2021(pos_tag):
    if _VERB_TAG_RE.match(pos_tag):
        return "VERB"
    if pos_tag in _NOUN_TAGS:
        return "NOUN"
    if pos_tag == "adj":
        return "ADJ"
    if pos_tag == "pron":
        return "PRON"
    if pos_tag == "ind":
        return "IND(other)"
    return "OTHER/unlabeled"


# 2026 UD upos -> the same coarse buckets, so the two sides are commensurable.
# ADV/ADP/CONJ/SCONJ/PART/INTJ/NUM all collapse into the 2021 'ind' catch-all,
# since the 2021 tagset does not split indeclinables further.
_UPOS_TO_BUCKET = {
    "VERB": "VERB",
    "NOUN": "NOUN",
    "ADJ": "ADJ",
    "PRON": "PRON",
    "ADV": "IND(other)",
    "ADP": "IND(other)",
    "CONJ": "IND(other)",
    "SCONJ": "IND(other)",
    "PART": "IND(other)",
    "NUM": "IND(other)",
    "INTJ": "IND(other)",
}


def read_2021_sentences(path):
    """0.csv -> (n_texts, n_sentence_rows, n_tokens_by_id_list, distinct_lemma_ids)."""
    texts = set()
    n_rows = 0
    n_tok = 0
    lemmas = set()
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            parts = line.rstrip("\n").split(";")
            if len(parts) < 4:
                continue
            n_rows += 1
            texts.add(parts[0].strip().strip('"'))
            ids = [int(x) for x in parts[3].split(",") if x.strip().isdigit()]
            n_tok += len(ids)
            lemmas.update(ids)
    return len(texts), n_rows, n_tok, lemmas


def read_2021_freq(path):
    """_8.csv -> (total_token_count, {lemma: total_count}, bucket_counts).

    `_8.csv` is keyed by (lemma, POS): 90,954 rows, 83,275 distinct lemma strings. Both
    aggregates below therefore ACCUMULATE — `lemma_freq` sums a homograph's rows into one
    lemma total, and `bucket_counts` is built per row so it never depends on the collapsed
    key at all. A last-wins assignment here would drop 2,492,275 of 4,577,461 tokens (54%),
    the H1486 / issue #70 lossy-aggregation class. A per-lemma `lemma_bucket` map was
    removed in the #70 sweep: it was last-seen-wins, would have mislabelled every homograph
    with its final row's POS, and was never returned or used.
    """
    total = 0
    lemma_freq = {}
    bucket_counts = {}
    with open(path, encoding="utf-8", errors="replace") as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            parts = line.split(",", 2)
            if len(parts) < 3:
                continue
            try:
                cnt = int(parts[0])
            except ValueError:
                continue
            lemma = parts[1].strip()
            pos = parts[2].strip()
            b = bucket_2021(pos)
            total += cnt
            lemma_freq[lemma] = lemma_freq.get(lemma, 0) + cnt
            bucket_counts[b] = bucket_counts.get(b, 0) + cnt
    return total, lemma_freq, bucket_counts


def read_2026(db_path):
    c = sqlite3.connect(db_path)
    cur = c.cursor()
    n_texts = cur.execute("SELECT COUNT(*) FROM text").fetchone()[0]
    n_sent = cur.execute("SELECT COUNT(*) FROM sentence").fetchone()[0]
    n_tok = cur.execute("SELECT COUNT(*) FROM token").fetchone()[0]
    n_lemma_ids = cur.execute("SELECT COUNT(DISTINCT lemma_id) FROM token").fetchone()[0]
    upos_counts = dict(cur.execute(
        "SELECT upos, COUNT(*) FROM token GROUP BY upos"
    ).fetchall())
    lemma_freq = dict(cur.execute(
        "SELECT lemma, COUNT(*) c FROM token GROUP BY lemma ORDER BY c DESC"
    ).fetchall())
    c.close()
    bucket_counts = {}
    for upos, cnt in upos_counts.items():
        b = _UPOS_TO_BUCKET.get(upos, "OTHER/unlabeled")
        bucket_counts[b] = bucket_counts.get(b, 0) + cnt
    return n_texts, n_sent, n_tok, n_lemma_ids, bucket_counts, lemma_freq


def top_n_drift(freq21, total21, freq26, total26, n=TOP_N):
    """Union of each side's own top-N by raw count; rank + corpus-share drift."""
    rank21 = {lem: i + 1 for i, lem in enumerate(
        sorted(freq21, key=lambda k: -freq21[k])[:n])}
    rank26 = {lem: i + 1 for i, lem in enumerate(
        sorted(freq26, key=lambda k: -freq26[k])[:n])}
    lemmas = sorted(set(rank21) | set(rank26),
                     key=lambda l: min(rank21.get(l, 10**9), rank26.get(l, 10**9)))
    rows = []
    for lem in lemmas:
        c21 = freq21.get(lem, 0)
        c26 = freq26.get(lem, 0)
        share21 = 100.0 * c21 / total21 if total21 else 0.0
        share26 = 100.0 * c26 / total26 if total26 else 0.0
        rows.append({
            "lemma": lem,
            "rank21": rank21.get(lem),
            "rank26": rank26.get(lem),
            "c21": c21, "c26": c26,
            "share21": share21, "share26": share26,
        })
    return rows


def md_bucket_table(b21, t21, b26, t26):
    keys = sorted(set(b21) | set(b26), key=lambda k: -(b21.get(k, 0) + b26.get(k, 0)))
    lines = ["| bucket | 2021 count | 2021 % | 2026 count | 2026 % | delta (pp) |",
             "|---|---:|---:|---:|---:|---:|"]
    for k in keys:
        c21 = b21.get(k, 0)
        c26 = b26.get(k, 0)
        p21 = 100.0 * c21 / t21 if t21 else 0.0
        p26 = 100.0 * c26 / t26 if t26 else 0.0
        lines.append(f"| {k} | {c21:,} | {p21:.1f}% | {c26:,} | {p26:.1f}% | {p26 - p21:+.1f} |")
    return "\n".join(lines)


def main():
    for p in (REL_2021_SENT, REL_2021_FREQ, DB_2026):
        if not os.path.isfile(p):
            print(f"ERROR: required input not found: {p}", file=sys.stderr)
            return 2

    print("reading 2021 sentence export (0.csv) ...")
    t21_texts, t21_rows, t21_tok_idlist, t21_lemmas = read_2021_sentences(REL_2021_SENT)
    print(f"  {t21_texts} texts, {t21_rows:,} sentence rows, "
          f"{t21_tok_idlist:,} token-ID refs, {len(t21_lemmas):,} distinct lemma ids")

    print("reading 2021 lemma frequency list (_8.csv) ...")
    t21_total_freq, freq21, bucket21 = read_2021_freq(REL_2021_FREQ)
    print(f"  {t21_total_freq:,} total attestations, {len(freq21):,} distinct lemma strings")

    print("reading 2026 master (dcs_full.sqlite) ...")
    t26_texts, t26_sent, t26_tok, t26_lemma_ids, bucket26, freq26 = read_2026(DB_2026)
    print(f"  {t26_texts} texts, {t26_sent:,} sentences, {t26_tok:,} tokens, "
          f"{t26_lemma_ids:,} distinct lemma ids, {len(freq26):,} distinct lemma strings")

    drift = top_n_drift(freq21, t21_total_freq, freq26, t26_tok, TOP_N)
    new_in_26 = [r for r in drift if r["rank21"] is None]
    dropped_from_26 = [r for r in drift if r["rank26"] is None]
    both = [r for r in drift if r["rank21"] is not None and r["rank26"] is not None]
    both_sorted_by_shift = sorted(
        both, key=lambda r: abs(r["rank26"] - r["rank21"]), reverse=True)

    out = []
    w = out.append
    w("# DCS corpus delta: 2021 relational export vs. 2026 CoNLL-U master\n")
    w("_Generated by `delta_stats.py` (H686). Superseded verdict at the bottom._\n")

    w("## 1. Corpus growth\n")
    w("| | 2021 (relational) | 2026 (CoNLL-U master) | delta |")
    w("|---|---:|---:|---:|")
    w(f"| texts | {t21_texts} | {t26_texts} | {t26_texts - t21_texts:+d} "
      f"({100.0 * (t26_texts - t21_texts) / t21_texts:+.1f}%) |")
    w(f"| sentences | {t21_rows:,} | {t26_sent:,} | {t26_sent - t21_rows:+,} — "
      f"**not directly comparable**, see caveat below |")
    w(f"| tokens | {t21_total_freq:,} | {t26_tok:,} | {t26_tok - t21_total_freq:+,} "
      f"({100.0 * (t26_tok - t21_total_freq) / t21_total_freq:+.1f}%) |")
    w(f"| distinct lemma IDs (0.csv cross-walk) | {len(t21_lemmas):,} | {t26_lemma_ids:,} | "
      f"{t26_lemma_ids - len(t21_lemmas):+,} |")
    w(f"| distinct lemma strings (freq list) | {len(freq21):,} | {len(freq26):,} | "
      f"{len(freq26) - len(freq21):+,} |\n")
    w("**Caveat:** the M3 `coverage_diff.py` sentence-row alignment already established that "
      "1 relational sentence row can map to *several* CoNLL-U sentences (re-segmentation), so "
      "the sentence-count row above is corpus size context, not a like-for-like delta. Token "
      "and lemma-ID counts ARE like-for-like — `0.csv`'s integer lemma-ID lists are the exact "
      "same `LemmaId`s used by the 2026 CoNLL-U (`DCS_FORMAT_COMPARISON.md`). Text/lemma "
      "coverage detail (which 30 texts were added, which 6 dropped, 89.3% lemma-ID Jaccard) is "
      "already reported by M3 — see "
      "[`coverage_diff.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/coverage_diff.md), "
      "not repeated here.\n")

    w("## 2. POS distribution shift (coarse buckets)\n")
    w("2021 tags (`_8.csv` third field) are a mix of gender letters (nominal), `ind`/`pron`/`adj`, "
      "and verb-class.voice codes (e.g. `2.Ā.`) — collapsed to UD-comparable coarse buckets. 2026 "
      "buckets are UD `upos` collapsed the same way (ADV/ADP/CONJ/SCONJ/PART/NUM/INTJ -> "
      "`IND(other)`, matching 2021's undifferentiated `ind`). Known limitation carried from the M7 "
      "notes: UD `Tense=Past` conflates aorist/perfect on the 2026 side — irrelevant to this coarse "
      "POS-bucket comparison since it stays above the tense/mood level.\n")
    w(md_bucket_table(bucket21, t21_total_freq, bucket26, t26_tok))
    w("")

    w(f"\n## 3. Top-{TOP_N} lemma frequency drift\n")
    w(f"Each side's own top-{TOP_N} lemmas by raw corpus count, union'd "
      f"({len(both)} lemmas in both top-{TOP_N}s, {len(new_in_26)} entered the 2026 top-{TOP_N} "
      f"from outside 2021's, {len(dropped_from_26)} fell out of it). Ranked by |rank shift|.\n")
    w(f"### Largest rank shifts (both in top-{TOP_N})\n")
    w("| lemma | 2021 rank | 2026 rank | rank shift | 2021 share % | 2026 share % |")
    w("|---|---:|---:|---:|---:|---:|")
    for r in both_sorted_by_shift[:30]:
        w(f"| {r['lemma']} | {r['rank21']} | {r['rank26']} | "
          f"{r['rank26'] - r['rank21']:+d} | {r['share21']:.3f} | {r['share26']:.3f} |")
    w(f"\n### Entered 2026 top-{TOP_N} (outside 2021's top-{TOP_N})\n")
    if new_in_26:
        w("| lemma | 2026 rank | 2026 share % | 2021 count (rank outside top-N) |")
        w("|---|---:|---:|---:|")
        for r in sorted(new_in_26, key=lambda r: r["rank26"])[:30]:
            w(f"| {r['lemma']} | {r['rank26']} | {r['share26']:.3f} | {r['c21']:,} |")
    else:
        w("(none)")
    w(f"\n### Fell out of the top-{TOP_N} (was in 2021's, not in 2026's)\n")
    if dropped_from_26:
        w("| lemma | 2021 rank | 2021 share % | 2026 count |")
        w("|---|---:|---:|---:|")
        for r in sorted(dropped_from_26, key=lambda r: r["rank21"])[:30]:
            w(f"| {r['lemma']} | {r['rank21']} | {r['share21']:.3f} | {r['c26']:,} |")
    else:
        w("(none)")

    # ---- verdict ----
    w("\n## 4. Verdict: is `DCS-data-2021/` superseded?\n")
    w("**NO — not fully contained, keep it.** Evidence:\n")
    w(f"- Text coverage (M3): 6 of 2021's 246 texts have no 2026 match "
      f"(`coverage_diff.md` § \"Only in 2021\") — genuinely absent from the 2026 CoNLL-U, "
      f"not renames (already reviewed by M3).")
    w(f"- Lemma-ID coverage (M3): 1,761 lemma IDs attested in 2021 do not appear in the 2026 "
      f"corpus at all (89.3% Jaccard, not 100%).")
    w(f"- This session: {len(dropped_from_26)} of 2021's top-{TOP_N} lemmas by frequency fell "
      f"out of 2026's top-{TOP_N} (frequency-rank drift, not necessarily absence — see table above "
      f"for which ones still have nonzero 2026 counts vs. genuinely dropped).")
    w("- The 2021 export also carries non-corpus tooling (`AddAuthor.exe`, `pref.exe`, Pascal "
      "sources, `.dig`/`.lps` project files) that has no 2026 counterpart at all and was never in "
      "scope for the CoNLL-U import.")
    w("\n**GTD @DO for a human:** none — do NOT archive/delete `DCS-data-2021/`. The 6 dropped "
      "texts and 1,761 corpus-2021-only lemma IDs are unique data, not import-pipeline debt.\n")

    os.makedirs(HERE, exist_ok=True)
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")
    print(f"\nwrote {os.path.relpath(OUT, REPO_ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
