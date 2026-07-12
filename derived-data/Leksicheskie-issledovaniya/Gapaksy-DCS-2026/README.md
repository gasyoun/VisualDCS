# Gapaksy-DCS-2026 — DCS hapax census (single-morpheme vs compound)

_Created: 12-07-2026 · Last updated: 12-07-2026_

Every **hapax legomenon** in the Digital Corpus of Sanskrit (DCS, release 2026):
a DCS-disambiguated lemma (`lemma_id`) whose total corpus frequency is exactly
**1**, counted over content tokens (punctuation excluded), then split into
transparent **compounds** vs **single-morpheme** hapaxes.

Parent folder: [`../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/README.md) ·
archive root: [`../../README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md).

## Headline numbers

| Frequency band | Lemmas | Share of vocabulary |
|---|---:|---:|
| **1 — hapax** | **39,987** | **41.9 %** |
| 2–9 (rare) | 34,740 | 36.4 % |
| 10–99 | 15,339 | 16.1 % |
| 100–999 | 4,622 | 4.8 % |
| 1000+ | 769 | 0.8 % |

- Corpus: **5,688,416** content tokens (non-`PUNCT`), **95,457** distinct `lemma_id`.
- **Hapaxes: 39,987 = 41.9 %** of the attested vocabulary (textbook Zipf: ~half the
  vocabulary occurs once, while 0.8 % of lemmas carry most of the tokens).
- Split of the hapaxes: **16,920 compound (42.3 %)** vs **23,067 single-morpheme (57.7 %)**.

## Files

- [`dcs2026_hapax_all.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_all.tsv)
  — all 39,987 hapax lemmas.
- [`dcs2026_hapax_single_morpheme.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_single_morpheme.tsv)
  — 23,067 hapaxes **not** segmentable into attested lemmas (the philologically
  interesting subset — but see limitation 4).
- [`dcs2026_hapax_compound.tsv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/dcs2026_hapax_compound.tsv)
  — 16,920 hapaxes that are transparent stem-concatenation compounds (`abdhinagarī`
  "ocean-city", `rājaputra` "king's son"), hapax only because samāsa formation is productive.
- [`gen_dcs_hapax.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Leksicheskie-issledovaniya/Gapaksy-DCS-2026/gen_dcs_hapax.py)
  — deterministic generator (no network, no randomness).

### TSV schema

Tab-separated, UTF-8, header row: `lemma_id  lemma  upos  grammar  meaning`.
`lemma` is IAST; `grammar`/`meaning` are joined from the DCS `lemma` table
(may be blank for lemmas with no dictionary gloss).

## Method

1. Group the `token` table of `dcs_full.sqlite` by `lemma_id` (DCS's disambiguated
   homonym id — so `X#1` and `X#2` are counted apart), over content tokens only.
2. Hapax = group with `count(*) == 1`.
3. Compound split: a hapax is **compound** if its IAST string segments into ≥2 members,
   each an independently attested base lemma (corpus freq ≥ 2, length ≥ 3), by **direct
   stem concatenation** (dynamic-programming split, no vowel-sandhi resolution at the seam).

## Limitations (read before citing)

1. **"Hapax in DCS", not "hapax in Sanskrit".** DCS does not cover the entire language;
   a DCS-hapax may be frequent in untagged texts.
2. **Direct-concat compound test only.** Compounds whose seam underwent vowel sandhi
   (`-a` + `a-` → `-ā-`, `-a` + `i-` → `-e-`) are **not** caught and remain, as false
   negatives, in the single-morpheme list.
3. **Over-splitting.** Any simple word that happens to be splittable into two attested
   lemmas is flagged compound (false positive); `MINLEN = 3` curbs the worst of it.
4. **"Single-morpheme" ≠ "underived root".** The kept list still contains prefixed/derived
   stems the dictionary can't split — privative `a-` (`a-badhira` "not deaf", `a-bhavana`
   "non-existence"), preverbs, secondary suffixes (`-tva`, `-tā`). A true root-hapax list
   needs a further morphological pass.
5. **Proper nouns not separated.** DCS does not use `upos = PROPN` in this export, so
   names sit unlabelled inside the `NOUN` hapaxes.

## Reproduce

```
python gen_dcs_hapax.py
```

Reads `../../../src/DCS-data-2026/dcs_full.sqlite`, rewrites the three TSVs in place.

## Provenance

Source DB: Oliver Hellwig, *Digital Corpus of Sanskrit*, release 2026 (CC BY-SA),
imported by the VisualDCS M1–M8 pipeline. Census authored under Opus 4.8
(`claude-opus-4-8`), 12-07-2026, handoff
[H762](https://github.com/gasyoun/Uprava/blob/main/handoffs/archive/H762-Sonnet_VisualDCS_dcs-hapax-census-single-vs-compound_12.07.26.md).

_Dr. Mārcis Gasūns_
