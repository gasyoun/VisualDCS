# ROADMAP — VisualDCS product integration · 2026H2

_Created: 08-08-2026 · Last updated: 08-08-2026_

Parent: [PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md](https://github.com/gasyoun/VisualDCS/blob/main/docs/PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md).

## Wave 0 — truth and ownership

- Mark H2321's per-lemma nominal trainer as shipped in `roadmap.md`.
- Keep standalone VisualDCS pages as research/demo surfaces.
- Record Systema as the only owner of login, tariff access, progress, commerce and learner-facing
  product orchestration.

## Wave 1 — one producer contract release

Ship the three surfaces together, with independent contract namespaces:

1. `verb-trainer` — roots, attested paradigm cells, prompts/answers, frequency and evidence flags.
2. `nominal-trainer` — lemma, case×number cells, forms, frequency and G2 provenance.
3. `concordance-passage` — search/form hits, citations and stable passage targets.

Deliverables:

- `visual/contracts/v1/manifest.json` with release ID, generated time, source pins, schemas,
  filenames, byte sizes and SHA-256 values;
- JSON Schemas for every payload and a shared learning-object identifier grammar;
- deterministic generators or packagers that consume existing canonical assets;
- a compatibility policy: additive fields within `v1`, breaking changes only under `v2`;
- a preview/full marker that expresses presentation capability, never user entitlement.

## Wave 2 — native Systema consumer

Systema imports and caches a pinned manifest, verifies hashes before promotion, renders all three
surfaces natively and stores progress against stable learning-object IDs. One coordinated release
uses separate OFF-by-default flags for verb, nominal and concordance→passage. Public previews use
the same contracts; full use is checked by existing course/tariff access services.

## Wave 3 — evidence and iteration

- Establish the pre-release baseline.
- Read at 7/14/30 days: eligible→first action ≤24h, return to learning, cross-device resume,
  support contacts, course-page→paid and revenue per active student.
- Report denominators and uncertainty. Scale, hold or revert from observed cohorts; do not invent a
  lift target or attribute seasonal movement to the feature without a comparator.

## Cross-program order

This integration sits after funnel measurement and cabinet adoption, and before the JIVO
production-proof/CRM sequence in the Systema roadmap. Existing claimed work is not interrupted.

## Non-goals

- no VisualDCS backend, accounts, payments or progress database;
- no iframe or live browser fetch from an unpinned `main` asset;
- no recomputation of linguistic data inside Systema;
- no manual edits to generated contract payloads;
- no new identity, entitlement, analytics or CRM store.

_Dr. Mārcis Gasūns_
