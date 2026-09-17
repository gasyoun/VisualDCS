# -*- coding: utf-8 -*-
"""build_mw_h3_parent_compounds.py -- H4480.

Parse MG's "MW H3 compounds" table (yadisk: Сложные слова (samāsa) в
санскрите (2)/Алгоримы обработки сложных слов (для искуственного интеллекта)/
compounds.txt, committed here as compounds.txt) into a machine-usable TSV and
cross-check its coverage against the DCS corpus compound universe (cmps.csv).

The source table is PARENT-KEYED (pūrvapada axis): 12,609 MW H1/H2 headwords
with their H3 compound children from the Cologne MW 1899 digitization. The
existing uttarapada_dict_vs_corpus.tsv (H1328) is FINAL-MEMBER-keyed -- this
is the complementary first-member view, not a duplicate.

Child token shapes in the source:
  +Y        -> child key2 is 'X-Y', shortened to '+Y' (rejoin with parent)
  plain Z   -> alternate full spelling already present (may contain '@' join
               marker or '-' internal hyphen)

Folds (H1328 conventions, okey()):
  '@' join marker removed; leading avagraha "'" = elided initial a;
  anusvara m-dot-below (U+1E43, MW style) -> m-dot-above (U+1E41, DCS style).
No other folding: vowel-length / junction-sandhi differences stay as-is.

Output TSV shape: parent<TAB>n_children<TAB>children, the children field joined by
CHILD_SEP ('|', never a space -- see CHILD_SEP below). A hard round-trip assertion
re-reads the written file and requires the children field to tokenize back to
exactly n_children tokens on every row; the script exits non-zero if any row fails.

Usage:
  python build_mw_h3_parent_compounds.py
  python build_mw_h3_parent_compounds.py --src compounds.txt --cmps cmps.csv
"""
import sys, os, argparse, unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
sys.stdout.reconfigure(encoding="utf-8")

OUT_TSV = os.path.join(HERE, "mw_h3_parent_compounds.tsv")

# Children serialization separator (H5064). 1,228 distinct source parents (1,247 rows)
# contain a literal space ('ad VERB', 'cur VERB', 'tan VERB', ...) and a '+' child
# rejoins onto its parent, so a space-joined children field cannot round-trip: a
# whitespace split returns more tokens than n_children declares -- exactly the 5 rows
# that combine a space-bearing parent with a '+' child did that.
# '|' occurs in no child token over all 12,609 rows -- preserve that invariant; the
# builder refuses to write if the separator reappears inside a child.
CHILD_SEP = "|"

ANUS_ABOVE, ANUS_BELOW = "\u1e41", "\u1e43"  # m-dot-above (DCS), m-dot-below (MW)


def nfc(s):
    return unicodedata.normalize("NFC", s.strip())


def fold_child(tok, parent):
    """Return the DCS-style surface/child form for one source token."""
    if tok.startswith("+"):
        form = parent + tok[1:]
    else:
        form = tok
    form = form.replace("@", "")
    if form.startswith("'"):
        form = "a" + form[1:]
    return nfc(form.replace(ANUS_BELOW, ANUS_ABOVE))


def parse_source(path):
    """Yield (parent, [folded_children]) per source row; count rows."""
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("<"):
                continue
            head, _, rest = line.partition(":")
            if not rest:  # not a data row
                continue
            parts = rest.split(":", 1)
            if len(parts) != 2:
                continue
            parent, children_str = parts
            parent = nfc(parent.replace(ANUS_BELOW, ANUS_ABOVE))
            children = [fold_child(t, parent) for t in children_str.split() if t]
            if children:
                rows.append((parent, children))
    return rows


