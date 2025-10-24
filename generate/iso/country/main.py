import json
import os
import sys
import re


def format_json_compact_arrays(obj):
    json_string = json.dumps(obj, indent=2, ensure_ascii=False)

    def compact_array(match):
        content = match.group(1)
        items = [item.strip() for item in re.findall(r'"[^"]*"|\d+', content)]
        if len(items) > 0:
            return '[ ' + ', '.join(items) + ' ]'
        return '[]'

    json_string = re.sub(r'\[\s*\n\s*((?:"[^"]*"|\d+)(?:\s*,\s*\n\s*(?:"[^"]*"|\d+))*)\s*\n\s*\]', compact_array, json_string)

    return json_string


def parse_countries(all_file, slim_2_file, slim_3_file):
    with open(all_file, 'r') as file:
        all_data = json.load(file)

    with open(slim_2_file, 'r') as file:
        slim_2_data = json.load(file)

    with open(slim_3_file, 'r') as file:
        slim_3_data = json.load(file)

    alpha_2 = {}
    alpha_3 = {}
    numeric = {}

    for entry in all_data:
        alpha_2_code = entry.get("alpha-2")
        alpha_3_code = entry.get("alpha-3")
        numeric_code = entry.get("country-code")
        name = entry.get("name")
        region = entry.get("region") or None
        sub_region = entry.get("sub-region") or None

        if alpha_2_code:
            alpha_2[alpha_2_code] = {
                "name": name,
                "alpha-3": alpha_3_code,
                "numeric": numeric_code,
                "region": region,
                "sub-region": sub_region
            }

        if alpha_3_code:
            alpha_3[alpha_3_code] = {
                "name": name,
                "alpha-2": alpha_2_code,
                "numeric": numeric_code,
                "region": region,
                "sub-region": sub_region
            }

        if numeric_code:
            numeric[numeric_code] = {
                "name": name,
                "alpha-2": alpha_2_code,
                "alpha-3": alpha_3_code,
                "region": region,
                "sub-region": sub_region
            }

    return alpha_2, alpha_3, numeric


def generate_alpha_2_schema(alpha_2, output_dir):
    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "title": "ISO 3166-1:2020 Alpha-2 Country Code",
        "description": "A two-letter country code from ISO 3166-1",
        "examples": [code for code in sorted(alpha_2.keys())[:4]],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
        "anyOf": [
            {
                "title": metadata["name"],
                "x-alpha-3": metadata["alpha-3"],
                "x-numeric": int(metadata["numeric"]),
                **({"x-region": metadata["region"]} if metadata["region"] else {}),
                **({"x-sub-region": metadata["sub-region"]} if metadata["sub-region"] else {}),
                "const": code
            }
            for code, metadata in sorted(alpha_2.items())
        ]
    }

    file_path = os.path.join(output_dir, "alpha-2.json")
    with open(file_path, 'w') as file:
        file.write(format_json_compact_arrays(schema))
        file.write('\n')
    print(f"Generated {file_path} with {len(alpha_2)} codes")


def generate_alpha_3_schema(alpha_3, output_dir):
    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "title": "ISO 3166-1:2020 Alpha-3 Country Code",
        "description": "A three-letter country code from ISO 3166-1",
        "examples": [code for code in sorted(alpha_3.keys())[:4]],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
        "anyOf": [
            {
                "title": metadata["name"],
                "x-alpha-2": metadata["alpha-2"],
                "x-numeric": int(metadata["numeric"]),
                **({"x-region": metadata["region"]} if metadata["region"] else {}),
                **({"x-sub-region": metadata["sub-region"]} if metadata["sub-region"] else {}),
                "const": code
            }
            for code, metadata in sorted(alpha_3.items())
        ]
    }

    file_path = os.path.join(output_dir, "alpha-3.json")
    with open(file_path, 'w') as file:
        file.write(format_json_compact_arrays(schema))
        file.write('\n')
    print(f"Generated {file_path} with {len(alpha_3)} codes")


def generate_numeric_schema(numeric, output_dir):
    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "title": "ISO 3166-1:2020 Numeric Country Code",
        "description": "A three-digit numeric country code from ISO 3166-1",
        "examples": [int(code) for code in sorted(numeric.keys())[:4]],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
        "anyOf": [
            {
                "title": metadata["name"],
                "x-alpha-2": metadata["alpha-2"],
                "x-alpha-3": metadata["alpha-3"],
                **({"x-region": metadata["region"]} if metadata["region"] else {}),
                **({"x-sub-region": metadata["sub-region"]} if metadata["sub-region"] else {}),
                "const": int(code)
            }
            for code, metadata in sorted(numeric.items())
        ]
    }

    file_path = os.path.join(output_dir, "numeric.json")
    with open(file_path, 'w') as file:
        file.write(format_json_compact_arrays(schema))
        file.write('\n')
    print(f"Generated {file_path} with {len(numeric)} codes")


def generate_alpha_all_schema(output_dir):
    schema = {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "title": "ISO 3166-1:2020 Alphabetic Country Code",
        "description": "A two-letter or three-letter alphabetic country code from ISO 3166-1",
        "examples": ["AF", "AFG", "US", "USA"],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
        "anyOf": [
            {"$ref": "alpha-2.json"},
            {"$ref": "alpha-3.json"}
        ]
    }

    file_path = os.path.join(output_dir, "alpha-all.json")
    with open(file_path, 'w') as file:
        file.write(format_json_compact_arrays(schema))
        file.write('\n')
    print(f"Generated {file_path}")




def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, "..", "..", ".."))

    all_file = os.path.join(project_root, "vendor", "iso3166", "all", "all.json")
    slim_2_file = os.path.join(project_root, "vendor", "iso3166", "slim-2", "slim-2.json")
    slim_3_file = os.path.join(project_root, "vendor", "iso3166", "slim-3", "slim-3.json")

    if not os.path.exists(all_file):
        print(f"Error: Data file not found: {all_file}", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(slim_2_file):
        print(f"Error: Data file not found: {slim_2_file}", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(slim_3_file):
        print(f"Error: Data file not found: {slim_3_file}", file=sys.stderr)
        sys.exit(1)

    output_dir = os.path.join(project_root, "schemas", "iso", "country", "2020")
    os.makedirs(output_dir, exist_ok=True)

    alpha_2, alpha_3, numeric = parse_countries(all_file, slim_2_file, slim_3_file)

    generate_alpha_2_schema(alpha_2, output_dir)
    generate_alpha_3_schema(alpha_3, output_dir)
    generate_numeric_schema(numeric, output_dir)
    generate_alpha_all_schema(output_dir)


if __name__ == "__main__":
    main()
