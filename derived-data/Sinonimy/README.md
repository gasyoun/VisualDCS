# Sinonimy

_Created: 05-07-2026 · Last updated: 05-07-2026_

Synonym-set research for Sanskrit verbs and nouns, derived from the Digital Corpus of
Sanskrit (DCS) plus Monier-Williams (MW) definitions — synonym rings built from shared
English glosses, a vector-similarity variant, and the syntagmatic (collocation) table
that several of these workbooks draw candidate synonyms from. Part of
[`derived-data/`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md)
— see that README for how this folder fits the wider research archive (and its
"Provenance confidence" note: `Sinonimy` was one of the two lowest-confidence DCS-vs-non-DCS
placement calls, confirmed correct by M.G. on 02-07-2026), and
[`../INDEX.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/INDEX.md)
for the size/file-count table (`Sinonimy` = 141MB / 12 files).

## Files

| File | Sheets | Notes |
|---|---|---|
| [Значения.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/Значения.xlsx) ("Meanings") | `Значения`, `Алфавитный порядок` (alphabetical order), `По убыванию глубины` (by descending depth) | Per-lemma sense inventory: `Лемма` (lemma) · `Значений` (number of senses) · `Список значений` (list of senses, e.g. `go`/`sun`/`patr`/`earth`/`body`/`arrow`/`eye`/`cow`/`sky`/`mother`/`bull` as English gloss fragments). 16,685 shared strings. |
| [Поиск синонимов в Цифровом корпусе Санскрита.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/Поиск%20синонимов%20в%20Цифровом%20корпусе%20Санскрита.xlsx) ("Synonym search in the Digital Corpus of Sanskrit") | `Подробная запись` (detailed record), `Краткая запись` (short record), `По дефинициям` (by definitions) | Core synonym-mining workbook. Columns: `Лемма`, `Дефиниций` (# definitions), `Синонимов 50% соответствия` (# synonyms at 50% match), `Связей дефиниций с дефинициями синонимов` (definition-to-synonym-definition link count), `Все дефиниции`, `Синоним`, `% соответствия` (% match), `Связи синонима`. Data rows show gloss-overlap synonym candidates, e.g. lemma `darśata` linked to `sun;94;moon;79;` (candidate synonym; match-% pairs) with matched-definition-fragment lists like `/sun/;/moon/;`. 91,129 shared strings — the largest workbook in this folder by string count. |
| [Глагольные синонимы_,без ограничений (2).xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/Глагольные%20синонимы_%2Cбез%20ограничений%20%282%29.xlsx) ("Verbal synonyms, unrestricted (2)") and its near-duplicate [S_P_D_F/Глагольные синонимы.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/S_P_D_F/Глагольные%20синонимы.xlsx) | `По дефинициям`, `Синонимы без ограничений` (unrestricted synonyms), `Заголовки син.рядов` (synonym-series headwords), `Поиск омонимов` (homonym search), `Краткая статистика` (brief stats), `Синонимы при 50% соответствия` | Verb-specific synonym rings, unrestricted variant (no minimum-match cutoff applied, contrasted with the "at 50%" sheet). Sample rows: English gloss `destroy` grouping IAST-in-slashes verb roots `/ativiloḍay/`, `/adhinirhan/`, `/anyathākṛ/`, `/apamṛd/`, `/apavap/`, `/apahan/`, `/abhibhañj/`, `/abhimṛd/`, `/abhiṣā/`, … — i.e. rows are keyed by an English sense, listing all Sanskrit verb roots (slash-delimited) sharing that gloss. **Both files have byte-identical shared-string content** (66,874 strings each, identical first-20 sample) — treat as duplicate/near-duplicate copies, not independently verified byte-for-byte. |
| [S_P_D_F/Синонимы существительных.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/S_P_D_F/Синонимы%20существительных.xlsx) ("Noun synonyms") | `Подробная запись`, `Краткая запись`, `По дефинициям`, `Поиск омонимов` | Same schema family as the verb-synonym workbooks but for nouns; adds a `Поиск омонимов` (homonym search) sheet. 117,201 shared strings — largest single workbook here. |
| [Подобие по векторам.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/Подобие%20по%20векторам.xlsx) ("Similarity by vectors") | `Лист1` | A **different methodology** from the gloss-overlap synonym search above: `Лемма` · `Подобных векторов` (# similar vectors) · `Леммы с подобными векторами` (lemmas with similar vectors) — a vector-space (distributional/embedding-style) similarity list, e.g. `mahīpati` grouped with `saṁgati`, `anindita`, `anuvrata`, `anuśāsana`, `parābhava`, `abhiprāya`, `kirīṭin`, `kutūhala`, `matsara`, `sampatti`, `nareśvara`, `bhujaṁgama`, `avaśa`, `asaṁśaya`, `īpsita`, `īpsu`, … The word list is unrelated in gloss to `mahīpati` ("lord of the earth") — suggesting these are corpus-co-occurrence/vector-similarity neighbors, not semantic synonyms. Only 6,705 shared strings — much smaller than the definition-based workbooks. |
| [S_P_D_F/Частотный список существительных и глаголов.xlsx](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/S_P_D_F/Частотный%20список%20существительных%20и%20глаголов.xlsx) ("Frequency list of nouns and verbs") | `Лист1` | Corpus-wide reference frequency list: `Абсолютная частота` (absolute frequency) · `Лемма` · `Грамм` (POS) · `Частота 1 на млн.` (frequency per million) · header note `Всего в корпусе 4577915 словоупотреблений` ("total 4,577,915 word-uses in the corpus" — matches the ~4.57M-token scale cited in the main VisualDCS project's `src/DCS-data-2021/10.csv`). Sample lemmas: `vac`, `bhū`, `as`, `rājan`, `gam`, `deva`, `dṛś`, `artha`, `dharma`, `ātman`, `putra`. Likely the frequency baseline the synonym-ranking sheets draw on. |
| [S_P_D_F/Синтагматическая таблица DCS.csv](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sinonimy/S_P_D_F/Синтагматическая%20таблица%20DCS.csv) and its `.txt` twin ("Syntagmatic table DCS") | Plain text, tab-separated, **byte-identical size** (47,457,106 bytes both) | Word-collocation table: each row = `row_id`, `lemma_id`, `lemma (garbled/mojibake encoding in early rows)`, then repeating `(text_id, count)` pairs recording which corpus texts a lemma co-occurs in and how many times. First rows show corrupted-looking lemma text (`akāra` mis-rendered) — appears to be a **legacy 8-bit/code-page encoding artifact**, not valid UTF-8; needs the original code page (likely a pre-Unicode Cyrillic/transliteration scheme) to render correctly. This is the same syntagmatic-table concept as [`Sochetaemost-sanskritskih-osnov`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Sochetaemost-sanskritskih-osnov/README.md)'s collocation data and [`Lexical-Cores`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Lexical-Cores/README.md)'s Приложение 7 (syntagmatic table for all corpus lemmas) — likely a related or shared export, not independently verified as identical content. |
| [Works-Share-Syn/data28.xlsx, data29.xlsx, data30.xlsx](https://github.com/gasyoun/VisualDCS/tree/main/derived-data/Sinonimy/Works-Share-Syn) | Unopened for this README | Recovered from the legacy `Works/Share/Syn` export tree (see parent README's provenance note on `Works-Share-*` folders) — generically named, not cross-referenced against the named files above; **`data28.xlsx` is byte-size-identical (7,918,311 bytes) to `Глагольные синонимы_,без ограничений (2).xlsx`**, suggesting it's the same workbook under its original export name. `data29.xlsx`/`data30.xlsx` sizes were not matched to a named counterpart. |

## Data schema

No single schema — this folder mixes several methodologies:

1. **Gloss-overlap synonym mining** (`Поиск синонимов...`, `Глагольные синонимы...`,
   `Синонимы существительных.xlsx`): lemma → definitions → % match against other lemmas'
   definitions → ranked synonym candidates, bucketed at a "50% match" threshold in some sheets.
2. **Vector-similarity** (`Подобие по векторам.xlsx`): lemma → nearest neighbors by some
   vector-space method (not documented; likely corpus co-occurrence, not classical WordNet-
   style synsets — neighbor lists don't track gloss overlap).
3. **Frequency baseline** (`Частотный список существительных и глаголов.xlsx`): plain
   lemma → absolute frequency → per-million rate, POS-tagged.
4. **Syntagmatic/collocation table** (`Синтагматическая таблица DCS.csv/.txt`): lemma →
   list of (text, co-occurrence count) pairs — the raw substrate several of the above analyses
   likely draw on.

## Usage example

Inspecting workbook sheet names and sample content without opening Excel (same technique as
used for [`QL`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/QL/README.md)):

```python
import zipfile, re

path = "Sinonimy/Поиск синонимов в Цифровом корпусе Санскрита.xlsx"
z = zipfile.ZipFile(path)
wb = z.read("xl/workbook.xml").decode("utf-8")
print(re.findall(r'<sheet name="([^"]+)"', wb))
# -> ['Подробная запись', 'Краткая запись', 'По дефинициям']
```

Reading the syntagmatic CSV/TXT (mind the legacy encoding — try `cp1251` or similar before
assuming UTF-8):

```python
with open("Sinonimy/S_P_D_F/Синтагматическая таблица DCS.csv",
          encoding="utf-8", errors="replace") as f:
    for line in f:
        row_id, lemma_id, lemma, *rest = line.rstrip("\n").split("\t")
        pairs = list(zip(rest[0::2], rest[1::2]))  # (text_id, count) pairs
        break
```

## Known caveats / limitations

- **Encoding corruption observed directly.** The syntagmatic CSV/TXT's lemma column renders
  as mojibake when read as UTF-8 (e.g. `akāra` shows corrupted) — this was directly observed,
  not inferred; try legacy code pages (`cp1251`) or check whether a proper transliteration
  scheme recovers it before using lemma text from this file.
- **Duplicate/near-duplicate files confirmed by size+content sampling, not full byte-diff.**
  `Глагольные синонимы_,без ограничений (2).xlsx` and `S_P_D_F/Глагольные синонимы.xlsx` share
  identical shared-string counts and first-20 samples; `Works-Share-Syn/data28.xlsx` matches
  the former's exact byte size. None of these were run through a full byte-level diff.
- **Two genuinely different similarity methods coexist** (gloss-overlap vs. vector-similarity)
  under the same "Sinonimy" (synonyms) folder name — don't assume `Подобие по векторам.xlsx`'s
  neighbor lists are semantic synonyms; the sampled example (`mahīpati` ↔ `saṁgati`, `anindita`,
  …) shows no obvious gloss relationship.
- **`Works-Share-Syn/data29.xlsx` and `data30.xlsx`** were not cross-referenced against a named
  counterpart — their exact relationship to the other files is unconfirmed.
- **Provenance confidence flag (inherited from parent INDEX).** This folder was one of the two
  lowest-confidence DCS-vs-non-DCS classification calls when the archive was split — confirmed
  correctly placed here by M.G. (02-07-2026).

## Provenance

**No generating script was found anywhere in the VisualDCS repo** — a repo-wide grep for
`Sinonimy`/`Синоним`/`SINTAGMA` matched only this archive's own README/INDEX files. Per the
parent [`derived-data/README.md`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/README.md),
this is hand-curated research material (V.V. Leonchenko and collaborators' corpus studies,
"spanning verb forms, nominal forms, compounds, pronouns, particles, phonetics, **synonymy**,
and stem collocability" — synonymy is named explicitly), **not** wired into the VisualDCS
dashboard pipeline (`../src/DCS-data-2021/`, `../src/DCS-data-2026/`) — reference archive only.

_Dr. Mārcis Gasūns_
