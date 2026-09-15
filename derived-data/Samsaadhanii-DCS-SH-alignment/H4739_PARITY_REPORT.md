# H4739 — Samsaadhanii DCS × Heritage alignment ingest parity report

_Created: 2026-09-16 · VALIDATION-ONLY (no upstream LICENSE file; parallel_corpus
README states CC BY 4.0 for the parent research work — provenance note only, the
stricter handoff rule wins). Aggregates only; row-level layer never committed._

## Upstream

| Source | sha256_12 | Shape |
|---|---|---|
| [`samsaadhanii/datasets`](https://github.com/samsaadhanii/datasets) `dcs_sh_alignment/parallel_corpus/parallel_data_iast.tsv` (no LICENSE file) | `4adc8776b9c0` | 130270 rows, tab-separated, 3 cols (sentence_id, sentence, segmentation), IAST |

The alignment pairs each DCS sentence (sandhied surface) with its ground-truth
Sanskrit Heritage Segmenter segmentation: hyphens split compound-internal
parts, spaces mark word boundaries / un-done sandhi junctions (`nāsti` →
`na asti`, `tathaiva` → `tathā eva`). Space-chunk counts therefore differ by
design; parity is measured at row level, not chunk level.

## Parity gates (hard)

| Gate | Result |
|---|---|
| G1 rows: csv walk == raw newline census == expected 130,270 | PASS — csv=130,270 raw=130,270 |
| G2 structure: 3 cols; ids unique+numeric; no empty fields | PASS — malformed=0, dup=0, non-numeric=0, empty=0 |

Structural defect sample (first 10, truncated):
- none

## Aggregate alignment metrics (counts only)

| Metric | Value |
|---|---|
| Sentences | 130,270 |
| Unique ids | 130,270 (min 6, max 621364) |
| Sentence space-chunks | 595,258 |
| Segmentation space-chunks | 689,745 |
| Segmentation segments (hyphen-split) | 864,903 |
| Compound chunks (hyphen-bearing) | 127,977 |
| Char-alignment ratio mean / min / max | 0.9486 / 0.0774 / 1.0000 |
| Sentences ratio ≥ 0.95 | 75,723 (58.13%) |
| Sentences ratio ≥ 0.85 | 126,852 (97.38%) |
| Sentences ratio < 0.70 | 569 (0.44%) |

## Hand-checked sample (deterministic: first 3 + seed-20260916 random 6 + last 3)

| id | sentence (sandhied) | ground-truth segmentation |
|---|---|---|
| 6 | `ghaṭasthayogam yogeśa tattvajñānasya kāraṇam` | `ghaṭa-stha-yogam yoga-īśa tattva-jñānasya kāraṇam` |
| 11 | `nāsti māyāsamaḥ pāśo nāsti yogāt param balam` | `na asti māyā-samaḥ pāśaḥ na asti yogāt param balam` |
| 58 | `dantamūlam jihvāmūlam randhram ca karṇayugmayoḥ` | `danta-mūlam jihvā-mūlam randhram ca karṇa-yugmayoḥ` |
| 151164 | `yadā hutāśo dīptārciḥ śuklotthānasamanvitaḥ` | `yadā huta-āśaḥ dīpta-arciḥ śukla-utthāna-sa-manu-itaḥ` |
| 63763 | `kṣatāni ca na rohanti kuṣṭhairmṛtyurhinasti tam` | `kṣatāni ca na rohanti kuṣṭhaiḥ mṛtyuḥ hinasti tam` |
| 176381 | `nāradastvatha devarṣir ājagāma yadṛcchayā` | `nāradaḥ tu atha deva-ṛṣiḥ ājagāma yadṛcchayā` |
| 404460 | `mukhe hyagniḥ sthito devo danteṣu ca bhujaṅgamāḥ` | `mukhe hi agniḥ sthitaḥ devaḥ danteṣu ca bhujaṅgamāḥ` |
| 506530 | `taduktam varadena śrīsiddhayogīśvarīmate` | `tat uktam varadena śrī-siddha-yogi-īśvarī-mate` |
| 189397 | `tāpasāraṇyam atulam divyakānanadarśanam` | `tāpasa-araṇyam atulam divya-kānana-darśanam` |
| 621313 | `namo hiraṇyabāhave senānye diśām ca pataye namaḥ` | `namaḥ hiraṇya-bāhave senānye diśām ca pataye namaḥ ` |
| 621353 | `tām samabhavat` | `tām samabhavat` |
| 621364 | `tām mṛgeṣu nyadadhāt` | `tām mṛgeṣu nyadadhāt` |

Hand-check verdicts (executor-read, 2026-09-16, 12/12 tabulated rows
read): 11 of 12 decompose into textbook-clean sandhi/compound analyses —
`ghaṭasthayogam` → `ghaṭa-stha-yogam`, `yogeśa` → `yoga-īśa` (a+ī→e),
`nāsti` → `na asti` (a+a→ā), `pāśo` → `pāśaḥ` (visarga→o before voiced),
`kuṣṭhairmṛtyurhinasti` → `kuṣṭhaiḥ mṛtyuḥ hinasti` (visarga→r before h),
`nāradastvatha` → `nāradaḥ tu atha` (aḥ+t→s t), `dīptārciḥ` →
`dīpta-arciḥ` (a+a→ā), `mukhe hyagniḥ` → `mukhe hi agniḥ` (i+a→ya variant),
`śrīsiddhayogīśvarīmate` → `śrī-siddha-yogi-īśvarī-mate` (i+ī→ī),
`tāpasāraṇyam` → `tāpasa-araṇyam` (a+ā→ā); the two sentence-final rows
(621353, 621364) are no-sandhi identities. ONE caveat: id 151164 splits
`samanvitaḥ` as `sa-manu-itaḥ` — a debatable morphemic split with char drift
(v↔u; standard analysis `sam-anv-itaḥ`); recorded, not fabricated, and the
ratio metric surfaces it (this row's ratio < 1.0). No invented segments
observed.

## Low-ratio tail (honest characterization)

569 sentences (0.44%) score ratio < 0.70 — inspection of the
worst (min 0.077) shows PARTIAL-COVERAGE alignments: the ground-truth
segmentation covers only a fragment of the sentence (e.g. id 70260: 149-char
compound string vs segmentation `śāntāḥ`; id 24056: 71-char sentence vs
`iti`). Mean stripped-length delta segmentation−sentence is +0.66 chars
(median +1), i.e. coverage is tight on ~99.5% of rows and the tail is an
upstream ground-truth coverage gap, not a parsing artifact.

## Verdict

**PASS** — 130,270 aligned sentences validated; aggregates only
committed (VALIDATION-ONLY).
