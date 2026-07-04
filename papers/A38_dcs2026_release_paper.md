---
paper_id: A38
title: "The Digital Corpus of Sanskrit 2026: An Open Treebank-and-Morphology SQLite Release with a Validated 2021→2026 Cross-Walk"
status: draft (expanded skeleton, 3/5) — scaffolded 2026-06-26, expanded 2026-07-04
readiness: 3/5
venue: "LREC-COLING (LR track) / Research Data Journal / JOHD"
author: "**Mārcis Gasūns**, independent scholar ([ORCID 0000-0003-4513-884X](https://orcid.org/0000-0003-4513-884X)), gasyoun@ya.ru"
data_source: "src/DCS-data-2026/ (master built M0–M8; figures verified against reports/m6_validation.md + reports/m7_widgets.md)"
---

# The Digital Corpus of Sanskrit 2026: An Open Treebank-and-Morphology SQLite Release with a Validated 2021→2026 Cross-Walk

_Created: 26-06-2026 · Last updated: 04-07-2026_

> **Draft status (2026-07-04, readiness 3/5).** Manuscript built directly on the completed
> data work in [`src/DCS-data-2026/`](https://github.com/gasyoun/VisualDCS/tree/main/src/DCS-data-2026)
> (milestones M0–M8 done, per
> [`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md)).
> **Every numeric claim below is transcribed from the verified validation reports**
> ([`reports/m6_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m6_validation.md),
> [`reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md),
> [`reports/coverage_diff.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/coverage_diff.md),
> [`reports/m4_exports.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m4_exports.md))
> and recomputes via `python src/DCS-data-2026/validate.py --all`; §4.5 gives the
> claim-by-claim artifact inventory. **Still open before submission:**
> (1) mint the Zenodo DOI and fill the data-availability statement (MG action — see
> [`A38_release_checklist.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_release_checklist.md));
> (2) obtain Oliver Hellwig's CC-BY redistribution sign-off and lock the upstream citation
> string (email queued in the GTD hub); (3) confirm the byline; (4) verify the exact
> bibliographic details of the §2 references against the published versions.

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
UD features. Validation passes at scale: cross-walk (0 mismatches over 754,726 sentences),
referential integrity (0 orphans), and full-token spot checks (200 verses, 0 mismatches); the
pilot pipeline runs CI-gated and additionally confirms idempotency (identical data hash on
re-build). We are deliberately explicit about two annotation
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

**Division of labor (companion papers).** This descriptor is deliberately narrow: it publishes
the corpus packaging and its denominator — **98,606 distinct attested lemmas** — and nothing
else. Two companion studies *consume* that denominator and are not anticipated here: the CDSL
headword-inventory growth census (paper A40), which joins dictionary headword lists against the
DCS lemma inventory to type corpus-unattested headwords, and the Monier-Williams botanical
crosswalk (paper A45), which measures corpus coverage of plant-name vocabulary. Neither paper's
analytical claims (headword-growth rates, botanical attestation profiles) appear in this one;
conversely, this paper's totals are the citable baseline both build on. Publishing the
denominator once, here, is what makes those measurements reproducible rather than ad-hoc.

## 2. Related work

**The corpus itself.** The DCS is built and maintained by Oliver Hellwig; its annotation
pipeline and design are described in Hellwig's publications on the corpus and its tooling —
the corpus overview (Hellwig 2010–2024, digital publication), the neural
sandhi-and-compound-splitting line of work that underlies the tokenisation (Hellwig & Nehrdich
2018), and, for the dependency layer, the Vedic treebank (Hellwig, Scarlata, Ackermann & Widmer
2020; Biagetti, Zehnder et al. subsequent extensions). *(Verify exact bibliographic strings
before submission.)* This paper adds no annotation; every linguistic decision in the data is
upstream's.

**The format target.** The 2026 distribution follows Universal Dependencies (Nivre et al. 2016;
Nivre et al. 2020 for UD v2), with DCS-specific extensions in FEATS/MISC (e.g. `Formation`,
`LemmaId`, `OccId`, `Unsandhied`, `WordSem`). One finding of our packaging work is that the
distribution's UPOS inventory retains pre-v2 values (`CONJ`, `PART` rather than `CCONJ`/`SCONJ`)
and a non-standard `Case=Cpd` for compound members (§6) — exactly the kind of detail a data
descriptor exists to put on record.

**The genre.** We follow the conventions of language-resource *data descriptors* (LREC resource
papers; *Research Data Journal for the Humanities and Social Sciences*; *Journal of Open
Humanities Data*): what is documented is provenance, schema, validation, licence, and access,
with the novelty claim confined to the packaging. Comparable precedents are the published
descriptors of derived, re-packaged corpora rather than of new primary resources.

**Sanskrit-NLP consumers.** The relational 2021 export has an installed base: frequency
dashboards (this project), lexicographic frequency layers, headword-attestation checks, and
cross-linking into the Cologne Digital Sanskrit Dictionaries (CDSL) ecosystem. §5 documents five
concrete consumers of the present release. The cross-walk section (§3.4) exists precisely
because this installed base cannot be rewritten wholesale.

A descriptor's related work is orientation, not a survey; we keep it at that.

## 3. Data and method

### 3.1 Source and pinning
The single source of truth is the DCS CoNLL-U distribution, mirrored at
[`gasyoun/dcs-conllu`](https://github.com/gasyoun/dcs-conllu) (upstream `OliverHellwig/sanskrit`,
path `dcs/data/conllu`) and **pinned to commit
`04e0778d3dc971030229179e25eea043d06ff397`** (upstream release 2026-03-05), recorded in a
`provenance` table inside the database so the import is reproducible. Re-pinning is deliberate, via
[`check_conllu_updates.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/check_conllu_updates.py),
which flags upstream commits after the pin. The two DCS serialisations and their differences
(data model, morphology representation, sandhi layer, partial syntax, encoding of anusvāra) are
documented and verified same-text in
[`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md).

### 3.2 Pipeline
The build follows the nine-milestone plan (M0–M8) in
[`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md),
all complete: acquire & pin (M0) → lossless CoNLL-U parse to staging JSONL
([`parse_conllu.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/parse_conllu.py), M1) →
build the normalized SQLite master
([`import_dcs_conllu.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_dcs_conllu.py), M2) →
align & coverage-diff against the 2021 export
([`coverage_diff.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/coverage_diff.py), M3) →
clean + legacy CSV exports
([`export_master.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/export_master.py), M4) →
validate ([`validate.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/validate.py), M5–M6) →
regenerate the derivable dashboard widgets
([`regen_widgets.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/regen_widgets.py), M7) →
land + publish (M8). The parser is lossless: MWT spans, every FEATS key (including the DCS-specific
`Formation`), every MISC key (`LemmaId`, `OccId`, `Unsandhied`, `WordSem`), and `HEAD`/`DEPREL`
where present.

### 3.3 Schema (flatten-all)
The master uses a **flatten-all** schema — every common FEATS/MISC key becomes its own column on
`token` rather than a tidy key/value side-table. The static core (per `create_schema()` in
[`import_dcs_conllu.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_dcs_conllu.py)) is:

