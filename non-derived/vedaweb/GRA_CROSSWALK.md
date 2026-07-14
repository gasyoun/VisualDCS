# GRA ↔ VedaWeb 2.0 crosswalk — Grassmann entries → attested Rigveda occurrences

_Created: 08-07-2026 · Last updated: 08-07-2026_

Built for [H097](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H097-Sonnet_VisualDCS_gra_vedaweb_crosswalk_03.07.26.md),
consuming the [H096](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H096-Sonnet_VisualDCS_vedaweb_feed_export_03.07.26.md)
feed in [`lemmatization.json`](lemmatization.json). Data file:
[`gra_vedaweb_crosswalk.tsv`](gra_vedaweb_crosswalk.tsv).

## Prior art — VedaWeb already links Grassmann entries; we don't re-match text

Per the `/prior-art` reflex, before building anything the H096 `lemmatization.json` export
was inspected directly. Each of its 10,552 stanza entries carries a `transformContext`
field — a per-token array with `form`, `lemma`, and (critically) an **`id_gra`** array: the
**internal Grassmann dictionary ID VedaWeb itself already resolved**, sourced from the
[kosh.uni-koeln.de CDSD RESTful API](https://kosh.uni-koeln.de/cdsd/gra/restful/ids)
(`based on`: Böhtlingk & Roth / Grassmann / Mayrhofer / Monier-Williams; `provided by`:
Natalie Korobzow, Pascal Coenen, Antje Casaretto, Anna Fischer for VedaWeb, plus Thomas
Malten, Peter Scharf, Malcolm D. Hyman, Jim Funderburk for CDSD). **This means VedaWeb's
Casaretto et al. (2025) morphological layer already IS a token-level Grassmann crosswalk** —
there was no unmatched free text to fuzzy-join. The gap this handoff fills is narrower than
originally scoped: VedaWeb exposes numeric IDs only, not headword text, so nothing
resolves an `id_gra` back to a Grassmann key1/key2 headword or aggregates it into
occurrence counts per dictionary entry.

**Confirming the ID scheme.** The kosh RESTful API was probed live
(`GET https://kosh.uni-koeln.de/cdsd/gra/restful/ids?ids=79&ids=1824`) and returned
`key1=agni` / `key1=Iq` (√īḍ) for those IDs — which matched exactly the `<L>79<pc>0008<k1>agni…`
and `<L>1824<pc>0230<k1>Iq…` entry headers already sitting locally in this org's own
[`csl-orig/v02/gra/gra.txt`](https://github.com/sanskrit-lexicon/csl-orig/blob/main/v02/gra/gra.txt).
**VedaWeb's `id_gra` is exactly the Grassmann `<L>` entry number** — so the ID→headword
join was built entirely from local `csl-orig` data (12,785 `<L>` entries, including
decimal-suffixed compound sub-entries like `<L>5833.1`), with zero live API calls needed
for the bulk of the work (only the two-ID confirmation probe hit the network).

## Method

1. Parsed all 164,758 `transformContext` tokens across the 10,552 stanza entries in
   `lemmatization.json`; every token in this export carries at least one `id_gra` (VedaWeb's
   lemmatization resource appears to be pre-filtered to dictionary-linkable content words —
   it is **not** a full RV word-count census; see caveat below).
2. Aggregated by `id_gra` → 9,946 unique Grassmann entry IDs, with RV occurrence counts.
3. Parsed `csl-orig/v02/gra/gra.txt` locally: regex over `<L>ID<pc>PC<k1>KEY1<k2>KEY2[<h>HOM]`
   header lines → 12,785 entries, 11,108 unique `key1` headwords (matches
   [`GRA-unique-key1-11108.txt`](https://github.com/gasyoun/SanskritLexicography/blob/master/HeadwordLists/now-2026/GRA-unique-key1-11108.txt)
   exactly — a useful independent sanity check that the local `<L>` parse is complete).
4. Joined `id_gra` → `<L>` entry → `key1`/`key2`/`hom` → wrote
   [`gra_vedaweb_crosswalk.tsv`](gra_vedaweb_crosswalk.tsv) (9,945 matched rows), one row
   per Grassmann entry with its RV occurrence count and one example VedaWeb token.

Reused the existing `csl-orig` line-format parser convention (no new transcoder — the join
is a plain ID lookup, not a transliteration match, so [FINDINGS.md §36](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)
accent-stripping pitfalls don't apply here).

## Coverage — honest numbers

| Metric | Count | % |
|---|---:|---:|
| GRA `<L>` entries total (all senses/homonyms) | 12,785 | — |
| GRA unique `key1` headwords total | 11,108 | — |
| GRA `<L>` entries attested ≥1× in RV via VedaWeb link | 9,945 | 77.8% |
| GRA unique `key1` headwords attested ≥1× in RV via VedaWeb link | 9,475 | 85.3% |
| Total RV token occurrences linked to a GRA entry | 192,637 | — |
| VedaWeb `id_gra` values with no matching `<L>` in current `gra.txt` | 1 | — |

**The single unmatched ID** is a literal `"-"` placeholder in one token's `id_gra` array
(form `tŕ̥ṇam`, location `1.161.11`) — a VedaWeb-side sentinel/data artifact, not a real
Grassmann entry number. Everything else resolved cleanly, which is a strong drift signal:
VedaWeb's snapshot of the Grassmann `<L>` numbering is essentially in sync with the current
`csl-orig/v02/gra/gra.txt`.

### Unmatched headwords — bucket + hypothesis

1,633 `key1` headwords (14.7%) never appear as a standalone `id_gra` link. A random sample
of 20 was spot-checked against `gra.txt` entry bodies; the pattern is consistent:
**compound-member-only stems**, whose Grassmann entry text says "enthalten in …" ("contained
in …") or "in <compound>" rather than giving the stem its own attested occurrence — e.g.
`vidyā` ("das Wissen … in jātavidyā́") and `sabar` ("… enthalten in den folgenden").
VedaWeb's word-level lemmatization naturally does not surface these as independent tokens
since Vedic compounds are lemmatized as a whole. This is the dominant hypothesis for the
unattested bucket, not a crosswalk failure — a Dictionary-to-Book link would legitimately
skip these (no RV occurrence to point to).

### Caveat: `lemmatization.json` is not a full-corpus word census

Every one of the 164,758 tokens in the export carries a non-empty `id_gra` — there are no
"unlinked token" placeholders. This means the export is very likely a **pre-filtered
dictionary-linkable subset** of RV running text (particles, pronouns handled purely
morphologically, etc. may be excluded upstream by VedaWeb), not the full ~190k-word RV
corpus. Occurrence counts in this crosswalk should be read as "attested via VedaWeb's
curated dictionary-linking layer," not as an exhaustive RV frequency count.

## Files

| File | Rows | Description |
|---|---:|---|
| [`gra_vedaweb_crosswalk.tsv`](gra_vedaweb_crosswalk.tsv) | 9,945 | `gra_L · gra_key1 · gra_key2 · gra_hom · gra_pc · rv_occurrence_count · vedaweb_example_form · vedaweb_example_lemma · vedaweb_example_location · match_method` — `match_method` is `vedaweb-id-link` throughout (VedaWeb's own curated ID linkage, not a text-similarity match). Sorted by occurrence count descending. |

## Advisory-only

Per the org's standing rule (see the [feed README](README.md) § Advisory-only): this
crosswalk is read-only against both `csl-orig/v02/gra/gra.txt` and the VedaWeb export.
Nothing here is written into reviewed dictionary data — it is a reference layer for a
future Dictionary-to-Book enhancement on [sanskrit-lexicon/GRA](https://github.com/sanskrit-lexicon/GRA).

_Dr. Mārcis Gasūns_
