---
paper_id: A38
title: "The Digital Corpus of Sanskrit 2026: An Open Treebank-and-Morphology SQLite Release with a Validated 2021→2026 Cross-Walk"
status: draft (skeleton, 2/5) — scaffolded 2026-06-26
readiness: 2/5
venue: "LREC-COLING (LR track) / Research Data Journal / JOHD"
author: "**Mārcis Gasūns**, independent scholar ([ORCID 0000-0003-4513-884X](https://orcid.org/0000-0003-4513-884X)), gasyoun@ya.ru"
data_source: "src/DCS-data-2026/ (master built M0–M8; figures verified against reports/m6_validation.md + reports/m7_widgets.md)"
---

# The Digital Corpus of Sanskrit 2026: An Open Treebank-and-Morphology SQLite Release with a Validated 2021→2026 Cross-Walk

> **Draft status (2026-06-26).** Manuscript skeleton built directly on the completed
> data work in [`src/DCS-data-2026/`](../src/DCS-data-2026/) (milestones M0–M8 done, per
> [`DCS_CONLLU_IMPORT_PLAN.md`](../src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md)). **Every
> numeric claim below is transcribed from the verified validation reports**
> ([`reports/m6_validation.md`](../src/DCS-data-2026/reports/m6_validation.md),
> [`reports/m7_widgets.md`](../src/DCS-data-2026/reports/m7_widgets.md),
> [`reports/coverage_diff.md`](../src/DCS-data-2026/reports/coverage_diff.md),
> [`reports/m4_exports.md`](../src/DCS-data-2026/reports/m4_exports.md)) and recomputes via
> `python src/DCS-data-2026/validate.py --all`. **Open before submission:**
> (1) write §2 Related work; (2) paste the exact `dcs_full.sqlite` schema table + the M4
> verb code-map into §3; (3) mint the Zenodo DOI and fill the data-availability statement;
> (4) obtain Oliver Hellwig's CC-BY redistribution sign-off and lock the upstream citation;
> (5) confirm ORCID / finalise byline; (6) add the per-text count-delta sample table.
> **Numbers marked _(TODO: verify)_ are not yet confirmed and must not be quoted until checked.**

## Abstract

