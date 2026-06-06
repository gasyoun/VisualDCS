#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
check_conllu_updates.py — has the upstream DCS CoNLL-U changed since our pin?

VisualDCS commits a *snapshot* of the CoNLL-U distribution from
https://github.com/OliverHellwig/sanskrit/tree/master/dcs/data/conllu , pinned at:

    commit 04e0778d3dc971030229179e25eea043d06ff397  (2026-03-05)

This script asks the GitHub API whether any commits have touched that path **after**
the pin, and lists them. Run it periodically (or from CI/cron) to know when the
committed `conllu/` snapshot is stale and should be refreshed + re-pinned.

Exit codes:  0 = up to date   1 = update(s) available   2 = check failed (network/API)

Usage:
    python check_conllu_updates.py
    GITHUB_TOKEN=ghp_xxx python check_conllu_updates.py   # higher API rate limit
"""

import json
import os
import sys
import time
import urllib.error
import urllib.request

try:
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")
except Exception:
    pass

# --- the pin (keep in sync with the docs when you re-snapshot) -------------- #
REPO = "OliverHellwig/sanskrit"
PATH = "dcs/data/conllu"
PINNED_SHA = "04e0778d3dc971030229179e25eea043d06ff397"
PINNED_DATE_HUMAN = "2026-03-05"
PINNED_DATE_UTC = "2026-03-05T18:20:09Z"   # commit time of the pin, in UTC (+01:00 -> Z)

API = (f"https://api.github.com/repos/{REPO}/commits"
       f"?path={PATH}&since={PINNED_DATE_UTC}&per_page=100")


def fetch(url):
    """GET a GitHub API URL with retries; return parsed JSON or None."""
    req = urllib.request.Request(url, headers={
        "Accept": "application/vnd.github+json",
        "User-Agent": "visualdcs-conllu-update-check",
    })
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=30) as r:
                return json.load(r)
        except urllib.error.HTTPError as e:
            if e.code in (403, 429):
                print("  GitHub API rate-limited. Set GITHUB_TOKEN for a higher limit.",
                      file=sys.stderr)
                return None
            print(f"  HTTP {e.code} from GitHub API.", file=sys.stderr)
            return None
        except (urllib.error.URLError, TimeoutError) as e:
            if attempt < 3:
                time.sleep(2 * (attempt + 1))
                continue
            print(f"  network error after retries: {e}", file=sys.stderr)
            return None
    return None


def main():
    print(f"Pinned : {REPO}:{PATH}")
    print(f"         @ {PINNED_SHA[:7]} ({PINNED_DATE_HUMAN})")
    print(f"Checking GitHub for newer commits to {PATH} ...\n")

    data = fetch(API)
    if data is None:
        print("CHECK FAILED — could not reach the GitHub API.")
        return 2

    # Exclude the pinned commit itself (the `since` filter is inclusive of its timestamp).
    newer = [c for c in data if c.get("sha") != PINNED_SHA]
    if not newer:
        print(f"UP TO DATE — no commits to {PATH} since {PINNED_DATE_HUMAN}.")
        return 0

    newer.sort(key=lambda c: c["commit"]["committer"]["date"], reverse=True)
    print(f"UPDATE AVAILABLE — {len(newer)} commit(s) to {PATH} since {PINNED_DATE_HUMAN}:\n")
    for c in newer[:10]:
        when = c["commit"]["committer"]["date"][:10]
        msg = c["commit"]["message"].splitlines()[0][:70]
        print(f"  {c['sha'][:7]}  {when}  {msg}")
    if len(newer) > 10:
        print(f"  … and {len(newer) - 10} more (API capped at 100)")

    top = newer[0]
    print(f"\nNewest : {top['sha'][:7]} ({top['commit']['committer']['date'][:10]})")
    print("\nTo refresh: re-clone upstream, re-extract dcs/data/conllu over src/DCS-data-2026/conllu/,")
    print("then re-pin (update PINNED_SHA/PINNED_DATE_* here and in the docs/CHANGELOG).")
    return 1


if __name__ == "__main__":
    sys.exit(main())
