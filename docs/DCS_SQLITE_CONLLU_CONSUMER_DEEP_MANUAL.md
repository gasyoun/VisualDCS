# DCS `dcs_full.sqlite` / CoNLL-U consumer deep manual — the org data layer, as built

_Created: 26-07-2026 · Last updated: 02-09-2026_

**Doc-of-record for the DCS corpus data layer.** Every schema claim and join recipe below was
executed live against the real database on 26-07-2026 (Fable 5, `claude-fable-5`, H1407); the
recorded numbers are the acceptance baseline. If your query returns different numbers, you are
either on a different vintage or in one of the traps in §7. Registered in
[Uprava/PROJECT_INTERLINKS.md](https://github.com/gasyoun/Uprava/blob/main/PROJECT_INTERLINKS.md)
and pointed at from the
[Uprava/DATA_LAYERS_CENSUS.md](https://github.com/gasyoun/Uprava/blob/main/DATA_LAYERS_CENSUS.md)
`dcs_full.sqlite` row.

## 1. What the master is, and what it is not

**The corpus master is** `src/DCS-data-2026/dcs_full.sqlite` — **920,883,200 bytes**, gitignored,
distributed as the GitHub Release
[`dcs-full-2026-03-05`](https://github.com/gasyoun/VisualDCS/releases/tag/dcs-full-2026-03-05)
(287 MB gz) and regenerable with
[`import_dcs_conllu.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/import_dcs_conllu.py) `--all`
from the pinned CoNLL-U submodule. Its `provenance` table, verbatim:

| key | value |
|---|---|
| `source_repo` | `gasyoun/dcs-conllu (OliverHellwig/sanskrit)` |
| `source_commit` | `04e0778d3dc971030229179e25eea043d06ff397` |
| `imported_at` | `2026-06-06T16:22:57+00:00` |
| `n_texts` | `270` |
| `n_tokens` | `5688416` |
| `schema` | `flatten-all; lemma<-dictionary.csv` |

License: **CC BY 4.0** (Oliver Hellwig, *Digital Corpus of Sanskrit*), with explicit written
redistribution sign-off recorded 09-07-2026 in
[`.ai_state.md`](https://github.com/gasyoun/VisualDCS/blob/main/.ai_state.md) (H043/A38).

**Path traps — none of these is the corpus master:**

| Path | What it actually is |
|---|---|
| `src/DCS-data-2026/dcs.sqlite` (31 MB) | the 13-text **pilot sample** (M2). WhitneyRoots' build manual records the symptom: DCS-reading scripts "return near-empty results" when pointed here |
| `src/DCS-data-2026/dcs_full.sqlite.gz` (287 MB) | the compressed Release artifact, not openable in place |
| `src/DCS-data-2026/archive.sqlite` (167 MB) | the **M9 research archive** (Leonchenko-era datasets: `period_freq`, `text_freq`, `core_vocab`, `parallels`, `subhashita`) — a *different corpus vintage*; see §4.3 |
| `archive_stopword.sqlite` (11 GB class) | the stop-word parallel run, regenerable, out of scope |
| `src/dcs_full.sqlite` (0 bytes) | a decoy left by a June 2026 session; removed by H1407 after a consumer grep confirmed nothing references it |

Consumers reach the master by the **sibling-checkout convention**: every known consumer hardcodes
`../VisualDCS/src/DCS-data-2026/dcs_full.sqlite` relative to its own repo root (WhitneyRoots offers
a `--db` override in
[`extract_dcs.py`](https://github.com/gasyoun/WhitneyRoots/blob/main/scripts/dcs/extract_dcs.py);
kosha's builders offer `--dcs`). Open it **read-only, streaming** — never load it whole, never open
it with an editor/Read tool: `sqlite3.connect("file:...dcs_full.sqlite?mode=ro", uri=True)`.

## 2. As-built schema (matches live `PRAGMA table_info`, 26-07-2026)

Tables: `text, chapter, sentence, token, mwt, lemma, provenance` (+ SQLite-internal
`sqlite_sequence`). Row counts, live:

| table | rows | notes |
|---|---|---|
| `text` | **270** | 196 morphological-only / **74 treebank** (`has_dependencies=1`) |
| `chapter` | 15,790 | |
| `sentence` | 754,726 | |
| `token` | **5,688,416** | |
| `mwt` | 1,024,841 | sandhi/compound surface spans |
| `lemma` | 180,176 | from the upstream `lookup/dictionary.csv`; only **98,606** lemma_ids actually occur in `token` |
| `provenance` | 6 | the table in §1 |

Columns (from `PRAGMA table_info`):

- **`text`** — `text_id` PK · `name` · `has_dependencies` (default 0)
- **`chapter`** — `chapter_id` PK · `text_id` FK · `ref` (e.g. `AbhCint, 1`)
- **`sentence`** — `id` PK (synthetic) · `sent_id` · `chapter_id` FK · `sent_counter` ·
  `sent_subcounter` · `text_sandhied`
- **`token`** — `id` PK (synthetic) · `sentence_id` FK → `sentence.id` · `occ_id` · `sent_id` ·
  `idx` · `form` · `lemma` · `lemma_id` FK → `lemma.lemma_id` · `upos` · `xpos` · `head` ·
  `deprel` · `deps` · `m_unsandhied` · `m_unsandhiedreconstructed` · `feat_case` · `feat_gender` ·
  `feat_number` · `m_annotator` · `feat_tense` · `feat_verbform` · `feat_mood` · `feat_person` ·
  `m_wordsem` · `feat_voice` · `m_punctuation` · `feat_formation` · `m_ismantra`
- **`mwt`** — `id` PK · `sentence_id` FK · `sent_id` · `span` (`1-2`) · `form`
- **`lemma`** — `lemma_id` PK · `lemma` · `grammar` · `preverbs` · `meanings`
- **`provenance`** — `key` PK · `value`

**The flatten-all rule.** Every UD `FEATS` key became a `feat_*` column and every `MISC` key an
`m_*` column (`Unsandhied=` → `m_unsandhied`, `WordSem=` → `m_wordsem`, `IsMantra=` →
`m_ismantra`, …). Absent features are **SQL `NULL`, not the string `'None'`** — a trap that cost
WhitneyRoots real debugging (`WHERE feat_verbform='None'` returns 0 rows on data where
`feat_verbform IS NULL` matches thousands; live check on lemma `gam`: `feat_tense='Pres' AND
feat_verbform IS NULL` = 4,279 rows, `feat_verbform='None'` = 0). The same convention nests:
**voice-NULL means active** — of those 4,279, 260 carry `feat_voice='Pass'` and the active
majority has `feat_voice` NULL, while `feat_voice='Act'` matches 0 rows.

**Why the PKs are synthetic** (upstream IDs are not unique — both defects verified live):

- `occ_id` (CoNLL-U `OccId`) is reused across a metrical line's sub-sentences: **684** `occ_id`
  values occur more than once. Caught at M5, where using it as PK silently lost tokens.
- `sent_id` collides *within* chapters: **248** `(sent_id, chapter_id)` pairs are duplicated.
  Caught at M6, where it silently dropped 449 sentences.

Join through `token.sentence_id = sentence.id`, never through `sent_id`/`occ_id`
([SanskritLexicography FINDINGS §9](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)).

## 3. The canonical spine join

Everything positional goes through one join shape (this is kosha's production query shape):

```sql
SELECT ...
FROM token t
JOIN sentence se ON t.sentence_id = se.id
JOIN chapter  ch ON se.chapter_id = ch.chapter_id
JOIN text     tx ON ch.text_id    = tx.text_id
```

Executed live 26-07-2026: **all 5,688,416 tokens resolve** through the full spine (zero loss), and
a `LEFT JOIN` orphan check on `token.lemma_id` → `lemma.lemma_id` returns **0** orphans and **0**
NULL `lemma_id` tokens. The layer is referentially clean; if your join drops rows, the defect is in
your keys, not the DB.

## 4. Generations: 2021 relational · 2026 CoNLL-U/sqlite · M9 archive

### 4.1 2021 ↔ 2026, and the LemmaId bridge

The 2021 relational export lives in
[`src/DCS-data-2021/`](https://github.com/gasyoun/VisualDCS/tree/main/src/DCS-data-2021)
(246 texts, `0.csv` + `10.csv` + `12/15.csv` joined by integer IDs, DCS-internal numeric
morphology codes). The 2026 side is the CoNLL-U distribution this sqlite was built from
(270 texts, UD `UPOS`/`FEATS` strings). **They are the same underlying data in two shapes**, and
the bridge is `LemmaId`: the integer IDs a 2021 `0.csv` row lists per sentence are exactly the
CoNLL-U `MISC: LemmaId=` values — verified token-for-token on a shared verse in
[`DCS_FORMAT_COMPARISON.md`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/DCS_FORMAT_COMPARISON.md)
(verdict: IDENTICAL). So `lemma_id` is the one durable cross-generation join key.

What does **not** bridge:

- **Sentence granularity.** One 2021 row = one metrical line; 2026 segments at pāda level
  (1 line ↔ N sentences). Counts of "sentences" are not comparable across generations
  ([FINDINGS §11](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md)).
- **Old per-row PKs.** The 2021 `10.txt` row IDs are a different ID space from `OccId` — never
  match on them (import plan §7).
- **Lemma inventory.** 246→270 texts; lemma coverage 91,406→98,606 (Jaccard 89.3%, M3 coverage
  report). Apparent "lost lemmas" are mostly lemmatization-policy drift — a-privatives now resolve
  to their bases (FINDINGS §79).
- **Coverage.** 30 texts added (mostly Vedic Śrautasūtras/Brāhmaṇas), 6 only-2021 incl. 1 rename.

### 4.2 UD-vintage drift inside 2026

The corpus-wide inventory does **not** match the sample-derived claims in
`DCS_FORMAT_COMPARISON.md`: that doc (one Abhidhānacintāmaṇi chapter) reports "older UD inventory
(`CONJ`, `PART` — not `SCONJ`)". As built, **`upos='SCONJ'` exists: 31,499 tokens** (live). Treat
per-sample tag claims as sample-scoped; enumerate `upos` values from the DB when it matters.

### 4.3 The M9 `archive.sqlite` is a different vintage — expect different counts

The frequency numbers circulating downstream (kosha
[`lemma_frequency.tsv`](https://github.com/gasyoun/kosha/blob/main/data/frequency/README.md),
csl-guides
[`corpus-attestation.mdx`](https://github.com/gasyoun/csl-guides/blob/main/docs/dictionaries/corpus-attestation.mdx))
come from the **M9 archive** (`period_freq`, Leonchenko-era exports), *not* from this sqlite.
Live demonstration of the mismatch — same lemma, both "DCS counts":

| lemma | `dcs_full.sqlite` tokens (live) | kosha/csl-guides `count_all` (archive-derived) |
|---|---|---|
| `ca` | **174,415** | 155,088 |
| `tad` | **197,087** | 151,248 |
| `na` | **63,741** | 53,981 |

Neither is wrong; they are different corpus vintages and different counting bases. **Never mix
them in one denominator**, and label which vintage a number comes from (kosha's own
`build_sense_frequency_layer.py` carries the same warning: "any residual excess is a DCS-vintage
mismatch").

## 5. Encoding and lemma conventions — the fold vs DO-NOT-fold rule

### 5.1 Anusvāra across generations (all counts live)

| layer | anusvāra | evidence |
|---|---|---|
| 2021 relational export / Kompozity archive files | `ṁ` U+1E41 (dot above) | `0.csv`, `cmps.csv`, `names.csv` |
| 2026 `lemma.lemma` | **pure `ṃ` U+1E43** | 8,932 rows with `ṃ`, **0** with `ṁ` |
| 2026 `token.lemma` | pure `ṃ` | 117,193 vs **0** |
| 2026 `sentence.text_sandhied` | predominantly `ṃ`, **not clean** | 417,623 rows with `ṃ` vs **1,052** with `ṁ` |
| 2026 `token.form` | predominantly `ṃ`, not clean | 542,036 vs **1,088** |
| MW / Cologne keys | `ṃ` U+1E43 | + `@`/`-` markup, leading avagraha `'` |

So: **lemma-level joins inside 2026 need no anusvāra fold** (the lemma columns are clean), but any
match against *surface* columns (`form`, `text_sandhied`, `m_unsandhied`) or against *2021-era
files* must unify `ṁ`→`ṃ` first — a residue of ~1,000 `ṁ` rows will otherwise silently vanish
from string matches.

### 5.2 The H1328 worked example — why "29% matched" looked plausible and was fake

H1328 joined MW's uttarapada index against the Kompozity corpus files
([`build_uttarapada_dict_vs_corpus.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/build_uttarapada_dict_vs_corpus.py)).
The naïve string join matched **29%** — a rate that looks like a legitimate research finding
("dictionary and corpus diverge"). It was an encoding artifact. Two convention families had to be
folded (`okey()` in the build script):

1. anusvāra: corpus `ṁ` U+1E41 vs MW `ṃ` U+1E43;
2. MW key markup: `@`, `-`, and the leading avagraha `'` (`'bja` = *abja*).

After folding: **33%**. The 4-point gap was pure convention noise. **The trap is that 29% did not
look broken** — nothing errors, the join "works", the number is publishable-looking.

**DO NOT fold further.** Vowel length, gender endings, and junction alternations
(`sena`/`senā`, `vatī`/`vat`, `cchada`/`chada`) are *morphological citation-form differences* —
DCS lemmatizes to a different citation form than MW's headword — diagnosed in H1328 as
`form_variant`, **never** as corpus absence (1,289 such pairs). Folding them fabricates matches;
not folding them but calling the misses "corpus-absent" fabricates a finding. Live demonstration
that both sides are real, distinct lemmas:

```text
sena  → lemma_ids 99721 (adj), 99722 (n), 168376 (m) — 5 tokens
senā  → lemma_id  99723 (f)                          — 1,075 tokens
```

A fold that merges `sena`/`senā` would silently pour 1,075 tokens into the wrong lemma.

**Reference implementation** of the conservative key: WhitneyRoots'
`dcs_key()` in
[`extract_dcs.py`](https://github.com/gasyoun/WhitneyRoots/blob/main/scripts/dcs/extract_dcs.py) —
NFC-normalize, unify `ṁ`→`ṃ`, strip avagraha variants, strip homonym prefix; **no diacritic
folding**. Its aggressive `fold()` (strip all diacritics) exists too but is used *only* for the
PPP prefix test, never for the join — keep that separation.

## 6. Canonical join recipe per consumer repo (each executed live 26-07-2026)

### 6.1 VisualDCS in-repo (paradigm trainer, citation forensics, LSC)

[`gen_paradigm_attested.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_attested.py)
(H1299) keys per-root paradigm cells off `upos='VERB'` tokens. Live: `SELECT COUNT(*) FROM token
WHERE upos='VERB'` → **1,007,361** (matches the committed H1299/M7 number exactly);
**11,096** distinct verbal lemma strings. Other in-repo consumers:
`dcs_shared_citation_errors.py` (H203 — locus resolution; see the Harivaṃśa vulgate-vs-critical
caveat it recorded) and the `derived-lsc/` pilot (per-period slices via the curated text→period
map, FINDINGS §87).

**The nominal side (added 27-07-2026, H1472).**
[`gen_paradigm_nominal.py`](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal.py)
is the NOUN/ADJ counterpart, and its universe is **not** the mirror image of the verbal one —
copying the `upos='VERB'` shape across is the first mistake to avoid:

```sql
-- the grid: 8 real cases x 3 numbers
SELECT lemma_id, lemma, upos, feat_case, feat_number, feat_gender,
       COALESCE(m_unsandhied, form), m_unsandhiedreconstructed
FROM token
WHERE upos IN ('NOUN','ADJ') AND lemma IS NOT NULL
  AND feat_case IN ('Nom','Acc','Ins','Dat','Abl','Gen','Loc','Voc')
  AND feat_number IN ('Sing','Dual','Plur');
```

Live totals (27-07-2026): NOUN 2,395,188 + ADJ 601,222 = **2,996,410** tokens, of which
**2,263,192** are placed on the grid, **724,676** are `feat_case='Cpd'` compound members carrying
no case (G19), and **8,542** carry no case tag at all. Any consumer slicing the nominal layer
owes the same three-way closure check — the buckets must sum back to the universe, or one is
being dropped (G20). Lexical gender for a lemma comes from the master's own dictionary-derived
`lemma.grammar` column (`m`/`f`/`n`/`adj`/`mn`/`mf`/`fn`/`mfn`), joined on `lemma_id`; it is a
different fact from the token's `feat_gender` and the two must not be conflated. Declension class
is **not in the corpus at all** — the shared heuristic taxonomy lives in SanskritGrammar's
[`sg_g2_declension_cell_coverage.py`](https://github.com/gasyoun/SanskritGrammar/blob/main/scripts/sg_g2_declension_cell_coverage.py)
(H1048) and is reused, not re-derived; the two assets reconcile at 57,144 lemma_ids with 0
disagreements.

### 6.2 WhitneyRoots — IAST lemma-string join, no SQL JOIN

WhitneyRoots links Whitney's 935 roots to the corpus **in Python on the IAST `lemma` string**
(never SLP1, never `lemma_id` except in `token_disambiguate.py`). Its production queries, verbatim:

```sql
SELECT lemma, grammar, preverbs FROM lemma;
SELECT lemma, COUNT(*) FROM token WHERE upos='VERB' GROUP BY lemma;
SELECT lemma, form, m_unsandhied, feat_verbform, feat_tense, feat_voice
  FROM token WHERE upos='VERB';
```

Resolution is three-tier — exact → `dcs_key()`-normalized → curated alias table
(`gach→gam`, `prach→pracch`, `har→hṛ`, …; near-matches like `hū≠hu` deliberately rejected) —
yielding **755/935 roots linked**, plus a `homonym_shared` flag when two Whitney entries land on
one DCS lemma. Encoding traps its
[`scripts/dcs/README.md`](https://github.com/gasyoun/WhitneyRoots/blob/main/scripts/dcs/README.md)
documents as having "cost real debugging": features are SQL `NULL` not `'None'`; verb class
(gaṇa) lives **only** on `lemma.grammar` (`"1.P.,4.P.,4.Ā."`), never per-token; PPP =
`feat_verbform='Part' AND feat_tense IS NULL`; Whitney classes are Roman numerals vs DCS Arabic —
normalize before comparing; present-finite means `feat_tense='Pres' AND feat_verbform IS NULL`
(a stale comment in `corpus_verify_classes.py` claims `='Fin'`; the code tests `IS NULL`).
Authority rule: DCS "can only suggest, never decide" — corpus absence is no evidence against
Whitney, and unaccented DCS cannot separate present classes I/VI (or IV from passive) — the exact
trap behind the Phase-8 revert of ~120 corpus-inferred class additions (FINDINGS §8).

### 6.3 kosha — sense/frequency layers, SLP1-keyed

kosha's builders (`data/frequency/`) are the org's heaviest `dcs_full` consumers. The sense layer
([`build_sense_frequency_layer.py`](https://github.com/gasyoun/kosha/blob/main/data/frequency/build_sense_frequency_layer.py))
runs the spine join grouped by `(m_wordsem, lemma_id)`, then transcodes `lemma.lemma` IAST → SLP1
for kosha's keys:

```sql
SELECT t.m_wordsem, t.lemma_id, ch.text_id, COUNT(*)
FROM token t
JOIN sentence se ON t.sentence_id = se.id
JOIN chapter  ch ON se.chapter_id = ch.chapter_id
WHERE t.m_wordsem IS NOT NULL AND t.m_wordsem != '' AND t.lemma_id IS NOT NULL
GROUP BY t.m_wordsem, t.lemma_id, ch.text_id;
```

Live: **531,747** WordSem-annotated tokens (matches FINDINGS §78 exactly) across **23,920**
distinct synset ids; top texts by WordSem tokens: Rāmāyaṇa 104,660 · Mahābhārata 53,292 ·
Suśrutasaṃhitā 43,279. Note the WordSem IDs have **no local ID→gloss inventory in the DB**
(FINDINGS §78) — that is what kosha's `build_wordsem_inventory.py` reconstructs. **But** kosha's
headline frequency layer (`build_frequency_layer.py` → `lemma_frequency.tsv`, 83,277 lemmas) reads
the **M9 `archive.sqlite`**, not `dcs_full` — see §4.3 before comparing counts.

### 6.4 csl-guides — downstream of kosha, top-2,000 slice

[`corpus-attestation.mdx`](https://github.com/gasyoun/csl-guides/blob/main/docs/dictionaries/corpus-attestation.mdx)
renders `src/data/corpus-frequency.json` = the top 2,000 of kosha's `lemma_frequency.tsv`
(SLP1-keyed, joins onto `dcs_cdsl_xref.tsv` via `slp1`/`normkey`; the xref links 15,902 DCS lemma
ids to CDSL headwords, **81.4% linked** — FINDINGS §12 — and is itself the "never re-derive this
join" asset). Chain of custody: DCS upstream → VisualDCS (M9 archive) → kosha frequency layer →
csl-guides rendering. Its quoted corpus totals (4,550,704 tokens / 59,282 lemmas) are
**archive-vintage**, not this sqlite's 5,688,416 — the §4.3 rule in the wild.

### 6.5 csl-atlas — 2021-banded summary only

csl-atlas consumes the *banded* `data/dcs/dcs_lemma_summary.json` (DCS-2021 vintage, bands only —
recorded in csl-guides'
[`NON_COLOGNE_SOURCES.md`](https://github.com/gasyoun/csl-guides/blob/main/src/data/NON_COLOGNE_SOURCES.md)).
Its migration-era schema notes in this repo are superseded — see the deprecation banner on
[`docs/csl-atlas-migration/DCS_SCHEMA.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/csl-atlas-migration/DCS_SCHEMA.md),
which describes a three-file reference export (78,761-row grammar-tag stats, abbreviation list,
bibliography) that is **not** this database and whose "no passage-level data exists" conclusion no
longer holds.

## 7. Gotcha registry — every entry live-verified or provenance-linked

| # | Gotcha | Evidence / provenance |
|---|---|---|
| G1 | **The Bhagavadgītā is findable neither by text name nor by numeric adhyāya — but it IS in the corpus.** `SELECT text_id, name FROM text WHERE name LIKE '%Bhagav%' OR name LIKE '%gīt%'` returns only `(243, 'Gītagovinda')` and `(420, 'Aṣṭāvakragīta')` — different works; and MBh book 6's numeric chapter refs jump `MBh, 6, 22` → `MBh, 6, 41`. Both lookups wrongly conclude absence. In fact the 18 Gītā adhyāyas are **relabeled** `MBh, 6, BhaGī 1` … `BhaGī 18` — all present, **10,547 tokens** (live). The prior org record ("absent from the DCS corpus — MBh book 6 omits adhyayas 23–40", kosha [`datasets.json`](https://github.com/gasyoun/kosha/blob/main/data/manifest/datasets.json), which parked a Gītā reader pack on that premise) mis-read this ref-relabeling as an omission — corrected 26-07-2026 by H1407's adversarial pass. **Nala** likewise has no `text` row but lives inside Mahābhārata. Match `chapter.ref` patterns, never just `text.name`, before asserting a work absent. | live queries, 26-07-2026 (verified twice: author + adversarial verifier); session danger-memory `dcs-full-db-path-and-gita-gap` |
| G2 | **`feat_case='Cpd'` = 841,052 tokens** — the DCS pseudo-case for non-final compound members, not a UD case. Any per-case distribution must decide explicitly whether compound members are in or out of the denominator. | live |
| G3 | **`head`/`deprel` are treebank-only**: 223,751 tokens = **3.9%** of the corpus, confined to the 74 `has_dependencies=1` texts (all 74 verified non-empty, Vedic-skewed). Absence of an arc means "not annotated", never "no relation" — use co-occurrence, not arcs, for corpus-wide claims. | live; [FINDINGS §104, §88](https://github.com/gasyoun/SanskritLexicography/blob/master/FINDINGS.md) |
| G4 | **`feat_tense='Past'` conflates aorist and perfect** (111,167 tokens). `feat_formation` recovers the formation for only 16,100 of them (`root`, `peri`, `them`, `s`, `is`, `red`, …); there is **no aorist TENSE value**. | live; FINDINGS §10, §91 |
| G5 | **`text_sandhied` is not reliably sandhied** — some rows store analyzed (de-sandhied) pada text, e.g. large parts of the Rāmāyaṇa; verbatim-quotation matching downgrades to partial. Locus joins across editions fail (Harivaṃśa vulgate-vs-critical numbering, H203). | FINDINGS §80, §102 |
| G6 | **`m_wordsem` sense IDs have no gloss inventory in the DB** (531,747 annotated tokens). Resolve via kosha's `wordsem` inventory layer. | live; FINDINGS §78 |
| G7 | **Per-period bucket labels lost spaces upstream**: the archive/QL period labels `3200` and `4700` are slots `3 200` and `4 700` (≈ up to 200 CE / 700 CE). The Kompozity per-period columns have **no** documented column→period mapping at all — do not guess one. A curated text→period map already exists; consume it, don't rebuild. | csl-guides `corpus-attestation.mdx`; [Kompozity README](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Kompozity/README.md); FINDINGS §87 |
| G8 | **Kompozity split member order ≠ surface order** (`rājakule` split as `kula rājan`; 3.3% rejected at freq ≥ 5). Order-independent uses are safe; head-first analyses must run the consonant-skeleton `order_ok()` gate. | FINDINGS §101 |
| G9 | **QL workbook SLP1 + length columns truncate at ṣṭh/ḍh** (`śreṣṭha → SrezW`; 1,622/90,929 rows). Recompute from `IAST` via `sanskrit_util.to_slp1`; never read those two columns. | FINDINGS §66 |
| G10 | **Absent features are SQL `NULL`, not `'None'`** (live: `feat_verbform='None'` → 0 rows). Present-finite = `feat_tense='Pres' AND feat_verbform IS NULL`. | live; WhitneyRoots README |
| G11 | **`occ_id`/`sent_id` are non-unique** (684 reused `occ_id`s; 248 `(sent_id, chapter_id)` collisions). Join on the synthetic `token.sentence_id → sentence.id` spine only. | live; FINDINGS §9 |
| G12 | **Annotation density collapses for later texts** — verbal-feature coverage varies by text/period; feats-based diachronic metrics measure annotation, not language. | FINDINGS §86 |
| G13 | **Unaccented corpus ⇒ present classes I/VI indistinguishable** (and IV vs passive); never trust corpus-inferred gaṇa (the Phase-8 revert of ~120 additions). Verb class lives only on `lemma.grammar`. | FINDINGS §8; WhitneyRoots build manual |
| G14 | **Key transliteration is mixed across the layer's feeds**: this DB's lemmas are IAST; kosha keys SLP1; `dcs_lemma_summary.json` is SLP1-keyed while other feeds are IAST. Check before joining. | FINDINGS §7 |
| G15 | **18.6% of DCS-2026 lemmas map to no CDSL headword** (81.4% link in `dcs_cdsl_xref.tsv`) — an unmatched lemma is normal, not a bug. | FINDINGS §12 |
| G16 | **`m_unsandhied` is mostly reconstructed** — `m_unsandhiedreconstructed` flags machine reconstruction (1,019/1,034 tokens in the format-comparison sample); treat unsandhied forms as analysis, not attestation. | `DCS_FORMAT_COMPARISON.md` |
| G17 | **UPOS inventory is not sample-stable**: `SCONJ` = 31,499 corpus-wide despite the sample doc's "older inventory, no SCONJ" claim. Enumerate from the DB. | live; §4.2 |
| G18 | **M9 archive text ids ≠ DCS `text_id`** (parallel-project ids are project-internal: Acintyastava=10≠415). Crosswalk by text *name*. | [m9_archive_ingest.md](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/m9_archive_ingest.md) |
| G19 | **`feat_case='Cpd'` is not a ninth case** — it marks a compound *member*, which has no case and (almost always) no `feat_number`. It is **724,676 tokens = 24.2% of all NOUN/ADJ**, so a "case distribution" that silently includes or silently drops it is wrong either way: exclude it from case grids and report it as its own bucket. Same trap for `feat_number IS NULL` (733,218). | H1472; [paradigm_nominal_build.md](https://github.com/gasyoun/VisualDCS/blob/main/reports/paradigm_nominal_build.md) |
| G20 | **The complement of a multi-column `IN` filter must be spelled out NULL-safely.** `NOT (feat_case IN (…) AND feat_number IN (…))` evaluates to `NULL` — not `TRUE` — for every case-untagged row (`NULL IN (…)` → `NULL`; `NULL AND TRUE` → `NULL`; `NOT NULL` → `NULL`), so those rows match **neither** the filter nor its supposed complement and vanish from both denominators. Cost the H1472 build 8,542 tokens until a closure assertion caught it. Write `feat_case IS NULL OR feat_case NOT IN (…) OR …`, and assert that the buckets sum to the universe. | H1472; [gen_paradigm_nominal.py](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/gen_paradigm_nominal.py) |
| G21 | **`token.feat_gender` (usage) ≠ `lemma.grammar` (lexical gender).** An adjective cited in its masculine `-a` form contributes feminine-tagged tokens (`paramayā`) that inflect as ā-/ī-stems. Grouping by token gender gives "tokens of this class tagged with this gender", never "this class's paradigm in this gender". | H1472 |
| G22 | **`feat_formation` exists only on finite `Mood=Ind` verbs, and its meaning depends on the tense.** Census of the pinned distribution: the `Formation` feature occurs **17,440 times, never once outside `Mood=Ind`** — 16,100 on `Tense=Past`, 1,340 on `Tense=Fut`, zero on participles and zero on all 8,726 `Tense=Past` Jus/Imp/Sub/Opt/Prec tokens. Two consequences. (a) *Always guard on tense*: `peri` under `Past` is the periphrastic **perfect** (4,046), under `Fut` the periphrastic **future** (1,340); a `WHERE feat_formation='peri'` with no tense predicate silently merges two unrelated categories. (b) *The non-indicative past moods cannot be split by formation at all* — the tag is absent **upstream**, not hidden by our predicate, so the injunctive-vs-aorist question is unanswerable from DCS FEATS and quoting those moods as formation-resolved is a defect. Propagating a formation from a same-form attestation would reach only **296 of 8,726 tokens (3.39%)** even allowing an exact form+lemma match, so no inference layer is worth building. Extends G4. | H3878; [audit_past_nonindicative_formation.py](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/audit_past_nonindicative_formation.py), [past_nonindicative_formation_audit.md](https://github.com/gasyoun/VisualDCS/blob/main/src/DCS-data-2026/reports/past_nonindicative_formation_audit.md) |

## 8. Silent-join-failure symptoms — the checklist

A DCS join that is *wrong* rarely *errors*. Suspect the layer when you see:

1. **A plausible-but-low match rate** (the H1328 "29%") — first re-run with `ṁ`→`ṃ` unification
   and MW-markup stripping; only then interpret the residue.
2. **Zero rows for a string you can see in the data** — you are matching `ṁ` against `ṃ` (or
   querying `'None'` instead of `IS NULL`, or pointing at the 31 MB sample DB).
3. **Counts slightly off a published number** — vintage mismatch (`dcs_full` vs M9 archive vs
   2021; §4.3) or a `Case=Cpd` denominator decision differing from the source you compare to.
4. **A text you expected is "missing"** — check G1: substring hits on `text.name` lie, famous
   works live inside larger rows (Nala), and even the chapter numbering can hide one (the
   Gītā sits under `BhaGī N` refs, invisible to a numeric-adhyāya scan).
5. **Rows silently dropped after an aggregate** — you joined through `sent_id`/`occ_id` (G11).
6. **A diachronic signal that tracks text age suspiciously well** — you measured annotation
   density (G12) or an undocumented period bucket (G7).
7. **A corpus-absence claim about a lemma** — check it is not a citation-form difference
   (`sena`/`senā`, §5.2) before asserting absence; 1,289 known `form_variant` pairs.

## 9. Reproducing the numbers

All numbers above regenerate with two read-only scripts (streaming; never open the DB with a
file-reading tool): the schema recon (`PRAGMA` + counts + provenance + gotcha queries) and the
join-recipe battery (spine join, WhitneyRoots/kosha shapes, fold pairs, treebank slice,
PK-collision counts). The exact scripts are recorded in H1407's session log; every query is quoted
inline above, so any SQLite client in `mode=ro` reproduces them one by one. Refresh policy: re-run
after any re-import (new `source_commit` in `provenance`), and treat this manual's numbers as
stale the moment `provenance.imported_at` changes — then update this file and its
[`.meta.md`](https://github.com/gasyoun/VisualDCS/blob/main/docs/DCS_SQLITE_CONLLU_CONSUMER_DEEP_MANUAL.meta.md)
staleness block in the same pass.

_Dr. Mārcis Gasūns_
