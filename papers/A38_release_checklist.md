# A38 / DCS-2026 — Zenodo + DOI release checklist

_Created: 04-07-2026 · Last updated: 04-07-2026_

Data-release checklist for the DCS-2026 master behind
[`H043-Fable_VisualDCS_dcs2026_release_26.06.26_paper.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/H043-Fable_VisualDCS_dcs2026_release_26.06.26_paper.md).
Agent-doable items are done; the Zenodo push / DOI mint itself is an **MG action** (needs the
Zenodo account) and is mirrored in the Uprava GTD hub.

## 1. Publish-safety (done — GO with one rights gate)

- **Intended visibility:** the repo, the Release asset
  ([`dcs-full-2026-03-05`](https://github.com/gasyoun/VisualDCS/releases/tag/dcs-full-2026-03-05))
  and all figures are already public on GitHub — no new exposure from a Zenodo mirror.
- **Personal data:** none (corpus text + morphological annotation only).
- **Secrets:** none in the artifact (SQLite built from public CoNLL-U).
- **Rights gate (the one open item):** the artifact is a *derived redistribution* of Oliver
  Hellwig's DCS (CC BY 4.0). CC BY permits redistribution with attribution, so the release is
  license-clean on its face; the **courtesy/confirmation sign-off from Hellwig** is nonetheless
  the standing gate before the DOI mint + journal submission (already a GTD @DO: email
  P. Hellwig; @WAITING: his reply). If the reply imposes conditions, resolve via
  `/decision-record` before minting.

## 2. License ruling

- **Upstream data:** CC BY 4.0 (Oliver Hellwig), per the distribution's provenance and readme —
  see [`src/DCS-data-2026/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/README.md)
  §License & citation.
- **Derived master + exports:** **CC BY 4.0**, attribution chain: Hellwig (annotation) →
  this project (packaging). Do not relicense more restrictively (CC BY forbids it in spirit) or
  more permissively (attribution must survive).
- **Repo code** (importers, validators): Apache-2.0 per the repo
  [`LICENSE`](https://github.com/gasyoun/VisualDCS/blob/main/LICENSE) — distinct from the data
  license; Zenodo record should state CC BY 4.0 (it describes the *data*).

## 3. Provenance + citation artifacts (done)

- [x] Provenance README —
  [`src/DCS-data-2026/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/README.md)
  + `provenance` table inside the DB (source SHA `04e0778d…`).
- [x] Validation reports committed
  ([`reports/`](https://github.com/gasyoun/VisualDCS/tree/main/src/DCS-data-2026/reports)); CI gate
  [`dcs-validate.yml`](https://github.com/gasyoun/VisualDCS/blob/main/.github/workflows/dcs-validate.yml).
- [x] [`CITATION.cff`](https://github.com/gasyoun/VisualDCS/blob/main/CITATION.cff) at repo root
  (added 04-07-2026 with this checklist; `doi:` field left blank until minted).
- [x] Asset integrity pinned in the paper: `dcs_full.sqlite.gz` = 287,713,306 bytes, SHA256
  `b9b76218f7145776e6014f885dee5dd74d6a8f80b9eddc11c82a51c4ad4a86b5`.

## 4. Zenodo push + DOI mint — ✅ EXECUTED 20-09-2026 (H5170 agent lane, per MG ruling «mint via Zenodo API ourselves»; legacy deposit API per Uprava FINDINGS §594)

1. [x] Hellwig rights gate confirmed — written CC-BY sign-off by email 2026-07-09 (see paper §8).
2. [x] Executed via the Zenodo **API with a personal token** (not the GitHub-integration
   toggle — the manual-upload path this checklist recommended): `dcs_full.sqlite.gz`
   (287,713,306 B, SHA-256 `b9b76218…` verified before and after upload, per-file MD5
   enforced by the mint script) + both SHA-256 sidecars.
3. [x] Metadata: type *Dataset*; title = the paper's title; creator Gasūns, Mārcis (ORCID
   0000-0003-4513-884X); license **CC BY 4.0**; related identifiers *isDerivedFrom* →
   `https://github.com/OliverHellwig/sanskrit/commit/04e0778d3dc971030229179e25eea043d06ff397`
   (commit existence verified live) + *isSupplementTo* → `gasyoun/VisualDCS`; attribution
   note "Derived from Oliver Hellwig: Digital Corpus of Sanskrit (DCS)" + release version in
   both `notes` and the description.
4. [x] **Concept DOI [10.5281/zenodo.22853985](https://doi.org/10.5281/zenodo.22853985)** ·
   **version DOI [10.5281/zenodo.22854185](https://doi.org/10.5281/zenodo.22854185)**
   (v2026.03.05). Incident note: a first publish (record 22853986) shipped one mis-uploaded
   sidecar (`dcs_full.sqlite.gz.sha256` carrying .gz bytes); remediated the same hour by a
   corrected **new version** under the same concept (record 22854185, file set verified);
   the concept DOI is unaffected. Version history keeps the defective v1 — standard Zenodo
   immutability.
5. [x] Record live-verified **logged-out** (HTTP 200; title/creator/file sizes match) before
   any DOI was wired.
6. [x] DOI pasted into: paper §8, `CITATION.cff` (`doi:` + identifiers), and the
   `dcs-full-2026-03-05` release notes.
7. [ ] `Uprava/ARTICLES.md` (A38 → readiness) — venue-gated editorial update, left to the
   articles lane.

_Dr. Mārcis Gasūns_
