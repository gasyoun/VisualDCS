# DCS 2021 → 2026 drift interpretation — what the delta means (H686 supplement)

_Created: 12-07-2026 · Last updated: 12-07-2026_

Supplement to
[`REPORT.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/REPORT.md)
(the primary H686 pass, [PR #37](https://github.com/gasyoun/VisualDCS/pull/37)), written by
Fable 5 (`claude-fable-5`) for
[H686](https://github.com/gasyoun/Uprava/blob/main/handoffs/H686-Fable_VisualDCS_dcs-2021-2026-delta-stats_11.07.26.md).
`REPORT.md` counts the delta; this file is the interpretation layer — what the drift
means, plus an independent replication by
[`delta_supplement.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/delta_supplement.py)
that confirms `REPORT.md`'s headline numbers via the exact `LemmaId` cross-walk (2021
tokens 4,577,913 from `0.csv` id-lists vs 4,577,461 from `_8.csv` — a 452-token, 0.01%
gap between the two independent 2021 aggregations; everything else matches).

Machine-readable companions added here:
[`lemma_freq_drift_top200.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/lemma_freq_drift_top200.csv)
(per-10k rates + rank shift, union of both top-200s) ·
[`pos_distribution_shift.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/pos_distribution_shift.csv) ·
[`per_text_token_delta.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/per_text_token_delta.csv)
(all 240 matched + 30 only-2026 + 6 only-2021 texts) ·
[`supplement_tables.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Corpus-Delta-2021-2026/supplement_tables.md)
(raw generated tables).

---

## 1. The delta is one story: the DCS went Vedic

