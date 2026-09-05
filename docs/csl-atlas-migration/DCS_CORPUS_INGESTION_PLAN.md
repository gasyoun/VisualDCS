_Created: 04-06-2026 · Last updated: 05-09-2026_

# DCS Corpus Ingestion Plan

Date: 2026-05-29

Status: migrated legacy planning document from `csl-atlas`. It is preserved in
VisualDCS as boundary-cleanup material, not as an active atlas plan.

DCS/corpus ownership is now VisualDCS. Before implementation, rewrite this
plan in VisualDCS terms and confirm that a real passage-level DCS export is
available. The currently inspected export is reference data only, not a
passage corpus.

Legacy status: planning document for Phase 3 (Corpus Grammar Of Usage). DCS is the first corpus because it provides lemmatized, morphologically annotated evidence. GRETIL, Ambuda, and Sanskrit Library follow in later phases.

This plan turns Track 3 of `ARCHITECTURE.md` into a bounded slice. It deliberately front-loads schema inspection: the developer critique warns that the DCS path and schema are **not yet documented**, and that a generalized corpus model must not be built before the real DCS export is inspected (`docs/READER_DEVELOPER_CRITIQUE.md`).

## Goal

If VisualDCS later has passage-level corpus data, connect lexical entries to
real corpus occurrences so downstream tools can ask whether dictionary claims
match attested usage, and profile grammar by genre and period.

```text
lemma / construction -> corpus occurrences -> genre & period -> source link -> review status
```

## Hard Constraint: Inspect Before You Model

```text
Phase 3a: inspect and document the DCS export   <-- start here
Phase 3b: ingest into a documented manifest
Phase 3c: build grammar dashboards
```

Do **not** design `CorpusOccurrence` fields, tokenization rules, or dashboards until a real DCS export has been inspected and its schema written down. The first deliverable of this phase is documentation, not code.

## Phase 3a: Schema Inspection (Deliverable: a doc, not a build)

Before any ingestion script:

1. **Locate the export.** Record the actual local path (expected to be a sibling of `../csl-orig`, exact location TBD). Treat it like dictionary sources: large raw data stays outside the repo (`ARCHITECTURE.md`, AUC-06).
2. **Document the format.** What does one DCS record contain — text id, passage reference, token surface, lemma, morphology tags, sense id? In what file format (CoNLL-U, JSON, TSV, XML)?
3. **Document the metadata.** What text-level metadata is available: title, author, genre, date/period, source collection, license?
4. **Document the tag set.** Morphology and POS tag inventory, and whether lemmas use SLP1/IAST/Devanagari (this decides how they join to dictionary headwords).
5. **Document gaps.** What is missing or inconsistent (unannotated texts, unknown periods, ambiguous lemmatization).

Write this up (e.g. extend this file or a `DCS_SCHEMA.md`) before writing a parser. This is the corpus equivalent of "inspect MW markup before classifying."

