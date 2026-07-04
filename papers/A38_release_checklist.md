# A38 / DCS-2026 — Zenodo + DOI release checklist

_Created: 04-07-2026 · Last updated: 04-07-2026_

Data-release checklist for the DCS-2026 master behind
[`A38_dcs2026_release_paper.md`](https://github.com/gasyoun/VisualDCS/blob/main/papers/A38_dcs2026_release_paper.md).
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

## 4. Zenodo push + DOI mint (MG @DO — do not automate credentials)

1. Wait for / confirm the Hellwig rights gate (§1).
2. On [zenodo.org](https://zenodo.org) (logged in via GitHub): **GitHub** integration page →
   flip the toggle for `gasyoun/VisualDCS`.
3. Zenodo archives only *tagged releases created after the toggle* — so either create a fresh
   tag (e.g. `dcs-full-2026-03-05.1`, same asset re-attached) or upload `dcs_full.sqlite.gz`
   manually as a Zenodo deposit (287.7 MB ≪ the 50 GB cap; manual upload gives cleaner metadata
   control and is the recommended path here).
4. Deposit metadata: type *Dataset*; title = the paper's title; creator Gasūns (ORCID
   0000-0003-4513-884X); license **CC BY 4.0**; related identifier *isDerivedFrom* → the
   upstream DCS (`https://github.com/OliverHellwig/sanskrit`, commit `04e0778d…`); description
   from the paper abstract.
5. Publish → copy the **version DOI** (not just the concept DOI).
6. Paste the DOI into: paper §8 (Data and reproducibility), `CITATION.cff` (`doi:` field),
   and the Release notes of `dcs-full-2026-03-05`.
7. Update `Uprava/ARTICLES.md` (A38 → readiness 4/5 candidate) and close the GTD @DO.

_Dr. Mārcis Gasūns_
