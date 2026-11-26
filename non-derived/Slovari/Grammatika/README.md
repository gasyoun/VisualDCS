# Grammatika — slovari.ru Russian grammar harvest

_Created: 26-11-2026_

Local-only harvest of the Russian-language grammar reference section at
<https://slovari.ru/default.aspx?s=0&p=165>. It sits under `non-derived/Slovari/`
because it is non-DCS reference material, alongside the existing Russian
dictionary data (Frish, Slozhnye-slova-v-DCS, Tihvinsky).

## Rights fence — read first

The source works are **copyright-held** academic books (Shvedova 1980,
Vinogradov, and the companion volumes). Therefore:

- `raw/` (downloaded RAR/DOC/TTF) and `derived/` (extracted page text) are
  **gitignored** and stay on this machine only.
- **Only tooling, the manifest, counts and SHA-256 hashes are committed.**
- Do not publish the text, do not enable Pages on it, do not send it to an
  external AI service. This follows the estate's `license-gated-ingest` /
  `publish-safety-check` discipline.

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
  requiring `ГРАММАТИКА` in the breadcrumb `#kroshki`.
- `manifest.json` — committed provenance: retrieval time, page count, character
  count, download count/bytes, and SHA-256 per page/file. No text.
- `derived/pages.jsonl` + `derived/text/*.txt` — local-only harvest output.
- `raw/downloads/*` — local-only binary downloads.
- `.gitignore` — the rights fence.

## Regenerate

```bash
python slovari_spider.py --delay 0.3
```

The manifest is rewritten on each run; `retrieved_utc` and the hashes change
with the source. Re-run `git status` before committing: only `manifest.json`
and the tooling should be staged.

Binary downloads are a separate pass (a first-position `file_id=` was initially
missed by the URL filter — fixed; the filter now reads parsed query keys):

```bash
python slovari_spider.py --files-only --seed "https://slovari.ru/default.aspx?s=0&p=2572" --delay 0.3
```

## Harvest results — 26-11-2026

| Measure | Value |
|---|---|
| Grammar-section pages | **1,790** (40,766,363 chars) |
| Crawl errors | **0** (one `p=5332` read timeout recovered on retry) |
| RAR downloads | **3** (5,252,834 bytes) — `file_id` 222 / 223 / 224 |
| DOC files extracted | **21** (both volumes) |
| DOC → text | **7,432,338 chars**, 9 replacement characters |

The 9 replacement chars are glyph-level gaps in antiword's UTF-8 mapping, not
a wholesale font-cmap failure: the Cyrillic body text is readable throughout.
All text remains under `derived/` and `raw/` (gitignored).

## DOC → Markdown conversion (local only)

1. Extract the downloaded RARs with WinRAR:
   `"/c/Program Files/WinRAR/WinRAR.exe" x -ibck -y raw/downloads/file_id_222.rar raw/doc/`
   (same for `224`; `223` is fonts).
2. Convert the old binary `.doc` files with `antiword`:
   `antiword -m UTF-8.txt raw/doc/<file>.doc > derived/doc/<stem>.txt`
   (`pandoc` handles `.docx`, not the legacy `.doc` format).
3. `python convert_doc.py` runs all 21 files and reports the replacement-char
   count per file. Keep every conversion product under `derived/`, never in git.

The fonts are custom (`file_id=223` ships them), so a future converter change
must be checked against the 9-replacement-char baseline before it is trusted.
