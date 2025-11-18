import json
import os
import re
from collections import defaultdict

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, "..", "..", ".."))
UTR_JSON_PATH = os.path.join(PROJECT_ROOT, "external", "xbrl", "utr", "utr.json")
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "schemas", "xbrl", "utr")

UTR_NS = "{http://www.xbrl.org/2009/utr}"


def camel_to_kebab(name):
    """Convert camelCase to kebab-case."""
    result = re.sub('([A-Z])', r'-\1', name)
    return result.lower().lstrip('-')


def load_utr_data():
    """Load and parse UTR JSON data."""
    with open(UTR_JSON_PATH, 'r', encoding='utf-8') as file:
        data = json.load(file)

    utr = data[f"{UTR_NS}utr"]
    last_updated = utr["@attributes"]["lastUpdated"]
    units = utr[f"{UTR_NS}units"][f"{UTR_NS}unit"]

    return last_updated, units


def group_by_item_type(units):
    """Group units by their itemType."""
    grouped = defaultdict(list)

    for unit in units:
        item_type = unit.get(f"{UTR_NS}itemType")
        if item_type:
            grouped[item_type].append(unit)

    return grouped


def create_unit_schema_entry(unit):
    """Create an anyOf entry for a single unit."""
    unit_id = unit.get(f"{UTR_NS}unitId", "")
    unit_name = unit.get(f"{UTR_NS}unitName", "")
    definition = unit.get(f"{UTR_NS}definition", "")
    symbol = unit.get(f"{UTR_NS}symbol", "")
    status = unit.get(f"{UTR_NS}status", "")

    if definition.endswith('.'):
        definition = definition[:-1]

    definition = re.sub(r'\s{2,}', ' ', definition)

    entry = {
        "const": unit_id,
        "title": unit_name,
        "description": definition
    }

    if symbol:
        entry["x-symbol"] = symbol

    if status:
        entry["x-status"] = status

    return entry


def generate_schema(item_type, units, last_updated, normative_only=False):
    """Generate a JSON Schema for an itemType."""
    filtered_units = units
    if normative_only:
        filtered_units = [u for u in units if u.get(f"{UTR_NS}status") == "REC"]

    item_type_display = item_type.replace("ItemType", " Item Type")
    item_type_display = re.sub(r'([a-z])([A-Z])', r'\1 \2', item_type_display)

    # Create examples from first few units (up to 3)
    examples = []
    for unit in filtered_units[:3]:
        unit_id = unit.get(f"{UTR_NS}unitId", "")
        if unit_id:
            examples.append(unit_id)

    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "title": f"XBRL UTR {item_type_display} units ({last_updated})",
        "description": f"Valid units for {item_type} as defined in the XBRL Units Type Registry",
        "examples": examples,
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": [
            "https://www.xbrl.org/specification/utr/rec-2013-11-18/utr-rec-2013-11-18-clean.html",
            "https://www.xbrl.org/utr/utr.xml"
        ],
        "anyOf": []
    }

    for unit in filtered_units:
        schema["anyOf"].append(create_unit_schema_entry(unit))

    return schema


def write_schema(filename, schema):
    """Write a schema to a JSON file."""
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    output_path = os.path.join(OUTPUT_DIR, filename)

    with open(output_path, 'w', encoding='utf-8') as file:
        json.dump(schema, file, indent=2, ensure_ascii=False)
        file.write('\n')


def main():
    """Main generator function."""
    print("Loading UTR data...")
    last_updated, units = load_utr_data()
    print(f"Loaded {len(units)} units (last updated: {last_updated})")

    print("Grouping units by itemType...")
    grouped = group_by_item_type(units)
    print(f"Found {len(grouped)} itemTypes")

    print("Generating schemas...")
    for item_type, item_units in sorted(grouped.items()):
        kebab_name = camel_to_kebab(item_type)

        all_schema = generate_schema(item_type, item_units, last_updated, normative_only=False)
        all_filename = f"{kebab_name}.json"
        write_schema(all_filename, all_schema)
        print(f"    {all_filename} ({len(item_units)} units)")

        normative_schema = generate_schema(item_type, item_units, last_updated, normative_only=True)
        normative_filename = f"{kebab_name}-normative.json"
        write_schema(normative_filename, normative_schema)
        rec_count = len([u for u in item_units if u.get(f"{UTR_NS}status") == "REC"])
        print(f"    {normative_filename} ({rec_count} REC units)")

    print(f"\nGenerated {len(grouped) * 2} schemas in {OUTPUT_DIR}")


if __name__ == "__main__":
    main()
