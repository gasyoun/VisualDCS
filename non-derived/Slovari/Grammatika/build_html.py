"""Build a browsable static HTML edition of the slovari.ru grammar harvest.

Offline: reads manifest.json (page inventory + SHA-256) and toc.json (section
tables of contents fetched by fetch_toc.py). Writes html/index.html plus one
index, one section page and one page per chapter for each of the seven works.
The converted DOC texts of "Русская грамматика" get their own pages too.

No network, no dependencies beyond the standard library.
"""

from __future__ import annotations

import html as H
import json
import pathlib
import re
from urllib.parse import parse_qs, urlparse

ROOT = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "html"

WORKS = [
    {
        "p": "167", "title": "Русская грамматика (Шведова, 1980)",
        "sections": [("5313", "Том 1"), ("5314", "Том 2")],
        "content": {"5313", "5314", "5315", "2572"},
    },
    {
        "p": "168", "title": "Краткая русская грамматика",
        "sections": [("5304", "Краткая русская грамматика")],
        "content": {"5304", "5312"},
    },
    {
        "p": "169", "title": 'В.В. Виноградов — «История слов»',
        "sections": [("3071", "История слов")],
        "content": {"3071", "5311"},
    },
    {
        "p": "170", "title": 'В.В. Виноградов — «Русский язык»',
        "sections": [("5306", "Русский язык")],
        "content": {"5306", "5310"},
    },
    {
        "p": "171", "title": "Библиографический указатель литературы по языкознанию",
        "sections": [("5317", "Выпуск I")],
        "content": {"5317", "5318"},
    },
    {
        "p": "172", "title": "Библиографический указатель литературы по русскому языкознанию",
        "sections": [
            ("5319", "Выпуск I"), ("5321", "Выпуск II"), ("5323", "Выпуск III"),
            ("5325", "Выпуск IV"), ("5327", "Выпуск V"), ("5330", "Выпуск VI"),
            ("5332", "Выпуск VII"), ("5334", "Выпуск VIII"),
        ],
        "content": {
            "5319", "5320", "5321", "5322", "5323", "5324", "5325", "5326",
            "5327", "5330", "5331", "5332", "5333", "5334", "5335", "5336",
        },
    },
    {
        "p": "173", "title": "Русская авторская лексикография XIX–XX веков. Антология",
        "sections": [("5309", "Антология")],
        "content": {"5309", "5316"},
    },
]

CSS = """
@font-face{font-family:'Grammatica';src:url('__FONT_BASE__Gramn.woff2') format('woff2');font-display:swap}
/* TIMENRC4 (Times New Roman CyrAC) is NOT applied: its vowels carry a
   built-in acute (а→á, о→ó, е→é, и→í), which would stress every vowel.
   The file ships in html/fonts/ for deliberate phonetic use only. */
body{font:16px/1.6 Georgia,'Times New Roman',serif;color:#1b1b1b;background:#faf8f3;margin:0}
header{background:#2f3b47;color:#fff;padding:14px 24px}
header a{color:#ffd9a0}
main{max-width:960px;margin:0 auto;padding:24px}
nav.crumb{font:13px/1.4 Arial,sans-serif;color:#666;margin:12px 0 20px}
nav.crumb a{color:#365b8a}
h1{font-size:26px;border-bottom:2px solid #c9b38c;padding-bottom:10px}
h2{font-size:19px;margin-top:28px}
a{color:#2a5a8c}
ol.toc{line-height:1.9}
pre.body{white-space:pre-wrap;word-wrap:break-word;background:#fff;border:1px solid #ddd8cc;
  padding:18px;border-radius:4px;font:15px/1.5 Georgia,'Times New Roman',serif}
pre.docbody{font-family:'Grammatica',Georgia,serif}
.pager{display:flex;justify-content:space-between;margin-top:24px;font:14px Arial,sans-serif}
.meta{font:13px Arial,sans-serif;color:#777}
table{border-collapse:collapse;width:100%}
td,th{border:1px solid #ddd8cc;padding:6px 10px;text-align:left}
.source{font:12px Arial,sans-serif;color:#888;margin-top:30px}
"""

m = json.loads((ROOT / "manifest.json").read_text(encoding="utf-8"))
toc = json.loads((ROOT / "toc.json").read_text(encoding="utf-8"))


