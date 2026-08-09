_Created: 09-08-2026 · Last updated: 09-08-2026_

# VisualDCS Learner Contracts — v1

Versioned read-only data contracts exposing DCS-derived learning objects to downstream
consumers (Systema-Sanscriticum and future cabinet integrations).

**Producer:** `VisualDCS` (this repo, `visual/contracts/v1/`)  
**Consumer:** `Systema-Sanscriticum` (owns identity, entitlements, progress, UI, commerce)  
**Handoff:** H2481 (Grok 4.5) — VisualDCS learner-contract release

---

## Payloads

| File | Records | Description |
|---|---|---|
| [`v1/verb-trainer.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/verb-trainer.json) | 7,689 roots | Conjugation cells with corpus evidence and tier labels |
| [`v1/nominal-trainer.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/nominal-trainer.json) | 31,753 lemmas | Declension cells per lemma across 8 cases × 3 numbers |
| [`v1/concordance-passage.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/concordance-passage.json) | 40 passages / 64 links | Curated reading passages cross-linked to concordance forms |
| [`v1/manifest.json`](https://github.com/gasyoun/VisualDCS/blob/main/visual/contracts/v1/manifest.json) | — | Release manifest with SHA-256, byte sizes, source pins |

Schemas live in [`v1/schemas/`](https://github.com/gasyoun/VisualDCS/tree/main/visual/contracts/v1/schemas).

---

## Stable ID grammar

IDs are opaque handles — never parse them for display; treat as string keys only.

| Type | Pattern | Example |
|---|---|---|
| Verb cell | `vdcs:v1:verb:<root-id>:<cell>` | `vdcs:v1:verb:gam:present-active.sg.3` |
| Nominal cell | `vdcs:v1:nominal:<lemma-id>:<cell>` | `vdcs:v1:nominal:42:nom-sing` |
| Passage | `vdcs:v1:passage:<title-slug>:<source-id>` | `vdcs:v1:passage:hitopadesa:3` |

IDs are stable within a `contractVersion`. A root/lemma/passage removal is a breaking
change and requires bumping to `v2`.

---

## Pinned-import algorithm (consumer guide)

```
1. Read manifest.json → note contractVersion and releaseId
2. Verify: sha256(file) == manifest.sha256[file] for each payload file
3. Cache payload files locally keyed by releaseId
4. On update: fetch new manifest.json → compare releaseId and sha256 hashes →
   download only changed payload files → swap cache atomically
5. Rollback: keep the previous releaseId cache; restore on any sha256 mismatch
```

Only `visual/contracts/v1/` is consumer-facing. Never read raw `visual/` source files
directly — their structure is internal and may change without notice.

---

## Preview / Full tier boundary

Each verb root and nominal lemma carries a `tier` field:

- `"full"` — token rank ≤ `tierBoundary` (100) — highest-frequency items  
- `"attested"` — rank > `tierBoundary` — lower-frequency, still attested in DCS

Consumer apps MAY expose `full`-tier items to all users and gate `attested`-tier items
behind a premium entitlement. The VisualDCS contract does not encode entitlement logic —
that is Systema-Sanscriticum's domain.

---

## Concordance passage coverage gap

22 of 40 passages are reachable via concordance links; 18 have zero links. This is a
named, documented gap — not a data error. The `unresolved` field in
`concordance-passage.json` lists all 18 zero-link `sourceId` values with a note explaining
the citation-matching strategy. Future releases may improve coverage via wider citation
normalization. Zero-link passages are included in the payload for completeness.

---

## Compatibility policy

Within `contractVersion: "1.0.0"` (v1), all changes are **additive only**:
- New fields may be added to any object
- Existing fields will not be renamed or removed
- Enum values will not be removed from `tier`, `kind`, or `evidence`

A breaking change (field removal, ID grammar change, enum contraction) requires a new
`contractVersion` in a new `visual/contracts/v2/` directory.

---

_Dr. Mārcis Gasūns_
