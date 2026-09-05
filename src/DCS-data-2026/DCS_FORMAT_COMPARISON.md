_Created: 06-06-2026 · Last updated: 05-09-2026_

# DCS distributions compared: relational-DB export vs. CoNLL-U

The Digital Corpus of Sanskrit (DCS) is published in two serialisations: the older **relational-DB
export** in [`../DCS-data-2021/`](../DCS-data-2021/) and the current **CoNLL-U** distribution. This note
compares them, grounded in a **same-text** example and verified by
[`compare_dcs_formats.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/compare_dcs_formats.py).

| | **Relational-DB export** (`../DCS-data-2021/`) | **CoNLL-U** (current) |
|---|---|---|
| Where | `../DCS-data-2021/` (`0.csv`, `10.csv`, `_8.csv`, `12/15.csv`, …) | `OliverHellwig/sanskrit` → `dcs/data/conllu` |
| Vintage | ~2021 snapshot | actively maintained |
| Shape | normalised **tables joined by integer IDs** | one **file per text/chapter**, one **token per line**, 10 TSV columns |
| Morphology | DCS-internal **numeric codes** in separate tables | **Universal-Dependencies** `UPOS` + `FEATS` strings |
| Coverage (measured) | **311,175** sentence rows across **246** texts | **270** text folders |
| Parse with | custom joins across CSV/SQL exports | any UD tool (`conllu`, `pyconll`, `spacy-conll`) |

> **Reproduce:** `python compare_dcs_formats.py` (uses the bundled real sample in
> [`sample_conllu/`](sample_conllu/)). All numbers below are its output.

---

## TL;DR

**They are the same underlying data in two different shapes.** The integer IDs the relational export
stores per sentence are *exactly* the `LemmaId` values in the CoNLL-U `MISC` column — verified token
for token on a shared verse. The differences are about **serialisation and annotation richness**, not
about different corpora:

- The relational export is **normalised** — a sentence row in `0.csv` is just a *lemma-ID sequence* plus
  the sandhied text string; to get per-token morphology you must join `10.csv` (words) and
  `12.csv`/`15.csv` (verb forms), decoding DCS numeric codes.
- CoNLL-U is **denormalised and self-contained** — every token carries its lemma, UD part-of-speech, UD
  morphological features, the unsandhied form, and stable DCS IDs, all on one line.
- CoNLL-U adds an **unsandhied/segmentation layer** (multiword-token spans) the flat relational
  sentence string does not encode explicitly.
- Syntax is **partial**: the CoNLL-U dependency columns are empty *in this sample*, but DCS now ships
  dependency (treebank) annotation for **some** texts — so check `HEAD`/`DEPREL` per text rather than
  assuming none.

---

## The same verse in both formats

**Text:** Abhidhānacintāmaṇi, ref. `AbhCint, 1: 1` (DCS `text_id=449`, `chapter_id=9741`).

**Relational — first row of `0.csv`** (`"Name";ref;index;<lemma IDs>,;<IAST>`):

```
"Abhidhānacintāmaṇi";AbhCint, 1: 1;1;,162427,62226,158146,111960,116648,11359,157299,65320,136760,33597,79462,157173,37879,;praṇipatyārhataḥ siddhasāṅgaśabdānuśāsanaḥ | rūḍhayaugikamiśrāṇāṁ nāmnāṁ mālāṁ tanomyaham ||
```

One row = one metrical line (two pādas, `|` … `||`). Morphology is **not** here — only the 13
lemma IDs and the surface text.

**CoNLL-U — the same line, as its first two sentences:**

```
# text = praṇipatyārhataḥ siddhasāṅgaśabdānuśāsanaḥ
# sent_id = 589896
1-2  praṇipatyārhataḥ  _       _    _  _                                _ _ _ _
1    praṇipatya        praṇipat VERB _ VerbForm=Conv                    _ _ _ LemmaId=162427|OccId=4186015|Unsandhied=praṇipatya|UnsandhiedReconstructed=True
2    ārhataḥ           ārhata   ADJ  _ Case=Nom|Gender=Masc|Number=Sing _ _ _ LemmaId=62226|OccId=4186016|Unsandhied=ārhataḥ|UnsandhiedReconstructed=True
…
6    tanomi            tan      VERB _ Tense=Pres|Mood=Ind|Person=1|Number=Sing _ _ _ LemmaId=157173|…
7    aham              mad      PRON _ Case=Nom|Number=Sing               _ _ _ LemmaId=37879|…
```

Same verse, but every token now carries lemma string, UD POS, UD features, the unsandhied form, and
DCS IDs — and the sandhi join `praṇipatya+arhataḥ → praṇipatyārhataḥ` is made explicit by the `1-2`
multiword-token span.

---

## The cross-walk (verified)

`compare_dcs_formats.py` accumulates CoNLL-U `LemmaId`s sentence by sentence until it has as many as
the relational row lists, then compares the two integer sequences:

```
0.csv lemma-ID list (13):
  [162427, 62226, 158146, 111960, 116648, 11359, 157299, 65320, 136760, 33597, 79462, 157173, 37879]
CoNLL-U LemmaId sequence, first 2 sentences (13):
  [162427, 62226, 158146, 111960, 116648, 11359, 157299, 65320, 136760, 33597, 79462, 157173, 37879]

VERDICT: IDENTICAL
```

So one relational "sentence" (a metrical line) corresponds to **two** CoNLL-U sentences (pāda-level
segmentation), and the **lemma IDs are shared keys across both distributions** — you can join the two
on `LemmaId`.

---

## Field / feature mapping

| Information | Relational export | CoNLL-U |
|---|---|---|
| Surface (sandhied) text | text string in `0.csv` | sentence `# text =` + multiword-token span rows |
| Token segmentation / sandhi split | implicit (flat lemma-ID list) | explicit **MWT spans** (`1-2`, `3-6`) + per-token `Unsandhied=` |
| Lemma (string) | integer ID → resolve via lemma table | `LEMMA` column directly |
| Lemma (stable ID) | the IDs in `0.csv` | `MISC: LemmaId=` (**same numbers**) |
| Part of speech | numeric code in `10.csv` | `UPOS` (UD) |
| Nominal/verbal morphology | numeric codes in `10.csv` / `12.csv` / `15.csv` | `FEATS` (`Case, Gender, Number, Tense, Mood, Person, VerbForm, Voice`) |
| Occurrence ID | row PK in `10.txt` | `MISC: OccId=` |
| Syntax (dependency) | — | `HEAD`/`DEPREL` columns (**empty in this sample**) |
| Semantic concept | DCS word-sense tables | `MISC` (where annotated) |

---

## Key differences (measured on the sample)

Sample = the one bundled chapter (`Abhidhānacintāmaṇi`, AbhCint 1): **154 sentences, 1034 tokens,
234 multiword-token spans**.

1. **Data model.** Relational = normalised, join-on-ID (compact, but needs the schema and several
   files to reconstruct a token). CoNLL-U = denormalised, one self-contained line per token.
2. **Morphology representation.** Relational stores **numeric codes** you must decode against DCS code
   tables. CoNLL-U gives readable UD features: observed `FEATS` keys were
   `Case(878), Number(604), Gender(593), VerbForm(29), Tense(10), Mood(10), Person(10), Voice(1)`.
3. **Sandhi & compounds are first-class in CoNLL-U.** 234 MWT spans split sandhi/compounds, and every
   token has an `Unsandhied=` form (1019 of 1034 flagged `UnsandhiedReconstructed=True`). The
   relational `0.csv` only keeps the joined surface string.
4. **Syntax is partial.** `HEAD` was populated on **0/1034** tokens *in this file*. DCS now provides
   dependency (treebank) annotation for **some** texts but not all — so check `HEAD`/`DEPREL` per file
   rather than assuming the corpus has none.
5. **UD tagset vintage.** UPOS uses the older UD inventory (`CONJ`, `PART` — not the UDv2
   `CCONJ`/`SCONJ`), and a DCS-specific `Case=Cpd` marks compound members. Observed UPOS:
   `NOUN=698, ADJ=104, CONJ=54, PART=45, ADV=45, VERB=39, NUM=25, PRON=23, ADP=1`.
6. **Encoding.** Both are IAST/Unicode, but **anusvāra differs**: `0.csv` uses `ṁ` (U+1E41), CoNLL-U
   uses `ṃ` (U+1E43). Normalise before matching strings across the two. (The relational side also has
   the mojibake / mislabeled-`.xls` issues noted in [`README.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/README.md).)
7. **Coverage / recency.** CoNLL-U covers **270** texts vs the relational dump's **246**, and is the
   maintained version — prefer it for anything current.
8. **Tooling.** CoNLL-U parses with standard UD libraries; the relational export needs bespoke code
   (which is what the Pascal tools and Python here do).

---

## Which to use when

- **Use CoNLL-U** for new work: it's current, broader, self-describing, UD-standard, and tool-friendly,
  with explicit sandhi splitting and unsandhied forms.
- **Use this relational export** only to (a) reproduce VisualDCS's existing dashboards, which were
  built from it, or (b) read fields the export pre-computed in its own tables. Join the two on
  `LemmaId` when you need to enrich the old data with UD morphology.

---

## Provenance & reproducibility

- Both distributions are © Oliver Hellwig, **Digital Corpus of Sanskrit**, **CC BY** (see
  [`README.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2021/README.md) for citation/license).
- [`sample_conllu/Abhidhanacintamani-AbhCint-1.conllu`](sample_conllu/) is one **unmodified** DCS
  CoNLL-U file, included so [`compare_dcs_formats.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/compare_dcs_formats.py) runs offline. Get the
  full set by cloning [`OliverHellwig/sanskrit`](https://github.com/OliverHellwig/sanskrit) and reading
  `dcs/data/conllu/files/`.
- Generated 2026-06-06 from the script output; re-run `python compare_dcs_formats.py` to refresh.

_Dr. Mārcis Gasūns_