def verify_roundtrip(path, rows, sep=CHILD_SEP):
    """Hard round-trip assertion for the written TSV (H5064).

    Re-read the file and require, for every row: exactly three tab-separated
    fields, a children field that tokenizes on `sep` back to exactly the declared
    n_children count, and the same (parent, n_children, children) triple as the
    in-memory rows. Raises AssertionError on the first violation.
    """
    expected = [(p, len(cs), cs) for p, cs in rows]
    got = []
    with open(path, encoding="utf-8") as f:
        header = f.readline().rstrip("\n")
        assert header == "parent\tn_children\tchildren", f"unexpected header: {header!r}"
        for lineno, line in enumerate(f, start=2):
            line = line.rstrip("\n")
            if not line:
                continue
            fields = line.split("\t")
            assert len(fields) == 3, f"line {lineno}: expected 3 fields, got {len(fields)}"
            parent, n_str, joined = fields
            n = int(n_str)
            toks = joined.split(sep) if joined else []
            assert len(toks) == n, (
                f"line {lineno} (parent {parent!r}): children tokenize to {len(toks)} "
                f"tokens but n_children declares {n}"
            )
            got.append((parent, n, toks))
    assert got == expected, (
        f"round-trip mismatch: re-read {len(got)} row(s) vs {len(expected)} in memory"
    )
    return len(got)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--src", default=os.path.join(HERE, "compounds.txt"))
    ap.add_argument("--cmps", default=os.path.join(HERE, "cmps.csv"))
    args = ap.parse_args()

    rows = parse_source(args.src)
    n_child_tokens = sum(len(c) for _, c in rows)
    distinct_children = {c for _, cs in rows for c in cs}

    # corpus universe (no header, semicolon-delimited):
    #   col1 = sandhied, often inflected surface  -> direct surface match
    #   col2 = stem split ("ambikā pati")         -> spaces removed = stem
    #          concatenation, the honest match for MW stem-form children
    corpus_surf, corpus_stem = set(), set()
    with open(args.cmps, encoding="utf-8") as f:
        for line in f:
            parts = line.rstrip("\n").split(";", 1)
            if not parts or not parts[0].strip():
                continue
            surf = nfc(parts[0].strip().replace(ANUS_BELOW, ANUS_ABOVE))
            corpus_surf.add(surf)
            if len(parts) > 1:
                stems = nfc(parts[1].replace(ANUS_BELOW, ANUS_ABOVE))
                corpus_stem.add(stems.replace(" ", ""))

    att_surf = distinct_children & corpus_surf
    att_stem = distinct_children & corpus_stem
    attested = att_surf | att_stem
    pct = 100.0 * len(attested) / max(1, len(distinct_children))
    pct_surf = 100.0 * len(att_surf) / max(1, len(distinct_children))
    pct_stem = 100.0 * len(att_stem) / max(1, len(distinct_children))

    sep_hits = [c for _, cs in rows for c in cs if CHILD_SEP in c]
    if sep_hits:
        sys.exit(
            f"FATAL: {len(sep_hits)} child token(s) contain the separator {CHILD_SEP!r} "
            f"({sep_hits[:5]}); pick a different CHILD_SEP"
        )

    # newline="\n": the committed TSV is LF-normalised (repo convention, see README
    # provenance) -- without it Python would write CRLF on Windows and churn the blob.
    with open(OUT_TSV, "w", encoding="utf-8", newline="\n") as out:
        out.write("parent\tn_children\tchildren\n")
        for parent, children in rows:
            out.write(f"{parent}\t{len(children)}\t{CHILD_SEP.join(children)}\n")

    print(f"source rows (parent occurrences): {len(rows)}")
    print(f"distinct parents:                {len({p for p, _ in rows})}")
    print(f"child tokens:                    {n_child_tokens}")
    print(f"distinct children (folded):      {len(distinct_children)}")
    print(f"corpus universe (cmps.csv):      {len(corpus_surf)} surfaces / {len(corpus_stem)} stem-concats")
    print(f"children attested (surface):     {len(att_surf)} ({pct_surf:.1f}%)")
    print(f"children attested (stem-concat): {len(att_stem)} ({pct_stem:.1f}%)")
    print(f"children attested (any key):     {len(attested)} ({pct:.1f}%)")
    print(f"children dictionary-only:        {len(distinct_children) - len(attested)} (lower bound)")

    try:
        n_verified = verify_roundtrip(OUT_TSV, rows)
    except AssertionError as exc:
        print(f"round-trip assertion:            FAIL -- {exc}")
        sys.exit(1)
    print(f"round-trip assertion:            {n_verified}/{len(rows)} rows OK (children tokenizes to n_children)")
    print(f"wrote {OUT_TSV} (children separator {CHILD_SEP!r})")


if __name__ == "__main__":
    main()
