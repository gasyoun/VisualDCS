_Created: 04-06-2026 · Last updated: 05-09-2026_

# CSL Atlas DCS Migration

Date: 2026-06-03
Last updated: 2026-06-04

These files were copied from `csl-atlas` during the boundary cleanup that made
`csl-atlas` dictionary-only.

The handoff merged in
[`VisualDCS` PR #4](https://github.com/gasyoun/VisualDCS/pull/4). The
corresponding atlas cleanup merged in
[`csl-atlas` PR #32](https://github.com/sanskrit-lexicon/csl-atlas/pull/32).

They preserve the earlier DCS reference-data inspection and generated manifest:

- `DCS_SCHEMA.md`
- `DCS_CORPUS_INGESTION_PLAN.md`
- `build-dcs-corpus.mjs`
- `dcs-manifest.json`

They are migration material only. They are not yet integrated into the
VisualDCS runtime or build.

If a copied file still says "atlas", read that as historical context from the
source repository. Active DCS/corpus ownership is here, in VisualDCS, and any
future implementation should first rewrite the plan in VisualDCS terms.

_Dr. Mārcis Gasūns_
