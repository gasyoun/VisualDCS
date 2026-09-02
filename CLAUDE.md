# CLAUDE.md

_Created: 15-05-2026 · Last updated: 02-09-2026_

**VisualDCS** is standalone HTML frequency dashboards for the
[Digital Corpus of Sanskrit (DCS)](http://www.sanskrit-linguistics.org/dcs/).
No build step, no server — open the `.html` in a browser. Org spine still
applies; this file is only repo-local always-on. Do **not** read it end-to-end.

## Danger — database paths

**The corpus master is**
[`src/DCS-data-2026/dcs_full.sqlite`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026)
— ~921 MB, gitignored, regenerable from the pinned CoNLL-U submodule, CC BY 4.0.
Open read-only and streaming; never load it with an editor/Read tool:

`sqlite3.connect("file:.../DCS-data-2026/dcs_full.sqlite?mode=ro", uri=True)`

`src/dcs_full.sqlite` is a **0-byte decoy** (H848). If that path exists, ignore
it. Do **not** open it as the database, do **not** treat empty results as an
empty corpus, do **not** copy the 920 MB file into git to "fix" it.
[`.gitignore`](https://github.com/gasyoun/VisualDCS/blob/main/.gitignore)
already lists `/src/dcs_full.sqlite`.

Also not the master:
[`src/DCS-data-2026/dcs.sqlite`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026)
(31 MB pilot) and
[`archive.sqlite`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026)
(M9 research vintage).

Do **not** rebuild the frequency tables or re-import the DB unless a named
handoff says so. Consume
[`dcs_lemma_summary.json`](https://github.com/gasyoun/VisualDCS/blob/main/dcs_lemma_summary.json)
and the published `visual/*.json`. Schema + gotchas:
[docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md).

## IAST lemmas (no scheme table here)

DCS `lemma.lemma` is **IAST**. The published
[`dcs_lemma_summary.json`](https://github.com/gasyoun/VisualDCS/blob/main/dcs_lemma_summary.json)
is **SLP1-keyed**. Kosha keys are SLP1. Check the scheme before joining.
Transliteration table:
[SANSKRIT_CONTEXT_PRIMER.md](https://github.com/gasyoun/github-spine/blob/main/SANSKRIT_CONTEXT_PRIMER.md)
— do not copy it into this file.

## Gītā is in DCS (the "absent" line is stale)

The primer / DANGER_FACTS line "Bhagavadgītā (MBh 6.23–40) is ABSENT from DCS"
is **wrong** (H848; refuted H1407). The 18 adhyāyas sit inside Mahābhārata book 6
as `MBh, 6, BhaGī 1` … `BhaGī 18` (10,547 tokens). `text.name` LIKE `%gīt%` only
hits Gītagovinda / Aṣṭāvakragīta. Match `chapter.ref`, never just `text.name`.

## Run the app / tests

- **App:** open
  [`sanskrit_index.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_index.html)
  (landing). Inventory of dashboards and JSON:
  [README.md](https://github.com/gasyoun/VisualDCS/blob/main/README.md).
- **JS:** `node tests/test_concordance.js` ·
  `node tests/test_nominal_dashboard.js` ·
  `node tests/test_nominal_trainer.js` ·
  `node tests/test_morphostatistics.js` ·
  `node tests/test_passage_reader.js`
- **Python:** `python src/DCS-data-2026/test_paradigm_attested.py` ·
  `python src/DCS-data-2026/test_learner_contracts.py` ·
  `python src/DCS-data-2026/validate.py` ·
  `python src/DCS-data-2026/validate_past_tense_resplit.py` ·
  `python src/DCS-data-2026/test_past_nonindicative_formation.py` ·
  `python validate_dcs_lemma_summary.py`
- Session journal:
  [`.ai_state.md`](https://github.com/gasyoun/VisualDCS/blob/main/.ai_state.md).

## Sync rules (never weaken)

- Edit
  [`gen_paradigm_nominal.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal.py)
  or
  [`sanskrit_nominal_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html)
  → `python src/DCS-data-2026/gen_paradigm_nominal.py` (full run, real SHA-256 —
  never `--skip-checksum`) **and** `node tests/test_nominal_dashboard.js` in the
  same PR. Keep the denominator-closure assertion (NULL-safe complement; H1472
  lost 8,542 tokens otherwise).
- Edit `past_class()` / `AORIST_FORMATIONS` / `is_past_indicative` →
  `python src/DCS-data-2026/validate_past_tense_resplit.py`. Aorist is a
  **lower** bound, Perfect an **upper** bound — quoting either as exact is a
  defect (H1486).
- Edit
  [`audit_past_nonindicative_formation.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/audit_past_nonindicative_formation.py)
  or its fixture →
  `python src/DCS-data-2026/test_past_nonindicative_formation.py`. The fixture is
  real corpus sentences, regenerable by
  [`build_past_nonindicative_fixture.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/fixtures/build_past_nonindicative_fixture.py)
  — never hand-edit it. `Formation` is absent **upstream** on all 8,726
  non-indicative past tokens (H3878, G22); do not widen `is_past_indicative`
  to "recover" tags that do not exist.
- The Aorist/Perfect split in
  [`paradigm_attested.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_attested.json)
  is applied **per token** via `past_class()`, not via `ud_to_category`. Do not
  "fix" the merged Perfect/Aorist fallback. Regenerating requires E46
  reconciliation (6,454 match / 0 disagree).
- Do not weaken `assert_evidence_degenerate()`. `STEM_TAGS` is SanskritGrammar
  Sangram G2's list — change both sides or the G2 reconciliation fails.

## Where the rest lives

| Topic | File |
|---|---|
| Dashboards, JSON inventory, 2021 vs 2026 sources | [README.md](https://github.com/gasyoun/VisualDCS/blob/main/README.md) |
| Pareto methodology | [pareto.md](https://github.com/gasyoun/VisualDCS/blob/main/pareto.md) |
| Shipped vs pending | [roadmap.md](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md) · [CHANGELOG.md](https://github.com/gasyoun/VisualDCS/blob/main/CHANGELOG.md) |
| Schema, gotchas G1–G22, join recipes | [docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md) |

New dashboard: write JSON under `visual/`, add a standalone `.html`, update
README, commit both. JS is inline; Chart.js 4.4.1 from cdnjs; colors
`#3266ad` / `#e24b4a` / `#1d9e75`. UTF-8 JSON only.

_Dr. Mārcis Gasūns_
