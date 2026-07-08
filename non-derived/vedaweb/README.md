# non-derived/vedaweb — VedaWeb 2.0 Rig-Veda bulk export

_Created: 08-07-2026 · Last updated: 08-07-2026_

**Derived crosswalks:**
- [`gra_vedaweb_crosswalk.tsv`](gra_vedaweb_crosswalk.tsv) + report
  [`GRA_CROSSWALK.md`](GRA_CROSSWALK.md) — Grassmann `<L>` entries → attested RV occurrence
  counts, built from this feed's `lemmatization.json` (H097).
- [`pwg_vedaweb_gloss_crosswalk.tsv`](pwg_vedaweb_gloss_crosswalk.tsv) + report
  [`PWG_VEDAWEB_GLOSS_CROSSWALK.md`](PWG_VEDAWEB_GLOSS_CROSSWALK.md) — PWG `<L>` entries →
  attested RV occurrences, paired with Geldner/Grassmann full-sentence translations
  ([`geldner_de_1951_1957.json`](geldner_de_1951_1957.json),
  [`grassmann_de_1876_1877.json`](grassmann_de_1876_1877.json)) as a gloss-validation
  witness, built from `lemmatization.json`'s `id_pwg` field (H362).

Registered feed for [H096](https://github.com/gasyoun/Uprava/blob/main/handoffs/H096-Sonnet_VisualDCS_vedaweb_feed_export_03.07.26.md)
— a **one-time bulk export** of four core Rig-Veda annotation layers from
[VedaWeb 2.0](https://vedaweb.uni-koeln.de/) (Universität zu Köln), landed here so
downstream consumers ([H097](https://github.com/gasyoun/Uprava/blob/main/handoffs/H097-Sonnet_VisualDCS_gra_vedaweb_crosswalk_03.07.26.md)
GRA↔VedaWeb crosswalk, [H098](https://github.com/gasyoun/Uprava/blob/main/handoffs/H098-Sonnet_VisualDCS_vedaweb_meter_translations_triage_03.07.26.md)
meter/translation triage, the ZALIZNYAK a–f accent-mobility emission) read from disk
instead of re-hitting the API.

## Retrieval

- **Date:** 08-07-2026 (UTC ~07:49–08:06)
- **Method:** VedaWeb 2.0 REST API (FastAPI), OpenAPI spec at
  [`https://vedaweb.uni-koeln.de/api/openapi.json`](https://vedaweb.uni-koeln.de/api/openapi.json).
  Catalog via `GET /api/resources?limit=4096`; each export via the async
  `GET /api/resources/{id}/export` → `202` + `pickupKey` → `GET /api/platform/tasks/download?pickupKey=…`
  flow (undocumented-but-anonymous per [FINDINGS.md §48](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)).
  Retrieval was polite/serial (one export in flight at a time, no auth, no rate-limit
  errors encountered).
- **Prior attempts:** two earlier sessions (03-07-2026) were blocked by a server-side
  `vedaweb.uni-koeln.de` outage — see [FINDINGS.md §48](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)
  and the H096 registry row. This session's liveness probe (`curl -sI …/openapi.json`)
  returned `200` before starting.
- **Note on the pickup-key mechanism:** each `pickupKey` is **single-use** — the first
  `GET .../download` call consumes it even if the HTTP transfer is truncated client-side
  (observed once on `lemmatization.json`, a 30s `curl --max-time` cut a live transfer
  short; the retry needed a *fresh* `/export` trigger, not a re-request with the same
  key). Re-trigger rather than retry on any partial download.

## Files

| file | resource ID | layer | rows (stanzas) | bytes (raw) | sha256 |
|---|---|---|---|---|---|
| `catalog.json` | — | full resource-listing catalog (36 resources) | 36 | 175,068 | `6b8834ea0e8cff80d4788ca3735ba38335b328e09edad0dddfbbd5fe68dae6e8` |
| [`casaretto_accented_wordsplit.json.gz`](casaretto_accented_wordsplit.json.gz) | `66695e4a14f6d337f7788740` | Casaretto et al. (2025) udātta-marked, position-aligned word-split + morphology | 10,552 | 105,669,318 (raw) / 8,069,363 (gz) | raw `0f64cf6bfe6d7cb4c46947a1f9303c20529b714c00b280f7fc1b6c6b0f014116` · gz `33c193af7d477f3f8e0cd5d041da86986f11b86ee6b9ba6d4c674961ac91ac89` |
| [`lemmatization.json`](lemmatization.json) | `679b7da2d5b833a67f64b3f7` | lemmatization + dictionary-entry cross-references (same positions) | 10,552 | 40,975,485 | `fc7ac8a419f66881ed1b9e9556adf13b2ebce4df8395ba7a6db1ec54b6a96cf3` |
| [`accented_text_scarlata_widmer_lubotsky.json`](accented_text_scarlata_widmer_lubotsky.json) | `66695c4b14f6d337f778873f` | accented saṁhitā text (Zurich version, Scarlata & Widmer 2017, after Lubotsky) | 10,552 | 2,520,899 | `02a3cf443ffb1f746abe3ca068732de247ae0f3715c527d67bd8a81588bbe7cd` |
| [`padapatha_lubotsky.json`](padapatha_lubotsky.json) | `668ba4460b5942c9849a8684` | Lubotsky (1997) padapāṭha | 10,552 | 2,414,660 | `87b95d2dc5c25a591ab6be638725813fcf96c5f5df9ec1cf766357a9551040f4` |
| [`metrical_data_2024.json`](metrical_data_2024.json) | `67615e6bb20f4c1a9fb8a040` | Metrical Data, Kiss & Kölligan (2024) — computer-generated scansion + meter-type label, based on Van Nooten & Holland (1994) | 10,551 | 3,192,567 | `662fe3e1c3df72b8bfea62ee47a01218cbed4bd042cf8e2a3facfc1e4eaaba77` |
| [`geldner_de_1951_1957.json`](geldner_de_1951_1957.json) | `668bb0671e18769f3d9a8689` | Geldner (1951-57) German RV translation | 10,548 | 2,880,341 | `3cecd154bc9b5c6626771aa573fe827030e8a3415bdd8110f9765c556a7105b3` |
| [`grassmann_de_1876_1877.json`](grassmann_de_1876_1877.json) | `668bbf5c1e18769f3d9aafc3` | Grassmann (1876-77) German RV translation | 10,552 | 2,660,969 | `9c4da98b28913f69e42a8344cfcb1e3587322feb23a1bad5c60ab693bef0ce75` |

All core exports cover the same Rig-Veda stanza/verse positions (RV maṇḍalas 1–10, per
`location`-keyed `contents[]` entries), position-aligned across files (Metrical Data is
one stanza short of the full 10,552 and Geldner is 4 stanzas short — source-side gaps,
not export defects). `casaretto_accented_wordsplit.json` exceeds the ~40MB size rule
(105MB raw) and is committed gzipped only — decompress with
`gunzip -k casaretto_accented_wordsplit.json.gz` or re-fetch fresh via the export flow
above (resource ID `66695e4a14f6d337f7788740`).

**Geldner + Grassmann translations (08-07-2026, H362):** landed after
[H359](https://github.com/gasyoun/Uprava/blob/main/handoffs/H359-Sonnet_Uprava_vedaweb_rights_outreach_send_08.07.26.md)
confirmed both CC BY 4.0 (see § License & attribution below). Export shape:
`id`, `title`, `subtitle`, `level`, `citation`, `description`, `meta`,
`contents[]` — each entry `{location, text, createdAt, archived}`, `text` a
full-sentence German translation of the stanza (not per-token).

**Metrical Data (08-07-2026, H360):** landed after
[H359](https://github.com/gasyoun/Uprava/blob/main/handoffs/H359-Sonnet_Uprava_vedaweb_rights_outreach_send_08.07.26.md)
confirmed CC BY 4.0 (see § License & attribution below). Export shape: `id`, `title`,
`subtitle`, `level`, `citation`, `description`, `meta`, `contents[]` — each entry
`{location, text, comments[], createdAt, archived}`; `text` holds one long/short
scansion line per pada, `comments[]` carries the meter-type label (e.g.
`{"by": "VedaWeb", "comment": "Stanza Type: Gāyatrī"}`), `null`/absent where VedaWeb
assigned no meter type. Consumed by
[SanskritKaraoke](https://github.com/gasyoun/SanskritKaraoke)'s `rv_verse_seeds.json`
seed table (H360).

Export format for all four is the API default (`format=json`, undocumented top-level
shape: `id`, `title`, `subtitle`, `level`, `citation`, `description`, `meta`,
`contents[]` — each `contents[]` entry keyed by `location` with layer-specific fields:
`tokens`/`text`/`calls`).

## License & attribution

**CC BY 4.0.** Attribute **"VedaWeb 2.0, Universität zu Köln"** for the platform, plus
the per-layer citation below (VedaWeb resources carry no machine-readable `license`
field in the catalog — this is the attribution VedaWeb's own site and prior probe
confirmed, [ROADMAP_VEDAWEB_REUSE.md](https://github.com/gasyoun/SanskritLexicography/blob/master/ROADMAP_VEDAWEB_REUSE.md)):

- **Casaretto et al. (2025)** (`casaretto_accented_wordsplit.json`, `lemmatization.json`):
  Casaretto, Antje, Pascal Coenen, Anna Fischer, Jakob Halfmann, Natalie Korobzow,
  Daniel Kölligan & Uta Reinöhl. 2025. *The morphologically glossed Rigveda – The Zurich
  annotation corpus revised and extended.* Hosted by VedaWeb – Online Research Platform
  for Old Indic Texts. University of Cologne.
  `https://vedaweb.uni-koeln.de/texts/rv/resources#id=66695e4a14f6d337f7788740`
- **Scarlata & Widmer (2017)** (`accented_text_scarlata_widmer_lubotsky.json`):
  Scarlata, Salvatore & Paul Widmer. 2017. *The Rigveda based on Lubotsky's word
  concordance.* Curated and hosted by VedaWeb – Online Research Platform for Old Indic
  Texts. University of Cologne.
- **Lubotsky (1997)** (`padapatha_lubotsky.json`): Lubotsky, Alexander. 1997.
  *Padapatha-text of the Rigveda.* Prepared by A. Lubotsky. Leiden. Transformed and
  hosted by VedaWeb – Online Research Platform for Old Indic Texts. University of
  Cologne.
- **`lemmatization.json`** additionally cross-references dictionary entries in
  **Cologne Digital Sanskrit Dictionaries** (Böhtlingk & Roth, Grassmann, Mayrhofer,
  Monier-Williams) — `provided by` credits Thomas Malten, Peter Scharf, Malcolm D.
  Hyman, Jim Funderburk (CDSD) alongside the VedaWeb team, a direct tie to this org's
  own dictionary work.
- **Kiss & Kölligan (2024)** (`metrical_data_2024.json`): Kiss, Börge, & Daniel
  Kölligan. 2024. *Computer-generated metrical analysis of the Rigveda saṁhitā text
  based on the edition of Van Nooten & Holland (1994).* Cologne. Curated and hosted by
  VedaWeb – Online Research Platform for Old Indic texts. University of Cologne.
  Generated via the open-source
  [`viracitapada`](https://github.com/VedaWebProject/viracitapada) tool. Rights
  confirmed CC BY 4.0 by Prof. Daniel Kölligan, 08-07-2026 (see H359 reply).
- **Geldner (1951-1957)** (`geldner_de_1951_1957.json`): Geldner, Karl Friedrich.
  1951-1957. *Der Rig-Veda aus dem Sanskrit ins Deutsche übersetzt.* Cambridge, Mass.:
  Harvard University Press. Digitized/hosted by VedaWeb – Online Research Platform for
  Old Indic Texts. University of Cologne. Rights confirmed CC BY 4.0 by Prof. Daniel
  Kölligan, 08-07-2026 (see H359 reply).
- **Grassmann (1876-1877)** (`grassmann_de_1876_1877.json`): Grassmann, Hermann. 1876-77.
  *Rig-Veda, übersetzt und mit kritischen und erläuternden Anmerkungen versehen.*
  Leipzig: F.A. Brockhaus. Digitized/hosted by VedaWeb – Online Research Platform for
  Old Indic Texts. University of Cologne. Rights confirmed CC BY 4.0 by Prof. Daniel
  Kölligan, 08-07-2026 (see H359 reply).

## Advisory-only

Per the org's I/VI accent-collapse lesson: nothing from this feed is ever written
directly into reviewed/human dictionary or corpus data anywhere in this org. It is a
read-only external corpus reference for crosswalks, validation runs, and triage
(H097/H098/WhitneyRoots accent validation).

_Dr. Mārcis Gasūns_