| table | columns |
|---|---|
| `text` | `text_id` PK, `name`, `has_dependencies` |
| `chapter` | `chapter_id` PK, `text_id`, `ref` |
| `sentence` | **synthetic `id` PK**, `sent_id`, `chapter_id`, `sent_counter`, `sent_subcounter`, `text_sandhied` |
| `token` | **synthetic `id` PK**, `sentence_id`, `occ_id`, `sent_id`, `idx`, `form`, `lemma`, `lemma_id`, `upos`, `xpos`, `head`, `deprel`, `deps`, + dynamic columns |
| `mwt` | `id` PK, `sentence_id`, `sent_id`, `span`, `form` |
| `lemma` | `lemma_id` PK, `lemma`, `grammar`, `preverbs`, `meanings` (from the upstream `dictionary.csv`, 180,176 entries) |
| `provenance` | `key` PK, `value` (source SHA, build parameters) |

FEATS/MISC columns are **added on demand** during import (`ALTER TABLE token ADD COLUMN`), so the
`token` table grows exactly the columns the corpus attests: `feat_case`, `feat_gender`,
`feat_number`, `feat_tense`, `feat_mood`, `feat_person`, `feat_verbform`, `feat_voice`,
`feat_formation`, `m_unsandhied`, `m_unsandhiedreconstructed`, `m_wordsem`, `m_punctuation`,
`m_annotator` (list verified on the pilot build; the full master carries the same set). Note the
**synthetic integer `id` PKs** on `sentence` and `token` — the reason is a corpus property, not a
design taste (§6). Tidy CSV exports (`sentences.csv`, `tokens.csv`, `lemmas.csv`,
`tokens_wide.csv`) and legacy compatibility exports (`0.csv`, `_8.csv`, best-effort `10.csv`)
regenerate from the master.

