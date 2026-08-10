"""verify_related_work_citations.py — every ACL URL in a draft must exist in the dump.

Acceptance gate for the A57 related-work draft (H2400): "Fail = no Anthology URLs".
A hallucinated-but-plausible aclanthology.org URL is the failure mode this catches —
it 404s at review time, not at write time. So: extract every aclanthology.org link
from the markdown, check each against the canonical `url` fields of the Anthology
dump, and report counts + any unknown URL.

Exit 0 = every cited URL resolves in the dump and the LSC/SemEval minimums hold.
Exit 1 = at least one URL is not in the dump, or an acceptance minimum fails.

Usage:
    python derived-lsc/verify_related_work_citations.py \
        --draft papers/A57_lsc_related_work.md \
        --cached anthology.bib.gz [--min-lsc 8]
"""

import argparse
import gzip
import pathlib
import re
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from mine_lsc_related_work import LSC_RE, debrace, parse_bib  # noqa: E402

URL_RE = re.compile(r"https://aclanthology\.org/[^\s)\]<>\"]+")
SEMEVAL_2020_T1 = "https://aclanthology.org/2020.semeval-1.1/"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--draft", required=True)
    ap.add_argument("--cached", required=True)
    ap.add_argument("--min-lsc", type=int, default=8)
    args = ap.parse_args()

    draft = pathlib.Path(args.draft).read_text(encoding="utf-8")
    cited = []
    for u in URL_RE.findall(draft):
        u = u.rstrip(".,;")
        if u.endswith("anthology.bib.gz"):
            continue  # the dump itself, not a paper
        if "…" in u or u.endswith("/..."):
            continue  # a prose placeholder template, not a citation
        if u not in cited:
            cited.append(u)

    path = pathlib.Path(args.cached)
    if path.suffix == ".gz":
        with gzip.open(path, "rt", encoding="utf-8", errors="replace") as f:
            lines = f.readlines()
    else:
        lines = path.read_text(encoding="utf-8", errors="replace").splitlines(True)

    url_to_title = {}
    for e in parse_bib(lines):
        url = e.get("url", "")
        if url:
            url_to_title[url] = (debrace(e.get("title", "")), e["_type"])

    unknown = [u for u in cited if u not in url_to_title]
    known = [u for u in cited if u in url_to_title]
    lsc_family = [u for u in known if LSC_RE.search(url_to_title[u][0])]

    print(f"Draft:              {args.draft}")
    print(f"Dump:               {path.name}")
    print(f"Distinct ACL URLs:  {len(cited)}")
    print(f"  resolved in dump: {len(known)}")
    print(f"  UNKNOWN:          {len(unknown)}")
    print(f"  LSC-family:       {len(lsc_family)} (minimum {args.min_lsc})")
    print(f"SemEval-2020 T1 cited: {SEMEVAL_2020_T1 in cited}")

    for u in unknown:
        print(f"  !! NOT IN DUMP: {u}")

    ok = True
    if unknown:
        print("\nFAIL — hallucinated or stale URL(s) above.")
        ok = False
    if len(lsc_family) < args.min_lsc:
        print(f"\nFAIL — only {len(lsc_family)} LSC-family citations, need {args.min_lsc}.")
        ok = False
    if SEMEVAL_2020_T1 not in cited:
        print("\nFAIL — SemEval-2020 Task 1 must be cited (acceptance criterion).")
        ok = False
    if ok:
        print("\nPASS — every cited URL is a canonical Anthology URL; minimums met.")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
