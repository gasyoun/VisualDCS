"""mine_lsc_related_work.py — verified LSC citation harvest from the ACL Anthology dump.

Every citation in the A57 related-work draft must come from the Anthology's own
`anthology.bib.gz` (its `url` field is the canonical paper URL), never from model
recall — a hallucinated ACL URL is the specific failure this script exists to
prevent (H2400 acceptance: "Fail = no Anthology URLs").

Two jobs:

1. **Census** the lexical-semantic-change (LSC) family and its sub-themes, so the
   draft's "N papers, 0 on Sanskrit" claims are measured rather than asserted.
2. **Emit** a candidate table (year, venue, title, canonical URL, authors) for the
   themes the A57 related-work section needs: shared tasks, count-based vs
   embedding methods, usage-graph gold / WiC, metric critique, low-resource and
   historical-language LSC, and Sanskrit/Indic diachrony.

Usage:
    python derived-lsc/mine_lsc_related_work.py --cached <path to anthology.bib.gz>
    python derived-lsc/mine_lsc_related_work.py --cached ... --json out.json

Output: markdown to stdout (census + per-theme candidate tables); optional JSON
sidecar with the full harvested records for downstream reuse.
"""

import argparse
import gzip
import json
import pathlib
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

ENTRY_RE = re.compile(r"^@(\w+)\{([^,]+),\s*$")
FIELD_RE = re.compile(r"^\s{2,}(\w+)\s*=\s*(.*)$")

# Braces in BibTeX titles protect case ({S}anskrit) — strip for display only.
BRACE_RE = re.compile(r"[{}]")


def debrace(text: str) -> str:
    return BRACE_RE.sub("", text).strip()


def parse_bib(lines):
    """Yield dicts of one Anthology entry each: type, key, title, url, year, authors, booktitle."""
    entry = None
    field = None
    buf = []

    def flush_field():
        nonlocal field, buf
        if entry is not None and field:
            raw = " ".join(buf).strip()
            raw = raw.rstrip(",").strip()
            if raw.startswith('"') and raw.endswith('"'):
                raw = raw[1:-1]
            entry[field] = raw
        field, buf = None, []

    for line in lines:
        m = ENTRY_RE.match(line)
        if m:
            flush_field()
            if entry:
                yield entry
            entry = {"_type": m.group(1).lower(), "_key": m.group(2).strip()}
            continue
        if entry is None:
            continue
        if line.strip() == "}":
            flush_field()
            yield entry
            entry = None
            continue
        fm = FIELD_RE.match(line)
        if fm:
            flush_field()
            field = fm.group(1).lower()
            buf = [fm.group(2).strip()]
        elif field:
            buf.append(line.strip())
    flush_field()
    if entry:
        yield entry


def first_author_surname(authors: str) -> str:
    """'Surname, Given  and  Surname2, Given2' -> 'Surname' (+ ' et al.')."""
    if not authors:
        return ""
    parts = [a.strip() for a in re.split(r"\s+and\s+", debrace(authors)) if a.strip()]
    if not parts:
        return ""
    surname = parts[0].split(",")[0].strip()
    if len(parts) == 1:
        return surname
    if len(parts) == 2:
        return f"{surname} & {parts[1].split(',')[0].strip()}"
    return f"{surname} et al."


# The LSC family regex is deliberately the SAME shape as Uprava's quarterly
# mine_anthology.py family #4, so the census here is comparable to that report.
LSC_RE = re.compile(
    r"\b(lexical semantic change|semantic shift|diachronic|word sense change|lsc )",
    re.I,
)
SANSKRIT_RE = re.compile(r"\bsanskrit\b", re.I)