> **Done (2026-05-30):** see [`docs/DCS_SCHEMA.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/csl-atlas-migration/DCS_SCHEMA.md). Key finding: the local `../DCS/` export is **reference data** (a 184/189-text abbreviation list, a bibliography, and a 78k word→grammar-category list), **not** passage-level occurrences. So the `CorpusOccurrence` model and genre/period dashboards below are **not buildable from this export**; what is built (`npm run build-dcs-corpus`) is the text inventory + grammar-category profile. Dictionary↔corpus lemma coverage is deferred (needs IAST→SLP1 and ~71% of CSV words carry a `?` diacritic-loss artifact). The passage-level sections of this plan await the full corpus.

## Corpus Metadata Model

Every ingested text must preserve the metadata listed in `ARCHITECTURE.md`:

- text id;
- title;
- author (if known);
- genre;
- period layer;
- source collection;
- license / access note;
- tokenization and lemmatization status;
- line / verse / passage / chapter reference.

Period layers use the conservative diachronic scale from `ARCHITECTURE.md` (`early-vedic` … `unknown`). Period assignment is `derived` or `inferred`, never exact dating, and must carry the source metadata used plus a confidence (`docs/EVIDENCE_LABELS.md`, UC-DIA-08). Where DCS gives no period, the layer is `unknown` — do not guess.

## CorpusOccurrence Shape

Target the common shape from `ARCHITECTURE.md`; confirm each field exists in the real export during Phase 3a before relying on it:

```text
CorpusOccurrence
  corpusId            "dcs"
  textId
  passageId
  token               surface form
  lemma
  normalizedLemma     joins to dictionary headwords
  morphology
  constructionTags[]  may be empty in the first pass
  genre
  periodLayer
  sourceHref
  confidence
```

The join key between corpus and dictionaries is `normalizedLemma`, reusing the same normalization as reader lookup and dictionary comparison.

## Suggested Pipeline

Mirror Phase 1 / Phase 2 layout:

- `scripts/lib/dcs-parser.mjs` — parse the documented DCS format into `CorpusOccurrence` records.
- `scripts/lib/corpus-manifest.mjs` — build the text-level manifest with metadata + period layers.
- `scripts/build-dcs-corpus.mjs` — emit the outputs below.
- `scripts/validate-dcs-corpus.mjs` — schema, counts, source links, metadata completeness.

Package scripts: `build-dcs-corpus`, `validate-dcs-corpus`. Add a missing-path warning (UC-DEV-12) so the build degrades gracefully when the DCS export is not present locally.

## Data Outputs

Compact JSON under `src/data/corpus/` (raw corpus never committed; only summaries):

- `corpus-manifest.json` — texts, genres, periods, license notes (UC-CG-01).
- `lemma-frequency.json` — lemma counts by text/genre/period (UC-CG-02).
- `pos-by-genre.json` — POS distribution heatmap data (UC-CG-03).
- `inflection-profiles.json` — case/number/gender (UC-CG-04 / UC-CG-05).
- `verb-morphology.json` — tense/mood/voice/person/number (UC-CG-06).
- `participle-krdanta.json` — participial derivation distribution (UC-CG-07).
- `dictionary-corpus-gap.json` — corpus orphans and dictionary-only lemmas (UC-CG-14 / UC-CG-15).
- `dcs-corpus-validation.json` — validation report.

Standard envelope on every file: `schemaVersion`, `generatedAt`, `sourcePath`, `recordCount`, `assumptions`, `warnings`, per-field `evidenceLevel`.

## Legacy Observable Pages

These page names came from the former atlas plan. They are not active
VisualDCS commitments until the plan is rewritten in this repository:

- `src/tools/corpus-inventory.md` — genre/period coverage.
- `src/tools/corpus-pos-heatmap.md` — POS by genre and period.
- `src/tools/corpus-inflection.md` — case/verb morphology explorers.
- `src/tools/dictionary-vs-corpus.md` — dictionary claim vs corpus usage (UC-CG-13), the cross-track payoff.

Each chart shows ranked examples with source links and metadata (UC-CG-12, UC-DEV-14).

## Validation

```text
build-dcs-corpus -> validate-dcs-corpus -> build
```

Validation should fail if: the manifest is missing required metadata; a period layer is asserted without source metadata; occurrence counts are implausible; any output lacks source links; or the Observable build breaks.

## Acceptance Criteria

- Phase 3a schema documentation exists *before* any ingestion code lands.
- One command regenerates all corpus JSON deterministically.
- Manifest preserves all required text metadata, with `unknown` where data is absent.
- Period layers carry source metadata + confidence and never claim exact dates.
- Corpus lemmas join to dictionaries via `normalizedLemma`, with mismatches sent to a review queue (UC-RV-04).
- No raw corpus committed; only compact summaries.
- No runtime LLM classification.

## Non-Goals (Phase 3)

- No GRETIL / Ambuda / Sanskrit Library ingestion yet — Phases 4–5, after a stable metadata + tokenization strategy exists.
- No sandhi/segmentation engine (UC-CG-16 is P3).
- No exact dating (AUC-01).
- No generalized corpus abstraction before the DCS export is inspected (AUC-08, critique).

## Related Documents

- `ARCHITECTURE.md` — Track 3, corpus metadata requirements, diachronic scale, Corpus Grammar Series.
- `docs/READER_DEVELOPER_CRITIQUE.md` — the "inspect DCS before modeling" warning.
- `docs/REVIEW_REPORTS.md` — the corpus-lemma mismatch queue.
- `docs/EVIDENCE_LABELS.md` — labeling derived/inferred period layers.
- `docs/USE_CASES.md` — UC-CG-01 through UC-CG-17, UC-RD-14, UC-DEV-06.

_Dr. Mārcis Gasūns_
