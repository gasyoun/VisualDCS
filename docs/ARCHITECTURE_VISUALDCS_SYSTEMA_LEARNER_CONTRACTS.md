# ARCHITECTURE — VisualDCS→Systema learner contracts

_Created: 08-08-2026 · Last updated: 08-08-2026_

Parent: [PLAN](https://github.com/gasyoun/VisualDCS/blob/main/docs/PLAN_VISUALDCS_SYSTEMA_LEARNER_CONTRACTS_2026H2.md).

## Boundary

```text
VisualDCS canonical generators/assets
  → deterministic contract packager
  → v1 schemas + manifest + checksums
  → Systema verified importer/cache
  → native learner UI
  → Systema entitlement + progress + ActivityEvent
```

VisualDCS exports facts. Systema interprets those facts as a product experience. Neither side
reimplements the other's source of truth.

## Producer components

| Component | Reuses | Emits |
|---|---|---|
| Verb contract packager | `visual/paradigm_attested.json`, trainer evidence flags | roots/cells/prompts with stable IDs |
| Nominal contract packager | `visual/paradigm_nominal_lemmas.json`, G2 reconciliation | lemmas/cells/forms with stable IDs |
| Concordance-passage packager | `visual/conc_data.js` source JSON + `passage_library.json` | hits, citations and passage targets |
| Release builder | existing generator source pins and reports | manifest, hashes, sizes, provenance |
| Validator | JSON Schemas + compatibility fixtures | fail-closed release verdict |

## Stable identifiers

IDs are opaque to the UI but readable in evidence. The v1 grammar is:

```text
vdcs:v1:verb:<root-id>:<cell-id>
vdcs:v1:nominal:<lemma-id>:<case-number-cell>
vdcs:v1:passage:<text-id>:<passage-id>
```

Display labels, transliteration, rank and frequency may change without changing identity. A source
identifier change requires an explicit migration map in the next manifest.

## Manifest contract

Required release fields: `contractVersion`, `releaseId`, `generatedAt`, `sourcePins`, `files[]`,
`schemas[]`, `sha256`, `bytes`, `recordCount`, `compatibility`, and `provenance`. Systema promotes a
release only after every declared file and schema passes. The previously pinned release remains
available for rollback.

## Consumer ownership

Systema owns the imported-release record, cache tables/files, native routes/components, existing
entitlement checks, learning progress and activity events. Progress uses the stable VisualDCS ID
plus user, status, score and timestamps; delivery retries are idempotent. Raw learner events and
person-level exports never return to VisualDCS.

## Failure behavior

- Hash/schema mismatch: reject the new release and keep the previous pin.
- Missing optional record: render a documented sparse state.
- Unknown breaking version: reject; never best-effort parse.
- Progress event retry: upsert/idempotency key, never double-count.
- Entitlement uncertainty: deny full access and retain public preview; never infer payment state.

_Dr. Mārcis Gasūns_