### 3.4 The 2021→2026 cross-walk
The integer lemma IDs the 2021 `0.csv` stores per sentence are *exactly* the CoNLL-U `LemmaId`
values, verified token-for-token on a shared verse: the 13-ID sequence of the first
Abhidhānacintāmaṇi line is IDENTICAL across both serialisations. `LemmaId` is therefore the
primary join key between vintages. For verbs we additionally **learned** a map from the 2021
`15.csv` numeric tense/mood codes (named in `timws.csv`) to observed UD `Tense|Voice|Mood`
combinations on the same forms (M4; transcribed from
[`reports/m4_exports.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m4_exports.md)).
The high-frequency codes resolve exactly; 31 of 33 attested codes resolve overall. An excerpt
(full table in the report):

| 2021 code | `timws.csv` name | forms (pilot) | dominant UD (Tense\|Voice\|Mood) |
|---:|---|---:|---|
| 1 | Present Active | 10,279 | `Tense=Pres\|Mood=Ind` |
| 2 | Potential Active | 4,804 | `Tense=Pres\|Mood=Opt` |
| 3 | Imperative Active | 4,386 | `Tense=Pres\|Mood=Imp` |
| 4 | Imperfect Active | 4,631 | `Tense=Impf\|Mood=Ind` |
| 5 | Future Active | 2,636 | `Tense=Fut\|Mood=Ind` |
| 15 | Perfect Active | 2,772 | `Tense=Past\|Mood=Ind` |
| 10–13 | Aorist Active/Medium | 701 | `Tense=Past\|Mood=Ind` |
| 24 | Present Passive | 1,809 | `Tense=Pres\|Voice=Pass\|Mood=Ind` |

The Perfect and Aorist rows landing in the *same* UD bucket is not a mapping error — it is the
UD `Tense=Past` collapse documented in §6, and the map is the concrete evidence for it. The map
is learned on the pilot scope (13 texts) and covers the tense-codes attested there; two rare
codes (35, 37) had no pilot match. Old per-row PKs (`10.txt`) occupy a *different* ID space from
CoNLL-U `OccId`, so individual 2021 rows cannot be patched — the refresh rebuilds wholesale
(consistent with the "full refresh" decision).

## 4. Results

All figures are from the full master `dcs_full.sqlite` (all 270 texts) unless noted, transcribed
from [`reports/m6_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m6_validation.md) and
[`reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md).

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
> count. The vendored
> [`dcs_lemma_summary.json`](https://github.com/gasyoun/VisualDCS/blob/main/dcs_lemma_summary.json)
> is a **DCS-2021** asset (`corpusRelease: DCS-2021`, `lemmaCount: 83,239` — the 2021 attested
> headword list); 91,406 is the 2021 attested-by-`LemmaId` count from the coverage diff. The
> release headline is 98,606.

### 4.2 Coverage diff, 2021 vs 2026 (verified)
Text coverage grew from 246 to 270 texts: 240 of 246 matched a 2026 counterpart, **30 added**
(mostly Vedic Śrautasūtras / Brāhmaṇas — Taittirīyabrāhmaṇa, Kāṭhakasaṃhitā, Saddharmapuṇḍarīkasūtra,
Harivaṃśa, …), **6 only-2021** (including one rename). Lemma coverage by exact `LemmaId` cross-walk:
2021 attested **91,406**, 2026 attested **98,606**, shared **89,645**, only-2021 **1,761**,
only-2026 **8,961** — **Jaccard overlap 89.3%** of the union.

Per-text count deltas illustrate the structural re-segmentation: token counts stay nearly
constant while sentence counts shift, because one 2021 metrical line maps to several CoNLL-U
sentences. A sample (pilot scope, from
[`reports/coverage_diff.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/coverage_diff.md)):

| text | 2021 sent | 2026 sent | 2021 tok | 2026 tok |
|---|---:|---:|---:|---:|
| Abhidhānacintāmaṇi | 932 | 677 | 4,326 | 4,471 |
| Amaruśataka | 106 | 212 | 3,219 | 3,221 |
| Arthaśāstra | 1,921 | 2,067 | 19,415 | 20,399 |
| Daśakumāracarita | 1,897 | 2,129 | 35,076 | 35,188 |
| Gītagovinda | 428 | 692 | 6,020 | 6,020 |
| Hitopadeśa | 718 | 3,432 | 24,958 | 25,040 |
| Kumārasaṃbhava | 613 | 1,225 | 10,237 | 10,261 |
| Meghadūta | 122 | 244 | 3,387 | 3,393 |

