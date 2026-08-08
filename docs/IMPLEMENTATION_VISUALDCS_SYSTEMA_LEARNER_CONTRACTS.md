# IMPLEMENTATION — VisualDCS learner-contract Wave 1

_Created: 08-08-2026 · Last updated: 08-08-2026_

Parent: [PLAN](https://github.com/gasyoun/VisualDCS/blob/main/docs/PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md).

## Ordered producer build

1. **Inventory and freeze inputs.** Record exact fields and source pins for
   `paradigm_attested`, `paradigm_nominal_lemmas`, concordance and passage assets. Touch no raw DCS
   source and change no existing generator semantics.
2. **Define schemas and ID helpers.** Add `visual/contracts/v1/schemas/*.schema.json` and one small
   shared ID formatter used by all packagers. Fixtures lock stable IDs for representative complete
   and sparse records.
3. **Package verb data.** Transform the existing attested payload without recomputing counts.
   Preserve `cellEvidence` and provenance.
4. **Package nominal data.** Transform the H2321 payload without recomputing G2 coverage. Preserve
   lemma IDs, cell counts and G2 source metadata.
5. **Package concordance→passage.** Build explicit passage targets from existing citations and
   passage-library IDs; unresolved citations remain named gaps, never guessed links.
6. **Build the release manifest.** Calculate SHA-256 and byte size after deterministic serialization;
   include source pins, record counts, schema paths and compatibility policy.
7. **Validate.** Add a focused Python test/validator for schemas, hashes, ID uniqueness, reference
   closure, deterministic rerun and previous-release compatibility.
8. **Document consumption.** Add a short consumer README with the pinned-import algorithm,
   rollback behavior and preview/full boundary; link the Systema plan.
9. **Publish atomically.** Commit schemas, payloads, manifest, reports and docs together. Never
   publish a manifest that references files absent from the same commit.

## Expected files

- `src/DCS-data-2026/build_learner_contracts.py`
- `src/DCS-data-2026/test_learner_contracts.py`
- `visual/contracts/v1/manifest.json`
- `visual/contracts/v1/schemas/*.schema.json`
- `visual/contracts/v1/{verb-trainer,nominal-trainer,concordance-passage}.json`
- `reports/learner_contracts_build.md`
- `visual/contracts/README.md`

## Dependency order

Systema implementation starts against committed fixtures after steps 1–2, but cannot promote a
release until steps 3–9 pass. The producer and consumer PRs remain independently revertible.

_Dr. Mārcis Gasūns_