def page(title: str, crumb: str, body: str, up: str = "../index.html") -> str:
    return (
        "<!doctype html>\n<html lang=\"ru\"><head><meta charset=\"utf-8\">"
        "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
        f"<title>{H.escape(title)} — Русская грамматика / slovari.ru</title>"
        f"<style>{CSS.replace('__FONT_BASE__', 'fonts/' if up == 'index.html' else '../fonts/')}</style></head><body>"
        f"<header><a href=\"index.html\">ГРАММАТИКА.ру</a> · "
        f"<a href=\"{up}\">Все произведения</a></header><main>"
        f"<nav class=\"crumb\">{crumb}</nav><h1>{H.escape(title)}</h1>{body}"
        "<p class=\"source\">Источник: slovari.ru, раздел ГРАММАТИКА. "
        "Оцифровка: Академия наук СССР, Институт русского языка, М.: Наука, 1980.</p>"
        "</main></body></html>\n"
    )


def slug(p: str, a0: str, path: str) -> str:
    return pathlib.Path(path).stem


def a0num(a0: str) -> int:
    mm = re.match(r"\d+", a0)
    return int(mm.group()) if mm else 10**9


# One row per (p, 0a0) — keep the longest variant of duplicate query URLs.
by_key: dict[tuple[str, str], dict] = {}
for row in m["page_index"]:
    q = parse_qs(urlparse(row["url"]).query)
    key = (q.get("p", ["0"])[0], q.get("0a0", ["0"])[0])
    if key not in by_key or row["chars"] > by_key[key]["chars"]:
        by_key[key] = row

labels: dict[tuple[str, str], str] = {}
for entries in toc.values():
    for e in entries:
        labels[(e["p"], e["0a0"])] = e["text"]

OUT.mkdir(exist_ok=True)
master = []
work_stats = []

