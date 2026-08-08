# PLAN — VisualDCS learner contracts for the samskrte.ru cabinet · 2026H2

_Created: 08-08-2026 · Last updated: 08-08-2026_

## Goal

Publish the verb trainer, nominal trainer and concordance→passage loop as one versioned,
reproducible VisualDCS contract release that Systema-Sanscriticum renders natively inside the
student cabinet. VisualDCS remains the owner of linguistic derivation and static data;
Systema owns identity, entitlements, progress, product UI, commerce and support.

## Layer documents

- [Roadmap](https://github.com/gasyoun/VisualDCS/blob/main/docs/ROADMAP_VISUALDCS_PRODUCT_INTEGRATION_2026H2.md)
- [Architecture](https://github.com/gasyoun/VisualDCS/blob/main/docs/ARCHITECTURE_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS.md)
- [Implementation](https://github.com/gasyoun/VisualDCS/blob/main/docs/IMPLEMENTATION_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS.md)
- [Verification](https://github.com/gasyoun/VisualDCS/blob/main/docs/VERIFICATION_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS.md)
- [Systema consumer plan](https://github.com/gasyoun/Systema-Sanscriticum/blob/main/docs/PLAN_SYSTEMA_VISUALDCS_CRM_JIVO_2026H2.md)

## Decisions taken

| # | Decision | Locked ruling |
|---:|---|---|
| 1 | Ownership | VisualDCS owns data/tools; Systema owns sales, cabinet, identity, progress and JIVO |
| 2 | Full-JIVO order | School-operational parity first; CRM next; literal product-parity extras later |
| 3 | Learning scope | Verb trainer + nominal trainer + concordance→passage |
| 4 | Programme order | Measurement → cabinet adoption → learner integration → JIVO production proof → CRM |
| 5 | Rendering | Native Systema UI over versioned VisualDCS contracts; no iframe |
| 6 | Progress | Stable cell/lemma/passage checkpoint IDs, completion and score stored in Systema |
| 7 | CRM ownership | Extend canonical Systema Lead/Deal/FollowUpTask/attribution/inbox models |
| 8 | Release shape | All three learner surfaces in one coordinated wave |
| 9 | Synchronization | Static JSON Schema + checksum + release manifest; Systema imports a pinned version |
| 10 | Access | Public preview; full use through existing course/tariff entitlements |
| 11 | Rollout | One release with separate flags and rollback per surface |
| 12 | CRM waves | Customer 360 first; marketing automation second; forecasting third |
| 13 | Contract gate | Schema, checksum, deterministic rebuild, rollback and consumer fixtures all pass |
| 14 | UI gate | Complete+sparse data at 1440px/390px; accessibility, keyboard and reduced motion |
| 15 | Progress gate | Entitlement matrix, idempotency, cross-device resume, duplicate resistance, reconciliation |
| 16 | Product gate | Baseline plus 7/14/30-day activation, return, support and paid-conversion evidence |

## Autonomy contract

- **On ambiguity:** apply the documented default and log it. Park money, access, privacy,
  production-send and destructive-migration ambiguity.
- **Stop conditions:** halt on contract/data loss, entitlement or payment regression, privacy
  exposure, destructive migration, production-send uncertainty, or repeated failed verification.
  Continue past an isolated noncritical failure only when the remaining wave stays valid.
- **Git authority:** commit, push, open PRs and merge every green PR; required checks and branch
  protection remain hard gates.
- **Fence:** do not modify raw DCS sources, prices/payment logic, canonical identity, active
  H2378–H2382 worktrees, or production state unless an exact handoff authorizes that surface.

## Prior-art verdict

**PARTIAL.** The three learner tools and their data already exist in this repository. Systema
already consumes other research assets through pinned vendored manifests and already has SRS,
activity and entitlement owners. Build only stable export contracts, consumer adapters and native
learner surfaces. Do not rebuild morphology, concordance, identity, access, analytics or chat.

## Autonomy-readiness target

Wave 1 is ready only when every deliverable has a schema, ordered implementation steps, exact
verification commands, rollback path and named risks. No blocking `@DECIDE` is allowed in the
producer or consumer path.

_Dr. Mārcis Gasūns_