(Atharvavedapariśiṣṭa's 24→1,695 token jump reflects genuinely expanded 2026 coverage, not
re-segmentation; the pilot's Ṛgveda row is excluded here because the pilot capped it at 80 files.)

### 4.3 Validation (verified, all PASS)
`validate.py --all` over the full master (a recorded manual run; CI gates the pilot-scope
pipeline on every push) reports: coverage **270 texts / 98,606
lemmas / 5,688,416 tokens** (matches upstream); position-based cross-walk over **754,726 sentences,
0 mismatches**; referential integrity **0 orphans** (tokens→lemma, tokens→sentence, sentences→chapter,
chapters→text); full-token spot checks over **200 verses, 0 mismatches** (every field: form,
lemma_id, upos, head, deprel, all FEATS). The pilot run additionally confirmed **idempotency** —
the database built twice yields an identical data hash (`60a4d07156ad9d30…`).

### 4.4 Verb-form distribution (verified, with caveats)
The 2026 master has **1,007,361** UPOS=VERB tokens vs the 2021 `timws.csv`-binned extract's
741,782 verbal examples (30 attested categories; the Excel-derived 38-category dashboard total,
781,616, is a separate aggregation of the same 2021 vintage and is not the comparandum here); the
increase is corpus growth plus a methodological difference (2026 counts every VERB token
directly). The largest UD-feature buckets: Past Passive Participle 216,803; Present Active
180,040; Absolutive 102,054; the combined **Perfect/Aorist Active 92,570** (see §6). A Pareto view
of the 38-category map: the top 5 forms cover 67.65% and the top 11 cover 94.6% of verbal tokens.

### 4.5 Claim-to-artifact inventory

Every headline figure in this paper traces to a committed, public artifact:

| claim | value | committed artifact |
|---|---|---|
| corpus totals (texts/sentences/tokens/lemmas/treebank) | 270 / 754,726 / 5,688,416 / 98,606 / 74 | [`reports/m6_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m6_validation.md), [`reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md) |
| verb totals + category table + Pareto | 1,007,361 VERB tokens; top-5 = 67.65% | [`reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md) |
| 2021↔2026 coverage diff | 246→270 texts; 89.3% lemma Jaccard | [`reports/coverage_diff.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/coverage_diff.md) |
| verb code map + legacy export diff | 31/33 codes resolve | [`reports/m4_exports.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m4_exports.md) |
| validation suite (full master manual run all PASS; pilot suite CI-gated) | see §4.3 | [`validate.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/validate.py), [`reports/m6_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m6_validation.md), [`reports/m5_validation.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m5_validation.md), [`.github/workflows/dcs-validate.yml`](https://github.com/gasyoun/VisualDCS/blob/main/.github/workflows/dcs-validate.yml) |
| published master | 287,713,306-byte gz, SHA256 `b9b76218…4a86b5` | Release [`dcs-full-2026-03-05`](https://github.com/gasyoun/VisualDCS/releases/tag/dcs-full-2026-03-05) |
| source pin | `04e0778d…` (2026-03-05) | `provenance` table; [`check_conllu_updates.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/check_conllu_updates.py) |
| format comparison (incl. anusvāra) | same-text verified | [`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md) |

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

### 5.1 Uptake: live consumers

Within a month of the build (June–July 2026), three independent downstream pipelines consume the
DCS-2026 master rather than re-parsing CoNLL-U — the practical test of a packaging claim:

1. **CDSL dictionary search (csl-apidev).** The clean lemma export feeds the word-frequency
   ranking refresh of the Cologne "simple search"
   ([`simple-search/wf1/wf.txt`](https://github.com/sanskrit-lexicon/csl-apidev/blob/main/simple-search/wf1/wf.txt))
   and a **15,902-lemma DCS↔CDSL crosswalk**, 12,945 of them (81.4%) linked to a CDSL headword
   ([`dcs_cdsl_xref.tsv`](https://github.com/sanskrit-lexicon/csl-apidev/blob/main/simple-search/dcs_xref/dcs_cdsl_xref.tsv)),
   both byte-reproducible from scripts committed beside them.
2. **Dictionary-sense verification (MWS).** DCS-2026 sentence contexts back a sense-verification
   sample for Monier-Williams citation-register work
   ([`sense_verify/`](https://github.com/sanskrit-lexicon/MWS/blob/master/papers/p3_citation_registers/sense_verify/README.md)).
3. **This project's own dashboards** (verb-form frequency, paradigm browser) — the original
   consumer the packaging was built for.

The *companion* research-archive release (§6.1) — a separate artifact, outside this descriptor's
validation claims — already feeds two further pipelines of its own: a lexicographic frequency
sidecar of 83,277 rows
([`kosha/lemma_frequency.tsv`](https://github.com/gasyoun/kosha/blob/main/data/frequency/lemma_frequency.tsv))
and, through it, the corpus-payoff ordering of a PWG→Russian translation worklist. We list these
separately, not as uptake of the master.

## 6. Limitations

Three are load-bearing for any reuse; each is documented at its source — the tense collapse in
[`reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md),
the identifier collisions in
[`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md),
the tagset vintage and legacy-export limits in
[`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md)
and [`reports/m4_exports.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m4_exports.md):

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

### 6.1 What this release does *not* contain

The scope boundary matters for citation. **DCS-2026** = the SQLite master + CSV exports built
from the pinned CoNLL-U distribution, nothing more. Specifically excluded:

- **The research-archive database is a separate release.** A companion SQLite
  (`archive.sqlite`, Release
  [`archive-2026-07`](https://github.com/gasyoun/VisualDCS/releases/tag/archive-2026-07)) holds
  *derived research datasets* — intra-corpus parallel-passage search results, period/text
  frequency dictionaries, subhāṣita collections — built by a different pipeline
  ([`import_archive.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_archive.py))
  with its own provenance report. It is not part of the DCS-2026 master and is not covered by
  this descriptor's validation claims; it has its own consumers (§5.1's companion note) and its
  own queue of further planned integrations.
- **No genre/date metadata** (upstream does not distribute it in CoNLL-U).
- **No re-split of aorist vs perfect** (see above) and no per-root paradigm-cell attestation
  tables — those are dashboard-side derivations, not release tables.
- **No annotation changes of any kind** relative to the pinned upstream commit.

## 7. Conclusion

DCS-2026 is a FAIR, reproducible, query-ready packaging of the current Digital Corpus of Sanskrit:
a normalized SQLite master and tidy exports over 270 texts, 5,688,416 tokens, 754,726 sentences,
and 98,606 lemmas (74 dependency-annotated), built losslessly from a single pinned upstream commit,
validated under CI, and bridged to the established 2021 relational ecosystem by a verified
`LemmaId` cross-walk. It does not re-annotate Sanskrit; it makes the annotation that exists
queryable, reproducible, and honest about the few places where Universal Dependencies and reused
identifiers do not fit Sanskrit cleanly.

## 8. Data and reproducibility

- **Artifact.** Full master `dcs_full.sqlite` (≈880 MB; 287,713,306 bytes gz) published as GitHub
  Release [`dcs-full-2026-03-05`](https://github.com/gasyoun/VisualDCS/releases/tag/dcs-full-2026-03-05)
  — asset `dcs_full.sqlite.gz`, SHA256
  `b9b76218f7145776e6014f885dee5dd74d6a8f80b9eddc11c82a51c4ad4a86b5`; regenerable via
  `python src/DCS-data-2026/import_dcs_conllu.py --all` from the pinned source.
- **Source pin.** [`gasyoun/dcs-conllu`](https://github.com/gasyoun/dcs-conllu) @
  `04e0778d3dc971030229179e25eea043d06ff397` (upstream `OliverHellwig/sanskrit`, 2026-03-05);
  recorded in the `provenance` table.
- **Reproduce the headline.** `python src/DCS-data-2026/validate.py --all` regenerates the M6
  figures against the master.
- **DOI.** _(TODO: mint via Zenodo↔GitHub on the VisualDCS repo — MG action; steps in
  [`A38_release_checklist.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_release_checklist.md);
  insert the DOI here before submission.)_
- **Licence.** Upstream DCS CoNLL-U is **CC BY 4.0** (Oliver Hellwig; per the distribution's
  provenance and readme). The derived master + exports are released under **CC BY 4.0** with
  attribution to Hellwig for the annotation and to this project for the packaging. _(Open gate:
  explicit redistribution sign-off from O. Hellwig — email queued — and the locked upstream
  citation string.)_
- **Cite the corpus.** Hellwig, Oliver. *The Digital Corpus of Sanskrit (DCS).* 2010–2024
  (year range per the distribution's own readme; re-check against upstream when locking the
  citation string).
- **Cite the release.** See [`CITATION.cff`](https://github.com/gasyoun/VisualDCS/blob/main/CITATION.cff)
  at the repository root.
- **Provenance docs.**
  [`src/DCS-data-2026/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/README.md),
  [`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md),
  [`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md).

_Dr. Mārcis Gasūns_
