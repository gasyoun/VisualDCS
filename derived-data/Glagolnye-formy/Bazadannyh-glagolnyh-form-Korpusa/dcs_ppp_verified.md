# DCS verified PPP forms — `dcs_ppp_verified.tsv`

_Created: 03-07-2026 · Last updated: 03-07-2026_

A corpus-attested list of **Past Passive Participle (PPP)** forms, extracted from the
verbal-forms database in this folder. "Verified" here means **attested in the DCS corpus**,
each with its occurrence count — not editorially hand-checked.

## Source

Extracted from [`База данных глагольных форм Санскрита.xlsx`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Glagolnye-formy/Bazadannyh-glagolnyh-form-Korpusa/%D0%91%D0%B0%D0%B7%D0%B0%20%D0%B4%D0%B0%D0%BD%D0%BD%D1%8B%D1%85%20%D0%B3%D0%BB%D0%B0%D0%B3%D0%BE%D0%BB%D1%8C%D0%BD%D1%8B%D1%85%20%D1%84%D0%BE%D1%80%D0%BC%20%D0%A1%D0%B0%D0%BD%D1%81%D0%BA%D1%80%D0%B8%D1%82%D0%B0.xlsx)
(55,032 corpus verbal forms). The database tags every form by tense/mood in the
`Время/наклонение` column; this asset is the subset where that column equals
**`Past Passive Participle`**, keyed by (root, form) with occurrence counts summed across the
class/voice rows of the same form.

## Contents

| Column | Meaning |
|---|---|
| `root` | Verbal stem/root as recorded in the DB (`Основа`). **Includes preverbed roots** (`prāp`, `āgam`, `pravac`) — strip prefixes before matching bare-root inventories. |
| `ppp_form` | The attested PPP surface form (`Форма`), e.g. `ukta`, `kṛta`, `gata`. |
| `gana_class_dcs` | Gaṇa class (`Класс`) — **DCS lexicon metadata** (Böhtlingk/MW tradition), not derived from the attested form. Treat with caution. |
| `voice_dcs` | Voice (`Залог`), same caveat. |
| `corpus_occurrences` | Token occurrences of this PPP form in the corpus (`Употреблений`). This is the "verified/attested" signal. |

Rows sorted by `corpus_occurrences` descending. UTF-8, tab-separated, no BOM.

## Totals

- **5,181** unique (root, form) PPP entries
- **4,974** roots with at least one attested PPP
- **233,079** total PPP token occurrences

Top forms: `vac→ukta` (7,734), `kṛ→kṛta` (7,599), `gam→gata` (6,270), `yuj→yukta` (3,786),
`sthā→sthita` (3,598).

## Caveats

- **Trust the form + count; be wary of the class/voice columns** — those are lexicon metadata,
  and the DCS lemma field lumps some homonyms, so a single (root, form) row can conflate
  same-spelled roots.
- Roots are as spelled in the source DB (preverbed forms present; IAST).

## Downstream use

Built to settle corpus-attestation questions in
[WhitneyRoots `docs/DECISIONS_NEEDED.md`](https://github.com/gasyoun/WhitneyRoots/blob/main/docs/DECISIONS_NEEDED.md)
§3 (PPP validation): e.g. it confirms `han→hata` (not `ghata`) and `dā→datta` at 1,471×
with **zero** `dātta`, and corroborates warnemyr's PPP for 9 of the 10 §3e corpus-frequency
cases (`uṣ→uṣṭa` being the one not surfaced here).

_Dr. Mārcis Gasūns_
