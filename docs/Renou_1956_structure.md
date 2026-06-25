# Renou 1956 — *Histoire de la langue sanskrite* — chapter & subsection structure

Faithful transcription of the **Table des matières** of Louis Renou, *Histoire de
la langue sanskrite* (Lyon: IAC, 1956), read from the scanned source
[`Histoire_de_la_langue_sanskrite_Renou_Louis.pdf`](Histoire_de_la_langue_sanskrite_Renou_Louis.pdf)
(PDF pp. 253–254 = the *Table des matières*). Page numbers below are Renou's **print**
pages. This is the ground-truth reference for the Renou language-state tagging in
`SanskritLexicography/RussianTranslation` (see that repo's `RENOU.md`).

> **Key fact for the tagging model:** the five chapters = our five states I–V. But two
> linguistically-distinct **registers** Renou treats are *subsections*, not chapters:
> **le sanskrit épigraphique** (inside Ch. II) and **le bhāṣya** = commentary language
> (the lead section of Ch. IV, given its own grammar). They are invisible in a flat
> 5-state model — hence the subsection extension planned below.

---

## The five chapters (= states I–V) and their subsections

### Chap. I — Période védique (p. 5) → **State I (Vedic)**
Sanskrit 5 · La langue védique et ses origines 6 · L'indo-iranien 8 · La langue
védique du Ṛgveda 10 · Phonétique du Ṛgveda 13 · Morphologie du Ṛgveda 17 · Syntaxe
et style du Ṛgveda 20 · Vocabulaire du Ṛgveda 25 · Origines du vocabulaire ṛgvédique
28 · Hymnes récents du Ṛgveda 31 · L'Atharvaveda 32 · Autres *mantra*'s 35 · Les
*gāthā* 38 · Les *yajus* 39 · La prose *brāhmaṇa* 41 · Grammaire de la prose *brāhmaṇa*
43 · La langue des Upaniṣad 50 · La langue des Sūtra 53 · La fin du védisme 59.

### Chap. II — Pāṇini et le problème de la langue parlée (p. 62) → **State II (Pāṇinian)**
L'enseignement de Pāṇini 62 · La langue «classique» et Pāṇini 67 · Kātyāyana et
Patañjali 71 · Les grammairiens ultérieurs 74 · L'autorité des *śiṣṭa* 76 · Le
sanskrit, langue parlée 81 · Sanskrit et moyen-indien 83 · Témoignages sur l'usage du
sanskrit 89 · **★ Le sanskrit épigraphique 94.**

### Chap. III — La langue épique et ses prolongements (p. 101) → **State III (Epic & prolongements)**
Caractères généraux 101 · Grammaire de l'Épopée 103 · Phrase et style épique 107 ·
Vocabulaire épique 110 · Les Purāṇa 115 · Le Bhāgavata 120 · Les Tantra 122 · La Smṛti
124 · Autres textes versifiés et style «*kārikā*» 125.

### Chap. IV — Le sanskrit classique : le bhāṣya, la kathā, le kāvya (p. 133) → **State IV (Classical)**
**★ Le commentaire (*bhāṣya*) de type ancien 133** · Les commentaires proprement
classiques 138 · **★ Caractères linguistiques du *bhāṣya* 139** *(its own grammar)* ·
Le sanskrit narratif (*kathā*) 146 · Le dialogue du théâtre 150 · La poésie savante
(*kāvya*) : généralités 158 · Les conditions extérieures du *kāvya* 163 · Le *kāvya* et
la grammaire 166 · Vocabulaire du *kāvya* 171 · Style du *kāvya* 177 · Figures de style
182 · L'art de suggérer 187 · Provenances du vocabulaire classique 198 · Emprunts de
vocabulaire 202.

### Chap. V — Sanskrit bouddhique et jaina ; le sanskrit hors de l'Inde (p. 206) → **State V (Buddhist/Jaina)**
Sanskrit bouddhique : généralités 206 · La littérature extra-canonique 210 · Grammaire
du sanskrit bouddhique 214 · Sanskrit «hybride» 220 · Sanskrit jaina : généralités 222
· Grammaire du sanskrit jaina 227 · Le sanskrit hors de l'Inde 229 · Conclusions 232.

*(Front/back matter: Avant-propos 1 · Abréviations, Bibliographie générale 3 ·
Spécimens de textes sanskrits 237 · Index des auteurs modernes cités 239 · Index des
matières 243 · Carte de l'Inde.)*

---

## What this means for the tagging model (the gap)

Our `RENOU.md` model is **flat I–V** (= the five chapters). The book shows two extra
things a flat model loses:

1. **Register ≠ period.** Renou's own framing (Avant-propos) is that these are *"moins
   des stades chronologiques que des modifications internes profondes, partiellement
   simultanées"* — partly-simultaneous registers, not a clean timeline. We already
   honour this with multi-label states; subsections take it one level deeper.
2. **Two register-subsections matter and have no home in I–V:**
   - **`épigraphique`** (II §p. 94) — inscriptional Sanskrit, filed by Renou under the
     *spoken-language / norm* chapter as a witness to **real attested usage** (vs the
     grammarians' ideal). Not "a period"; a documentary register.
   - **`bhāṣya`** (IV §pp. 133–145) — **commentary language**, the *lead* section of the
     classical chapter, with its **own grammar** (*Caractères linguistiques du bhāṣya*).
     Linguistically distinct (terse, formulaic, meta-textual); "does not fit" kāvya or
     kathā. The user's call: this one is *important to have*.

A faithful model therefore = **state (I–V) + optional register (subsection)**. See the
companion plan in `SanskritLexicography/RussianTranslation/RENOU_SUBSECTIONS_PLAN.md`.

### Register subsections worth coding (linguistically distinct *and* signal-detectable)
| Register | Renou loc. | Parent state | Likely detector |
|---|---|---|---|
| `epig` epigraphic | II p. 94 | II | inscription corpora / `<ls>` inscription sigla |
| `bhasya` commentary | IV p. 133–145 | IV | commentary texts (bhāṣya/ṭīkā/vṛtti); DCS *Philosophy/Commentary*; `<ls>` commentary sigla |
| `katha` narrative prose | IV p. 146 | IV | DCS genre *Narrative Prose* |
| `natya` drama dialogue | IV p. 150 | IV | DCS genre *Nāṭya* |
| `kavya` high poetry | IV p. 158 | IV | DCS genre *Kāvya* |
| `purana` / `tantra` / `smrti` | III p. 115/122/124 | III | DCS genre *Purāṇa* / *Tantra-Āgama* |
| `rgveda` / `brahmana` / `upanisad` / `sutra` | I p. 10/41/50/53 | I | DCS Vedic sub-genres |
| `bauddha` / `jaina` | V p. 206/222 | V | BHS set / Jaina texts |

**Open design issue (commentary cross-cuts):** a *bhāṣya* can comment on a Vedic, epic
or kāvya base text — so "commentary" is arguably an **orthogonal discourse-type axis**,
not strictly a child of IV. Renou files it under IV at index level; whether we model it
as `IV.bhasya` (hierarchical) or as an independent `register=bhasya` tag is the first
decision in the plan.
