# H2499 — Dual-run compare: Grok rebuild vs VisualDCS #110 learner contracts

_Created: 15-08-2026 · Last updated: 15-08-2026_

**Lanes:** override = Claude Sonnet 5 (`claude-sonnet-5`), [VisualDCS #110](https://github.com/gasyoun/VisualDCS/pull/110) merged 09-08-2026 · independent = Grok 4.6 (`grok-4.6`) this pass.

**Source handoff:** [H2481 (Grok 4.5) — Publish versioned VisualDCS learner contracts](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H2481-Grok_VisualDCS_visualdcs-systema-learner-contract-release_08.08.26.md)

**Residual:** [H2499 (Grok 4.6) — Dual-run compare for H2481 VisualDCS learner-contract release](https://github.com/gasyoun/Uprava/blob/main/handoffs/H2499-Grok_VisualDCS_h2481-grok-dual-run-compare_09.08.26.md)

**Verdict:** **keep #110.** Three payloads are byte-identical to the published release. Independent source-pin parity found zero drift. Manifest timestamps were not rewritten.

---

## Rebuild command

Worktree off `origin/main` (`faf2ac1`). Published [`visual/contracts/v1/`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/) was not written.

```text
python src/DCS-data-2026/h2499_dual_run_rebuild.py
python src/DCS-data-2026/test_learner_contracts.py
python src/DCS-data-2026/build_learner_contracts.py --check
```

Machine record: [`H2499_DUAL_RUN_REBUILD_RESULT_20260815.json`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/H2499_DUAL_RUN_REBUILD_RESULT_20260815.json).

Two packager serializations (`run-a`, `run-b`) were written under `%LOCALAPPDATA%\Temp\h2499-rebuild\` and hashed. They matched each other and matched published `v1/`.

---

## Hash table

| File | Run A SHA-256 | Run B | Published #110 | Bytes | Class |
|---|---|---|---|---:|---|
| [`verb-trainer.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/verb-trainer.json) | `5276b7d04ee409c58c8fe7426b26efdabc2cbc1d3d4d05082f5ed1d593f2d4f6` | same | same | 11,219,452 | identical |
| [`nominal-trainer.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/nominal-trainer.json) | `13b5a16f5b45e886744f56f3464e8122730d60e1a677323f5b67024684de6663` | same | same | 15,591,893 | identical |
| [`concordance-passage.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/concordance-passage.json) | `b1d676e358e20d12eee85817c9fc9c32e735dfb050019ecece88d08f1912a08d` | same | same | 45,833 | identical |

---

## Own-data parity vs the four H2481 source pins

Independent walk of the source assets (not a desk-read of the override report). Linguistic facts were not recomputed.

| Pin | Path | Source SHA-256 | Pin fields | Packed count | Parity |
|---|---|---|---|---|---|
| `paradigm_attested` | [`visual/paradigm_attested.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_attested.json) | `e69972e6784b99628cb386572e6d2306c034b050aae63d3980ed093d03e63424` | schema `1.1.0`, DCS-2026, `gen_paradigm_attested.py (H1299)` | 7,689 roots | 0 errors (root set, rank/tier/tokens, every cellId + forms) |
| H2321 nominal lemmas | [`visual/paradigm_nominal_lemmas.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/paradigm_nominal_lemmas.json) | `30027b5f90cf79310f6f0cad4717183226d9f23a5e6adb5764dcb6cadc9e6384` | DCS-2026, `gen_paradigm_nominal_lemmas.py (H2321)` | 31,753 lemmas | 0 errors (lemma set, metadata, every cellId + forms) |
| concordance | [`visual/conc_data.js`](https://github.com/gasyoun/VisualDCS/blob/main/visual/conc_data.js) | `172a3c7355d9418caebfea4b4bffb1a46a815a3674bf22298bac34fbe08f1ad3` | `gen_concordance_data.py (H1505)`, formCount 6423 | 64 links / 60 resolved / 26,641 unresolved | 0 errors vs re-derived prefix-match |
| passages | [`passage_library.json`](https://github.com/gasyoun/VisualDCS/blob/main/passage_library.json) | `9389e6dd02e283046d6757423ef5c5c9975a04c77808a3f9a23b28287909b4d3` | 40 passages | 40 / 18 zero-link | 0 errors; zero-link ids `[10, 11, 12, 15, 17, 18, 19, 20, 25, 26, 27, 28, 30, 31, 32, 33, 37, 38]` |

Published acceptance tests also green: schema, 53,527 unique verb cellIds, 117,805 unique nominal cellIds, 40 passageIds, 64/64 link closure, manifest SHA-256 and record counts.

---

## Salvage table (`/dual-run-salvage` classes)

| Artifact | Class | Adjudication |
|---|---|---|
| `verb-trainer.json` | **identical** | Same bytes from the committed packager and from the independent source walk. Keep #110. |
| `nominal-trainer.json` | **identical** | Same. Keep #110. |
| `concordance-passage.json` | **identical** | Same, including the named 18-passage coverage gap. Keep #110. Do not widen citation matching (H2481 fence: never fuzzy-link). |
| `v1/schemas/*.schema.json` | **identical** | Grok lane reused the shipped Draft-07 schemas; they validate the rebuild. Keep #110. |
| `manifest.json` | **equivalent** | Payload SHA-256, byte sizes, record counts and source-pin strings match. `releaseId` / `generatedAt` / `builtBy` are the override's historical build stamp (`vdcs-learner-v1-20260809`, Sonnet 5). Rewriting them today would change the consumer cache key with no payload change. **Keep #110 manifest.** |
| Packager [`build_learner_contracts.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/build_learner_contracts.py) | **equivalent** | Grok did not re-author the transform (linguistic facts are fenced). Independence is the two-run serialization + the source walk. Same conclusion. |
| [`deterministic_rebuild_check.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/deterministic_rebuild_check.py) in-place rebuild | **conflicting** (tooling, not data) | Override check rebuilt **into** `visual/contracts/v1/`. A failed or interrupted run could clobber the published release. Grok lane rebuilds to `--out-dir` / scratch and leaves `v1/` untouched. **Keep Grok check.** Payloads unchanged. |
| This memo + [`h2499_dual_run_rebuild.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/h2499_dual_run_rebuild.py) + `--out-dir` | **net-new** (Grok) | Dual-run evidence and a non-clobbering rebuild path. Promote. No payload / ID / schema change. |

**Keep-best:** published `v1/` payloads and manifest stay exactly as #110. Promote only the compare memo, the independent rebuild harness, `--out-dir` on the packager, and the non-clobbering rebuild check.

---

## What was not done

- No v2, no additive consumer fields, no citation-normalizer widening.
- No Systema money, cabinet, entitlement, or person-level telemetry.
- Manifest `builtBy` left as Sonnet 5 — that is who shipped the release bytes.

_Dr. Mārcis Gasūns_