The Digital Corpus of Sanskrit (DCS) is the central morphologically annotated corpus of
Sanskrit, but it circulates in two incompatible serialisations: an older relational-database
export (the basis of most downstream tools, including this project's frequency dashboards) and
the current Universal-Dependencies CoNLL-U distribution, which crossed a format redesign in
2022 and is the maintained source of truth. We present a FAIR, DOI-minted *data descriptor* for
**DCS-2026**: a queryable SQLite master and a set of tidy CSV exports derived losslessly from
the CoNLL-U distribution at a single pinned upstream commit. The master covers **270 texts,
5,688,416 tokens, 754,726 sentences, and 98,606 distinct attested lemmas**, of which **74 texts
carry dependency (treebank) annotation**; the remainder are morphological only. We document the
normalized schema, a validated lemma-keyed cross-walk between the 2021 and 2026 vintages (89.3%
Jaccard overlap of attested lemmas), and a learned map from the 2021 DCS-internal verb codes to
UD features. Validation is CI-gated: cross-walk at scale (0 mismatches over 754,726 sentences),
referential integrity (0 orphans), idempotency (byte-identical re-build), and full-token spot
checks (200 verses, 0 mismatches) all pass. We are deliberately explicit about two annotation
caveats that any reuse must respect: (i) UD `Tense` has no Aorist/Perfect value, so both collapse
into a single `Tense=Past` bucket; and (ii) the corpus's own occurrence and sentence identifiers
(`OccId`, `sent_id`) are non-unique, forcing synthetic primary keys. The contribution is not new
corpus annotation — that is Hellwig's — but a validated, reproducible, query-ready packaging of
the current DCS together with an honest mapping back to the established 2021 ecosystem.

## 1. Introduction

The Digital Corpus of Sanskrit (DCS; Oliver Hellwig, 2010–present) is the de-facto reference
corpus for quantitative Sanskrit philology. Almost every downstream resource that reports DCS
frequencies — including this project's verb-form and paradigm dashboards — was built against the
corpus's **relational-database export**, a set of normalized CSV/SQL tables joined by integer
IDs (a sentence row in `0.csv` is a lemma-ID sequence plus a sandhied surface string; per-token
morphology lives in separate tables encoded as DCS-internal numeric codes). Since then the DCS
has migrated to a **Universal-Dependencies CoNLL-U** distribution — one self-contained token per
line, with readable UD part-of-speech and feature strings, explicit sandhi/compound splitting,
unsandhied forms, stable DCS identifiers, and dependency trees for a subset of texts. Per
upstream, the CoNLL-U format "changed in the 2022-08-09 release to comply with the UD standard,"
so the gap between the two vintages is not merely *more data* but a format redesign.

This creates a concrete reuse problem. The maintained, broader, UD-standard distribution is the
right basis for new work, but it is a directory of ~15,900 plain-text files, not a queryable
database, and it shares no obvious key with the relational export that the existing tooling
expects. We close this gap. We build a single **queryable SQLite master** plus tidy CSV exports
directly from the CoNLL-U distribution, pinned to one upstream commit for reproducibility; we
prove and use a **lemma-keyed cross-walk** to the 2021 vintage so that old and new can be joined;
and we validate the result under CI. This paper is the *data descriptor* for that release.

Our claims are modest and data-oriented:

1. **A query-ready, validated DCS-2026 master exists and is reproducible** from one pinned
   upstream commit, with a published artifact and (on acceptance) a minted DOI.
2. **The 2021 and 2026 vintages are joinable on `LemmaId`**, verified token-for-token, with a
   measured coverage diff (texts and lemmas added/removed) and a learned 2021-code→UD-feature map
   for verbs.
3. **The release is honest about UD's limits for Sanskrit** — the aorist/perfect collapse and the
   non-unique corpus IDs are documented as first-class caveats, not hidden behind clean totals.

## 2. Related work  *(TODO — to be written)*

Position against: (a) the DCS itself and Hellwig's publications describing its annotation; (b) UD
treebank and corpus *data descriptors* as a genre (what an LR-track / RDJ / JOHD descriptor is
expected to document — schema, provenance, validation, licence); (c) other Sanskrit corpus and
treebank releases and the Sanskrit-NLP tooling that consumes them. The **novelty claim** is not
new annotation but the *validated, reproducible, query-ready packaging* of the current DCS plus
the documented, tested 2021→2026 cross-walk that lets the large installed base of relational-export
tooling migrate. Keep this section short and precise — a descriptor's related work is orientation,
not a survey.

## 3. Data and method

### 3.1 Source and pinning
The single source of truth is the DCS CoNLL-U distribution, mirrored at `gasyoun/dcs-conllu`
(upstream `OliverHellwig/sanskrit`, path `dcs/data/conllu`) and **pinned to commit
`04e0778d3dc971030229179e25eea043d06ff397`** (upstream release 2026-03-05), recorded in a
`provenance` table inside the database so the import is reproducible. Re-pinning is deliberate, via
[`check_conllu_updates.py`](../src/DCS-data-2026/check_conllu_updates.py), which flags upstream
commits after the pin. The two DCS serialisations and their differences (data model, morphology
representation, sandhi layer, partial syntax, encoding of anusvāra) are documented and verified
same-text in [`DCS_FORMAT_COMPARISON.md`](../src/DCS-data-2026/DCS_FORMAT_COMPARISON.md).

### 3.2 Pipeline
The build follows the eight-milestone plan in
[`DCS_CONLLU_IMPORT_PLAN.md`](../src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md), all complete:
acquire & pin (M0) → lossless CoNLL-U parse to staging JSONL ([`parse_conllu.py`](../src/DCS-data-2026/parse_conllu.py), M1) →
build the normalized SQLite master ([`import_dcs_conllu.py`](../src/DCS-data-2026/import_dcs_conllu.py), M2) →
align & coverage-diff against the 2021 export ([`coverage_diff.py`](../src/DCS-data-2026/coverage_diff.py), M3) →
clean + legacy CSV exports ([`export_master.py`](../src/DCS-data-2026/export_master.py), M4) →
validate ([`validate.py`](../src/DCS-data-2026/validate.py), M5–M6) →
regenerate the derivable dashboard widgets ([`regen_widgets.py`](../src/DCS-data-2026/regen_widgets.py), M7) →
land + publish (M8). The parser is lossless: MWT spans, every FEATS key (including the DCS-specific
`Formation`), every MISC key (`LemmaId`, `OccId`, `Unsandhied`, `WordSem`), and `HEAD`/`DEPREL`
where present.

### 3.3 Schema (flatten-all)  *(TODO: paste the verified per-column schema table)*
The master uses a **flatten-all** schema — every common FEATS/MISC key becomes its own column on
`token` rather than a tidy key/value side-table. The tables (verified on the pilot
`dcs.sqlite`) are: `text(text_id, name, has_dependencies)`, `chapter(chapter_id, text_id, ref)`,
`sentence(id, sent_id, chapter_id, sent_counter, sent_subcounter, text_sandhied)`,
`token(id, sentence_id, occ_id, sent_id, idx, form, lemma, lemma_id, upos, xpos, head, deprel,
deps, feat_case, feat_gender, feat_number, feat_tense, feat_mood, feat_person, feat_verbform,
feat_voice, feat_formation, m_unsandhied, m_unsandhiedreconstructed, m_wordsem, m_punctuation,
m_annotator)`, `mwt(id, sentence_id, sent_id, span, form)`,
`lemma(lemma_id, lemma, grammar, preverbs, meanings)`, and `provenance(key, value)`. Note the
**synthetic integer `id` PKs** on `sentence` and `token` (the reason is in §6). Tidy CSV exports
(`sentences.csv`, `tokens.csv`, `lemmas.csv`, `tokens_wide.csv`) and legacy compatibility exports
(`0.csv`, `_8.csv`, best-effort `10.csv`) regenerate from the master.

### 3.4 The 2021→2026 cross-walk  *(TODO: paste the M4 code-map table)*
The integer lemma IDs the 2021 `0.csv` stores per sentence are *exactly* the CoNLL-U `LemmaId`
values, verified token-for-token on a shared verse: the 13-ID sequence of the first
Abhidhānacintāmaṇi line is IDENTICAL across both serialisations. `LemmaId` is therefore the
primary join key between vintages. For verbs we additionally **learned** a map from the 2021
`15.csv` numeric tense/mood codes (named in `timws.csv`) to observed UD `Tense|Voice|Mood`
combinations (M4): codes 1–5 and 24 map exactly; 31 of 33 attested codes resolve. Old per-row
PKs (`10.txt`) occupy a *different* ID space from CoNLL-U `OccId`, so individual 2021 rows cannot
be patched — the refresh rebuilds wholesale (consistent with the "full refresh" decision).

## 4. Results

All figures are from the full master `dcs_full.sqlite` (all 270 texts) unless noted, transcribed
from [`reports/m6_validation.md`](../src/DCS-data-2026/reports/m6_validation.md) and
[`reports/m7_widgets.md`](../src/DCS-data-2026/reports/m7_widgets.md).

### 4.1 Corpus headline (verified)

| metric | value | source |
|---|---:|---|
| texts | **270** | M6 / M7 |
| dependency-annotated (treebank) texts | **74** | M7 |
| sentences | **754,726** | M6 / M7 |
| tokens | **5,688,416** | M6 / M7 |
| distinct attested lemmas | **98,606** | M6 / M7 / coverage_diff |
| UPOS=VERB tokens | **1,007,361** | M7 |

> **Lemma-count provenance — do not conflate.** 98,606 is the **2026** distinct-attested-lemma
> count. The vendored [`dcs_lemma_summary.json`](../dcs_lemma_summary.json) is a **DCS-2021** asset
> (`corpusRelease: DCS-2021`, `lemmaCount: 83,239` — the 2021 attested headword list); 91,406 is
> the 2021 attested-by-`LemmaId` count from the coverage diff. The release headline is 98,606.

### 4.2 Coverage diff, 2021 vs 2026 (verified)
Text coverage grew from 246 to 270 texts: 240 of 246 matched a 2026 counterpart, **30 added**
(mostly Vedic Śrautasūtras / Brāhmaṇas — Taittirīyabrāhmaṇa, Kāṭhakasaṃhitā, Saddharmapuṇḍarīkasūtra,
Harivaṃśa, …), **6 only-2021** (including one rename). Lemma coverage by exact `LemmaId` cross-walk:
2021 attested **91,406**, 2026 attested **98,606**, shared **89,645**, only-2021 **1,761**,
only-2026 **8,961** — **Jaccard overlap 89.3%** of the union. *(TODO: add the per-text count-delta
sample table from coverage_diff if the venue allows the space.)*

### 4.3 Validation (verified, all PASS)
The CI-gated `validate.py --all` over the full master reports: coverage **270 texts / 98,606
lemmas / 5,688,416 tokens** (matches upstream); position-based cross-walk over **754,726 sentences,
0 mismatches**; referential integrity **0 orphans** (tokens→lemma, tokens→sentence, sentences→chapter,
chapters→text); full-token spot checks over **200 verses, 0 mismatches** (every field: form,
lemma_id, upos, head, deprel, all FEATS). The pilot run additionally confirmed **idempotency** —
the database built twice yields an identical data hash (`60a4d07156ad9d30…`).

### 4.4 Verb-form distribution (verified, with caveats)
The 2026 master has **1,007,361** UPOS=VERB tokens vs the 2021 38-category extract's 741,782 verbal
examples; the increase is corpus growth plus a methodological difference (2026 counts every VERB
token directly). The largest UD-feature buckets: Past Passive Participle 216,803; Present Active
180,040; Absolutive 102,054; the combined **Perfect/Aorist Active 92,570** (see §6). A Pareto view
of the 38-category map: the top 5 forms cover 67.65% and the top 11 cover 94.6% of verbal tokens.

## 5. Discussion

A queryable, validated master changes what is cheap. Frequency questions that previously required
bespoke joins across several relational-export tables (decoding DCS numeric codes) become single
SQL queries over readable UD features; the `has_dependencies` flag lets a consumer restrict to the
74-text treebank subset for syntactic work; and the `LemmaId` cross-walk means the large installed
base of tools built on the 2021 export can be migrated rather than rewritten. Because the import is
pinned and idempotent, every reported number is reproducible from one command and one SHA — the
property that distinguishes a data *descriptor* from a one-off dump. The release is intentionally a
*layer over* the DCS, not a re-annotation: it adds queryability, validation, provenance, and a
documented bridge, and changes none of Hellwig's annotation decisions.

## 6. Limitations

Three are load-bearing for any reuse and are documented in
[`reports/m7_widgets.md`](../src/DCS-data-2026/reports/m7_widgets.md):

- **Aorist/perfect collapse under UD `Tense`.** UD's `Tense` inventory has no Aorist or Perfect
  value, so both surface as a single `Tense=Past` bucket (≈102k tokens), distinct only from
  `Tense=Impf` (≈47k). The DCS-specific `feat_formation` (root/peri/s/red…) that could re-split
  them is present on **<2%** of verbs — too sparse. Consumers needing the aorist≠perfect distinction
  must not read it off `Tense=Past`.
- **Non-unique corpus IDs → synthetic PKs.** The corpus reuses `OccId` across a line's
  sub-sentences, and `sent_id` collides *within* chapters (≈449 sentences would have been silently
  dropped if keyed on it). The master therefore keys both `token` and `sentence` on a **synthetic
  integer `id`**, retaining `occ_id`/`sent_id` as non-key attributes, and validates cross-walk
  position-based rather than by `sent_id`.
- **UD tagset vintage and the legacy `10.csv`.** UPOS uses the older UD inventory (`CONJ`/`PART`,
  not UDv2 `CCONJ`/`SCONJ`) plus a DCS-specific `Case=Cpd` for compound members. The 2021
  occurrence-keyed `10.csv` cannot be reproduced byte-for-byte (its 2021-internal sentence/occurrence
  IDs have no 2026 counterpart; only `LemmaId` bridges), so it is regenerated UD-faithful + best-effort
  legacy codes, not as a byte-match.

Two further scope notes: some dashboard widgets are **not derivable** from the CoNLL-U alone —
`dcs_genres.json` / `dcs_scatter.json` need per-text genre+date metadata the corpus does not carry,
and `anki_compact.json` / `passage_library.json` are hand-curated. Anusvāra differs between vintages
(2021 `ṁ` U+1E41 vs 2026 `ṃ` U+1E43) and must be normalised before cross-vintage string matching.

## 7. Conclusion

DCS-2026 is a FAIR, reproducible, query-ready packaging of the current Digital Corpus of Sanskrit:
a normalized SQLite master and tidy exports over 270 texts, 5,688,416 tokens, 754,726 sentences,
and 98,606 lemmas (74 dependency-annotated), built losslessly from a single pinned upstream commit,
validated under CI, and bridged to the established 2021 relational ecosystem by a verified
`LemmaId` cross-walk. It does not re-annotate Sanskrit; it makes the annotation that exists
queryable, reproducible, and honest about the few places where Universal Dependencies and reused
identifiers do not fit Sanskrit cleanly.

## 8. Data and reproducibility

- **Artifact.** Full master `dcs_full.sqlite` (≈920 MB; ≈287 MB gz) published as a GitHub Release
  `dcs-full-2026-03-05` on the VisualDCS repo; regenerable via
  `python src/DCS-data-2026/import_dcs_conllu.py --all` from the pinned source. *(TODO: add the
  release URL and the `dcs_full.sqlite.gz` SHA256.)*
- **Source pin.** `gasyoun/dcs-conllu` @ `04e0778d3dc971030229179e25eea043d06ff397` (upstream
  `OliverHellwig/sanskrit`, 2026-03-05); recorded in the `provenance` table.
- **Reproduce the headline.** `python src/DCS-data-2026/validate.py --all` regenerates the M6 figures
  against the master.
- **DOI.** _(TODO: mint via Zenodo↔GitHub on the VisualDCS repo; insert the DOI here before submission.)_
- **Licence.** Upstream DCS CoNLL-U is CC BY 4.0 (Oliver Hellwig). The derived master + exports are
  released under CC BY with attribution. _(TODO: confirm explicit redistribution sign-off from
  O. Hellwig and lock the exact upstream citation string.)_
- **Cite the corpus.** Hellwig, Oliver. *The Digital Corpus of Sanskrit (DCS).* 2010–2024.
- **Provenance docs.** [`src/DCS-data-2026/README.md`](../src/DCS-data-2026/README.md),
  [`DCS_FORMAT_COMPARISON.md`](../src/DCS-data-2026/DCS_FORMAT_COMPARISON.md),
  [`DCS_CONLLU_IMPORT_PLAN.md`](../src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md).
