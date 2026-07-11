"""Emit the `translation-witness` Type-D typed-link dataset (TYPED_LINK_ID_GRAMMAR.md
§4a, H540) for the landed Grassmann `<L>` <-> VedaWeb Grassmann-de layer crosswalk.

One row per gra_vedaweb_crosswalk.tsv entry: anchor = the Grassmann Worterbuch entry
(gra:<L>), target = the RV stanza in the Grassmann-de (1876-1877) VedaWeb translation
layer (vedaweb:<RV-locus>:<layer ObjectId>). Both halves are host-stable ids already
present in the source files (spec §0, reuse-don't-mint) -- match_method=id-link, no
fuzzy matching. Superseded pre-spec prototype: build_type_d_id_join.py /
type_d_id_join.tsv (Q4.0, H522) used an incompatible ad-hoc schema -- this is the
canonical TYPE_D_RECORD_FIELDS emission per H539.
"""
import csv
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[3] / "kosha" / "scripts"))
from concordance_core import TIER_CONFIDENCE, TYPE_D_RECORD_FIELDS  # noqa: E402

sys.stdout.reconfigure(encoding="utf-8")

HERE = Path(__file__).resolve().parent
CROSSWALK = HERE / "gra_vedaweb_crosswalk.tsv"
LAYER_JSON = HERE / "grassmann_de_1876_1877.json"
OUT_TSV = HERE / "typed_link_translation_witness.tsv"

# Landing date of the underlying crosswalk + layer export (H362), not today's date --
# these rows assert a fact that was already true on that date.
LANDED_DATE = "08-07-2026"


def main():
    import json

    layer = json.loads(LAYER_JSON.read_text(encoding="utf-8"))
    resource_id = layer["id"]
    locations = {c["location"] for c in layer["contents"] if c.get("location")}

    with open(CROSSWALK, encoding="utf-8-sig", newline="") as f:
        crosswalk_rows = list(csv.DictReader(f, delimiter="\t"))

    out_rows = []
    unmatched = 0
    for row in crosswalk_rows:
        loc = row["vedaweb_example_location"]
        if loc not in locations:
            unmatched += 1
            continue
        out_rows.append({
            "anchor_type": "id-gra",
            "anchor_id": "gra:%s" % row["gra_L"],
            "anchor_key_slp1": row["gra_key1"],
            "target_locus": "vedaweb:%s:%s" % (loc, resource_id),
            "link_type": "translation-witness",
            "source_dataset": "VisualDCS/non-derived/vedaweb/grassmann_de_1876_1877.json",
            "match_method": "id-link",
            "confidence": TIER_CONFIDENCE["id-link"],
            "evidence_count": row["rv_occurrence_count"],
            "date": LANDED_DATE,
        })

    with open(OUT_TSV, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=TYPE_D_RECORD_FIELDS, delimiter="\t")
        writer.writeheader()
        writer.writerows(out_rows)

    print("crosswalk rows: %d, emitted: %d, unmatched (no layer location): %d" % (
        len(crosswalk_rows), len(out_rows), unmatched))


if __name__ == "__main__":
    main()
