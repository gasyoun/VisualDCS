# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Day-to-day session state lives in [`.ai_state.md`](.ai_state.md); this file records
durable, user-facing milestones.

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

## [Unreleased]

### Added
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