# Themes the A57 related-work section must cover. Each: (label, title regex).
THEMES = [
    ("Shared tasks & benchmarks", r"\b(semeval|shared task|evalita|codwoe|lscdiscovery|rushifteval)\b"),
    ("Count-based / distributional methods", r"\b(ppmi|count.based|pointwise mutual|distributional (model|semantic|space)|second.order)\b"),
    ("Embedding alignment & temporal models", r"\b(procrustes|align(ed|ment|ing)? .{0,20}embedding|temporal (word )?embedding|dynamic word embedding|diachronic (word )?embedding)\b"),
    ("Usage graphs, WiC & annotated gold", r"\b(usage graph|wug\b|\bwug|word.in.context|\bwic\b|usage.based|annotat\w+ .{0,25}(sense|usage))\b"),
    ("Metric critique & evaluation design", r"\b(rethinking|evaluat\w+ .{0,25}(lexical semantic change|semantic change)|metric|pitfall|caveat|comparison of .{0,25}(approach|method)|survey)\b"),
    ("Low-resource & historical languages", r"\b(low.resource|ancient|historical|classical|medieval|latin|greek|chinese|hebrew|russian|indic|hindi)\b"),
]


FIXTURE = """@proceedings{fake-2026-1,
    title = "Proceedings of Nothing",
    url = "https://aclanthology.org/2026.fake-1.0/"
}
@inproceedings{schlechtweg-etal-2020-semeval,
    title = "{S}em{E}val-2020 Task 1: Unsupervised Lexical Semantic Change Detection",
    author = "Schlechtweg, Dominik  and
      McGillivray, Barbara  and
      Hengchen, Simon",
    booktitle = "Proceedings of the Fourteenth Workshop on Semantic Evaluation",
    year = "2020",
    url = "https://aclanthology.org/2020.semeval-1.1/"
}
@inproceedings{solo-2026-sanskrit,
    title = "Diachronic Analysis of Vedic {S}anskrit",
    author = "Solo, Ada",
    year = "2026",
    url = "https://aclanthology.org/2026.fake-1.9/"
}
"""


def selftest():
    """Fixtures for the two things most likely to break silently: multi-line BibTeX
    field continuation (authors) and the @proceedings exclusion."""
    entries = list(parse_bib(FIXTURE.splitlines(True)))
    assert len(entries) == 3, f"expected 3 entries, got {len(entries)}"

    papers = [e for e in entries if e["_type"] != "proceedings"]
    assert len(papers) == 2, "@proceedings must be separable from papers"

    semeval = papers[0]
    assert semeval["url"] == "https://aclanthology.org/2020.semeval-1.1/", semeval.get("url")
    title = debrace(semeval["title"])
    assert title.startswith("SemEval-2020 Task 1:"), title
    assert LSC_RE.search(title), "SemEval-2020 T1 must match the LSC family regex"
    # three authors joined across continuation lines -> 'et al.'
    cite = first_author_surname(semeval["author"])
    assert cite == "Schlechtweg et al.", cite

    sanskrit = papers[1]
    stitle = debrace(sanskrit["title"])
    assert SANSKRIT_RE.search(stitle) and LSC_RE.search(stitle), stitle
    assert first_author_surname(sanskrit["author"]) == "Solo"

    assert first_author_surname("Aida, Taichi  and  Bollegala, Danushka") == "Aida & Bollegala"
    assert first_author_surname("") == ""
    print("selftest PASS")


