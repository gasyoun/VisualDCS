# Grammatika — slovari.ru Russian grammar harvest

_Created: 26-11-2026 · rights ruling: 26-11-2026_

Harvest of the Russian-language grammar reference section at
<https://slovari.ru/default.aspx?s=0&p=165>. It sits under `non-derived/Slovari/`
because it is non-DCS reference material, alongside the existing Russian
dictionary data (Frish, Slozhnye-slova-v-DCS, Tihvinsky).

## Rights

The source works are academic books published by Nauka (Shvedova 1980,
Vinogradov, and the companion volumes). **Publication in this repository was
authorized by the repo owner on 26-11-2026 on the basis of publisher rights.**
The original text, the RAR/DOC sources and the fonts are therefore tracked
here, not held locally only. No licence document was attached to the ruling in
this session — if one exists, it should be added to this folder.

This reverses the initial local-only fence; that earlier decision is kept in
PR #189 history for audit, not re-applied.

## What is on the source site

The section index `p=165` lists seven works:

| p | Work |
|---:|---|
| 167 | Русская грамматика (Shvedova, 1980) |
| 168 | Краткая русская грамматика |
| 169 | В.В. Виноградов «История слов» |
| 170 | В.В. Виноградов «Русский язык» |
| 171 | Библиографический указатель литературы по языкознанию |
| 172 | Библиографический указатель литературы по русскому языкознанию |
| 173 | Русская авторская лексикография XIX–XX веков. Антология |

`p=167` additionally offers the full two-volume grammar as DOC files in RAR
archives on `p=2572`: `LoadFile.aspx?file_id=222` (vol. I), `224` (vol. II),
`223` (fonts). Chapter pages are `default.aspx?s=0&p=5315&0a0=NNNN`; the body
lives in `div.PlainText`, the heading in `h1.partname`.

**Encoding trap:** every page declares `<meta http-equiv="Content-Type"
content="text/html; charset=windows-1251">`, but the bytes actually served are
**UTF-8**. Decoding by the declaration mojibakes all Cyrillic and fails on
byte `0x98`. The spider decodes UTF-8 explicitly. Verified 26-11-2026.

## Files

- `slovari_spider.py` — crawler (`requests` + `lxml`, already in the estate env;
  no Scrapy install needed). Seeds at `p=165`, follows only same-host links
  carrying `p=`, `0a0=` or `file_id=`, and stays in the grammar subtree by
  requiring `ГРАММАТИКА` in the breadcrumb `#kroshki`. Output filenames carry a
  short hash of the normalized URL so query variants cannot overwrite each other.
- `manifest.json` — provenance: retrieval time, page count, character count,
  download count/bytes, and SHA-256 per page/file.
- `derived/pages.jsonl` + `derived/text/*.txt` — **1,790** chapter texts.
- `derived/doc/*.txt` — 21 converted DOC files (both volumes).
- `raw/downloads/*.rar`, `raw/doc/`, `raw/fonts/` — source archives, DOCs, fonts.
- `convert_doc.py` — antiword-based DOC → text converter with replacement-char audit.
- `repair_paths.py` — one-off historical fix for the first run's 451 colliding
  filenames (888 renamed, 902 re-fetched on 26-11-2026); kept for audit, not
  needed on a fresh harvest.
- `toc.json` + `fetch_toc.py` + `build_html.py` — the browsable HTML edition
  (see below).

## Browsable HTML edition

Open [`html/index.html`](html/index.html) directly in a browser — no server,
no build step. It lists all seven works; each work has its own `index.html`
(the table of contents), one `section_*.html` per volume/issue, and one page
per chapter with breadcrumb navigation and prev/next links. The 21 DOC texts
of «Русская грамматика» also have their own pages, linked from that work's
index together with the source RAR archives.

| Work | HTML pages |
|---|---:|
| Русская грамматика (2 volumes) | 151 chapters + 21 DOC texts |
| Краткая русская грамматика | 18 |
| История слов | 834 |
| Русский язык | 27 |
| Библиографический указатель по языкознанию | 16 |
| Библиографический указатель по русскому языкознанию (8 issues) | 259 |
| Русская авторская лексикография | 26 |

Chapter titles come from the source site's own tables of contents (`toc.json`,
1,090 entries), not from the generic `h1` («тексты») of the harvest pages.

Regenerate the edition offline:

```bash
python fetch_toc.py   # only if toc.json is stale; needs network
python build_html.py  # offline, reads manifest.json + toc.json
```

`build_html.py` writes under `html/`; a link check over all generated pages
found **0 broken relative links** (9,480 checked).

## Regenerate

```bash
python slovari_spider.py --delay 0.3
```

The manifest is rewritten on each run; `retrieved_utc` and the hashes change
with the source. Binary downloads are a separate pass (a first-position
`file_id=` was initially missed by the URL filter — fixed; the filter now reads
parsed query keys):

```bash
python slovari_spider.py --files-only --seed "https://slovari.ru/default.aspx?s=0&p=2572" --delay 0.3
```

## Harvest results — 26-11-2026

| Measure | Value |
|---|---|
| Grammar-section pages | **1,790** files / 40,766,363 chars |
| Crawl errors | **0** (one `p=5332` read timeout recovered on retry) |
| RAR downloads | **3** (5,252,834 bytes) — `file_id` 222 / 223 / 224 |
| DOC files extracted | **21** (both volumes) |
| DOC → text | **7,432,338 chars**, 9 replacement characters |

The 9 replacement chars are glyph-level gaps in antiword's UTF-8 mapping, not
a wholesale font-cmap failure: the Cyrillic body text is readable throughout.
The fonts are custom (`file_id=223` ships them), so a future converter change
must be checked against the 9-replacement-char baseline before it is trusted.

## DOC → text conversion

1. Extract the downloaded RARs with WinRAR:
   `"/c/Program Files/WinRAR/UnRAR.exe" x -y -o+ raw/downloads/file_id_222.rar raw/doc/`
   (same for `224`; `223` is fonts).
2. Convert the old binary `.doc` files with `antiword`:
   `antiword -m UTF-8.txt raw/doc/<file>.doc > derived/doc/<stem>.txt`
   (`pandoc` handles `.docx`, not the legacy `.doc` format).
3. `python convert_doc.py` runs all 21 files and reports the replacement-char
   count per file.

## Attribution

Академия наук СССР, Институт русского языка. *Русская грамматика.* М.: Наука,
1980 (главный редактор Н. Ю. Шведова). Companion volumes and bibliographies as
listed in the table above. Source: slovari.ru, ГРАММАТИКА, retrieved 26-11-2026.
