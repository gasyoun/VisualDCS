"""One-off repair: make derived/text paths unique after the first crawl.

The first run keyed filenames on p + 0a0 only; 451 URL variants collided and
overwrote each other. This script rewrites every path with the same
URL-hash stem the spider now uses, re-fetching the colliding pages so no text
is lost, then verifies 1 row = 1 file.
"""

from __future__ import annotations

import hashlib
import json
import pathlib
import time
from collections import Counter
from urllib.parse import parse_qs, urlparse

import requests
from lxml import html as lxml_html

from slovari_spider import norm

root = pathlib.Path(__file__).resolve().parent
manifest_path = root / "manifest.json"
m = json.loads(manifest_path.read_text(encoding="utf-8"))
counts = Counter(r["path"] for r in m["page_index"])
session = requests.Session()
session.headers.update({"User-Agent": "VisualDCS-slovari-grammar-repair/1.0"})


def new_path(url: str) -> str:
    q = parse_qs(urlparse(url).query)
    stem = (
        "p" + q.get("p", ["0"])[0] + "_a" + q.get("0a0", ["0"])[0]
        + "_" + hashlib.sha256(norm(url).encode("utf-8")).hexdigest()[:8]
    )
    return "derived/text/" + stem + ".txt"


refetched = renamed = 0
for row in m["page_index"]:
    dest_rel = new_path(row["url"])
    dest = root / dest_rel
    src = root / row["path"]
    if counts[row["path"]] > 1:
        resp = session.get(row["url"], timeout=30)
        resp.raise_for_status()
        doc = lxml_html.fromstring(resp.content.decode("utf-8", errors="replace"))
        parts = ["".join(n.itertext()) for n in doc.xpath('//div[contains(@class,"PlainText")]')]
        text = "\n".join(p.replace("\xa0", " ").strip() for p in parts if p.strip())
        payload = text.encode("utf-8")
        dest.write_bytes(payload)
        row["chars"] = len(text)
        row["sha256"] = hashlib.sha256(payload).hexdigest()
        refetched += 1
        time.sleep(0.2)
    elif src.exists():
        src.rename(dest)
        renamed += 1
    else:
        raise SystemExit("missing source file: " + str(src))
    row["path"] = dest_rel

# Stale files from the colliding groups (one per group survived the overwrite).
for old_rel, n in counts.items():
    if n > 1:
        stale = root / old_rel
        if stale.exists():
            stale.unlink()

paths = [r["path"] for r in m["page_index"]]
assert len(paths) == len(set(paths)), "paths still collide"
assert all((root / p).is_file() for p in paths), "missing derived file"
m["page_chars"] = sum(r["chars"] for r in m["page_index"])
m["rights"] = (
    "Publication authorized by repo owner 26-11-2026 (publisher rights). "
    "Source text included."
)
manifest_path.write_text(json.dumps(m, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
with (root / "derived" / "pages.jsonl").open("w", encoding="utf-8") as fh:
    for r in m["page_index"]:
        fh.write(json.dumps(r, ensure_ascii=False) + "\n")
print("renamed=%d refetched=%d unique_paths=%d chars=%d" % (renamed, refetched, len(paths), m["page_chars"]))
