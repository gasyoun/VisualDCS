"""Type-D grammar<->nongrammar ID join (Q4.0, H522).

Joins the existing gra_vedaweb_crosswalk.tsv (id_gra -> VedaWeb example
location) against the three VedaWeb translation-layer exports landed
08-07-2026, keyed on the shared RV stanza `location` field. Emits
type_d_id_join.tsv with the D2 schema:
    grammar_id, nongrammar_locus, link_type, source_dataset, date
"""
import csv
import json
import sys

if sys.stdout.encoding is None or sys.stdout.encoding.lower() != "utf-8":
    sys.stdout.reconfigure(encoding="utf-8")
    sys.stderr.reconfigure(encoding="utf-8")

JOIN_DATE = "2026-07-11"

EXPORTS = [
    ("metrical_data_2024.json", "metrical_data_2024"),
    ("geldner_de_1951_1957.json", "geldner_de_1951_1957"),
    ("grassmann_de_1876_1877.json", "grassmann_de_1876_1877"),
]


def load_export_locations(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    resource_id = data["id"]
    locations = {c["location"] for c in data["contents"] if c.get("location")}
    return resource_id, locations, len(data["contents"])


def load_crosswalk_rows(path):
    with open(path, encoding="utf-8") as f:
        return list(csv.DictReader(f, delimiter="\t"))


def main():
    crosswalk_rows = load_crosswalk_rows("gra_vedaweb_crosswalk.tsv")
    crosswalk_locations = {row["vedaweb_example_location"] for row in crosswalk_rows if row.get("vedaweb_example_location")}

    join_rows = []
    coverage = {}
    for filename, source_dataset in EXPORTS:
        resource_id, export_locations, n_stanzas = load_export_locations(filename)
        matched = 0
        for row in crosswalk_rows:
            loc = row.get("vedaweb_example_location")
            if not loc or loc not in export_locations:
                continue
            gra_l = row["gra_L"]
            join_rows.append({
                "grammar_id": f"id_gra:{gra_l}",
                "nongrammar_locus": f"vedaweb:{resource_id}:{loc}",
                "link_type": "translation-witness",
                "source_dataset": source_dataset,
                "date": JOIN_DATE,
            })
            matched += 1
        coverage[source_dataset] = {
            "resource_id": resource_id,
            "n_stanzas": n_stanzas,
            "n_matched_join_rows": matched,
            "n_matched_unique_locations": len(export_locations & crosswalk_locations),
        }

    with open("type_d_id_join.tsv", "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=["grammar_id", "nongrammar_locus", "link_type", "source_dataset", "date"],
            delimiter="\t",
        )
        writer.writeheader()
        writer.writerows(join_rows)

    print(f"total join rows: {len(join_rows)}")
    print(f"crosswalk rows: {len(crosswalk_rows)}, unique example locations: {len(crosswalk_locations)}")
    for source_dataset, c in coverage.items():
        print(
            f"{source_dataset}: resource_id={c['resource_id']} n_stanzas={c['n_stanzas']} "
            f"unique_locations_matched={c['n_matched_unique_locations']}/{len(crosswalk_locations)} "
            f"join_rows={c['n_matched_join_rows']}"
        )


if __name__ == "__main__":
    main()
