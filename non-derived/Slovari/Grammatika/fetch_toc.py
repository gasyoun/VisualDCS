"""Fetch the slovari.ru section tables of contents into toc.json.

A TOC page is a page whose div.PlainText contains anchors to
default.aspx?...&p=NNNN&0a0=MMMM. The resulting file is the offline input for
build_html.py, so the HTML build itself needs no network.
"""

from __future__ import annotations

import json
import pathlib
from urllib.parse import parse_qs, urljoin, urlparse

import requests
from lxml import html as lxml_html

TOC_PAGES = [
    3071, 5304, 5306, 5309, 5312, 5313, 5314, 5317, 5319, 5321,
    5322, 5323, 5324, 5325, 5327, 5330, 5332, 5333, 5334, 5336,
]

root = pathlib.Path(__file__).resolve().parent
s = requests.Session()
s.headers.update({"User-Agent": "VisualDCS-grammar-toc/1.0"})
toc = {}
for pid in TOC_PAGES:
    url = f"https://slovari.ru/default.aspx?s=0&p={pid}"
    resp = s.get(url, timeout=30)
    resp.raise_for_status()
    doc = lxml_html.fromstring(resp.content.decode("utf-8", errors="replace"))
    entries = []
    seen = set()
    for a in doc.xpath('//div[contains(@class,"PlainText")]//a[@href]'):
        q = parse_qs(urlparse(urljoin(resp.url, a.get("href"))).query)
        if "0a0" not in q:
            continue
        target_p = q.get("p", [str(pid)])[0]
        a0 = q["0a0"][0]
        key = (target_p, a0)
        if key in seen:
            continue
        seen.add(key)
        entries.append(
            {
                "text": " ".join("".join(a.itertext()).split()),
                "p": target_p,
                "0a0": a0,
            }
        )
    toc[str(pid)] = entries
    print(f"p={pid}: {len(entries)} TOC entries")

(root / "toc.json").write_text(
    json.dumps(toc, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
)
