"""Repair Unicode artefacts in the harvested text; keep manifest hashes honest.

Evidence (26-11/27-11-2026):
  * 34,434 U+0096 in derived/text are cp1252 EN DASH (0x96) decoded as C1.
  * 693 U+0007 in derived/doc are the same dash glyph in the phoneme table:
    the HTML harvest of that table uses an en dash between |з| and |з'|.
  * 9 U+FFFD in derived/doc are a truncated final letter; the original HTML
    pages give СССР / АББРЕВИАТУРЫ / ОБЗОР / ПАР.
Other C1 code points (0x82, 0x8f, 0x9a, 0x9f) are rare and ambiguous — left as-is.
"""

from __future__ import annotations

import collections
import hashlib
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent
m_path = ROOT / "manifest.json"
m = json.loads(m_path.read_text(encoding="utf-8"))

stats = collections.Counter()

# --- HTML harvest pages (hashes in manifest) ---
for row in m["page_index"]:
    p = ROOT / row["path"]
    text = p.read_text(encoding="utf-8")
    n = text.count("\u0096")
    if n:
        text = text.replace("\u0096", "\u2013")
        p.write_text(text, encoding="utf-8")
        stats["text_endash"] += n
    payload = text.encode("utf-8")
    row["chars"] = len(text)
    row["sha256"] = hashlib.sha256(payload).hexdigest()
m["page_chars"] = sum(r["chars"] for r in m["page_index"])

# --- DOC conversion output ---
fixes = [
    (r"ССС\ufffd", "СССР"),
    (r"АББРЕВИАТУР\ufffd", "АББРЕВИАТУРЫ"),
    (r"АББРЕВИАТУ\ufffd", "АББРЕВИАТУР"),
    (r"ОБЗО\ufffd", "ОБЗОР"),
    (r"ВИДОВЫХ ПА\ufffd", "ВИДОВЫХ ПАР"),
]
for p in sorted((ROOT / "derived" / "doc").glob("*.txt")):
    text = p.read_text(encoding="utf-8")
    for pattern, repl in fixes:
        text, n = re.subn(pattern, repl, text)
        stats["doc_replacement"] += n
    n = text.count("\x07")
    if n:
        text = text.replace("\x07", "\u2013")
        stats["doc_bel"] += n
    p.write_text(text, encoding="utf-8")

remaining = collections.Counter()
for d in ("derived/text", "derived/doc"):
    for p in (ROOT / d).glob("*.txt"):
        for ch in p.read_text(encoding="utf-8"):
            o = ord(ch)
            if 0x80 <= o <= 0x9F or o == 0x07 or ch == "\ufffd":
                remaining[hex(o)] += 1

m["unicode_normalization"] = {
    "date": "2026-11-27",
    "text_u0096_to_u2013": stats["text_endash"],
    "doc_replacement_fixed": stats["doc_replacement"],
    "doc_bel_to_u2013": stats["doc_bel"],
    "remaining_ambiguous_c1": dict(remaining),
    "note": "Web fonts are typography only; encoding is fully Unicode.",
}
m_path.write_text(json.dumps(m, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
with (ROOT / "derived" / "pages.jsonl").open("w", encoding="utf-8") as fh:
    for row in m["page_index"]:
        fh.write(json.dumps(row, ensure_ascii=False) + "\n")
print(dict(stats), "remaining:", dict(remaining))
