# Type-D `id_gra` ↔ VedaWeb-stanza concordance

_Created: 11-07-2026 · Last updated: 11-07-2026_

Built for [H522](https://github.com/gasyoun/Uprava/blob/main/handoffs/H522-Sonnet_VisualDCS_type_d_grammar_nongrammar_id_join_10.07.26.md)
(Q4.0 of the
[Concordance roadmap](https://github.com/gasyoun/Uprava/blob/main/CONCORDANCE_ROADMAP_GRAMMAR_NONGRAMMAR_2026_2027.md)),
consuming the D2 schema and the [H097](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H097-Sonnet_VisualDCS_gra_vedaweb_crosswalk_03.07.26.md)
crosswalk. Data file: [`type_d_id_join.tsv`](type_d_id_join.tsv). Build script:
[`build_type_d_id_join.py`](build_type_d_id_join.py).

## Schema (D2, fixed — not redesigned here)

`{grammar_id, nongrammar_locus, link_type, source_dataset, date}`:

- `grammar_id` — `id_gra:<L-number>`, reused unchanged from `gra_vedaweb_crosswalk.tsv`.
- `nongrammar_locus` — `vedaweb:<resource-id>:<stanza-ref>`, where `<resource-id>` is
  VedaWeb's own hex resource ID (each export's top-level `"id"` field) and `<stanza-ref>`
  is the RV `location` (e.g. `1.1.6`).
- `link_type` — `translation-witness` for all rows in this handoff's scope.
- `source_dataset` — which of the 3 exports the row came from.
- `date` — join-computation date (`2026-07-11`), not source-publication date.

## Method

No fuzzy matching was needed. `gra_vedaweb_crosswalk.tsv` (H097) already carries a
`vedaweb_example_location` column: one attested RV stanza per Grassmann `<L>` headword,
in the same `Book.Hymn.Verse` format (`1.1.6`) VedaWeb uses in every export's per-stanza
`location` field. All three translation-layer exports
([`metrical_data_2024.json`](metrical_data_2024.json),
[`geldner_de_1951_1957.json`](geldner_de_1951_1957.json),
[`grassmann_de_1876_1877.json`](grassmann_de_1876_1877.json)) already stamp `location`
per stanza — confirmed by direct inspection before writing any join logic (per-stanza
keys, not free text). The join is therefore a direct lookup: for every crosswalk row,
check whether its `vedaweb_example_location` is present in an export's location set, and
if so emit a join row carrying that export's resource ID and `<L>`-number unchanged.

## Coverage

`gra_vedaweb_crosswalk.tsv`: 9,945 rows, 5,164 unique example locations.

| Export | Resource ID | Stanzas | Unique locations matched | Join rows |
|---|---|---|---|---|
| `metrical_data_2024.json` | `67615e6bb20f4c1a9fb8a040` | 10,551 | 5,164 / 5,164 (100%) | 9,945 |
| `geldner_de_1951_1957.json` | `668bb0671e18769f3d9a8689` | 10,548 | 5,160 / 5,164 (99.9%) | 9,918 |
| `grassmann_de_1876_1877.json` | `668bbf5c1e18769f3d9aafc3` | 10,552 | 5,164 / 5,164 (100%) | 9,945 |

**Total: 29,808 `translation-witness` rows.** Geldner's shortfall is a real gap in the
underlying export (4 of its 10,552 potential stanzas are missing/unlanded), not a join
defect — the 4 missing locations were checked and are simply absent from
`geldner_de_1951_1957.json`'s own `contents` array.

## Elizarenkova RU witness — ready 4th source, out of scope here

The handoff's context line assumed the Elizarenkova (1989–1999) Russian RV translation
landed in
[`SanskritLexicography/RussianTranslation`](https://github.com/gasyoun/SanskritLexicography/tree/master/RussianTranslation).
On inspection, [`elizarenkova_ru_1989_1999.json`](elizarenkova_ru_1989_1999.json) actually
already sits in this same `VisualDCS/non-derived/vedaweb/` directory (landed by H361,
08-07-2026), with the identical `location`-keyed schema (10,552 stanzas, resource ID
`668be38c1e18769f3d9b0251`). It would join against the same crosswalk with the same
method — a one-line addition to `EXPORTS` in `build_type_d_id_join.py` — but is left out
of this handoff's delivered scope (the 3 named exports only) since the roadmap treats it
as a separately-tracked source. Flagged here so a future session doesn't have to
re-discover the location match.

## Consumers

- [`PROJECT_INTERLINKS.md`](https://github.com/gasyoun/Uprava/blob/main/PROJECT_INTERLINKS.md)
  Corpus & morphology feeds section.
- [`VisualDCS/non-derived/INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/non-derived/INDEX.md).
- Q4.0 row in
  [`CONCORDANCE_ROADMAP_GRAMMAR_NONGRAMMAR_2026_2027.md`](https://github.com/gasyoun/Uprava/blob/main/CONCORDANCE_ROADMAP_GRAMMAR_NONGRAMMAR_2026_2027.md).

_Dr. Mārcis Gasūns_
