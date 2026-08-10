# A57 — Related work: lexical semantic change detection, and where Sanskrit sits

_Created: 10-08-2026 · Last updated: 10-08-2026_

Related-work section draft for **A57**, *Lexical Semantic Change Detection for Sanskrit: a
Deterministic PPMI Pilot over the DCS Chronology* (registered in
[ARTICLES.md](https://github.com/gasyoun/Uprava/blob/main/ARTICLES.md), venue target
LChange'27 / NLP4DH). Companion to the protocol and scores in
[derived-lsc/README.md](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/README.md).

Every citation below is the **canonical `url` field** of an entry in the ACL Anthology's own
`anthology.bib.gz` (dump generated **08-08-2026**), harvested by
[derived-lsc/mine_lsc_related_work.py](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/mine_lsc_related_work.py) —
not recalled. Re-verify with the reproduce line at the bottom before submission.

## ⚠️ The novelty claim needs narrowing (finding of this pass)

[derived-lsc/README.md](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/README.md)
and [ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md](https://github.com/gasyoun/Uprava/blob/main/ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md)
opportunity #1 both assert **zero** Sanskrit papers in the LSC family. As of the 08-08-2026
dump that is **no longer true**:

> Hariharan & Mortensen (2026), [Transformer-Enabled Diachronic Analysis of Vedic Sanskrit:
> Neural Methods for Quantifying Types of Language Change](https://aclanthology.org/2026.lrec-1.81/),
> LREC 2026, pp. 1044–1053.

It matches both the `\bsanskrit\b` and the diachronic-family title regex, so any
"first diachronic work on Sanskrit" phrasing is now falsifiable by a single grep. What it does
**not** do (per its abstract; full text not yet read — see Open questions):

| Axis | Hariharan & Mortensen 2026 | A57 |
|---|---|---|
| Change type | **morphological / feature** inventory (verbal features, compounding, new vocabulary) | **lexical-semantic**, sense-level, per lemma |
| Method | 100+ regex pseudo-labels → fine-tuned multilingual BERT → confidence-weighted ensemble | count-based PPMI + cosine, deterministic, no neural component |
| Corpus | 1.47 M words, provenance unstated on the landing page | DCS / [dcs-conllu](https://github.com/gasyoun/dcs-conllu), 5.69 M tokens, gold lemmatization, DCS's own 5-slot chronology |
| Periodization | "over 2,000 years", slices unnamed | 5 explicit slots, anchored against texts of known date |
| Output | detection rate + calibration, no per-lemma ranking released | 3,049-lemma graded ranking + binary flag, released as TSV |
| Gold | weak supervision, no human sense-annotation | n=30 stratified human-gold sheet + DURel-style protocol |

**Safe claim to make instead:** A57 is the first *lexical semantic change* (sense-level,
SemEval-2020-Task-1-shaped) study of Sanskrit, and the first to release a per-lemma graded
ranking over a dated Sanskrit corpus. Hariharan & Mortensen is adjacent prior work on
**morphological** change and must be cited as such, not omitted.

## Census (measured, not asserted)

| Measure | Value |
|---|---|
| Non-`@proceedings` Anthology entries scanned | 127,681 |
| LSC family (title match, same regex as Uprava's quarterly sweep) | **236** |
| … of those since 2020 | **160** |
| … carrying a canonical `aclanthology.org` URL | 236 (100%) |
| Sanskrit anywhere in the dump (any method) | 122 |
| **Sanskrit ∩ LSC family** | **1** (the LREC 2026 paper above) |

The 236 here vs **237** in
[ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md](https://github.com/gasyoun/Uprava/blob/main/ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md)
is the `@proceedings`-exclusion in this harvester (volume front matter is not a paper); the
family grew from 81 (11-07-2026 measurement) largely through LChange'26 and LREC 2026.

## 1 · The task and its shared-task definition

The binary + graded formulation A57 adopts is
[SemEval-2020 Task 1: Unsupervised Lexical Semantic Change Detection](https://aclanthology.org/2020.semeval-1.1/)
(Schlechtweg et al. 2020) — subtask 1 binary change, subtask 2 graded ranking, four languages.
Its predecessor framing is
[A Wind of Change: Detecting and Evaluating Lexical Semantic Change across Times and Domains](https://aclanthology.org/P19-1072/)
(Schlechtweg et al. 2019). The Spanish follow-on shared task
[LSCDiscovery](https://aclanthology.org/2022.lchange-1.17/) extended the setup to discovery
rather than a fixed target list — relevant to A57's own 60-lemma target set, which is
frequency-stratified rather than hand-picked.

Field survey: [Diachronic word embeddings and semantic shifts: a survey](https://aclanthology.org/C18-1117/)
(Kutuzov et al. 2018).

## 2 · Method precedents — and why A57 is deliberately count-based

The reference point for aligned diachronic embedding spaces is
[Diachronic Word Embeddings Reveal Statistical Laws of Semantic Change](https://aclanthology.org/P16-1141/)
(Hamilton et al. 2016), with the companion measure comparison in
[Cultural Shift or Linguistic Drift?](https://aclanthology.org/D16-1229/) (Hamilton et al.
2016). A57 needs **no Procrustes alignment**: its context vocabulary is the top 5,000
whole-corpus lemmas shared across all slots, so the per-slot PPMI spaces are aligned by
construction — the same rationale as the *temporal referencing* line of work,
[Time-Out: Temporal Referencing for Robust Modeling of Lexical Semantic Change](https://aclanthology.org/P19-1044/)
(Dubossarsky et al. 2019), and its shared-task instantiations
([TemporalTeller](https://aclanthology.org/2020.semeval-1.27/),
[DCC-Uchile](https://aclanthology.org/2020.semeval-1.23/)).

That count-based choice is defensible on evidence from the shared task itself, not only on
reproducibility grounds: [Discovery Team at SemEval-2020 Task 1](https://aclanthology.org/2020.semeval-1.6/)
(Martinc et al. 2020) reports **context-sensitive embeddings not always better than static**
for change detection, and [IMS at SemEval-2020 Task 1: How Low Can You Go?](https://aclanthology.org/2020.semeval-1.8/)
(Kaiser et al. 2020) shows low-dimensional count models remain competitive. Strong
contextualised entries exist ([UiO-UvA](https://aclanthology.org/2020.semeval-1.14/),
[DiaSense](https://aclanthology.org/2020.semeval-1.4/),
[CIRCE](https://aclanthology.org/2020.semeval-1.21/) ensembling context-free and
context-dependent representations), and the current cross-lingual state of the art is the WiC
pretrained [XL-LEXEME](https://aclanthology.org/2023.acl-short.135/) (Cassotti et al. 2023),
extended ordinally by [XL-DURel](https://aclanthology.org/2025.findings-ijcnlp.19/)
(Yadav & Schlechtweg 2025) — none of which has a Sanskrit-capable checkpoint, which is the
honest reason A57 does not use them.

PPMI-space precedent outside the LSC family:
[Random Positive-Only Projections: PPMI-Enabled Incremental Semantic Space Construction](https://aclanthology.org/S16-2024/)
(QasemiZadeh & Kallmeyer 2016), and a temporal PPMI variant in
[TPPMI](https://aclanthology.org/2024.cpss-1.10/) (Schmitt et al. 2024).

## 3 · Annotated gold — the standard A57's n=30 sheet is built against

A57's binary flag is currently a quartile heuristic; the human-gold design follows
[Diachronic Usage Relatedness (DURel): A Framework for the Annotation of Lexical Semantic Change](https://aclanthology.org/N18-2027/)
(Schlechtweg et al. 2018) and its tooling,
[The DURel Annotation Tool](https://aclanthology.org/2024.eacl-demo.15/) (Schlechtweg et al.
2024). The usage-graph resources that operationalize it:
[DWUG: A large Resource of Diachronic Word Usage Graphs in Four Languages](https://aclanthology.org/2021.emnlp-main.567/)
(Schlechtweg et al. 2021), extended in
[More DWUGs](https://aclanthology.org/2024.emnlp-main.796/) (Schlechtweg et al. 2024), with
sense structure modeled in
[Modeling Sense Structure in Word Usage Graphs with the Weighted Stochastic Block Model](https://aclanthology.org/2021.starsem-1.23/)
(2021) and graph quality improved by
[Improving Word Usage Graphs with Edge Induction](https://aclanthology.org/2024.lchange-1.9/)
(Noble et al. 2024) and
[Enriching Word Usage Graphs with Cluster Definitions](https://aclanthology.org/2024.lrec-main.546/)
(Kutuzov et al. 2024). Earlier gold standard:
[SURel](https://aclanthology.org/S19-1001/) (Hätty et al. 2019).

The non-Indo-European construction A57's sampling design most closely imitates is
[ChiWUG: A Graph-based Evaluation Dataset for Chinese Lexical Semantic Change Detection](https://aclanthology.org/2023.lchange-1.10/)
(Chen et al. 2023) — cited in the protocol as the target κ ≥ 0.6 model — alongside
[Construction of Evaluation Dataset for Japanese Lexical Semantic Change Detection](https://aclanthology.org/2023.paclic-1.13/)
(Ling et al. 2023).

## 4 · Metric critique — why A57 reports a frequency control

The caveat A57's limitations section is written against is
[Rethinking Metrics for Lexical Semantic Change Detection](https://aclanthology.org/2026.lchange-1.13/)
(Goworek & Dubossarsky 2026). Related evaluation-design work:
[A Multidimensional Framework for Evaluating Lexical Semantic Change with Social Science Applications](https://aclanthology.org/2024.acl-long.76/)
(Baes et al. 2024) and
[A Semantic Distance Metric Learning approach for Lexical Semantic Change Detection](https://aclanthology.org/2024.findings-acl.451/)
(Aida & Bollegala 2024).

This is why the pilot reports **Spearman ρ = −0.013** between its graded score and a
frequency-shift baseline: the ranking is not a re-description of frequency change. The
sparsity/frequency bias of PPMI-cosine at low counts is stated as a limitation and handled by
comparing ranks **within** frequency terciles.

## 5 · Low-resource and historical-language LSC — the comparison class

A57 belongs with the resource-building side of the family rather than the
method-benchmarking side. Datasets for languages without English-scale corpora:
[RuSemShift](https://aclanthology.org/2020.coling-main.90/) (Rodina & Kutuzov 2020) and the
[three-part diachronic semantic change dataset for Russian](https://aclanthology.org/2021.lchange-1.2/)
(Kutuzov & Pivovarova 2021);
[Lexicon of Changes](https://aclanthology.org/2022.lchange-1.11/) for Chinese (Chen et al.
2022); [Historical Ink: Semantic Shift Detection for 19th Century Spanish](https://aclanthology.org/2024.lchange-1.4/)
(Montes et al. 2024). Ancient-language sense work with an LLM annotation layer:
[Sense-Based Annotation of Geographical Nouns in Ancient Greek and Latin](https://aclanthology.org/2026.latechclfl-1.26/)
(Farina et al. 2026). Corpus-side precedent for dated layers over a long span:
[A Diachronic Treebank of Russian Spanning More Than a Thousand Years](https://aclanthology.org/2020.lrec-1.646/)
(Berdicevskis & Eckhoff 2020) and
[Open Korean Historical Corpus](https://aclanthology.org/2026.lrec-1.521/) (Song et al. 2026).

Frame-semantic alternative to vector distance, newest in the family:
[ReFRAME or Remain: Unsupervised Lexical Semantic Change Detection with Frame Semantics](https://aclanthology.org/2026.starsem-conference.5/)
(Tat et al. 2026).

## 6 · Computational Sanskrit — the neighbours, none of them semantic-change

Sanskrit is well served computationally (122 papers) but almost entirely synchronically.
Diachrony appears as morphology, intertextuality, or corpus construction:
[Transformer-Enabled Diachronic Analysis of Vedic Sanskrit](https://aclanthology.org/2026.lrec-1.81/)
(Hariharan & Mortensen 2026, §above);
[Exploring Similarity Measures and Intertextuality in Vedic Sanskrit Literature](https://aclanthology.org/2024.nlp4dh-1.12/)
(Miyagawa et al. 2024);
[Mapping Hymns and Organizing Concepts in the Rigveda](https://aclanthology.org/2025.nlp4dh-1.44/)
(Bollineni et al. 2025);
[Sanskrit Travelogue: A Large-Scale Unified and Annotated Corpus of Sanskrit Texts](https://aclanthology.org/2026.lrec-1.535/)
(De Luca et al. 2026).

On the lexical-semantic side the closest work is sense disambiguation, not sense change:
[Sanskrit Word Sense Disambiguation Based on Lexicographic Definitions](https://aclanthology.org/2026.iscls-1.2/)
(Hellwig et al. 2026) — itself DCS-based, and the natural reviewer question ("why not just run
WSD per slot?") that A57 must answer explicitly. Also
[Word Sense Alignment of Sanskrit Lexica](https://aclanthology.org/2024.iscls-1.1/) (Patel &
Kulkarni 2024) and [Concordance of Sanskrit Synonyms](https://aclanthology.org/2025.wsc-csdh.12/)
(Patel 2025).

## Citation count against acceptance

Acceptance required **≥8 LSC Anthology papers including SemEval-2020 Task 1**. This draft
cites **46** distinct Anthology papers, of which **26** are in the LSC title-family, and
[SemEval-2020 Task 1](https://aclanthology.org/2020.semeval-1.1/) is cited in §1 and §2 —
5.75× the required minimum on the family count alone.

These are not hand-counted: every URL is checked back against the dump's own `url` fields by
[derived-lsc/verify_related_work_citations.py](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/verify_related_work_citations.py),
which exits non-zero on any URL absent from the dump (the hallucinated-URL failure mode) or if
either acceptance minimum breaks. Run it before submission and after any citation edit.

## Open questions before submission

- **Read the full text of [2026.lrec-1.81](https://aclanthology.org/2026.lrec-1.81/)** (ELRA
  PDF, external to the landing page). The abstract does not name its corpus; if it turns out
  to be DCS-derived, the overlap discussion in §Novelty needs strengthening, and the
  periodization comparison must be redone against its actual slices.
- **Fix the stale zero-hit claim** in
  [derived-lsc/README.md](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/README.md)
  and [ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md](https://github.com/gasyoun/Uprava/blob/main/ACL_METHOD_OPPORTUNITIES_SANSKRIT_2026.md)
  opportunity #1 — done for the README in this pass; the Uprava sweep row is a separate repo.
- **κ is still unmeasured** — the n=30 sheet
  ([lsc_human_gold_sample.tsv](https://github.com/gasyoun/VisualDCS/blob/main/derived-lsc/lsc_human_gold_sample.tsv))
  is unannotated, so no accuracy claim may enter the paper yet. A human decides whether to
  annotate in-house or recruit a second annotator for the κ ≥ 0.6 target.
- **Venue**: LChange'27 CfP (~Oct–Dec 2026) is watched in
  [GTD_NEXT_ACTIONS.md](https://github.com/gasyoun/Uprava/blob/main/GTD_NEXT_ACTIONS.md).
  Now that a 2026 LREC Sanskrit-diachrony paper exists, NLP4DH becomes the weaker option —
  the reviewer pool that already saw the LREC paper is at LChange.

## Reproduce

```
curl -sS -o anthology.bib.gz https://aclanthology.org/anthology.bib.gz
python derived-lsc/mine_lsc_related_work.py --cached anthology.bib.gz \
  --query "\bppmi\b|pointwise mutual information" --query "\bprocrustes\b" \
  --query "\bdurel\b|\bsurel\b|\bwug\b|usage pair|word usage graph" \
  --query "\bvedic\b|rigveda|ṛgveda|rgveda"
```

Harvested with the 08-08-2026 dump by Claude Code **Fable 5** (`claude-fable-5`) under
[H2400](https://github.com/gasyoun/Uprava/blob/main/handoffs/H2400-Fable_VisualDCS_a57-lsc-anthology-related-work_07.08.26.md).

_Dr. Mārcis Gasūns_
