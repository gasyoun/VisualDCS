"""Compare the regenerated contract assets with HEAD, ignoring the run-date stamp.

Uprava H5423 (E016 wave 5). Run AFTER the generators:

    python src/DCS-data-2026/regen_widgets.py --figures-only
    python gen_dcs_lemma_summary.py
    python check_generated_figures.py                      # exit 1 on a real change
    python check_generated_figures.py --restore-date-only  # drop date-only rewrites

dcs_lemma_summary.json is ONE line of compact JSON whose top-level "generatedAt" is
today's date, so a line-based `git diff -I` mask would hide every change in the file.
Both assets are compared as parsed JSON with the top-level "generatedAt" removed.
"""
import argparse
import json
import subprocess
import sys

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

ASSETS = ["dcs_published_figures.json", "dcs_lemma_summary.json"]
STAMP_KEY = "generatedAt"


def normalized(raw):
    doc = json.loads(raw)
    if isinstance(doc, dict):
        doc.pop(STAMP_KEY, None)
    return doc


def head_blob(path):
    res = subprocess.run(["git", "show", f"HEAD:{path}"], capture_output=True)
    return res.stdout if res.returncode == 0 else None


def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("--restore-date-only", action="store_true")
    args = ap.parse_args()
    real = []
    for path in ASSETS:
        try:
            with open(path, "rb") as fh:
                now = fh.read()
        except FileNotFoundError:
            continue  # asset not in this (sparse) checkout
        before = head_blob(path)
        if before == now:
            continue
        if before is not None and normalized(before) == normalized(now):
            if args.restore_date_only:
                subprocess.run(["git", "checkout", "HEAD", "--", path], check=True)
            print(f"date-stamp-only {path}")
            continue
        real.append(path)
        print(f"CHANGED {path}")
    return 1 if real else 0


if __name__ == "__main__":
    sys.exit(main())
