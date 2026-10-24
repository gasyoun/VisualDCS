# F4-DCS — shared-*erroneous*-citation test (MW ← Böhtlingk): verdict

_Created: 10-07-2026 · Last updated: 24-10-2026_

Handoff [H203](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H203-Opus_VisualDCS_dcs_shared_citation_errors_05.07.26.md).
Original run 10-07-2026 by Opus 4.8 (`claude-opus-4-8`); **refreshed 24-10-2026 by DeepSeek
Flash (`deepseek-flash`)** against the re-frozen candidate list. Read-only against the DCS
passage corpus; this is the compact, dictionary-facing summary for csl-atlas consumption per the
[VISUALDCS_CONSUMPTION_CONTRACT](https://github.com/sanskrit-lexicon/csl-atlas/blob/main/docs/VISUALDCS_CONSUMPTION_CONTRACT.md)
(summary only — the passage-resolution code stays in VisualDCS).

**What the refresh changed.** [csl-atlas#467](https://github.com/sanskrit-lexicon/csl-atlas/pull/467)
(H5248) re-froze the F1/F5 forensic suite, so the candidate list moved from 587 to **598** rows
(63 added, 52 removed — it was *revised*, not appended to). Re-run on the new list, the verdict
does not move: still **0 adjudicated shared errors**, still exactly one resolvable candidate —
the same `tiraspaṭa` / CAURAP. (A.) 49 recension artifact. The counts below are the refreshed
ones; the 10-07-2026 figures (587 / 570 / 298 / 271 / 17) are superseded.

## Bottom line

**0 adjudicated shared errors. The test cannot strengthen A10 with the DCS corpus — A10 stays 3/5.**
This is a corpus-availability blocker, not a null finding about the copying hypothesis: the shared
*apparatus* (F1 citation Jaccard) and shared *order* (F5 order-concordance 0.81) results are
untouched. What could not be run here is the shared-*error* closer, because the DCS corpus and the
Petersburg citations are keyed to **incompatible editions**.

## The numbers

| Stage | Count |
|---|---:|
| Shared rare candidate citations (PWG/PW ∩ MW) | 598 |
| …whose sigil maps to a text present in DCS | 567 |
| …**resolvable to a specific DCS locus** | **1** |
| …VERIFIED (lemma present at locus) | 0 |
| …ERRONEOUS (lemma absent — adjudication candidates) | 1 |
| **Adjudicated genuine shared errors** | **0** |

### Why 597/598 are UNRESOLVED

| Reason | Count |
|---|---:|
| **Harivaṃśa, continuous no. exceeds DCS's 6 073-verse corpus** (Petersburg vulgate vs DCS critical edition) | 293 |
| **Harivaṃśa/Kauśikasūtra, multi-chapter** — no concordance from a continuous Petersburg number to DCS (chapter, verse) | 273 |
| Text absent from DCS or sigil ambiguous (BĪJAG=Bījagaṇita, GAṆAR, LAGHUK, CHANDOM, BHĀṢĀP, VEDĀNTAS, SĀH, PURUṢOTT, VEṆĪS, …) | 31 |

**The candidate pool is 94.5 % Harivaṃśa** (565/598), cited by the Petersburg dictionaries with the
**Calcutta-vulgate continuous śloka number** (running up to 16 291). DCS's Harivaṃśa is the
**critical edition** (118 chapters, per-chapter verses, ≈ 6 073 verses total). 293 Petersburg numbers
*provably exceed* the entire DCS Harivaṃśa (e.g. 16 291 > 6 073); the rest cannot be mapped to a
(chapter, verse) locus without a vulgate↔critical concordance that does not exist in-repo. This is
exactly the edition/numbering-offset trap the handoff flags — here it is not a small offset but two
different editions of different lengths.

### The one resolvable candidate — adjudicated as an edition artifact

`tiraspaṭa` · **CAURAP. (A.) 49** (cited by PW and MW) → Caurapañcaśikā v.49. Lemma absent from DCS's
verse 49. **Adjudged NOT a copied error:** the `(A.)` marks a *specific recension* of the
Caurapañcaśikā (a text with substantially divergent recensions in different verse orders); DCS carries
a *different* single recension, so its v.49 is not the same stanza. The absent lemma is a
recension mismatch, not an editor-independent wrong locus. Per the conservative rule ("only
editor-independent wrong loci count"), it does not qualify.

## What would unblock this

The test needs the candidate refs and the corpus in the **same edition**. Concretely: either
(a) a **Calcutta-vulgate → critical-edition Harivaṃśa verse concordance**, or (b) a digital
**vulgate** Harivaṃśa (the edition Böhtlingk actually cited) token-lemmatized to its own continuous
numbering. Until one exists, F4-DCS is not runnable for this candidate set; F1 + F5 remain the
standing evidence for A10.

## Provenance

- DCS corpus: `dcs_full.sqlite`, source commit `04e0778d3dc971030229179e25eea043d06ff397`
  (`gasyoun/dcs-conllu` ← `OliverHellwig/sanskrit`), imported 2026-06-06; 270 texts.
- Candidate set: [`csl-atlas/data/forensic/shared_rare_citations.csv`](https://github.com/sanskrit-lexicon/csl-atlas/blob/main/data/forensic/shared_rare_citations.csv)
  — **598 rows**, sha256 `04582873b9c29ca4dfa1673adfed8ca50fc010e3c81e425f6a1b4f0bdf0e301d` (the LF
  blob at csl-atlas `49a7e89f`). The 10-07-2026 run hashed a **CRLF** working copy of the
  pre-re-freeze list (`07c1e6e2…`, 587 rows); that digest is not reproducible from any repo blob,
  which this refresh fixes by pinning the blob itself.
- Runs: 10-07-2026 Opus 4.8 (`claude-opus-4-8`, H203) · 24-10-2026 refresh DeepSeek Flash
  (`deepseek-flash`). The JSON `model` field is written from `F4_MODEL` and names the runner of
  that artifact, not the original handoff model.
- Resolver + full per-candidate classification: [`dcs_shared_citation_errors.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/dcs_shared_citation_errors.py)
  → [`reports/dcs_shared_citation_errors.csv`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/dcs_shared_citation_errors.csv)
  + [`.json`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/dcs_shared_citation_errors.json).

_Dr. Mārcis Gasūns_
