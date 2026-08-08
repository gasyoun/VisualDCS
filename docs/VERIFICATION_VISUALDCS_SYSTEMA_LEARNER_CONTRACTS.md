# VERIFICATION — VisualDCS/Systema learner integration

_Created: 08-08-2026 · Last updated: 08-08-2026_

Parent: [PLAN](https://github.com/gasyoun/VisualDCS/blob/main/docs/PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md).

## Producer acceptance

- JSON Schema validation passes for every payload and the manifest.
- Declared byte sizes and SHA-256 values match the committed files.
- Two clean rebuilds are byte-identical.
- Stable learning-object IDs are unique and unchanged for locked fixtures.
- Verb totals/evidence flags reconcile with `paradigm_attested`.
- Nominal totals/G2 provenance reconcile with `paradigm_nominal_lemmas`.
- Every emitted passage target resolves; unresolved citations are counted and excluded explicitly.
- A deliberately corrupted file and breaking schema both fail closed while the previous release
  remains usable.

Expected command family:

```text
python src/DCS-data-2026/build_learner_contracts.py --check
python src/DCS-data-2026/test_learner_contracts.py
node tests/test_nominal_trainer.js
node tests/test_concordance.js
```

## Consumer acceptance

- Systema imports the pinned manifest only after hash/schema validation.
- Public preview and every paid/unpaid/expired entitlement case match canonical access services.
- Checkpoints are idempotent, duplicate-resistant and resume on a second device.
- Verb, nominal and concordance→passage can each be disabled without disabling the others.
- Complete and sparse fixtures render at 1440px and 390px with keyboard access, visible focus,
  acceptable contrast, reduced motion and no horizontal overflow.
- Aggregate progress counts reconcile with raw checkpoint rows; no person-level export is committed.

## Product acceptance

Save a pre-release aggregate baseline and report days 7, 14 and 30: eligible users, first useful
action ≤24h, return to learning, cross-device resume, support contacts, paid conversion and revenue
per active learner. Print denominators. Do not claim causality without a comparable cohort.

## Risks and spikes

| Risk | Required spike / containment |
|---|---|
| Existing asset labels are unstable IDs | Lock source IDs and migration fixtures before UI work |
| Concordance citations do not map cleanly to passages | Measure closure first; never fuzzy-link in production |
| Contract payload is too large | Measure compressed/uncompressed size; paginate/import server-side without changing semantics |
| Entitlement logic drifts | Call canonical Systema access services; matrix-test paid, partial, expired and preview |
| All-at-once learner wave enlarges blast radius | Independent feature flags and previous-manifest rollback |

_Dr. Mārcis Gasūns_
