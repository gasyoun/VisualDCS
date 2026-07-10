# PWG ↔ VedaWeb 2.0 gloss cross-check — Geldner + Grassmann German translations

_Created: 08-07-2026 · Last updated: 08-07-2026_

Built for [H362](https://github.com/gasyoun/Uprava/blob/main/handoffs/H362-Sonnet_VisualDCS_vedaweb_geldner_grassmann_pwg_gloss_08.07.26.md),
consuming the [H096](https://github.com/gasyoun/Uprava/blob/main/handoffs/H096-Sonnet_VisualDCS_vedaweb_feed_export_03.07.26.md)
feed's [`lemmatization.json`](lemmatization.json) `id_pwg` field (the same generalization
[H097](https://github.com/gasyoun/Uprava/blob/main/handoffs/H097-Sonnet_VisualDCS_gra_vedaweb_crosswalk_03.07.26.md)
found for `id_gra`, noted at [FINDINGS.md §63](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md))
plus two newly-landed translation exports:
[`geldner_de_1951_1957.json`](geldner_de_1951_1957.json) and
[`grassmann_de_1876_1877.json`](grassmann_de_1876_1877.json). Data file:
[`pwg_vedaweb_gloss_crosswalk.tsv`](pwg_vedaweb_gloss_crosswalk.tsv).

Rights: both translations were unconfirmed ("DECIDE") at
[LAYERS_TRIAGE.md](LAYERS_TRIAGE.md) rows #14/#15 until
[H359](https://github.com/gasyoun/Uprava/blob/main/handoffs/H359-Sonnet_Uprava_vedaweb_rights_outreach_send_08.07.26.md)'s
outreach got an explicit written reply (Prof. Daniel Kölligan, 08-07-2026) confirming both
as **CC BY 4.0** — see
[`OUTREACH_2026-07-08_vedaweb_kolligan_reinohl_rights.md`](https://github.com/gasyoun/Uprava/blob/main/handoffs/OUTREACH_2026-07-08_vedaweb_kolligan_reinohl_rights.md).

## Confirming the ID scheme — `id_pwg` is the PWG `<L>` entry number

Same pattern as GRA. `lemmatization.json`'s per-token `transformContext` carries a `calls`
block showing the live kosh lookup
(`GET https://kosh.uni-koeln.de/cdsd/pwg/restful/ids?ids=349&ids=80913…`) and a resolved
`id_pwg` array per token. A live probe of that endpoint for IDs `349` and `80913` returned
`headword: "agni"` and `headword: "yajYa"` respectively — which match exactly the
`<L>349<pc>1-0028<k1>agni<k2>agni/` and `<L>80913<pc>6-0014<k1>yajYa<k2>yajYa/` entry headers
already in [`csl-orig/v02/pwg/pwg.txt`](https://github.com/sanskrit-lexicon/csl-orig/blob/master/v02/pwg/pwg.txt).
**`id_pwg` is exactly the PWG `<L>` entry number** — the join was built entirely from local
`csl-orig` data (123,366 `<L>` entries), with only the two-ID confirmation probe hitting the
network.

## Prior-art check — is the Grassmann translation redundant given GRA's own id_gra crosswalk?

Mission item 2 asked this explicitly before building anything. **No — the two Grassmann
resources serve different roles and are not redundant:**

- **GRA the *dictionary*** (`sanskrit-lexicon/GRA`, already crosswalked via `id_gra` in
  [`GRA_CROSSWALK.md`](GRA_CROSSWALK.md)/H097) gives Grassmann's German **dictionary
  gloss** per headword — a lexicographic definition, the same kind of unit PWG provides.
- **This Grassmann *translation* layer** (`grassmann_de_1876_1877.json`, his 1876-77 RV
  metrical translation) gives a **full-sentence rendering of the whole stanza** in context
  — a materially different unit (running verse translation, not headword-by-headword
  gloss).

The PWG gloss cross-check this handoff builds needs the **translation**, not the
dictionary: the validation question is "does PWG's headword gloss for this attested word
plausibly fit the sentence Geldner/Grassmann translated it into?" — a dictionary entry
alone can't answer that, only a translated full stanza can. Both Grassmann assets stay in
the repo, each serving its own crosswalk (`GRA_CROSSWALK.md` for GRA↔attestation,
`PWG_VEDAWEB_GLOSS_CROSSWALK.md` here for PWG↔translation-witness).

## Method

1. Parsed all 164,758 `transformContext` tokens across the 10,552 `lemmatization.json`
   stanza entries; 161,421 tokens (98.0%) carry a non-empty `id_pwg` array (3,337 do not —
   same VedaWeb pre-filtering caveat GRA_CROSSWALK.md documents: this is a
   dictionary-linkable subset of RV running text, not a full-corpus word census).
2. Aggregated by `id_pwg` → 10,183 unique PWG entry IDs, with RV occurrence counts.
3. Parsed `csl-orig/v02/pwg/pwg.txt` locally: regex over
   `<L>ID<pc>PC<k1>KEY1<k2>KEY2[<h>HOM]` header lines → 123,366 entries (matches the
   dictionary's own full `<L>` count exactly), plus a short markup-stripped snippet of the
   entry body (PWG's local text uses `{#…#}` for transliterated Sanskrit and {% raw %}`{%…%}`{% endraw %} for
   German prose, not the `<i>`/`<div>` structure the kosh API's on-the-fly XML rendering
   exposes — both were stripped for a readable plain-text snippet).
4. Joined `id_pwg` → `<L>` entry → `key1`/`key2`/`hom`/gloss-snippet, then for one example
   attested RV location per entry, pulled the matching Geldner and Grassmann full-sentence
   translations from the two newly-landed exports. Wrote
   [`pwg_vedaweb_gloss_crosswalk.tsv`](pwg_vedaweb_gloss_crosswalk.tsv) (10,182 matched
   rows), sorted by RV occurrence count descending.

Reused the `csl-orig` `<L>`-header parser convention from `GRA_CROSSWALK.md` (a plain ID
lookup, not a transliteration match — no transcoder needed).

## Coverage — honest numbers

| Metric | Count | % |
|---|---:|---:|
| PWG `<L>` entries total (all senses/homonyms) | 123,366 | — |
| PWG unique `key1` headwords total | 106,082 | — |
| PWG `<L>` entries attested ≥1× in RV via VedaWeb link | 10,182 | 8.3% |
| PWG unique `key1` headwords attested ≥1× in RV via VedaWeb link | 9,079 | 8.6% |
| Total RV token occurrences linked to a PWG entry | 233,867 | — |
| VedaWeb `id_pwg` values with no matching `<L>` in current `pwg.txt` | 1 | — |

PWG's much lower attestation percentage than GRA's (77.8%) is expected, not a crosswalk
defect: PWG (Böhtlingk & Roth, the large Petersburg dictionary) covers the entire Sanskrit
literary corpus at ~10× GRA's entry count, of which only a slice pertains to the Rigveda.
The 10,182 matched entries are exactly PWG's Rigveda-relevant slice.

**The single unmatched ID** (`614901`) has no corresponding `<L>` in the current
`pwg.txt` — the same kind of VedaWeb-side numbering drift GRA_CROSSWALK.md found (one
sentinel/stale ID out of ~10k, a strong signal the rest of the join is in sync).

### Caveat: `lemmatization.json` is not a full-corpus word census

Same caveat as `GRA_CROSSWALK.md` — every non-empty-`id_pwg` token in the export is
dictionary-linked by construction, so occurrence counts here read as "attested via
VedaWeb's curated dictionary-linking layer," not an exhaustive RV frequency count.

## Files

| File | Rows | Description |
|---|---:|---|
| [`pwg_vedaweb_gloss_crosswalk.tsv`](pwg_vedaweb_gloss_crosswalk.tsv) | 10,182 | `pwg_L · pwg_key1 · pwg_key2 · pwg_hom · pwg_pc · pwg_gloss_snippet · rv_occurrence_count · example_location · example_form · example_lemma · geldner_text · grassmann_text` — one row per PWG entry attested in the RV, with a worked example location and both translators' full-sentence rendering at that location for eyeball comparison against PWG's own gloss. |

## Advisory-only, validation-only

Per the org's standing rule (see the [feed README](README.md) § Advisory-only) and this
handoff's own guardrail: this crosswalk is **read-only** against both `csl-orig/v02/pwg/pwg.txt`
and the VedaWeb exports. **Nothing here is ever written into reviewed PWG dictionary data.**
The joined table is a validation witness for a human (or a future targeted pass) to spot-check
— surfacing candidate gloss/translation divergences for review, not an automated corrector.
Any text-correction proposal that comes out of eyeballing this table follows the normal
[`csl-orig` correction workflow](../../../csl-corrections/docs/correction-workflow.md)
(registry check → queue → monthly batch PR), never a direct edit.

_Dr. Mārcis Gasūns_
