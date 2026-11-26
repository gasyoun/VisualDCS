"""Crawl the slovari.ru GRAMMATIKA section (p=165) into local-only derived files.

Crawl rules (deliberately small, no framework dependency):
  * seed: https://slovari.ru/default.aspx?s=0&p=165
  * follow only same-host links carrying p=, 0a0= or file_id=
  * stay inside the grammar section: breadcrumb #kroshki must mention ГРАММАТИКА
  * site DECLARES windows-1251 in <meta http-equiv> but actually serves UTF-8
    (verified 26-11-2026: cp1251 decoding mojibakes "ГРАММАТИКА" and fails on 0x98)
  * page body is div.PlainText, title is h1.partname
  * LoadFile.aspx is a binary download, routed to raw/downloads/

Output (all gitignored):
  derived/pages.jsonl          one row per HTML page: url, title, text_path, sha256
  derived/text/<p>_<0a0>.txt   plain text of div.PlainText
  raw/downloads/<file_id>...   RAR/DOC/TTF payloads
  manifest.json                provenance + counts + hashes (committed)

Usage: python slovari_spider.py [--out-dir .] [--delay 0.5]
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import time
from datetime import datetime, timezone
from pathlib import Path
from urllib.parse import parse_qs, urljoin, urlparse

import requests
from lxml import html as lxml_html

BASE = "https://slovari.ru"
SEED = BASE + "/default.aspx?s=0&p=165"
HEADERS = {"User-Agent": "VisualDCS-slovari-grammar-harvester/1.0 (research; low-rate)"}
SECTION_MARK = "ГРАММАТИКА"
# p=, 0a0= and file_id= — match parsed keys, not the raw query string
# (a first-position param has no leading ?/&; that bug hid all LoadFile links).
HARVEST_KEYS = {"p", "0a0", "file_id"}


def norm(url: str) -> str:
    u = urlparse(url)
    q = parse_qs(u.query, keep_blank_values=True)
    # collapse &amp;-style duplicates and drop form/viewstate noise
    clean = {k: v[0] for k, v in q.items() if k not in {"__VIEWSTATE", "__VIEWSTATEGENERATOR"}}
    keys = sorted(clean)
    return u.scheme + "://" + u.netloc.lower() + u.path + "?" + "&".join(
        f"{k}={clean[k]}" for k in keys
    )


def sha256_bytes(b: bytes) -> str:
    return hashlib.sha256(b).hexdigest()


def is_harvestable(url: str) -> bool:
    u = urlparse(url)
    if u.netloc.lower().replace("www.", "") != "slovari.ru":
        return False
    if not HARVEST_KEYS.intersection(parse_qs(u.query, keep_blank_values=True)):
        return False
    return u.path.lower().endswith(("default.aspx", "loadfile.aspx"))


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--out-dir", default=".")
    ap.add_argument("--delay", type=float, default=0.5)
    ap.add_argument("--max-pages", type=int, default=2000)
    ap.add_argument("--seed", default=SEED, help="start URL (use p=2572 for --files-only)")
    ap.add_argument("--files-only", action="store_true", help="only fetch LoadFile.aspx payloads")
    args = ap.parse_args()

    root = Path(args.out_dir).resolve()
    text_dir = root / "derived" / "text"
    dl_dir = root / "raw" / "downloads"
    text_dir.mkdir(parents=True, exist_ok=True)
    dl_dir.mkdir(parents=True, exist_ok=True)

    session = requests.Session()
    session.headers.update(HEADERS)
    queue = [args.seed]
    seen: set[str] = set()
    rows: list[dict] = []
    downloads: list[dict] = []
    errors: list[dict] = []
    fetched = 0

    while queue and fetched < args.max_pages:
        url = queue.pop(0)
        key = norm(url)
        if key in seen:
            continue
        seen.add(key)
        try:
            resp = session.get(url, timeout=30)
            resp.raise_for_status()
        except Exception as exc:  # network / 5xx — record and continue
            errors.append({"url": url, "error": str(exc)})
            continue
        fetched += 1

        if urlparse(url).path.lower().endswith("loadfile.aspx"):
            fid = re.search(r"file_id=(\d+)", url).group(1)
            name = resp.headers.get("Content-Disposition", "")
            m = re.search(r'filename="?([^";]+)"?', name)
            ext = Path(m.group(1)).suffix if m else ".bin"
            dest = dl_dir / f"file_id_{fid}{ext}"
            dest.write_bytes(resp.content)
            downloads.append(
                {
                    "file_id": int(fid),
                    "url": url,
                    "path": str(dest.relative_to(root)).replace("\\", "/"),
                    "bytes": len(resp.content),
                    "sha256": sha256_bytes(resp.content),
                }
            )
        else:
            # Verified 26-11-2026: <meta> says windows-1251, but the bytes are
            # UTF-8. Trusting the declaration mojibakes every Cyrillic title.
            doc = lxml_html.fromstring(
                resp.content.decode("utf-8", errors="replace")
            )
            crumbs = doc.xpath('//div[@id="kroshki"]')
            crumb_text = "".join(crumbs[0].itertext()) if crumbs else ""
            if args.files_only:
                # Do not rewrite the 40M-char text harvest on a download pass.
                for href in doc.xpath("//a[@href]/@href"):
                    candidate = urljoin(resp.url, href)
                    if urlparse(candidate).path.lower().endswith("loadfile.aspx"):
                        if norm(candidate) not in seen:
                            queue.append(candidate)
                continue
            if url != args.seed and SECTION_MARK not in crumb_text:
                continue  # wandered out of the ГРАММАТИКА section

            title_nodes = doc.xpath('//h1[contains(@class,"partname")]')
            title = " ".join(title_nodes[0].itertext()).strip() if title_nodes else ""
            body_nodes = doc.xpath('//div[contains(@class,"PlainText")]')
            parts = ["".join(n.itertext()) for n in body_nodes]
            text = "\n".join(p.replace("\xa0", " ").strip() for p in parts if p.strip())
            q = parse_qs(urlparse(url).query)
            stem = "p" + q.get("p", ["0"])[0] + "_a" + q.get("0a0", ["0"])[0]
            dest = text_dir / (stem + ".txt")
            payload = text.encode("utf-8")
            dest.write_bytes(payload)
            rows.append(
                {
                    "url": url,
                    "title": title,
                    "path": str(dest.relative_to(root)).replace("\\", "/"),
                    "chars": len(text),
                    "sha256": sha256_bytes(payload),
                }
            )

            for href in doc.xpath("//a[@href]/@href"):
                candidate = urljoin(resp.url, href)
                if is_harvestable(candidate) and norm(candidate) not in seen:
                    queue.append(candidate)

        if args.delay:
            time.sleep(args.delay)

    now = datetime.now(timezone.utc).isoformat(timespec="seconds")
    if args.files_only and (root / "manifest.json").exists():
        # Preserve the text harvest; refresh only the download provenance.
        manifest = json.loads((root / "manifest.json").read_text(encoding="utf-8"))
        manifest["retrieved_utc"] = now
        manifest["files"] = len(downloads)
        manifest["file_bytes"] = sum(d["bytes"] for d in downloads)
        manifest["downloads"] = sorted(downloads, key=lambda d: d["file_id"])
        manifest["errors"] += len(errors)
        manifest["error_index"] += errors
    else:
        manifest = {
        "source": "slovari.ru / ГРАММАТИКА",
        "seed": SEED,
        "retrieved_utc": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "encoding": "utf-8 (site meta declares windows-1251; declaration is wrong)",
        "selector": "div.PlainText",
        "pages": len(rows),
        "page_chars": sum(r["chars"] for r in rows),
        "files": len(downloads),
        "file_bytes": sum(d["bytes"] for d in downloads),
        "errors": len(errors),
        "page_index": sorted(rows, key=lambda r: r["url"]),
        "downloads": sorted(downloads, key=lambda d: d["file_id"]),
        "error_index": errors,
        "rights": "Copyright-held source texts. raw/ and derived/ are gitignored; "
        "only this provenance manifest is committed. Do not publish the text.",
    }
    (root / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    if not args.files_only:
        with (root / "derived" / "pages.jsonl").open("w", encoding="utf-8") as fh:
            for r in manifest["page_index"]:
                fh.write(json.dumps(r, ensure_ascii=False) + "\n")

    print(
        f"pages={manifest['pages']} chars={manifest['page_chars']} "
        f"files={manifest['files']} bytes={manifest['file_bytes']} errors={manifest['errors']}"
    )
    return 0 if manifest["errors"] == 0 else 2


if __name__ == "__main__":
    sys.exit(main())
