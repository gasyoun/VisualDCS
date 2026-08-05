# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Day-to-day session state lives in [`.ai_state.md`](.ai_state.md); this file records
durable, user-facing milestones.

## [Unreleased]

## [2026-08-05] — Aorist/perfect re-split propagated into `paradigm_attested.json` (H2294)

### Changed
- **The H1486 aorist/perfect re-split now reaches `paradigm_attested.json` (H2294).** The
  per-root paradigm dataset's finite past indicative is split into **`Aorist`**,
  **`Periphrastic Perfect`** and **`Perfect`** cell categories; the merged `Perfect/Aorist`
  label is gone (**2,422 → 0** occurrences in both
  [`visual/paradigm_attested.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_attested.json)
  and its `_data.js` twin, regenerated in one pass as always). Schema **1.0.0 → 1.1.0**.
  **This was not a regeneration:** `ud_to_category` is keyed on `(Tense,Voice,Mood)` and
  structurally cannot carry per-token `feat_formation`, so re-running the old generator
  reproduced the merged bucket verbatim — the finite-cell aggregation loop now applies
  `past_class()` per token, the same expression `regen_widgets.verb_forms()` uses.
  The csl-observatory **E46 reconciliation is unchanged** (6,454 roots match, 0 disagree):
  the split touches the display category only, never the E46 5-tuple.

### Added
- **`cellEvidence` — the bound ships with the data, not just with the docs (H2294).** Each
  split past category declares `formation-attested` (read off `feat_formation`) or
  `defaulted` (the untagged residue, i.e. **inferred**). Measured: the per-cell defaulted
  share is **exactly 0% or 100%, never in between** (1,955 attested cells vs 3,229
  defaulted) — degenerate *by construction*, since `Perfect` is defined as the untagged
  residue. That is what makes a per-category flag exact at per-cell granularity instead of
  an approximation, and `assert_evidence_degenerate()` fails the build if it ever stops
  holding. [`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html)
  badges it on the browse grid, the flashcard, and every exported deck card (deck schema
  1.1.0), so a learner is never shown an inferred `Perfect` as though the corpus asserted
  it. Aorist remains a **lower** bound and Perfect an **upper** bound.
- **`--e46-tsv` on `gen_paradigm_attested.py`.** The csl-observatory TSV path was resolved
  relative to the checkout, which is correct for `GitHub/VisualDCS` and wrong for any linked
  git worktree — regenerating from a worktree would have rewritten a committed
  reconciliation report as **BLOCKED** purely because of where the tree lives.
- **Regression coverage for the split** in
  [`test_paradigm_attested.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/test_paradigm_attested.py):
  no merged label may be emitted, every split category must carry a `cellEvidence` verdict,
  `Perfect *` may only ever be `defaulted`, and `Aorist`/`Periphrastic Perfect` only ever
  `formation-attested`. Each check was verified to go **red** against an injected defect.

## [2026-08-05] — Name-keyed-reader sweep across the 2021 dump (H2293, issue #70)

### Added
- **Collision + total-reconciliation guards on the `timws.csv` reader (H2293, issue #70).**
  [`read_2021_verbcats`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py)
  now prints every category name carrying more than one code with its per-code breakdown
  (8 names, 42 codes → 30 names), and reconciles the parsed sum against the independently
  documented 781,616 headline in README/CLAUDE (Excel-derived, ±10 tolerance). Checked against
  the pre-H1486 value: 741,782 trips the guard, so the bug would have surfaced at parse time.
- **[`reports/name_keyed_reader_sweep_2021_dump.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/name_keyed_reader_sweep_2021_dump.md)
  — the issue #70 follow-up sweep.** All 12 readers of the DCS-2021 dump, here and in
  SanskritGrammar, classified by source key vs dict key. **H1486 was the only materially-wrong
  instance; no second corrupted number shipped.** Records that `_8.csv` is a 63× larger instance
  of the same trap (a last-wins name-keyed read loses 2,492,275 of 4,577,461 tokens, 54%) which
  every live consumer already avoids by summing, and that `tense_case_data.json` must stay a
  duplicate-preserving list because four sibling verify scripts sum it by label.

### Fixed
- **`export_master.py::diff_8` no longer assigns `_8.csv` counts last-wins.** `_8.csv` is keyed
  by (lemma, POS) — 90,954 rows, 83,275 distinct lemma strings — so the old assignment silently
  discarded the counts of 6,340 homographs. Harmless in practice (only set membership and
  `len()` were read) but armed for the next caller; now sums, and reports `old_rows`/`new_rows`
  beside the lemma counts so the collapse is visible in the M4 report.
- **`whitney_per_text_counts.py` no longer skips the first row of `15.csv`.** That table is
  headerless — the `.splitlines()[1:]` slice was copied from a `timws.csv` reader (which does
  have a header) and silently dropped a real finite-form row on every run. No published number
  changes (690 aorist forms before and after).
- **`delta_stats.py::read_2021_freq`** — removed a dead last-wins `lemma_bucket` map (computed,
  never returned, would have mislabelled every homograph's POS) and corrected the docstring,
  which advertised four return values for a three-value return.

## [2026-08-04] — Aorist ≠ Perfect: the `Tense=Past` re-split (H1486)

### Added
- **Aorist and Perfect are separate categories again — the `Tense=Past` re-split (H1486).**
  UD has no Aorist tense value, so both Sanskrit past tenses collapsed into one
  `Perfect/Aorist` bucket. DCS's own `feat_formation` carries the past-stem formation, and
  [`regen_widgets.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py)
  now uses it: within the finite past indicative (93,329 tokens) the seven Whitney aorist
  formations give **Aorist 12,054**, `peri` gives **Periphrastic Perfect 4,046**, and the
  untagged remainder defaults to **Perfect 77,229** — reconstituting the former merged
  92,570 + 759 exactly. `verb_forms_38cat.json` gains `Aorist Active` / `Perfect Active` /
  `Periphrastic Perfect Active` / `Perfect Passive`; `verb_forms_ud.json` gains a
  `Formation=` axis.
- **`validate_past_tense_resplit.py` — the re-split's error bars, measured not assumed.**
  Only one step of the split is a default (`feat_formation IS NULL` → Perfect, because DCS
  leaves the simple perfect unmarked), and a published Limitations claim now rests on it, so
  four independent checks report on it and emit
  [`reports/past_tense_resplit_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/past_tense_resplit_validation.md):
  taxonomy agreement with the independent 2021 asset `visual/paradigm_endings.json` (PASS —
  the unmarked past category there is the simple perfect, so the default reproduces that
  annotation's own default); frequency-weighted adjudication of the 50 commonest untagged
  forms (58.92% of the defaulted mass, all textbook perfects); an aorist-leakage floor of
  1.13%; and 3.54% imperfect contamination. **Aorist is therefore a lower bound and Perfect
  an upper bound** — the script asserts denominator closure and imports its rules from
  `regen_widgets.py` so validator and validated cannot drift.

### Fixed
- **The "`feat_formation` is present on <2% of verbs — too sparse" claim was wrong and is
  retracted (H1486).** The arithmetic was right and the denominator was not: 16,100 tags
  against all ~1.01M verb tokens is 1.60%, but the feature only ever applies to the finite
  past indicative, where coverage is **17.25%**. Corrected in
  [`README.md`](https://github.com/gasyoun/VisualDCS/blob/main/README.md),
  [`CLAUDE.md`](https://github.com/gasyoun/VisualDCS/blob/main/CLAUDE.md),
  `reports/m7_widgets.md` and the A38 paper's §6 Limitations.
- **2021 comparison figures under-counted by 39,836 examples (H1486).** `timws.csv` binds 42
  category *codes* to 30 distinct category *names*, and `read_2021_verbcats` keyed its map on
  the name — so each of the 8 collisions kept only the last code and silently dropped the
  rest (`Imperfect Active` 35,921 + 4,442 → 4,442; `Aorist Active` 583 + 721 → 721). Summing
  collisions yields **781,618**, reconciling with the documented Excel headline 781,616 to
  within 2. This also retracts A38 §4.4's explanation that 741,782 and 781,616 were "separate
  aggregations of the same 2021 vintage" — they are the same aggregation, one of them
  mis-summed. Surfaced only because the re-split gave the 2026 side a matching `Aorist Active`
  row to compare against.

## [2026-08-04] — Russian roadmap of record rewrite + figure corrections (H1855)

### Fixed
- **Russian roadmap of record rewritten; the two mis-published figures corrected in every
  remaining publish site (H1855,
  [issue #66](https://github.com/gasyoun/VisualDCS/issues/66)).**
  [`roadmap.md`](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md) is now a
  document-of-record (dated header, inline ✅ markers incl. item 9 / H1536, open items
  listed): the body itself — not just the banner — states **Nom.Sg = 761,605 = 33.7 %** of
  the 2,263,192 cased grid tokens (was "34.6 % of all nominal forms") and **dual pooled =
  46,909 = 2.07 %** with the per-cell spread (max Nom.Dual 0.91 %, all 8 dual cells < 1 %)
  instead of "Dual < 1 % везде", each with the recomputation path
  (`gen_paradigm_nominal.py` over `dcs_full.sqlite`, pin `04e0778d…` →
  [`reports/paradigm_nominal_build.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_nominal_build.md)).
  The last stale publish site,
  [`mockups/index-dark.html`](https://github.com/gasyoun/VisualDCS/blob/main/mockups/index-dark.html)'s
  «Морфостатистика» `fact:` line, corrected likewise (`sanskrit_index.html` was already
  fixed earlier).

## [2026-07-31] - Standalone widgets wave (H1504–H1538) + lychee (H1743)

### Added
- **[`sanskrit_anki_decks.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_anki_decks.html)
  — standalone Anki-deck flashcard widget (H1504)**, consuming the already-computed
  `visual/anki_compact.json` (200 cards, 4 learning stages). Data is embedded inline (no
  companion file, no `fetch()`), so the file is fully self-contained. Stage filter,
  click-to-flip cards, CSV export in Anki's plain-text import format, and a Markdown export
  grouped by stage for Obsidian.

### Changed
- **[`sanskrit_index.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_index.html)**
  — the *Anki-деки* (D2) card flipped from `type:'widget'` to `type:'file'`, now linking
  directly to `sanskrit_anki_decks.html`.
- **Print / PDF one-page export (H1536)** —
  [`sanskrit_pxn_v4.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4.html)
  and
  [`sanskrit_paradigm_trainer.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_paradigm_trainer.html)
  gain an on-screen "🖨 Печать / PDF" button (`window.print()`) and an `@media print`
  stylesheet: nav/controls/side panels get a shared `.no-print` class hidden at print time
  (`display:none`, including the trigger button itself), so Ctrl+P prints only the current
  paradigm grid on one page. Verified headless via `chrome --headless --print-to-pdf`
  (1-page PDF, chrome/controls text absent from the extracted text).

### Added
- **Standalone concordance search widget (H1505).**
- **Curated-passage browser widget — standalone HTML (H1537).**
- **Morphostatistics reference widget — person×number, cases, prefixes (H1538).**

### Fixed
- **Markdown link check: replace Docker-based checker with lychee + scheduled run (H1743).**

### Changed
- **Roadmap truth-pass:** inline done markers for items 1–8 + integration section (H1878).


## [2026-07-27] — Concordance search widget (H1505)

### Added
- **[`sanskrit_concordance.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_concordance.html)**
  — standalone client-side search over the 6,423-form concordance: typing a root or
  inflected form (diacritic-insensitive — ASCII `kuryat` matches `kuryāt`) returns every
  matching form with its total corpus occurrence count and up to 5 example strophes with
  source citation, highlighted inline. No server, no `fetch()` — works from a
  double-clicked `file://` page. `sanskrit_index.html`'s "Конкорданс" card flips from
  `type:'widget'` to `type:'file'`.
- **[`gen_concordance_data.py`](https://github.com/gasyoun/VisualDCS/blob/main/gen_concordance_data.py)**
  — packs the existing `visual/conc_part{1,2,3}.json` into
  [`visual/conc_data.js`](https://github.com/gasyoun/VisualDCS/blob/main/visual/conc_data.js)
  (a `window.CONC_DATA` script twin, ≈5.3 MB), verifying the three parts don't re-key the
  same form and that each form's count agrees with `visual/conc_totals.json`.
- **[`tests/test_concordance.js`](https://github.com/gasyoun/VisualDCS/blob/main/tests/test_concordance.js)**
  — headless render test (`node tests/test_concordance.js`), same pattern as
  `tests/test_nominal_dashboard.js`: runs the page's own inline script against the real
  data and asserts on exact-match, substring/root-match, diacritic-insensitive-match, and
  no-results behaviour.

## [2026-07-27] — Nominal paradigm dashboard: case × number per declension class (H1472)

### Changed (propagation pass, 27-07-2026)
- **[`docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md)**
  — §6.1 gains the NOUN/ADJ join recipe with live totals and the `lemma.grammar` vs
  `feat_gender` distinction; the gotcha registry grows **G18 → G21**: `Cpd` is not a ninth case
  (G19), the NULL-complement trap that silently dropped 8,542 tokens (G20), token gender ≠
  lexical gender (G21). Metadoc revision row added.
- **[`CLAUDE.md`](https://github.com/gasyoun/VisualDCS/blob/main/CLAUDE.md)** — new "Sync rules"
  section: regenerate ⇒ re-run the node test in the same PR; never ship `--skip-checksum`
  output; never weaken the denominator-closure assertion; `STEM_TAGS` is shared with
  SanskritGrammar and must not drift.

### Added
- **[`sanskrit_nominal_dashboard.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_nominal_dashboard.html)
  — the nominal paradigm dashboard (H1472)**, the roadmap's long-standing "biggest unbuilt
  tool" and the nominal twin of the verb paradigm browser: the 8 case × 3 number grid per
  declension class over **2,263,192 cased NOUN + ADJ tokens**, 14 stem classes × token
  gender × 24 cells, each cell colour-coded by frequency and opening its attested surface
  endings, top attested forms, and real corpus sentences with text + reference.
- **[`src/DCS-data-2026/gen_paradigm_nominal.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal.py)**
  — the reproducible generator over the pinned `dcs_full.sqlite`, emitting
  [`visual/paradigm_nominal.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal.json)
  + its `window.*` `.js` twin and
  [`reports/paradigm_nominal_build.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_nominal_build.md)
  from one aggregation pass. Declension-class bucketing **reuses** SanskritGrammar's Sangram
  G2 tag list (H1048) rather than inventing a second taxonomy, extended with the `-ant`
  class G2 leaves in its `other_consonant` residue.
- **[`reports/nominal_g2_reconciliation.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/nominal_g2_reconciliation.md)**
  — cross-check against Sangram G2's per-lemma coverage asset: **57,144 lemma_ids agree
  exactly** on both token and attested-cell counts, 0 disagreements, and the only class
  re-bucketing is the intended `-ant` extension (279 lemma_ids).
- **[`tests/test_nominal_dashboard.js`](https://github.com/gasyoun/VisualDCS/blob/main/tests/test_nominal_dashboard.js)**
  — headless render test: executes the page's own inline script against a DOM stub with the
  real generated data, then asserts the data contract (denominator closure, per-cell sums,
  pinned checksum, examples resolving to real forms of their own cell). 21 checks.

### Changed
- **[`sanskrit_index.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_index.html)**
  — new starred card for the nominal dashboard; the morpho-statistics card's stale
  `Nom.Sg = 34.6% · Dual < 1% везде` fact recomputed on the 2026 master.
- **[`roadmap.md`](https://github.com/gasyoun/VisualDCS/blob/main/roadmap.md)** — its two
  headline nominal numbers, recomputed on DCS-2026, **do not reproduce verbatim**: Nom.Sg is
  **33.7%** of cased tokens (not 34.6%), and "Dual < 1% everywhere" holds only per cell
  (largest dual cell 0.91%) — pooled across all cases the dual is **2.07%**.

### Fixed
- A `NOT (feat_case IN (…) AND feat_number IN (…))` complement in the generator silently lost
  every case-untagged token to SQL three-valued logic (`NULL IN (…)` → `NULL`, `NOT NULL` →
  `NULL`), so 8,542 tokens matched neither the grid query nor its supposed complement and
  vanished from both denominators. Spelled out NULL-safely and backed by a build-time
  assertion that grid + `Cpd` + unplaceable must equal the whole NOUN/ADJ universe
  (2,996,410) — the assertion is what caught it.

## [2026-07-26] — DCS data-layer doc-of-record: consumer deep manual (H1407, Wave 4)

### Added
- **[`docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md)**
  (+ [`.meta.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.meta.md))
  — the org-wide doc-of-record for the `dcs_full.sqlite` corpus layer: as-built schema
  (live `PRAGMA`, 26-07-2026), 2021↔2026↔M9-archive generational boundaries with the
  `LemmaId` bridge and a live vintage-mismatch demonstration, the anusvāra census +
  fold vs DO-NOT-fold rule (the H1328 29%→33% worked example), one executed join
  recipe per consumer repo (VisualDCS, WhitneyRoots, kosha, csl-guides, csl-atlas),
  the G1–G18 gotcha registry, and silent-join-failure symptoms. All 64 recorded
  numbers executed live against the real 920 MB DB.

### Changed
- **[`docs/csl-atlas-migration/DCS_SCHEMA.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/csl-atlas-migration/DCS_SCHEMA.md)**
  — deprecation banner: it documents the superseded pre-import three-file reference
  export; its "no passage-level data" conclusion no longer holds.

### Fixed
- Removed the 0-byte decoy `src/dcs_full.sqlite` from the canonical checkout after an
  org-wide grep confirmed only prose (no code) referenced the path; the `.gitignore`
  guard rule stays so the decoy can never be committed if recreated.

## [2026-07-20] — MW uttarapada index × DCS Kompozity: dictionary productivity vs corpus attestation (H1328)

### Added
- **[`derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/uttarapada_dict_vs_corpus.tsv)**
  — the join, 19,177 rows (one per MW-kept compound final member), giving for each:
  MW first-member productivity (type count), corpus compound-form count, summed DCS
  token frequency, corpus first-member count, the MW∩corpus / MW-only / corpus-only
  first-member set arithmetic, and a `corpus_status` (final / form_variant /
  nonfinal_only / absent). Joins the
  [MWderivations issue15 reverse index](https://github.com/gasyoun/MWderivations/blob/master/issue15/compounds_reverse_classified.tsv)
  (dictionary side) to
  [`Kompozity/cmps.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/cmps.csv)
  × [`names.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/names.csv)
  (corpus side).
- **[`derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py)**
  — the reproducible build. Folds the two orthographic mismatches between the sides
  (anusvāra `ṃ`/`ṁ`; MW markup `@`/`-`/avagraha) but deliberately does **not** fold
  vowel-length / gender / junction-sandhi differences, diagnosing those as
  `form_variant` rather than asserting a false absence.
- **[`reports/uttarapada_dict_vs_corpus_divergence.md`](https://github.com/gasyoun/VisualDCS/blob/main/reports/uttarapada_dict_vs_corpus_divergence.md)**
  — the divergence report with both directions. Headline: even where MW **and** the
  corpus attest a final member, their first-member vocabularies are near-disjoint
  (median Jaccard 0.00; 56 % of matched finals share zero first members —
  e.g. `-indra`, MW 2 vs corpus 286, overlap 0). Direction A (dictionary-only,
  10,387 finals, 86 % MW-hapax) is framed as a corpus-unattested *stratum*, not
  "ghost words" (per [SanskritLexicography FINDINGS §86](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)
  and the pwg/mw ghost-word work). Direction B surfaces the productive
  enumeration/comparison heads the corpus over-attests and MW under-lists
  (`-ādi`, `-ādya`, `-ābha`, `-uttama`, `-vyāghra`, `-indra`).
- **[`visual/kompozity_dict_vs_corpus.html`](https://github.com/gasyoun/VisualDCS/blob/main/visual/kompozity_dict_vs_corpus.html)**
  — a self-contained interactive visualization of the divergence: a log-log scatter of
  dictionary productivity × corpus attestation for the 6,249 shared final members, coloured
  by first-member overlap (the "same finals, different words" story made visible), plus the
  four-strata bar, the Jaccard-overlap histogram, both divergence tables, and the twin
  junk-heads. Theme-aware, no external assets; palette CVD-validated.

## [2026-07-19] — paradigm trainer scale-up: 6 roots -> the attested verb space (H1299)

### Added
- **`sanskrit_paradigm_trainer.html`** — root picker + search, attested-only cell grid
  (every cell shown carries >=1 real corpus form+count, no fabricated textbook cells),
  frequency-weighted flashcard trainer mode, JSON deck export for downstream SRS.
  Scales the 6-hand-picked-root paradigm browser to **7,689 corpus-attested roots**
  (frequency floor >=2 total VERB tokens; top 100 = "full" tier, the rest =
  "attested"-only long tail per the H1299 plan's decision #3). `sanskrit_pxn_v4.html`
  (the 6-root deep view) is untouched.
- **`src/DCS-data-2026/gen_paradigm_attested.py`** — the data build, over the full 2026
  DCS master (`dcs_full.sqlite`, 270 texts, 1,007,361 VERB tokens); reuses
  `regen_widgets.ud_to_category`/`participle_cat` rather than re-deriving the
  tense/mood category map or the participle heuristic. Writes
  `visual/paradigm_attested.json` + `paradigm_attested_data.js` (same aggregation
  pass, byte-stable rerun verified) and a build report.
- **`src/DCS-data-2026/test_paradigm_attested.py`** — regression: pins the top-100
  root list, spot-checks 10 roots (the 6 hand-picked + 4 more high-rank), and
  enforces the never-fabricate-class discipline (no root record may carry a Panini
  class number; DCS's unaccented tagging cannot resolve verb class I vs VI or IV vs
  passive at the root-class level, and `Tense=Past` conflates aorist/perfect — both
  carried through honestly, never resolved).
- **E46 reconciliation** — cross-checked this build's per-root finite-cell counts
  against csl-observatory's `paradigm_cell_coverage_per_root.tsv` (H817, same DB,
  identical SQL filter): **0 mismatches**, 6,454 roots match exactly
  (`reports/e46_reconciliation.md`).
- Landing page (`sanskrit_index.html`) gained a card for the new trainer.

## [2026-07-12] — annotation-layer census supplement (H686 §3b)

### Added
- **Annotation-depth census**, a second axis the token-level delta passes miss:
  census over all 270 CoNLL-U text folders (`delta_annotation_layers.py`) —
  WordSem 219/270 (corpus-wide, not Vedic-selective), Vedic Treebank 74,
  IsMantra 44 (both Vedic-selective). Sharp finding: 29 of the 30 only-2026
  texts arrived with **zero** WordSem annotation (sole exception: Atharvaveda
  Paippalāda) — the Vedic wave added raw tokens without the semantic layer.
  Per-text CSV + reproducibility script ([PR #41](https://github.com/gasyoun/VisualDCS/pull/41)).

## [2026-07-12] — 2021→2026 delta: drift-interpretation supplement (H686 completed)

### Added
- **Drift interpretation + replication supplement** to the H686 delta report:
  [`derived-data/Corpus-Delta-2021-2026/DRIFT_INTERPRETATION.md`](derived-data/Corpus-Delta-2021-2026/DRIFT_INTERPRETATION.md)
  (+ `delta_supplement.py`, 3 CSVs, generated tables) — what the delta *means*: the +24.3%
  growth is a coherent Vedic composition shift (iti/vai/agni/etad up, ca/tu/api/vac down);
  the 1,761 only-2021 lemmas are mostly a-privative **lemmatization-policy drift**, not lost
  text (real only-2021 text = 892 tokens across 4 commentary fragments); POS texture stable
  within 1.5 pp under a shared-lexicon comparison; all-texts per-text token deltas (only
  10/240 matched texts shrank, max −873). Verdict unchanged: keep `DCS-data-2021/`, but
  never compute a *current statistic* from it.

## [2026-07-11] — Type-D VedaWeb concordance, 2021-2026 delta verdict, DCS 2026 hapax census

### Added
- **Type-D translation-witness typed-link retrofit** ([PR #36](https://github.com/gasyoun/VisualDCS/pull/36),
  H540): [`non-derived/vedaweb/typed_link_translation_witness.tsv`](non-derived/vedaweb/typed_link_translation_witness.tsv)
  (9,945 rows, regenerable via `emit_typed_link_translation_witness.py`) — the
  `gra_vedaweb_crosswalk.tsv` × `grassmann_de_1876_1877.json` join re-emitted in the canonical
  `TYPE_D_RECORD_FIELDS` shape per [`TYPED_LINK_ID_GRAMMAR.md`](https://github.com/gasyoun/Uprava/blob/main/TYPED_LINK_ID_GRAMMAR.md)
  §4a, validated 0-error against `kosha/scripts/typed_link_lint.py`. Supersedes the pre-spec
  `build_type_d_id_join.py` / `type_d_id_join.tsv` prototype (Q4.0, H522) — kept in-repo,
  marked superseded, not deleted.
- **DCS 2021→2026 corpus delta report** ([PR #37](https://github.com/gasyoun/VisualDCS/pull/37),
  H686): [`derived-data/Corpus-Delta-2021-2026/`](derived-data/Corpus-Delta-2021-2026/REPORT.md)
  — texts 246→270 (+9.8%), tokens 4,577,461→5,688,416 (+24.3%), lemma IDs 91,406→98,606,
  POS-bucket shift + top-200 lemma frequency-drift table. **Verdict: `DCS-data-2021/` is
  NOT superseded** (6 texts + 1,761 lemma IDs are 2021-only) — report only, no deletion.
- **DCS 2026 hapax census** ([PR #38](https://github.com/gasyoun/VisualDCS/pull/38), H762):
  [`derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/`](derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/README.md)
  — 39,987 hapax lemmas (41.9% of the 95,457-lemma vocabulary) over the full 5,688,416-token
  corpus, split single-morpheme (57.7%) vs compound (42.3%) via direct stem-concat
  segmentation; 3 TSVs + deterministic generator + a 5-limitation method README.

### Fixed
- A lint gap in `kosha/scripts/typed_link_lint.py`: 21 Grassmann `<L>` entries carry a
  decimal homonym suffix (`gra:5833.1`) the `gra:` regex rejected — widened to
  `^\d+(\.\d+)?$` (landed alongside PR #36, see [kosha PR #59](https://github.com/gasyoun/kosha/pull/59)).

## [2026-07-10] — VedaWeb feeds, A38 data-paper progress, M9 research archive, dictionary/corpus cross-checks (H790 backfill)

_(Backfilled 14-07-2026, H790 changelog-backfill pass, Sonnet 5 (`claude-sonnet-5`) —
27 substantive commits from 02–10.07.2026 had no changelog record. The prior H790
pass on this repo checked against the wrong "last tag" — `dcs-full-2026-03-05`
instead of the chronologically later `archive-2026-07` (2026-07-02) — and so missed
this window entirely.)_

### Added
- **M9: research-archive parallels loader** ([PR #8](https://github.com/gasyoun/VisualDCS/pull/8)):
  `import_archive.py parallels` ingests 245 Polnorazmernye CSVs into a queryable
  `archive.sqlite` — 154,304 matches (14,702 GOOD / 139,602 PARTLY), a
  quality-anchored parser recovering 271 malformed rows with zero silent loss, and
  a `parallel_text` crosswalk linking 140/146 texts (95.9%) to `dcs_full.text`.
- **Corpus-verified PPP list** (5,181 forms) derived from the verbal-forms DB, plus
  a subhashita export script feeding SanskritLexicography's `IndischeSprueche`.
- **A38 DCS-2026 release paper**: skeleton expanded to 3/5
  ([PR #11](https://github.com/gasyoun/VisualDCS/pull/11), H156); Hellwig cluster +
  ISCLS 2026 added to Related Work via an ACL Anthology scan
  ([PR #13](https://github.com/gasyoun/VisualDCS/pull/13)); venue locked to
  *Research Data Journal*, byline/ORCID confirmed, Hellwig CC-BY sign-off recorded
  ([PR #24](https://github.com/gasyoun/VisualDCS/pull/24)).
- **VedaWeb 2.0 Rig-Veda feeds**: bulk export of the 4 core RV annotation layers
  (Casaretto et al. 2025 accented word-split + morphology, lemmatization + CDSD
  cross-refs, Scarlata & Widmer accented text, Lubotsky padapatha — all 10,552
  stanzas, CC BY 4.0, H096); the GRA↔VedaWeb crosswalk linking 9,945/12,785
  Grassmann `<L>` entries (77.8%) to 192,637 attested RV token occurrences
  ([PR #18](https://github.com/gasyoun/VisualDCS/pull/18), H097); meter/translation
  layers triage ([PR #19](https://github.com/gasyoun/VisualDCS/pull/19), H098) then
  rights-confirmed GO on all 4 DECIDE-tier layers
  ([PR #20](https://github.com/gasyoun/VisualDCS/pull/20), H359); VedaWeb Metrical
  Data (2024) export (H360); Elizarenkova's RU RV translation landed as a feed
  (H361); Geldner + Grassmann PWG gloss cross-check (H362).
- **H457 — dictionary-side Titov parametric core for Sanskrit**: first application
  of the Voronezh-school (V.T. Titov) parametric analysis to Sanskrit from the
  dictionary side, cross-checked against Leonchenko's 435-lemma corpus core —
  `pwg_parametric_core.tsv` (106,082 PWG headwords × 13 cols)
  ([PR #27](https://github.com/gasyoun/VisualDCS/pull/27)).
- **H203/F4-DCS — shared-erroneous-citation test**: resolver + report over 587
  shared rare PWG/PW∩MW citations vs. the DCS passage corpus; 0 adjudicated
  genuine shared errors (96% of the pool is a Petersburg continuous-numbering vs.
  DCS critical-edition Harivaṃśa mismatch, not a copied error) — A10 evidence
  stays F1+F5, readiness unchanged at 3/5.
- **H728 — Sanskrit LSC pilot**: first Lexical Semantic Change derivation for
  Sanskrit in the ACL Anthology's LSC family (0 prior hits) — deterministic
  PPMI-cosine over dcs-conllu (5.69M tokens), 3,049 lemmas scored, 1,258 on the
  primary Vedic→Epic pair, freq-shift-controlled (Spearman −0.013), stratified
  60-lemma target set for a future ChiWUG-style gold.
- **H589 — dark-mode data-app mockups** for the 3 dashboards (CSS-only restyle,
  scripts byte-identical, per the H563 winner-only rollout).
- DCS akshara/varṇa/ligature frequency regen (H237) + Fonetika varga-series-
  diachrony (5 consonant series by period, Cramér's V).
- Per-subfolder `README.md` across `derived-data/`
  ([PR #15](https://github.com/gasyoun/VisualDCS/pull/15)) and a new
  Lexical-Cores README with a word-count table
  ([PR #14](https://github.com/gasyoun/VisualDCS/pull/14)).

### Fixed
- CI: renamed over-long filenames that broke `actions/checkout`
  ([PR #28](https://github.com/gasyoun/VisualDCS/pull/28)).
- Pages: escaped literal Liquid tokens that were failing the Jekyll build
  ([PR #29](https://github.com/gasyoun/VisualDCS/pull/29)).

## [2026-06-06] — DCS CoNLL-U import pipeline (M1–M8) ✅

Imported the **current** DCS distribution (CoNLL-U / Universal Dependencies) alongside the 2021
relational dump, as a queryable, validated SQLite master. The 2021 dashboards are unchanged.

### Added
- **`src/DCS-data-2026/` pipeline** (stdlib Python): `parse_conllu` → `import_dcs_conllu` (flatten-all
  SQLite) → `coverage_diff` → `export_master` (CSVs + verb tense/mood **code map**) → `validate`
  (cross-walk · integrity · idempotency · spot; CI-gated via `.github/workflows/dcs-validate.yml`) →
  `regen_widgets` (dashboard JSON). Findings in `src/DCS-data-2026/reports/`.
- **Full SQLite master** published as a GitHub Release `dcs-full-2026-03-05` (287 MB gz; regenerable, not
  committed): 270 texts · 5,688,416 tokens · 754,726 sentences · 98,606 attested lemmas · 74 treebank
  texts. Pinned to `gasyoun/dcs-conllu @ 04e0778` (submodule at `src/DCS-data-2026/conllu`).

### Verified / Fixed
- The 2021 `0.csv` integer IDs are exactly the CoNLL-U `LemmaId`s (cross-walk: 0 mismatches at scale).
- `OccId` and `sent_id` are both non-unique in the corpus (`sent_id` even within a chapter) — sentences
  and tokens are keyed by synthetic ids (bugs surfaced by the validation suite).

### Changed
- `src/DCS-data` split into `DCS-data-2021` (relational dump, converted out of Git LFS to plain blobs)
  and `DCS-data-2026` (CoNLL-U submodule + pipeline); README gained the 2026 source entry.

## [2026-07-19] — paradigm-trainer attested scale-up staged (H1299 queued)

### Added
- **Paradigm-trainer scale-up staged (queued, docs-only, via [`/ask-batch`](https://github.com/gasyoun/claude-config/blob/main/commands/ask-batch.md), Fable 5 `claude-fable-5`):**
  new [`docs/PLAN_VISUALDCS_PARADIGM_TRAINER_ATTESTED_SCALEUP_2026H2.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/PLAN_VISUALDCS_PARADIGM_TRAINER_ATTESTED_SCALEUP_2026H2.md)
  (+ metadoc) staging the 6-root [`sanskrit_pxn_v4.html`](https://github.com/gasyoun/VisualDCS/blob/main/sanskrit_pxn_v4.html)
  browser's generalisation to the whole attested verb space with a trainer mode
  ([H1299](https://github.com/gasyoun/Uprava/blob/main/handoffs/H1299-Sonnet_VisualDCS_paradigm-trainer-attested-scaleup_19.07.26.md), Sonnet, queued).
- Documentation and tooling for the DCS data and its lineage:
  - `src/DCS-data-2021/README.md` — provenance of the 2021 relational-DB export (Oliver Hellwig's
    Digital Corpus of Sanskrit), license/citation, and an inventory of raw tables vs. derived
    analysis vs. the Free Pascal / Lazarus processing tools.
  - `src/DCS-data-2026/DCS_FORMAT_COMPARISON.md`, `compare_dcs_formats.py`, and a bundled
    `sample_conllu/` file — a verified comparison of the relational export against the
    current CoNLL-U distribution (same data, joinable on `LemmaId`).
  - `src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md` — plan + milestone roadmap for importing the
    current CoNLL-U updates into the relational export (full refresh, hybrid schema,
    SQLite + CSV exports, pilot-first, data-layer before dashboards).
  - `src/DCS-data-2026/check_conllu_updates.py` — checks upstream for CoNLL-U commits after the
    pinned snapshot (`04e0778`, 2026-03-05).
- `src/DCS-data-2021/` raw corpus assets prepared for GitHub:
  - Split parts of the two >100 MB files (`10.csv` → 2 parts, `10.txt` → 3 parts),
    each ≤ 99 MiB and split on line boundaries so they rebuild byte-for-byte.
  - `src/DCS-data-2021/rejoin.bat` — rebuilds the originals from their parts.
  - `src/DCS-data-2021/.gitignore` — excludes the >100 MB originals `10.csv` / `10.txt`
    (kept locally, committed only as split parts).
  - `src/DCS-data-2021/DCS-data-CLEANUP.md` — full inventory and rationale of the cleanup.
  - Repo-root `.gitattributes` — Git LFS tracking for the 11 large committed files
    (the split parts + 6 standalone 50–99 MB files).

### Changed
- **Split `src/DCS-data` into dated versions:** `src/DCS-data-2021/` (the relational-DB export) and
  `src/DCS-data-2026/` (the CoNLL-U side — comparison, import plan, update tracker, sample). The full
  2026 CoNLL-U corpus lives in a separate repo (`gasyoun/dcs-conllu`, pinned `04e0778` / 2026-03-05),
  mounted as a git submodule at `src/DCS-data-2026/conllu` — keeping VisualDCS lean and off Git LFS.
  Re-pointed the 8 LFS `.gitattributes` rules to the new `src/DCS-data-2021/` path.
- Brought the docs in line with the current repo: `README.md` and `CLAUDE.md` now cover all
  three dashboards and the `src/DCS-data-2021/` corpus, with the roadmap reconciled against shipped
  features, and `roadmap.md` got a status banner. Corrected the DCS dependency-annotation note
  (syntax coverage is **partial**, not absent) and de-linked two dead references in the
  migration ingestion plan.
- Renamed the data folder `src/DSC-data/` → `src/DCS-data/` (correct acronym, matching
  the Digital Corpus of Sanskrit / VisualDCS). Updated all internal references and
  re-pointed the Git LFS paths after the rename.

### Removed
- 8 redundant `.txt` files that were byte-for-byte identical to their `.csv` twin
  (`All`, `capters`, `cpx`, `forms`, `forms10`, `gra`, `topics`, `Files`) — kept the `.csv`.
