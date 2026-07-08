# LAYERS_TRIAGE.md — VedaWeb 2.0 meter + translation layers, GO/NO-GO triage

_Created: 08-07-2026 · Last updated: 08-07-2026_

[H098](https://github.com/gasyoun/Uprava/blob/main/handoffs/H098-Sonnet_VisualDCS_vedaweb_meter_translations_triage_03.07.26.md)
deliverable — Phase 4 of
[ROADMAP_VEDAWEB_REUSE.md](https://github.com/gasyoun/SanskritLexicography/blob/master/ROADMAP_VEDAWEB_REUSE.md).
Gated on the [H096](https://github.com/gasyoun/Uprava/blob/main/handoffs/H096-Sonnet_VisualDCS_vedaweb_feed_export_03.07.26.md)
catalog ([`catalog.json`](catalog.json), 36 resources, retrieved 08-07-2026). This is a
**triage, not a bulk import** — every claim below is checked against the live catalog and,
for the two headline candidates, a real sample export. Nothing new was bulk-landed; see
§ Sample exports for the two files that were fetched, sampled, and discarded (not
committed — see rights finding below for why).

## Headline finding: the "CC BY 4.0 platform default" is not machine-confirmed for 34/36 layers

H096 and `ROADMAP_VEDAWEB_REUSE.md` state VedaWeb's content license as **CC BY 4.0** for
everything, attributed to "VedaWeb 2.0, Universität zu Köln." Re-checking against the
catalog's own `license`/`licenseUrl` fields and the platform's site-notice segment
(`GET /api/platform/segments/6669938faf86e41764a1502a`, English "Responsible for the
Content of This Website" page) found:

- **34 of 36 catalog resources have `license: null`.** Only two carry an explicit license:
  the **Zurich RV Edition** (Zehnder et al. 2024, `68cbd0d2…`) — **CC BY 4.0** — and the
  **Würzburger AV Text** (Kim 2025, `68d39ddd…`) — **CC BY-SA 4.0**.
- The site notice states: *"Individual resources provide their own citation guidelines,
  which can be found in the resource information. Please use these for citing specific
  data."* — i.e. the platform's own stated policy is **per-resource citation, not a
  blanket redistribution license**. The `citation` field present on every resource (a
  bibliographic "cite as" string with `{{res_url}}`/`{{curr_date}}` placeholders) is a
  **citation requirement, not a license grant**.
- No platform-wide content-license statement was found on `/api/platform` (footer,
  about, privacy, or site-notice segments) — the only license text present is for the
  **Tekst software** itself (`AGPL-3.0-or-later`, unrelated to the hosted data).

**This does not necessarily mean H096's four already-landed layers are mis-licensed** —
those four (Casaretto accented word-split/morphology, lemmatization+CDSD cross-refs,
Scarlata & Widmer accented text, Lubotsky padapāṭha) are VedaWeb-team-authored derived
scholarship, a materially different rights posture than a third-party translator's prose
(below). But the blanket "CC BY 4.0 for everything" framing in
[ROADMAP_VEDAWEB_REUSE.md](https://github.com/gasyoun/SanskritLexicography/blob/master/ROADMAP_VEDAWEB_REUSE.md)
was an assumption carried from an early on-ramp probe, not a re-verified fact — flagged
below as a FINDINGS entry and a GTD `@DECIDE` (confirm-or-narrow) rather than silently
corrected, since H096 is already merged and out of this handoff's scope to re-litigate.

**Rule applied here:** per H098's binding guardrail ("a layer whose license/provenance
can't be confirmed is DECIDE, never GO"), every layer without an explicit `license` field
is **DECIDE**, not GO — including the two headline candidates (Elizarenkova RU, Metrical
Data). The two explicitly-licensed layers are the only clean GO.

## Method

1. Full catalog re-read (36 resources) — `id`, `title`, `resourceType`, `level`, `license`/
   `licenseUrl`, `meta` (author/editor/year/language/data-steward/revisions-by).
2. Live sample-exports (async `/resources/{id}/export` → `pickupKey` →
   `/platform/tasks/download`, per [FINDINGS §48](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md))
   for the two headline claims: Elizarenkova Russian translation and the VedaWeb-generated
   metrical-scansion layer. Both confirmed real and field-mapped (§ Sample exports); neither
   was committed (DECIDE, not GO — see rights finding).
3. Copyright-term cross-check per translator: for named third-party translators, `life + 70`
   (the binding term in the EU/Germany/France/Russia jurisdictions relevant here) against
   the translator's death year, to separate "old enough to plausibly be PD regardless of
   VedaWeb's own rights" from "still in copyright, VedaWeb's hosting rights unconfirmed."
   This is triage-grade (death years from public reference, not individually re-verified
   per name) — treat as directional, not a legal opinion.

## Full 36-layer inventory

| # | title | resourceType | level | lang | author/editor (death yr, PD-term note) | license field | verdict | consumer |
|---|---|---|---|---|---|---|---|---|
| 1 | Hymn Properties (Geldner 1951-57) | locationMetadata | 1 | — | VedaWeb-team-curated metadata | null | DECIDE | — (metadata, low value alone) |
| 2 | Lemmatization + dict entries | apiCall | 2 | sa/en/de | VedaWeb team | null | **GO (already landed, H096)** | already consumed |
| 3 | Recitation, Kirchheiner (1983) | audio | 2 | sa | Guni H. Kirchheiner (living/recent) | null | DECIDE | SanskritKaraoke (audio gate applies) |
| 4 | Literature References | externalReferences | 2 | — | VedaWeb team | null | DECIDE | low priority |
| 5 | Stanza Properties, Arnold (1905)/Oldenberg | locationMetadata | 2 | — | Arnold †1926, Oldenberg †1920 — PD source, VedaWeb encoding layer unconfirmed | null | DECIDE | metrical cross-check |
| 6 | **Metrical Data, VedaWeb 2024** (Van Nooten & Holland base) | plainText | 2 | — | VedaWeb team (Kiss & Kölligan), computer-generated via open-source [`viracitapada`](https://github.com/VedaWebProject/viracitapada) | null | **DECIDE (low-risk — recommend outreach)** | **SanskritKaraoke meter labels** |
| 7 | Griffith (1889-1991 sic, actually 1889-1896) | plainText | 2 | en | Ralph T.H. Griffith †1906 — PD (life+70 since 1976) | null | DECIDE* | PWG/comparative gloss witness |
| 8 | Renou (1955-1969) | plainText | 2 | fr | Louis Renou †1966 — **in copyright to 2036** | null | **DECIDE — do not use without rights clearance** | — |
| 9 | Zurich version, Scarlata & Widmer (2017), after Lubotsky | plainText | 2 | sa | living/recent editors | null | DECIDE (already landed as accented text via H096 under the team-authored rationale) | already consumed |
| 10 | Aufrecht (1955 reprint of 1877 ed.) | plainText | 2 | sa | Theodor Aufrecht †1907 — PD | null | DECIDE* | — |
| 11 | Eichler (2017), after Aufrecht/Van Nooten & Holland | plainText | 2 | sa (Deva) | Detlef Eichler (living/recent) — **in copyright** | null | **DECIDE — do not use without clearance** | — |
| 12 | Van Nooten & Holland (1994) | plainText | 2 | sa (IAST) | living/recent editors — **in copyright** | null | **DECIDE** | base text for Metrical Data (#6) |
| 13 | Lubotsky Padapatha (1997) | plainText | 2 | sa | Alexander Lubotsky (living) — **in copyright** | null | DECIDE (already landed via H096 under the team-hosting rationale) | already consumed |
| 14 | Geldner (1951-1957) | plainText | 2 | de | Karl Friedrich Geldner †1929 — PD (life+70 since 2000); VedaWeb's specific digitized/revised edition layer unconfirmed | null | DECIDE* | **PWG German gloss witness** |
| 15 | Grassmann (1876-1877) | plainText | 2 | de | Hermann Grassmann †1877 — PD | null | DECIDE* | PWG German gloss witness (GRA is a sibling dict already) |
| 16 | Otto (1948, written pre-1937) | plainText | 2 | de | Rudolf Otto †1937 — PD (life+70 since 2008) | null | DECIDE* | — |
| 17 | MacDonell (1922) | plainText | 2 | en | Arthur A. MacDonell †1930 — PD (life+70 since 2001) | null | DECIDE* | — |
| 18 | Müller (1891) | plainText | 2 | en | Max Müller †1900 — PD | null | DECIDE* | — |
| 19 | Oldenberg (1897) | plainText | 2 | en | Hermann Oldenberg †1920 — PD | null | DECIDE* | — |
| 20 | **Elizarenkova (1989-1999)** | plainText | 2 | **ru** | Tatyana Elizarenkova †2007 — **in copyright to ~2078 (Russia, life+70)** | null | **DECIDE — do not use without rights clearance** | **RussianTranslation RU witness (blocked)** |
| 21 | Geraldes et al. (2023) | plainText | 2 | pt | living authors — **in copyright** | null | DECIDE | — (out of org scope) |
| 22 | **Annotations, Casaretto et al. (2025)** | textAnnotation | 2 | sa (ISO15919) | VedaWeb team (living) | null | GO (already landed, H096) | already consumed |
| 23 | Literature References (AB) | externalReferences | 3 | — | VedaWeb team | null | DECIDE | low priority |
| 24 | TITUS Edition, Gippert et al. (SB, 1997-2012) | plainText | 3 | sa | TITUS project (Frankfurt), base ed. Weber †1901 (PD) | null | DECIDE | — |
| 25 | Eggeling (1882-1900) | plainText | 3 | en | Julius Eggeling †1918 — PD | null | DECIDE* | — |
| 26 | Casaretto et al. (2021), after Hettrich & Weber | plainText | 3 | sa (IAST) | living/recent editors, base Hettrich (living) — **in copyright** | null | DECIDE | — |
| 27 | Hettrich (1988) | plainText | 3 | de | Heinrich Hettrich (living/recently active) — **in copyright** | null | DECIDE | — |
| 28 | Annotations, Casaretto et al. (2026) | textAnnotation | 3 | sa (IAST) | VedaWeb team (living) | null | **DECIDE (same rationale as #22, worth re-confirming together)** | **morphology-beyond-RV pool** |
| 29 | Hymn titles, Whitney & Lanman (1905) | locationMetadata | 1 | en | Whitney †1894, Lanman †1941 — PD (Lanman since 2011) | null | DECIDE* | AV metadata |
| 30 | TITUS Edition, Gippert et al. (AVS, 1997-2012) | plainText | 2 | sa | TITUS project, base Roth/Whitney 1856 (PD) | null | DECIDE | — |
| 31 | Whitney & Lanman (1905) | plainText | 2 | en | see #29 — PD | null | DECIDE* | AV translation witness |
| 32 | Links to Zurich Edition (AVP) | externalReferences | 2 | — | VedaWeb team | null | DECIDE | low priority |
| 33 | **Zurich Edition, Zehnder et al./Hellwig et al. (2024)** (AVP) | plainText | 2 | sa (ISO15919) | living editors, **but platform-asserted** | **CC BY 4.0** | **GO (confirmed)** | primary-text feed (not meter/translation, noted for completeness) |
| 34 | **Würzburger Text, Kim (2025)** (AVP) | plainText | 2 | sa (ISO15919) | Jeong-Soo Kim (living), **but platform-asserted** | **CC BY-SA 4.0** | **GO (confirmed)** | primary-text feed (not meter/translation, noted for completeness) |
| 35 | TITUS Edition, Gippert & Martínez García (JB, 1997-2012) | plainText | 2 | sa | TITUS project, base Aufrecht 1879 (PD) | null | DECIDE | — |
| 36 | TITUS Edition, Gippert et al. (MS, 1997-2008) | plainText | 2 | sa | TITUS project, base Raghu Vīra & Lokesh Chandra 1954 — **in copyright** | null | DECIDE | — |

`*` = translator's own work is plausibly PD by death-year, but VedaWeb's specific
digitized/revised text (the `revisions by` field most rows carry) has no independently
confirmed license — still DECIDE per the strict guardrail, but the **lower-risk tier**:
a maintainer email is more likely to yield a quick GO than the in-copyright rows.

## Consumer mapping (mission item 3)

| candidate layer | consumer | verdict | effort estimate if cleared |
|---|---|---|---|
| Metrical Data (VedaWeb 2024) (#6) | [SanskritKaraoke](https://github.com/gasyoun/SanskritKaraoke) RV verse seeds | DECIDE, low-risk (VedaWeb-team computed, open-source generator) | ~0.5d: export + per-pada scansion parse (audio gate at SanskritKaraoke is separate and still applies) |
| Elizarenkova RU (#20) | [RussianTranslation](https://github.com/gasyoun/SanskritLexicography/tree/master/RussianTranslation) context/citation witness | **DECIDE, in-copyright — do not use in bulk without explicit rights clearance from VedaWeb/Nauka publisher**; short scholarly-quotation excerpts (a line or two per citation, not bulk incorporation) are a materially different, likely-fine use, but that's an editorial call each time, not a feed | 0d until cleared; if cleared, ~0.5d export+land |
| Geldner de (#14), Grassmann de (#15) | PWG German gloss cross-check witness | DECIDE, lower-risk tier (translators PD, VedaWeb edition layer unconfirmed) | ~0.5d each if cleared |
| Casaretto et al. (2026) annotations (#28) | glossary-adjudication pool (SCL pilot 3 pattern) | DECIDE, same rationale as the already-landed #22 — worth a single combined rights confirmation covering both | ~0.5d if cleared |

**No GO items in the meter/translation/gloss/morphology scope this triage was asked to
cover.** The only two confirmed-license layers (#33, #34) are primary AV texts outside
that scope — noted for completeness, not spun into new handoffs here (no immediate
consumer named in the mission).

## Sample exports (verified, not landed)

Both fetched via the async export flow, inspected for real field shapes, then discarded
(not committed — DECIDE, not GO):

- **Elizarenkova** (`668be38c1e18769f3d9b0251`, format=json, ~4.0 MB, 10,551 `contents[]`
  entries): confirms the layer is real, genuinely Russian (Cyrillic prose, e.g. `location:
  "1.1.1"` → *"Агни призываю я – во главе поставленного…"*), and per-stanza (not
  per-pada). Same shape as the H096-landed layers: `id`, `title`, `subtitle`, `level`,
  `citation`, `description`, `meta`, `contents[]` keyed by `location` with a `text` field.
- **Metrical Data** (`67615e6bb20f4c1a9fb8a040`, format=json, ~3.2 MB, 10,551 entries):
  per-stanza `text` field holds one scansion line per pada (e.g.
  `"—◡ —— ◡—◡— (8)\n——◡ —◡ —◡— (8)\n——— —◡—◡— (8)"` — long/short syllable marks +
  syllable-count per pada) plus a `comments[]` array carrying the **meter-type label**
  (e.g. `{"by": "VedaWeb", "comment": "Stanza Type: Gāyatrī"}`). This is exactly the
  meter-label + restored-scansion shape SanskritKaraoke would need.

## Wiring

- **FINDINGS.md**: new §62 entry for the license-field-vs-blanket-claim gap (below).
- **GTD**: H098 row → done; new `@DECIDE` rows for (a) re-confirm/narrow the H096 blanket
  CC BY 4.0 claim, (b) rights clearance for the 4 DECIDE consumer-mapped layers above.
- **ROADMAP_VEDAWEB_REUSE.md**: Phase 4 ticked, with the DECIDE outcome (not a silent GO)
  recorded inline.
- **Registry**: H098 row 🟡→✅ in `handoffs/README.md`.

_Dr. Mārcis Gasūns_
