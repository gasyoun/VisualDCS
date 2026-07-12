# Sanskrit lexical semantic change pilot (LSC) — eval protocol + scores

_Created: 11-07-2026 · Last updated: 11-07-2026_

First lexical-semantic-change derivation for Sanskrit: the ACL Anthology's 81-paper LSC family
(73 papers since 2020) contains **no Sanskrit work** as of 11-07-2026 — measured in
[ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md](https://github.com/gasyoun/Uprava/blob/main/ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md)
(opportunity #1). Built by
[H728](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H728-Fable_VisualDCS_sanskrit-lsc-pilot_11.07.26.md),
Fable 5 (`claude-fable-5`). Task shape:
[SemEval-2020 Task 1](https://aclanthology.org/2020.semeval-1.1/) (binary + graded change);
metric caveats per [Goworek & Dubossarsky 2026](https://aclanthology.org/2026.lchange-1.13/).

## Files

| File | What |
|---|---|
| [build_lsc_pilot.py](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/build_lsc_pilot.py) | deterministic builder (two passes over dcs-conllu; `--selftest`) |
| [lsc_scores.tsv](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/lsc_scores.tsv) | 3,049 lemmas scoreable on ≥1 slot pair: per-slot counts, cosine distances, frequency-shift baseline, graded rank + binary flag (primary pair) |
| [lsc_targets.tsv](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/lsc_targets.tsv) | frequency-stratified 60-lemma target set (3 terciles × 10 top + 10 bottom graded) |
| [lsc_stats.json](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/lsc_stats.json) | build census + thresholds + control statistic |

## Data (all local, canonical — nothing re-derived)

- **Contexts:** the [dcs-conllu](https://github.com/gasyoun/dcs-conllu) checkout — DCS gold
  lemmatization, 63,600 chapter files, lemma column, IAST.
- **Dating:** [`lookup/chapter-info.xml`](https://github.com/gasyoun/dcs-conllu/blob/main/lookup/chapter-info.xml)
  `<dcsTimeSlot>` per chapter — DCS's own 5-slot chronology. Slot semantics were anchored
  empirically against texts of known date (not assumed): slot 1 holds Ṛgveda-khilāni /
  Atharvaveda / Brāhmaṇas (**Vedic**), slot 2 Mahābhārata / Rāmāyaṇa / Manu / Caraka /
  Arthaśāstra (**Epic / early**, ≈ −300…+300), slot 3 Kālidāsa / Kāmasūtra / Vāgbhaṭa /
  Bodhicaryāvatāra (**Classical**, ≈ 300–800), slot 4 Bhāgavatapurāṇa / Kathāsaritsāgara
  (**Medieval**, ≈ 800–1300), slot 5 Gheraṇḍasaṃhitā / Haṭhayogapradīpikā (**Late**, 1300+).
  17 chapters carry no slot and are excluded.
- **Cross-check:** the kosha
  [frequency layer](https://github.com/gasyoun/kosha/blob/main/data/frequency/lemma_frequency.tsv)
  per-period vectors (QL/FRQ_P coding) remain the org's canonical *frequency* asset; this
  derivation adds the *semantic* (distributional) layer the atlas agenda flagged as
  "needs net-new derivation".

## Method (deterministic; no neural components)

Count-based, offline, versioned — the same invariant as the csl-atlas embedding-lane rule
(H662): frozen inputs → reproducible ranks.

1. Per slot: bag-of-sentence lemma co-occurrence; context vocabulary = top 5,000 lemmas by
   whole-corpus count, shared across slots (vector spaces aligned by construction — no
   Procrustes step needed, unlike [Hamilton et al. 2016](https://aclanthology.org/P16-1141/)).
2. PPMI weighting per slot.
3. **Graded score** for a lemma between slots *i, j* = cosine distance between its PPMI
   vectors. Scoreable iff ≥50 tokens in both slots. Reported pairs: (1,2) (2,3) (3,4) (4,5)
   (1,5); **primary pair = 1→2 (Vedic→Epic)** — the two largest slots and the classic
   Vedic→post-Vedic semantic frontier.
4. **Binary flag** = top quartile of the primary graded score (threshold 0.9052) — an
   explicit heuristic pending a human-judged gold (see Next steps).
5. **Control:** frequency-shift baseline |log₂ relative-frequency ratio| per pair.

## Build census (11-07-2026)

| Measure | Value |
|---|---|
| Sentences / tokens / distinct lemmas | 754,561 / 5,687,226 / 90,331 |
| Tokens per slot 1…5 | 1,278,147 · 1,731,353 · 1,268,792 · 1,028,609 · 380,325 |
| Scoreable lemmas (≥50 in ≥2 slots) | 3,224 (3,049 written) |
| Primary pair (Vedic→Epic) scored | 1,258 lemmas |
| Binary threshold (q75 distance) | 0.9052 |
| **Spearman ρ, graded score vs frequency-shift** | **−0.013** |
| Target set | 60 (3 frequency terciles × 20) |

The ≈0 correlation with the frequency baseline is the key control: the graded ranking is not
a re-description of frequency change.

## Face validity (not a gold evaluation)

Known Vedic→post-Vedic semantic movers rank high on the primary pair while stable
high-frequency referential/function lemmas rank at the bottom (rank out of 1,258; 1 = most
changed):

| Lemma | Rank | Reading |
|---|---|---|
| dharman | 165 | Vedic *dharman* n. recedes as *dharma* m. takes over post-Vedically |
| ṛta | 223 | the Vedic cosmic-order term collapses in Epic usage (n₂ = 57) |
| māyā | 356 | "wondrous power" → "illusion" trajectory |
| kratu | 485 | "resolve/sacrificial power" narrows |
| asura | 753 | "lord/god" → "demon"; mid-rank fits the flip completing after Epic |
| agni · na · ca · go · deva | 1256 · 1255 · 1240 · 1238 · 1159 | stable — as expected |

## Limitations (read before citing)

- **Sparsity/frequency bias:** count-based cosine distances run high for low-count lemmas
  (the q75 of 0.905 reflects sparse vectors, not rampant change) — a documented artifact of
  PPMI-cosine LSC. Compare ranks **within** a frequency tercile (the targets file encodes
  this), not raw distances across terciles.
- **Binary flag is a quartile heuristic**, not a judgment-backed class. A
  [ChiWUG-style](https://aclanthology.org/2023.lchange-1.10/) usage-pair gold over the
  60-lemma target set is the required next step before any accuracy claim.
- **Dating is chapter-level and coarse** (5 slots; composite texts like the Mahābhārata sit
  wholly in slot 2 despite internal stratification).
- DCS is unaccented and its composition skews by genre per slot (Vedic ritual vs epic
  narrative vs śāstra); genre confounds semantic-change signal — flag any per-lemma claim
  against the top context words before publishing it.

## Next steps

- ChiWUG-style human gold over `lsc_targets.tsv` → real binary/graded evaluation
  (κ-reported, per the org's MWSA-discipline instruments).
- Venue: LChange'27 (CfP expected ~Oct–Dec 2026, watched in
  [GTD](https://github.com/gasyoun/Uprava/blob/main/GTD_NEXT_ACTIONS.md)) or NLP4DH.
  Registered as a paper candidate in [ARTICLES.md](https://github.com/gasyoun/Uprava/blob/main/ARTICLES.md).

_Dr. Mārcis Gasūns_
