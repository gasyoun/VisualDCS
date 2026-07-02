# M9 — research-archive datasets → `archive.sqlite` (validation report)

_Created: 02-07-2026 · Last updated: 02-07-2026_

Ingests the reuse-priority `derived-data/` + `non-derived/` research datasets into a
queryable SQLite sidecar, `archive.sqlite`, alongside the M1–M8
[`dcs_full.sqlite`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md)
stack. Built by
[`import_archive.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_archive.py)
(one subcommand per dataset). Both DBs are gitignored.

**Two output DBs (packaging decision):**
- **`archive.sqlite`** (≈167 MB) — the compact primary asset: full-text parallels (with verse
  text) + crosswalk + period/text/core frequencies + subhāṣita. **Published as GitHub Release
  asset `archive-2026-07`** (gzipped), same pattern as `dcs_full.sqlite`. This is what the four
  bridges download.
- **`archive_stopword.sqlite`** (≈11 GB) — the ~40.5M-row stop-word run in its own DB. It is
  20–30× everything else and **fully regenerable** from the committed `Stopovye/` CSVs
  (`python import_archive.py stopword`), so it is **not shipped** — regenerate locally when a
  consumer needs it. Keeping it out of the primary asset is what makes the everyday download
  practical.

**Model provenance:** authored + run under **Opus 4.8 (`claude-opus-4-8`)**, 2026-07-02.

**Reproduce:**
```sh
cd src/DCS-data-2026
python import_archive.py parallels     # D1 full-text (canonical)
python import_archive.py stopword      # D2 stop-word (partial; reassembles 11 7z-split CSVs)
python import_archive.py freq          # D3 period/text frequencies + core vocab
python import_archive.py subhashita    # D4 subhāṣita
python import_archive.py validate      # this report's numbers
# or: python import_archive.py all
```

## Schema

**`archive.sqlite`** (primary):

| Table | Rows | What |
|---|---|---|
| `parallels` | 154,304 | full-text source-verse↔parallel matches (with verse text); `method='fulltext'` |
| `parallel_text` | 146 | crosswalk: project-internal text id ↔ abbrev/fullname ↔ `dcs_full.text` |
| `text_names` | 128 | **authoritative** id→name list from Приложение 2 headers |
| `period_freq` | 634,802 | lemma × period × rank × count (QL/FRQ_P + Приложение 3/4) |
| `text_freq` | 285,875 | lemma × text × rank × count (Приложение 2, per-text frequency dictionary) |
| `core_vocab` | 27,045 | core-vocabulary lists by period + combined core with coverage% (Приложение 5/10 + Сборное ядро) |
| `subhashita` | 7,537 | Böhtlingk *Indische Sprüche*: Devanāgarī + IAST + German + source attribution |
| `subhashita_ramayana` | 8,941 | subhāṣita↔Rāmāyaṇa alignment with Russian translation |

**`archive_stopword.sqlite`** (regenerable, not shipped): `parallels` 40,573,260 stop-word
matches (`method='stopword'`, no verse text) + copies of `text_names` + `parallel_text`.

## D1 — parallels, full-text method (canonical, `Polnorazmernye/`)

- **245 files, 501,231 source verses, 154,304 parallel matches** — GOOD 14,702 / PARTLY 139,602.
- CSV grammar (richer than the one-line doc): each row is
  `source_ref ; source_pada ; source_verse` then repeating 4-tuples
  `parallel_ref ; parallel_verse ; quality(GOOD|PARTLY) ; matched_words`. Parsed with a
  **quality-anchored** reader (GOOD/PARTLY are exact anchors), so the 271 malformed rows
  (0.05%, a stray `;` or missing pada) are **recovered with zero silent loss**
  (`recovered=1` flag; 1,259 parallels recovered).
- **Text-id crosswalk:** the filename prefix is a **project-internal** id (Acintyastava=10,
  Divyāvadāna=104, MBh=187) — *not* the DCS `text_id` (415/473/154). Resolved id→name from
  each file's constant first-field abbreviation, fullname from target refs
  (`<Fullname> <Abbrev>, …`, abbrev = the source's own field0), then linked to `dcs_full.text`
  exact→diacritic-insensitive (`sanskrit_util.norm`). **140/146 texts (95.9%) linked to
  `dcs_full`;** `target_text_id` resolved for **94.0%** of rows. The 6 unlinked are
  malformed source abbreviations in the raw export (`Atharvaveda Śaunaka)`, `Cakra ?) on Suśr`).
- **Cross-validated** against the authoritative Приложение 2 id-list: the two agree (see validate output).
- Spot check: MBh (187) → Rāmāyaṇa parallels present and correctly typed.

## D2 — parallels, stop-word method (partial, `Stopovye/` → `archive_stopword.sqlite`)

- 113 texts (102 in-place CSVs + **11 oversize CSVs reassembled from 7-Zip split volumes**
  into a temp dir at run time — raws never committed; see
  [RESTORE_SPLIT_FILES.md](https://github.com/gasyoun/VisualDCS/blob/main/RESTORE_SPLIT_FILES.md)).
- **40,573,260 matches** (197,422 source verses; 264× the full-text run — the stop-word method
  is far noisier). 1,572 rows recovered via the quality-anchored parser, 36 unrecoverable rows
  skipped and **counted** (no silent loss). Filter `quality='GOOD'` for the high-precision subset.
- Rows store **structured columns only** (source/target ids, refs, quality, matched_words) —
  **no verse text** (`store_text=False`) — and land in the separate **`archive_stopword.sqlite`**
  (regenerable, not shipped; see packaging note at top).
- `method='stopword'`, `run='2022-partial'`. Loaded with periodic commit + WAL checkpoint every
  500k rows (a single final commit ballooned the WAL to 5 GB — fixed).
- ⚠️ The full 245-text stop-word run (`PARA/VSE/PART/`, 11.7GB) was **deliberately deleted
  by M.G.** (02-07-2026) and is out of scope — only this partial run survives.

## D3 — period / text frequency dictionaries + core vocabulary

- `period_freq`: **QL/FRQ_P** (279,168 rows, 10 DCS-coded periods) + **Приложение 4**
  (290,115, 11 Russian-labelled periods) + **Приложение 3** (65,519, whole-corpus with
  part-of-speech grammar, `period='ALL-corpus'`). **Periods are stored as their raw column
  labels** (both the DCS codes `9 Vedic`/`11 Epic`/`12 Classic`/`1 -800`… and Leonchenko's
  Russian `Леммы Ведийского периода`…) — no lossy re-binning; the two schemes are kept
  distinct by `source`.
- `text_freq`: **Приложение 2** (285,875 rows) — per-text frequency dictionary; its column
  headers `<id> "<Name>"` are the authoritative id→name list, also materialised as `text_names`.
- `core_vocab`: **Приложение 5** (19,073, cores by period) + **Приложение 10** (440, stable
  core across all history) + **Сборное ядро** (7,532, combined core with `coverage_pct`).
- **Lemma normalization:** every `lemma_raw` (IAST) → `lemma_slp1` via `sanskrit-util`
  (`to_slp1`); **100% coverage** on all frequency tables (kṛ→kf, bhū→BU, vac→vac). Original
  spelling preserved in `lemma_raw`.
- **Column-mapping judgment calls** (Russian workbooks): the `(lemma, "WD FRQ")` paired-column
  layout was read generically; Приложение 4 lemmas carry single-quote wrappers (`'tad'`) which
  are stripped into `lemma_raw`; Приложение 3's middle column is a part-of-speech tag (→`grammar`).

## D4 — subhāṣita (Böhtlingk, *Indische Sprüche*)

- `subhashita`: 7,537 sayings from `Subhash_Bt.xlsx` sheet `Лист1` — `saying_id`, `page`,
  `text_sa_deva` (Devanāgarī), `text_sa_iast` (IAST, from the Btlnk sheet where present else
  `deva_to_iast`), `translation_de`, `source_attribution`, apparatus `notes`.
- **Honest field naming:** the workbook's translation is **German** (Böhtlingk), not Russian
  — stored as `translation_de`, *not* `translation_ru` as the handoff tentatively named it
  (per "don't invent fields"). There is **no meter column** in the source, so none was invented.
- `subhashita_ramayana`: 8,941 rows from sheet `Btlnk, Ram, Mh` — the subhāṣita↔Rāmāyaṇa
  alignment carrying `ram_rus` (Russian translation of the matched Rāmāyaṇa verse), the actual
  Sa/Ru signal in this dataset.

## Caveats / open judgment calls

- Filename number range (`104_1--20`) is the **source-side** book/section range, not a target
  id range as the one-line doc implied — a single source file matches many target texts.
- 6/146 parallel texts unlinked to `dcs_full` (malformed source abbreviations, listed above);
  they keep their project id + parsed name and are queryable, just not DCS-linked.
- Stop-word rows intentionally omit verse text (size); the full 245-text stop-word run is gone.

## Validation (`python import_archive.py validate`)

```
- parallels [fulltext/2026]: 154,304 matches | GOOD 14,702 / PARTLY 139,602 | target_id resolved 94.0% | recovered rows 1259
- crosswalk parallel_text: 146 texts | dcs_full-linked 140 (95.9%)
  - vs Приложение 2 authoritative id-list: 85 ids present, 83 names agree
- period_freq: 634,802 rows   | text_freq: 285,875 | core_vocab: 27,045 | text_names: 128
- subhashita: 7,537 | subhashita_ramayana: 8,941
- period_freq SLP1 coverage: QL/FRQ_P 100% · Прил3 100% · Прил4 100%
- [archive_stopword.sqlite] parallels [stopword/2022-partial]: 40,573,260 matches | GOOD/PARTLY split
```

The 2 name disagreements vs Приложение 2 are the malformed-abbrev texts (`Atharvaveda Śaunaka)` etc.).

## Definition of done

- `archive.sqlite` builds reproducibly from one command per dataset. ✅
- Validation numbers above (from `python import_archive.py validate`). ✅ ALL PASS with documented caveats.
- `archive.sqlite` (167 MB) published as Release asset `archive-2026-07`; stop-word DB regenerable. ✅

_Dr. Mārcis Gasūns_
