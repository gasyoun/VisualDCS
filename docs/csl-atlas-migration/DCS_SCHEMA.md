# DCS Export — Schema As Found (Phase 3a)

Date: 2026-05-30

Status: the Phase 3a schema-inspection gate from `docs/DCS_CORPUS_INGESTION_PLAN.md`. This documents what the **actual** local DCS export contains, before any ingestion code, and revises the plan's assumption that DCS would arrive as passage-level occurrences.

## Location

Sibling repository of `csl-atlas`:

```text
../DCS/
```

It is the Cologne reference-data mirror of the Digital Corpus of Sanskrit (Oliver Hellwig, Heidelberg), CC BY-SA 4.0. Like `csl-orig`, it stays outside this repo; only compact generated summaries are committed here.

## Headline finding: this is reference data, not a passage corpus

`docs/DCS_CORPUS_INGESTION_PLAN.md` assumed DCS would provide lemmatized, passage-level occurrences (text id, passage id, token, lemma, morphology per occurrence) feeding a `CorpusOccurrence` model and genre/period dashboards. **The available export does not contain passages or occurrences.** It is three reference files:

| File | Rows | What it is |
|---|---|---|
| `DCS-72034-gramm-tag-stats.csv` | 78,761 | a word → grammar-category list (aggregate, no passages, no frequency) |
| `DCS-abbreviation-list.txt` | 189 | DCS text inventory: full title → short code |
| `DCS-Corpus-Bibliography` | ~free text | bibliographic detail for a handful of texts |

Consequence: lemma-frequency-by-text, POS-by-genre, inflection profiles, and the `CorpusOccurrence` model are **not buildable from this export** — they need the full DCS corpus (passage-level), which is not present here.

## What IS buildable

- **Corpus text inventory / manifest** (UC-CG-01) from the abbreviation list (+ bibliography where it matches).
- **Aggregate grammar-category distribution** across the 78k DCS words.
- **(Later) dictionary-vs-DCS lemma coverage** — which dictionary lemmas appear in the DCS word list — but see the encoding caveat below; it needs IAST→SLP1 transcoding and is only partial.

## File formats

### DCS-72034-gramm-tag-stats.csv

Semicolon-separated, header `#;Word;GRAM`:

```text
#;Word;GRAM
1;a ;ind
3;akac ;m
4;aka?uka ;adj
```

- `#` — running index.
- `Word` — IAST headword, **with a trailing space**; trim it.
- `GRAM` — grammar category; 40 distinct values, ~6,767 blank.

`GRAM` groups into:

- nominal gender: `m`, `f`, `n`, `mn`, `mf`, `fn` (and blank);
- `adj`, `ind`;
- verbal: `<class>. <pada>` e.g. `1. P.`, `10. P.`, `Denom. P.` — class number + Parasmaipada/Ātmanepada.

### DCS-abbreviation-list.txt

Tab-separated `FullTitle<TAB>Code`, after a one-line header:

```text
DCS abbreviations (Gasuns edition)
Abhidharmakośa	Abh
Amarakośa	AmK
Agnipurāṇa	AgniP
```

189 texts. Titles are IAST. Codes are DCS sigla (distinct from the per-dictionary `<ls>` sigla compared in `citation-apparatus`).

### DCS-Corpus-Bibliography

Free text; entries of the form `Title Year — (= CODE) full citation.` Only a handful of texts are detailed, so it is a supplementary enrichment, not the inventory.

## Encoding caveats (important)

- The repo states UTF-8 NFC, IAST throughout — true for the abbreviation list and bibliography.
- **The CSV word column has lossy diacritics**: non-ASCII characters are replaced by `?` (`akart?ka`, `akarma?ya`, `akal?`). So CSV words are not reliable IAST and cannot be cleanly transcoded to SLP1 where a `?` occurs. This limits any dictionary-coverage join to the ASCII-clean subset and must be flagged.
- Some verb `GRAM` codes show `?` for the pada (`1. ?.` is almost certainly `1. Ā.`), same encoding loss.

## Implications for Phase 3

1. Build the **DCS text manifest** and **grammar-category distribution** now (no transcoding needed).
2. Treat **dictionary-vs-corpus lemma coverage** as a later, explicitly partial slice (IAST→SLP1 transcoding; skip `?`-damaged words).
3. Do **not** build `CorpusOccurrence`, passage dashboards, or genre/period grammar from this export — they require the full DCS corpus. Revisit when/if passage-level data is obtained (the original Phase 3 vision).
4. The DCS abbreviation list is also a candidate cross-reference for the source-siglum and source-layer review queues, but DCS codes ≠ dictionary `<ls>` sigla, so any link is itself a reviewed mapping.

## Related

- `docs/DCS_CORPUS_INGESTION_PLAN.md` — the original Phase 3 plan (its passage-level assumptions are revised here).
- `ARCHITECTURE.md` — corpus metadata requirements and the conservative diachronic scale.