def main():
    if "--selftest" in sys.argv:
        selftest()
        return
    ap = argparse.ArgumentParser()
    ap.add_argument("--cached", required=True, help="path to anthology.bib(.gz)")
    ap.add_argument("--json", default=None, help="optional JSON sidecar for harvested records")
    ap.add_argument("--selftest", action="store_true", help="run parser fixtures and exit")
    ap.add_argument("--per-theme", type=int, default=40, help="max rows per theme table")
    ap.add_argument(
        "--query",
        action="append",
        default=[],
        help="extra title regex searched over the WHOLE dump, not just the LSC family "
        "(repeatable). Needed because method precedents — PPMI, Procrustes, usage-pair "
        "annotation — often carry none of the family keywords in their titles.",
    )
    args = ap.parse_args()

    path = pathlib.Path(args.cached)
    if path.suffix == ".gz":
        with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
            lines = f.readlines()
    else:
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines(True)

    total = 0
    lsc = []
    sanskrit_lsc = []
    sanskrit_all = []
    queries = [(q, re.compile(q, re.I), []) for q in args.query]
    for e in parse_bib(lines):
        if e["_type"] == "proceedings":
            continue
        total += 1
        title = debrace(e.get("title", ""))
        if not title:
            continue
        rec = {
            "key": e["_key"],
            "title": title,
            "url": e.get("url", ""),
            "year": e.get("year", ""),
            "authors": debrace(e.get("author", "")),
            "cite": first_author_surname(e.get("author", "")),
            "booktitle": debrace(e.get("booktitle", e.get("journal", ""))),
        }
        for _, rx, bucket in queries:
            if rx.search(title):
                bucket.append(rec)
        if SANSKRIT_RE.search(title):
            sanskrit_all.append(rec)
        if LSC_RE.search(title):
            lsc.append(rec)
            if SANSKRIT_RE.search(title):
                sanskrit_lsc.append(rec)

    def year_int(rec):
        try:
            return int(rec["year"])
        except (TypeError, ValueError):
            return 0

    lsc.sort(key=lambda r: (-year_int(r), r["title"]))
    since_2020 = [r for r in lsc if year_int(r) >= 2020]
    with_url = [r for r in lsc if r["url"].startswith("https://aclanthology.org/")]

    print("# A57 LSC related-work harvest — ACL Anthology (verified)\n")
    print(f"- **Dump:** `{path.name}` (generated {lines[0].strip().split('on ')[-1] if lines else 'n/a'})")
    print(f"- **Non-proceedings entries scanned:** {total:,}")
    print(f"- **LSC family (title match):** {len(lsc):,} · since 2020: {len(since_2020):,}")
    print(f"- **With canonical aclanthology.org URL:** {len(with_url):,}")
    print(f"- **Sanskrit ∩ LSC family:** {len(sanskrit_lsc)}  <- the A57 gap claim\n")

    seen_theme = {}
    for label, pattern in THEMES:
        rx = re.compile(pattern, re.I)
        hits = [r for r in lsc if rx.search(r["title"])]
        seen_theme[label] = hits
        print(f"\n## {label} — {len(hits)} hits\n")
        print("| Year | Cite | Title | URL | Venue |")
        print("|---|---|---|---|---|")
        for r in hits[: args.per_theme]:
            venue = r["booktitle"][:60]
            print(f"| {r['year']} | {r['cite']} | {r['title']} | {r['url']} | {venue} |")

    print(f"\n## Sanskrit (whole dump, any method) — {len(sanskrit_all)} hits\n")
    print("| Year | Cite | Title | URL |")
    print("|---|---|---|---|")
    for r in sorted(sanskrit_all, key=lambda r: -year_int(r))[: args.per_theme]:
        print(f"| {r['year']} | {r['cite']} | {r['title']} | {r['url']} |")

    for label, _rx, bucket in queries:
        bucket.sort(key=lambda r: -year_int(r))
        print(f"\n## QUERY `{label}` (whole dump) — {len(bucket)} hits\n")
        print("| Year | Cite | Title | URL | Venue |")
        print("|---|---|---|---|---|")
        for r in bucket[: args.per_theme]:
            print(f"| {r['year']} | {r['cite']} | {r['title']} | {r['url']} | {r['booktitle'][:60]} |")

    if args.json:
        out = {
            "dump": str(path),
            "scanned": total,
            "lsc_total": len(lsc),
            "lsc_since_2020": len(since_2020),
            "sanskrit_lsc": len(sanskrit_lsc),
            "sanskrit_all": len(sanskrit_all),
            "records": lsc,
            "sanskrit_records": sanskrit_all,
            "queries": {label: bucket for label, _rx, bucket in queries},
            "themes": {k: [r["key"] for r in v] for k, v in seen_theme.items()},
        }
        pathlib.Path(args.json).write_text(
            json.dumps(out, ensure_ascii=False, indent=2), encoding="utf-8"
        )
        print(f"\nJSON sidecar written to {args.json}", file=sys.stderr)


if __name__ == "__main__":
    main()
