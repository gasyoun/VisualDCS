# Consonant series (varga) by period — diachronic shares

_Created: 07-07-2026 · Last updated: 07-07-2026_

The five Sanskrit consonant series (varga) as **shares by historical period**, derived
from the DCS-2026 per-varṇa/per-period counts. Built to replace the χ²-p-value "Table 5"
of the 2014 dissertation *Состав и строй древнеиндийских корней* (Gasūns) with an
honest frequency-share + effect-size analysis (see [H246](https://github.com/gasyoun/Uprava/blob/main/handoffs/H246-Fable_GasunsDhatu_2026_printed_book_prep_06.07.26.md),
defect **L7**), and reusable on its own.

## Files

| File | Content |
|---|---|
| [`aggregate_vargas.py`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/varga-series-diachrony/aggregate_vargas.py) | Deterministic aggregator: 48 varṇas → 5 vargas × 5 periods, shares + Cramér's V |
| [`varga_share_by_period.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/varga-series-diachrony/varga_share_by_period.csv) | 5 vargas × {5 period shares, corpus share, 5 counts, Δ I→V} |
| [`slot_era_map.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/varga-series-diachrony/slot_era_map.csv) | DCS `dcsTimeSlot` 1–5 → era label + defining texts + approx. dates |

**Source:** [`../regen-2026/varna_freq.csv`](https://github.com/gasyoun/VisualDCS/blob/main/derived-data/Fonetika/regen-2026/varna_freq.csv)
(48 varṇas × `slot1..slot5`, DCS pin 2026-03-05, CC BY 4.0). Regenerate with
`python aggregate_vargas.py`.

## Scope

Only the **25 sparśa** (stops + class nasals) form the 5 vargas. Anusvāra, visarga,
semivowels (`y r l v`) and sibilants (`ś ṣ s h`) are separate classes and are excluded.
Shares are **column shares** — each varga as a % of the 25-stop mass *within* a period,
so they answer "does the balance of series shift over time" independent of period size.

## Period → era (empirical, from `chapter-info.xml` text composition)

| Slot | Era | Defining texts | Approx. |
|:--:|---|---|---|
| I | Vedic (Saṃhitā–Brāhmaṇa–Śrautasūtra) | Ṛgveda, Atharvaveda, Śatapathabrāhmaṇa, Taittirīyasaṃhitā | ~1500–500 BCE |
| II | Epic & early śāstra | **Mahābhārata, Rāmāyaṇa**, Caraka, Arthaśāstra, Aṣṭādhyāyī | ~400 BCE–200 CE |
| III | Early classical | Suśruta, Yogasūtra-bhāṣya, Matsya/Viṣṇu-purāṇa, Harivaṃśa | ~200–600 CE |
| IV | Later classical / early medieval | Āyurvedadīpikā, Bhāgavata/Garuḍa-purāṇa, Kathāsaritsāgara | ~600–1000 CE |
| V | Medieval / late | Rasaratnasamuccaya, Skandapurāṇa (Revākhaṇḍa), Gheraṇḍasaṃhitā | ~1000–1700 CE |

DCS slots are **ordered strata, not exact centuries**; absolute dating is coarse and
sometimes reflects the manuscript, not composition (e.g. Śāṅkhāyana-śrautasūtra falls in
slot V). Treat era labels as approximate.

## Headline

χ²(16) = 54,891 (p ≈ 0) but **Cramér's V = 0.037** — the series composition is
diachronically **near-stable** across ~2 millennia; the χ² is "significant" only because
N ≈ 9.94M. The one appreciable drift is a **rise of velars (+5.2 pp I→V)** and mild rise
of retroflexes (+1.4 pp), offset by declining dentals (−4.2 pp) and labials (−2.3 pp).
This **reverses** the 2014 claim that labials/cerebrals grow and dentals grow in the
classical period.

**Consumer:** GasunsDhatu 2026 print edition, §2.6 «Распределение рядов согласных».

_Dr. Mārcis Gasūns_