The +1.11M tokens (+24.3%) are not spread evenly — the 30 only-2026 texts are
overwhelmingly Vedic ritual and exegetical literature (nine śrautasūtras, the
Taittirīya- and Kauṣītaki-brāhmaṇas, Taittirīyāraṇyaka, Kāṭhakasaṃhitā,
Vājasaneyisaṃhitā, the Paippalāda Atharvaveda …), plus two large non-Vedic additions,
the Harivaṃśa and the Saddharmapuṇḍarīkasūtra (list in
[`src/DCS-data-2026/reports/coverage_diff.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/coverage_diff.md)).
Every frequency mover in the top table lines up with that composition shift, in both
directions:

- **Up (Vedic-prose signature):** iti +41.1 per 10k (the quotative scaffolding of
  brāhmaṇa/sūtra prose), etad +19.9 and idam +12.0 (the deictics of ritual exposition),
  vai +18.0 (the Vedic emphatic, nearly doubling its rate), agni +12.8, atha +9.6
  (sūtra-initial "next"), as +9.2 (copula-heavy expository prose). Even tad's +16.1
  fits — brāhmaṇa prose is tad-dense. The same signature drives `REPORT.md`'s
  "entered the top-200" list: yaj, hu, soma, paśu, svāhā, devatā — the śrauta lexicon
  wholesale.
- **Down (epic/classical share diluted):** ca −32.2, tu −11.3, api −8.4, tathā −6.1,
  vac −8.0 (the epic *uvāca* formula), mahat −7.1 — and in `REPORT.md`'s rank-shift
  table, pāṇḍava, sūta, rāma, nṛpa, śara all falling. Nothing classical shrank in
  absolute terms; the epic layer was diluted by a quarter-corpus of new Vedic material.

**Rank stability at the top is high** — 2026's top-9 lemmas are 2021's top-9 permuted;
the biggest jump inside the top-20 is etad (18 → 10). Frequency work built on the 2021
top table (dashboard Pareto lists, teaching orders) is directionally safe, but rates
shift by up to ±12% relative even at ranks 1–3, so anything citing *rates* should cite
the 2026 master.

## 2. The 1,761 "only-2021" lemmas are mostly annotation drift, not lost text

Refinement of `REPORT.md` §4's second evidence bullet. The only-2021 attested lemma ids
carry just **7,747 tokens (0.17% of the 2021 corpus)**, and the highest-frequency ones
are almost all **a-privative adjectives/participles**: aprameya (284), anindita (227),
avadhya (191), aprāpta (125), svalpa (123), adīna (101), asakta (94), asahya (81),
pūrvokta (78), asambhrānta (73), avijñāta (62). These words did not leave the corpus —
the 2026 lemmatization resolves privative/preverb compounds to their bases (the same
policy change that makes the lemma "a" jump +18.3 per 10k, rank 112 → 32; treat that
mover as segmentation drift, not usage drift). 746 of the 1,761 ids are still in the
2026 dictionary (unattested), 1,015 are gone from it entirely. So the "unique data"
in the 2021 snapshot is smaller than the raw 1,761 suggests — but it is still nonzero,
which is why the registered keep-verdict stands (see §4).

## 3. Morphological texture is stable; per-text content is monotone

- **POS shift is bounded by ~1.5 pp** despite the 24.3% growth. Computed with one
  shared lexicon (the 2026 dictionary's grammar labels) applied to BOTH token streams —
  so tagset drift is excluded by construction: noun 43.9% → 42.4%, indeclinable 17.3% →
  18.0%, verbal root 17.1% → 17.7%, adjective 11.5% → 11.0%, pronoun 9.8% → 10.5%.
  Vedic prose trades some nominal style for particles, pronouns and finite verbs —
  exactly the sign pattern observed. (`REPORT.md` §2 gets the same signs with its
  2021-lexicon-vs-UD-UPOS bucketing; the agreement of the two methods is itself a
  robustness check.)
- **Only 10 of 240 matched texts shrank**, all trivially: Ṛgveda −873 tokens (−0.5%),
  Skandapurāṇa (Revākhaṇḍa) −679, Abhidharmakośa −240, then seven texts at −161 or
  less. Everything else is equal or larger in 2026 — the 2026 master is a clean
  superset at text level, minus cleanup-scale trims.
- Of the 6 only-2021 texts, 2 are 0-token stubs (Ekākṣarakoṣa, Nāḍīvijñāna) and 4 are
  fragmentary commentaries totalling **892 tokens** (Cakra ?) on Suśr 165, Comm. on the
  Kāvyālaṃkāravṛtti 393, Hārāṇacandara on Suśr 162,
  Khādiragṛhyasūtrarudraskandavyākhyā 172).

## 4. Verdict, restated with the refinement

The registered verdict (`REPORT.md` §4, census rows in
[`Uprava/DATA_LAYERS_CENSUS.md`](https://github.com/gasyoun/Uprava/blob/main/DATA_LAYERS_CENSUS.md)
flipped 11-07-2026) is **keep `src/DCS-data-2021/`, no archive/delete @DO** — this
supplement confirms it, with sharpened weights on the evidence:

- The *corpus-content* argument is weaker than it looks: 892 tokens of real only-2021
  text + mostly-annotation-drift lemma losses. For any **statistic**, the 2026 master
  supersedes the 2021 snapshot — never compute a current number from `DCS-data-2021/`.
- The *decisive* keep-arguments are the non-corpus ones: the derived-analysis layer
  (`texts.csv` dates/authors/POS profiles, `timws.csv` 38-category tense/mood table,
  `111.csv` collocations, `verx.csv` endings) and the Free Pascal tools are VisualDCS's
  own work feeding the live dashboards, and the 2021-internal row IDs/morph code tables
  (`10.csv`, `12.csv`, `15.csv`) are irreproducible from 2026 (M4,
  [`src/DCS-data-2026/reports/m4_exports.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m4_exports.md)).

## 5. Standing caveats (noted, not re-derived)

- UD `Tense=Past` conflates aorist/perfect in the 2026 master (M7,
  [`src/DCS-data-2026/reports/m7_widgets.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m7_widgets.md)) —
  tense-level 2021↔2026 comparisons must use the legacy 38-category codes, not UD
  features. Both H686 passes stay at token/lemma/POS level where this is irrelevant.
- Sentence counts are structurally incomparable (one 2021 metrical line ↔ several
  CoNLL-U sentences); tokens are the comparable unit.
- Text matching is the M3 rule (exact → normalized → abbreviation) plus a "NEW"-suffix
  rename fix (Gopathabrāhmaṇa NEW ↔ Gopathabrāhmaṇa, 7,468 tokens — without it the
  only-2021 list wrongly gains a 7th text).

_Dr. Mārcis Gasūns_