for work in WORKS:
    wdir = OUT / ("p" + work["p"])
    wdir.mkdir(exist_ok=True)
    sections = work["sections"]
    sec_ids = [pid for pid, _ in sections]
    assigned: dict[str, list[dict]] = {pid: [] for pid in sec_ids}

    for (p, a0), row in by_key.items():
        if p == work["p"] and a0 == "0":
            continue  # work landing page, rendered as the work index intro
        # Only this work's own content pages — TOC labels are global, so a
        # label match alone must never pull another work's chapter in.
        if p not in work["content"]:
            continue
        sec = None
        for pid in sec_ids:
            if any(e["p"] == p and e["0a0"] == a0 for e in toc.get(pid, [])):
                sec = pid
                break
        if sec is None:
            sec = p if p in sec_ids else sec_ids[0]
        title = labels.get((p, a0)) or (
            row["title"] if row["title"] and row["title"] != "тексты" else f"§ {a0}"
        )
        assigned[sec].append(
            {
                "p": p, "a0": a0, "row": row, "title": title,
                "file": slug(p, a0, row["path"]) + ".html",
            }
        )

    ordered: dict[str, list[dict]] = {}
    for pid in sec_ids:
        items = []
        seen = set()
        for e in toc.get(pid, []):
            key = (e["p"], e["0a0"])
            if key in seen:
                continue
            found = next(
                (c for c in assigned[pid] if c["p"] == e["p"] and c["a0"] == e["0a0"]), None
            )
            if found:
                seen.add(key)
                items.append(found)
        rest = sorted(
            (c for c in assigned[pid] if (c["p"], c["a0"]) not in seen),
            key=lambda c: (a0num(c["a0"]), c["p"]),
        )
        ordered[pid] = items + rest

    # Chapter pages + per-section TOCs.
    chapter_files: list[str] = []
    for pid, sec_title in sections:
        chapters = ordered[pid]
        rows_html = []
        for i, c in enumerate(chapters):
            text = pathlib.Path(ROOT / c["row"]["path"]).read_text(encoding="utf-8")
            prev_link = (
                f'<a href="{chapters[i-1]["file"]}">← {H.escape(chapters[i-1]["title"][:60])}</a>'
                if i else "<span></span>"
            )
            next_link = (
                f'<a href="{chapters[i+1]["file"]}">{H.escape(chapters[i+1]["title"][:60])} →</a>'
                if i + 1 < len(chapters) else "<span></span>"
            )
            crumb = (
                f'<a href="index.html">{H.escape(work["title"])}</a> / '
                f'<a href="section_{pid}.html">{H.escape(sec_title)}</a> / {H.escape(c["title"][:70])}'
            )
            body = (
                f'<p class="meta">Раздел {H.escape(c["a0"])} · '
                f'<a href="{c["row"]["url"]}">оригинал на сайте</a> · '
                f'{c["row"]["chars"]:,} знаков · SHA-256 {c["row"]["sha256"][:16]}…</p>'
                f'<pre class="body">{H.escape(text)}</pre>'
                f'<div class="pager">{prev_link}{next_link}</div>'
            )
            (wdir / c["file"]).write_text(
                page(c["title"], crumb, body), encoding="utf-8"
            )
            chapter_files.append(c["file"])
            rows_html.append(
                f'<li><a href="{c["file"]}">{H.escape(c["title"])}</a> '
                f'<span class="meta">({c["row"]["chars"]:,} знаков)</span></li>'
            )
        sec_body = (
            f'<p class="meta">{len(chapters)} разделов · '
            f'<a href="index.html">вернуться к содержанию произведения</a></p>'
            f'<ol class="toc">{"".join(rows_html)}</ol>'
        )
        (wdir / f"section_{pid}.html").write_text(
            page(sec_title, f'<a href="index.html">{H.escape(work["title"])}</a> / {H.escape(sec_title)}', sec_body),
            encoding="utf-8",
        )

    # Work index.
    intro_row = by_key.get((work["p"], "0"))
    intro = ""
    if intro_row:
        txt = pathlib.Path(ROOT / intro_row["path"]).read_text(encoding="utf-8")
        intro = f'<p class="meta">{H.escape(txt[:700])}</p>' if txt.strip() else ""
    links = "".join(
        f'<li><a href="section_{pid}.html">{H.escape(title)}</a> '
        f'<span class="meta">({len(ordered[pid])} разделов)</span></li>'
        for pid, title in sections
    )
    extra = ""
    if work["p"] == "167":
        docs = sorted((ROOT / "derived" / "doc").glob("*.txt"))
        doc_links = "".join(
            f'<li><a href="doc_{p.stem}.html">{H.escape(p.stem)}</a></li>' for p in docs
        )
        for p in docs:
            txt = p.read_text(encoding="utf-8")
            (wdir / f"doc_{p.stem}.html").write_text(
                page(
                    p.stem,
                    f'<a href="index.html">{H.escape(work["title"])}</a> / Полный текст DOC / {H.escape(p.stem)}',
                    f'<pre class="body docbody">{H.escape(txt)}</pre>',
                ),
                encoding="utf-8",
            )
        extra = (
            f'<h2>Полный текст двухтомника (DOC)</h2><ol class="toc">{doc_links}</ol>'
            '<p class="meta">Архивы: '
            '<a href="../../raw/downloads/file_id_222.rar">том I</a>, '
            '<a href="../../raw/downloads/file_id_224.rar">том II</a>, '
            '<a href="../../raw/downloads/file_id_223.rar">шрифты</a>.</p>'
        )
    (wdir / "index.html").write_text(
        page(
            work["title"],
            '<a href="../index.html">ГРАММАТИКА</a> / ' + H.escape(work["title"]),
            f'{intro}<h2>Содержание</h2><ol class="toc">{links}</ol>{extra}',
        ),
        encoding="utf-8",
    )
    work_stats.append((work, len(chapter_files)))
    master.append(
        f'<li><a href="p{work["p"]}/index.html">{H.escape(work["title"])}</a> '
        f'<span class="meta">— {len(chapter_files)} страниц</span></li>'
    )
    print(f'p{work["p"]}: {len(chapter_files)} chapter pages, {len(sections)} sections')

(OUT / "index.html").write_text(
    page(
        "ГРАММАТИКА — русские грамматики slovari.ru",
        "ГРАММАТИКА",
        f'<p>Семь произведений из раздела «Грамматика» сайта slovari.ru. '
        f'Все страницы работают локально, без сервера и сети.</p>'
        f'<ol class="toc">{"".join(master)}</ol>'
        f'<p class="meta">Собрано {m["pages"]:,} страниц источника; '
        f'в HTML-издании {sum(n for _, n in work_stats):,} страниц. '
        f'<a href="../README.md">О правах и происхождении</a></p>',
        up="index.html",
    ),
    encoding="utf-8",
)
print(f"html/index.html: {len(WORKS)} works")
