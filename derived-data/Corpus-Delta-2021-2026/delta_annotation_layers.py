"""Annotation-layer census of the DCS-2026 CoNLL-U corpus (H686 supplement §6).

The primary H686 pass (REPORT.md + DRIFT_INTERPRETATION.md §1-5) reads the
2021->2026 delta purely at token/lemma/POS level. This script measures the
ORTHOGONAL axis those passes omit: which of the three CoNLL-U annotation layers
each text carries.

Layers (per src/DCS-data-2026/conllu/readme.md):
  * WordSem  (MISC WordSem=)          lexical semantic-concept IDs -> Sanskrit WordNet
  * Treebank (cols 7/8 HEAD/DEPREL)   dependency syntax; "Vedic Treebank" subset
  * IsMantra (MISC IsMantra=True)     token is in a mantra (Bloomfield's Concordance)

Writes annotation_layers_by_text.csv (per-text token counts + only_2026 flag)
and prints the summary tables.

Reproduce:  python delta_annotation_layers.py
Requires the full CoNLL-U corpus under ../../src/DCS-data-2026/conllu/files/
(clone OliverHellwig/sanskrit if absent). Read-only over the corpus.
"""
import sys, os, glob, csv

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, "..", "..", "src", "DCS-data-2026",
                                     "conllu", "files"))
OUT = os.path.join(HERE, "annotation_layers_by_text.csv")

# The 30 texts present in 2026 but not 2021 (coverage_diff.md / REPORT.md).
ONLY_2026 = {
    "Aitareya-Āraṇyaka", "Atharvaveda (Paippalāda)", "Bhāradvājaśrautasūtra",
    "Commentary on the Kāvyālaṃkāravṛtti", "Drāhyāyaṇaśrautasūtra", "Harivaṃśa",
    "Hiraṇyakeśiśrautasūtra", "Jaiminīya-Upaniṣad-Brāhmaṇa", "Jaiminīyaśrautasūtra",
    "Kauśikasūtrakeśavapaddhati", "Kauṣītakagṛhyasūtra", "Kauṣītakibrāhmaṇa",
    "Kaṭhāraṇyaka", "Kāṭhakasaṃhitā", "Mānavaśrautasūtra", "Mīmāṃsāsūtrabhāṣya",
    "Saddharmapuṇḍarīkasūtra", "Sāmavidhānabrāhmaṇa", "Taittirīyabrāhmaṇa",
    "Taittirīyāraṇyaka", "Vaikhānasaśrautasūtra", "Vaitānasūtra", "Vasiṣṭhadharmasūtra",
    "Vājasaneyisaṃhitā (Mādhyandina)", "Vārāhaśrautasūtra", "Āpastambadharmasūtra",
    "Āśvālāyanaśrautasūtra", "Śāṅkhāyanaśrautasūtra", "Ṛgvidhāna", "Ṣaḍviṃśabrāhmaṇa",
}


def scan():
    rows = []
    for text in sorted(os.listdir(ROOT)):
        tdir = os.path.join(ROOT, text)
        if not os.path.isdir(tdir):
            continue
        tok = ws = tb = mn = 0
        for fp in glob.glob(os.path.join(tdir, "*.conllu")):  # skip *_parsed dups
            with open(fp, encoding="utf-8") as fh:
                for line in fh:
                    if not line or line[0] in "#\n":
                        continue
                    c = line.rstrip("\n").split("\t")
                    if len(c) < 10 or "-" in c[0] or "." in c[0]:  # MWT/empty node
                        continue
                    tok += 1
                    if c[6] not in ("_", ""):
                        tb += 1
                    if "WordSem=" in c[9]:
                        ws += 1
                    if "IsMantra=True" in c[9]:
                        mn += 1
        rows.append((text, tok, ws, tb, mn, "yes" if text in ONLY_2026 else ""))
    return rows


def pct(a, b):
    return (100.0 * a / b) if b else 0.0


def main():
    if not os.path.isdir(ROOT):
        sys.exit(f"corpus not found at {ROOT} — clone OliverHellwig/sanskrit first")
    rows = scan()

    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["text", "tokens", "wordsem_tokens", "treebank_tokens",
                    "ismantra_tokens", "only_2026"])
        w.writerows(rows)

    n_ws = sum(1 for r in rows if r[2] > 0)
    n_tb = sum(1 for r in rows if r[3] > 0)
    n_mn = sum(1 for r in rows if r[4] > 0)
    o26 = [r for r in rows if r[5] == "yes"]
    o26_nows = [r for r in o26 if r[2] == 0]

    print(f"texts scanned          : {len(rows)}")
    print(f"texts with WordSem>0   : {n_ws}")
    print(f"texts with Treebank>0  : {n_tb}")
    print(f"texts with IsMantra>0  : {n_mn}")
    print(f"only-2026 texts        : {len(o26)}  (WordSem==0: {len(o26_nows)})")
    print(f"CSV -> {OUT}")


if __name__ == "__main__":
    main()
