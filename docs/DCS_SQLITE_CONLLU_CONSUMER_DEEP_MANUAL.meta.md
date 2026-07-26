# Metadoc — DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.md

_Created: 26-07-2026 · Last updated: 26-07-2026_

## Staleness block

LAST_VERIFIED: 26-07-2026
VERIFIED_BY: Fable 5 (`claude-fable-5`), H1407
COMMANDS_SPOT_RUN: 64

(64 = every query in the two read-only recon/join scripts executed against the live
920,883,200-byte `dcs_full.sqlite`; all recorded numbers in the manual come from that run.)

## Purpose

Doc-of-record for the org's DCS corpus data layer: the as-built schema of
`src/DCS-data-2026/dcs_full.sqlite`, the 2021↔2026↔M9 generational boundaries, the
fold vs DO-NOT-fold encoding rule, one executed join recipe per consumer repo, and the
G1–G18 gotcha registry. Written so a fresh session (or external consumer) can join
against the corpus without rediscovering any of the recorded traps.

## Audience

Agents and humans in any org repo consuming DCS data: VisualDCS itself, WhitneyRoots,
kosha, csl-guides, csl-atlas, SanskritGrammar, SamudraManthanam. Assumes SQL and basic
IAST; assumes nothing about DCS internals.

## Provenance

- Handoff: [H1407](https://github.com/gasyoun/Uprava/blob/main/handoffs/H1407-Fable_VisualDCS_deep-manual-dcs-corpus-data-layer-wave4_20.07.26.md)
  (Wave 4 of the org deep-manuals programme; plan set indexed at
  [PLAN_ORG_DEEP_MANUALS_FABLE_WAVES_2026H2.md](https://github.com/gasyoun/Uprava/blob/main/docs/PLAN_ORG_DEEP_MANUALS_FABLE_WAVES_2026H2.md)).
- Model: Fable 5 (`claude-fable-5`), 26-07-2026.
- Inputs: live queries against `dcs_full.sqlite` (provenance commit `04e0778d…`,
  imported 06-06-2026); repo docs
  ([`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md),
  [`DCS_CONLLU_IMPORT_PLAN.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_CONLLU_IMPORT_PLAN.md),
  [`m9_archive_ingest.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m9_archive_ingest.md),
  `.ai_state.md` H1328/H457/M1–M9 entries); consumer-repo source reads (WhitneyRoots
  `scripts/dcs/`, kosha `data/frequency/`, csl-guides corpus-attestation chain);
  [SanskritLexicography FINDINGS](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)
  §§7–12, 66, 78–80, 86–88, 91, 101–102, 104.

## Verification

- Every §2 row count, §3 spine-join total, §4.3 vintage-mismatch triple, §5.1 anusvāra
  census, §5.2 `sena`/`senā` pair, §6 consumer numbers (1,007,361 VERB; 531,747
  WordSem; 23,920 synsets), and the live-tagged G-registry entries reproduce the H1407
  recon exactly (zero deltas against the Wave-4 plan baseline).
- **Independent adversarial pass (26-07-2026, second Fable 5 agent, cold read):** 31
  quantitative claims independently re-queried — 29 exact to the digit; 1 corrected
  (present-finite `gam` count needed its filter stated in full → §2 now teaches the
  nested voice-NULL convention); 1 **refuted and rewritten** — G1's inherited "MBh book 6
  omits adhyāyas 23–40" was a ref-relabeling artifact (`BhaGī 1–18` chapters are present,
  10,547 tokens; refutation re-confirmed by the author with an independent query).
  All non-quantitative spot-checks against WhitneyRoots/kosha/csl-guides sources confirmed.
- Acceptance bar: [VERIFICATION_ORG_DEEP_MANUALS_FABLE_WAVES.md](https://github.com/gasyoun/Uprava/blob/main/docs/VERIFICATION_ORG_DEEP_MANUALS_FABLE_WAVES.md) → Wave 4.

## Ranked improvement backlog

1. Add an executed join recipe for SamudraManthanam / SanskritGrammar (sangram) once
   their DCS consumption stabilizes — currently they consume derived TSVs, not the DB.
2. Automate §9: commit the two recon scripts as a `spot_check_dcs_manual.py` CI-runnable
   gate instead of quoting queries inline only.
3. Extend §4.1 with the M4 learned code map (2021 numeric morphology ↔ UD FEATS)
   coverage table — currently only referenced.
4. WordSem: link G6 to kosha's published inventory artifact once its dataset row lands
   in `datasets.json`.

## Limitations

- Numbers are pinned to `source_commit 04e0778d…` / import of 06-06-2026; any re-import
  invalidates them (refresh policy in §9 of the manual).
- Consumer recipes reflect consumer-repo code as read on 26-07-2026; those repos evolve
  independently and this metadoc's history table is the sync record.
- The 2021-side claims (numeric codes, `0.csv` shapes) are documented from the repo's
  own comparison/import docs, not re-executed against the 2021 CSVs in this pass.

## Revision history

| Date | Change | By |
|---|---|---|
| 26-07-2026 | Created with the manual (H1407, Wave 4) | Fable 5 (`claude-fable-5`) |

_Dr. Mārcis Gasūns_
