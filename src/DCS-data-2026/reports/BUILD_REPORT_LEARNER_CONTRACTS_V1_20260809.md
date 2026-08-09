_Created: 09-08-2026 · Last updated: 09-08-2026_

# Build Report — VisualDCS v1 Learner Contracts (H2481)

**Model:** Claude Sonnet 5 (`claude-sonnet-5`) — dual-run override of H2481 (Grok 4.5)  
**Date:** 09-08-2026  
**Release ID:** `vdcs-learner-v1-20260809`

---

## Summary

| Payload | Records | File size | SHA-256 (first 16) |
|---|---|---|---|
| `verb-trainer.json` | 7,689 roots | see manifest | `5276b7d04ee409c5...` |
| `nominal-trainer.json` | 31,753 lemmas | see manifest | `13b5a16f5b45e886...` |
| `concordance-passage.json` | 40 passages / 64 links | see manifest | `b1d676e358e20d12...` |
| `manifest.json` | — | — | — |

All four payloads **pass Draft-07 JSON Schema validation** (jsonschema 4.26.0).  
Two sequential builds are **byte-identical** (deterministic rebuild confirmed).

---

## Source pins

| Asset | Version / annotation |
|---|---|
| `paradigm_attested.json` | schemaVersion `1.1.0`, corpusRelease `DCS-2026` |
| `paradigm_nominal_lemmas.json` | schemaVersion `1.0.0`, corpusRelease `DCS-2026` |
| `conc_data.js` | formCount `6423` |
| `passage_library.json` | 40 passages |

---

## Concordance passage coverage gap

**Strategy:** citation prefix-match — strip trailing `: N` from each `passage_library.json`
`src` field, then exact-match against concordance citation strings.

| Metric | Value |
|---|---|
| Total concordance citations scanned | 26,701 |
| Resolved citations (prefix-matched) | 60 |
| Unresolved citations | 26,641 |
| Distinct unresolved citation strings | (see `unresolved.distinctUnresolvedCitationStrings` in payload) |
| Passages reachable via links | 22 / 40 |
| Passages with zero links | 18 |

**Zero-link passage sourceIds:** `[10, 11, 12, 15, 17, 18, 19, 20, 25, 26, 27, 28, 30, 31, 32, 33, 37, 38]`

These are **named gaps**, not errors. They are included in the payload with `linkedFormCount: 0`.
Unresolved citations are retained in the `unresolved` object — never fuzzy-linked (H2481 plan constraint).

Root cause: the concordance citation scheme (`Mbh 1.1.1`) does not canonically match the
passage library `src` format (`Mbh,1.1.1` or `MBh, 1, 1: 1`) in 99.8% of cases.
Wider citation normalization is future work.

---

## Dual-run override note

H2481 was model-locked Grok 4.5. Executed here by Claude Sonnet 5 under user override.
H2499 (Grok 4.5) is the residual dual-run-compare handoff — must be independently
re-run and adjudicated before H2481 is marked fully closed.

_Dr. Mārcis Gasūns_
