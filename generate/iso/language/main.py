import json
import os
import sys
import csv


def parse_iso_639_2(file_path, set_3_lookup_by_part1, set_3_lookup_by_part2b, set_3_lookup_by_part2t):
    """Parse ISO-639-2 file which contains Set 1, Set 2, and Set 5."""
    set_1 = {}
    set_2_bibliographic = {}
    set_2_terminologic = {}
    set_5 = {}

    with open(file_path, 'r', encoding='utf-8-sig') as file:
        for line in file:
            line = line.strip()
            if not line:
                continue

            parts = line.split('|')
            if len(parts) < 5:
                continue

            part2b = parts[0].strip()
            part2t = parts[1].strip()
            part1 = parts[2].strip()
            english_name = parts[3].strip()
            french_name = parts[4].strip()

            # Determine if this is Set 5 (language families/groups)
            is_language_family = 'languages' in english_name.lower() or 'language family' in english_name.lower()

            # Set 5 entries
            if is_language_family and part2b:
                set_5[part2b] = {
                    'name': english_name,
                    'name_french': french_name
                }
            else:
                # Set 1 entries
                if part1:
                    set_3_data = set_3_lookup_by_part1.get(part1, {})
                    set_1[part1] = {
                        'name': english_name,
                        'name_french': french_name,
                        'part2b': part2b if part2b else None,
                        'part2t': part2t if part2t else None,
                        'scope': set_3_data.get('scope'),
                        'language_type': set_3_data.get('language_type')
                    }

                # Set 2 entries
                if part2b:
                    set_3_data = set_3_lookup_by_part2b.get(part2b, {})
                    set_2_bibliographic[part2b] = {
                        'name': english_name,
                        'name_french': french_name,
                        'part1': part1 if part1 else None,
                        'scope': set_3_data.get('scope'),
                        'language_type': set_3_data.get('language_type')
                    }

                if part2t:
                    set_3_data = set_3_lookup_by_part2t.get(part2t, {})
                    set_2_terminologic[part2t] = {
                        'name': english_name,
                        'name_french': french_name,
                        'part1': part1 if part1 else None,
                        'scope': set_3_data.get('scope'),
                        'language_type': set_3_data.get('language_type')
                    }

    return set_1, set_2_bibliographic, set_2_terminologic, set_5


def parse_iso_639_3(file_path):
    """Parse ISO-639-3 file which contains Set 3."""
    set_3 = {}

    with open(file_path, 'r', encoding='utf-8') as file:
        reader = csv.DictReader(file, delimiter='\t')
        for row in reader:
            code = row['Id'].strip()
            if not code:
                continue

            metadata = {
                'name': row['Ref_Name'].strip(),
                'scope': row['Scope'].strip() if row['Scope'].strip() else None,
                'language_type': row['Language_Type'].strip() if row['Language_Type'].strip() else None,
                'part2b': row['Part2b'].strip() if row['Part2b'].strip() else None,
                'part2t': row['Part2t'].strip() if row['Part2t'].strip() else None,
                'part1': row['Part1'].strip() if row['Part1'].strip() else None,
                'comment': row['Comment'].strip() if row['Comment'].strip() else None
            }

            set_3[code] = metadata

    return set_3


def build_set_3_lookups(set_3):
    """Build lookup tables from Set 3 by Part1, Part2b, and Part2t codes."""
    lookup_by_part1 = {}
    lookup_by_part2b = {}
    lookup_by_part2t = {}

    for code, metadata in set_3.items():
        if metadata.get('part1'):
            lookup_by_part1[metadata['part1']] = {
                'scope': metadata['scope'],
                'language_type': metadata['language_type']
            }
        if metadata.get('part2b'):
            lookup_by_part2b[metadata['part2b']] = {
                'scope': metadata['scope'],
                'language_type': metadata['language_type']
            }
        if metadata.get('part2t'):
            lookup_by_part2t[metadata['part2t']] = {
                'scope': metadata['scope'],
                'language_type': metadata['language_type']
            }

    return lookup_by_part1, lookup_by_part2b, lookup_by_part2t


def expand_scope(scope_code):
    """Expand scope code to full word."""
    if not scope_code:
        return None

    scope_map = {
        'I': 'individual',
        'M': 'macrolanguage',
        'S': 'special'
    }

    if scope_code not in scope_map:
        print(f"Error: Unknown scope code '{scope_code}'", file=sys.stderr)
        sys.exit(1)

    return scope_map[scope_code]


def expand_language_type(type_code):
    """Expand language type code to full word."""
    if not type_code:
        return None

    type_map = {
        'L': 'living',
        'E': 'extinct',
        'H': 'historic',
        'C': 'constructed',
        'S': 'special',
        'A': 'ancient'
    }

    if type_code not in type_map:
        print(f"Error: Unknown language type code '{type_code}'", file=sys.stderr)
        sys.exit(1)

    return type_map[type_code]


def build_base_schema():
    """Build base schema with required fields."""
    return {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/standard/74575.html"]
    }


def generate_set_1_schema(set_1, output_dir):
    """Generate schema for ISO 639-1 (2-letter codes)."""
    schema = build_base_schema()
    schema.update({
        "$comment": "Set 1 contains the most common languages (2-letter codes). All Set 1 codes have corresponding codes in Set 2 and Set 3",
        "title": "ISO 639-1:2023 Language Code",
        "description": "A two-letter language code from ISO 639-1",
        "examples": sorted(set_1.keys())[:4],
        "anyOf": [
            {
                "const": code,
                "title": metadata['name'],
                **({'x-scope': expand_scope(metadata['scope'])} if metadata.get('scope') else {}),
                **({'x-language-type': expand_language_type(metadata['language_type'])} if metadata.get('language_type') else {}),
                **({'x-name-french': metadata['name_french']} if metadata.get('name_french') else {}),
                **({'x-set-2-bibliographic': metadata['part2b']} if metadata.get('part2b') else {}),
                **({'x-set-2-terminologic': metadata['part2t']} if metadata.get('part2t') else {})
            }
            for code, metadata in sorted(set_1.items())
        ]
    })

    file_path = os.path.join(output_dir, "set-1.json")
    with open(file_path, 'w') as file:
        json.dump(schema, file, indent=2)
        file.write('\n')
    print(f"Generated {file_path} with {len(set_1)} codes")


def generate_set_2_bibliographic_schema(set_2_bibliographic, output_dir):
    """Generate schema for ISO 639-2 bibliographic codes."""
    schema = build_base_schema()
    schema.update({
        "$comment": "Set 2 bibliographic is a superset of Set 1 and a subset of Set 3. Bibliographic codes are based on English language names",
        "title": "ISO 639-2:2023 Bibliographic Language Code",
        "description": "A three-letter bibliographic language code from ISO 639-2",
        "examples": sorted(set_2_bibliographic.keys())[:4],
        "anyOf": [
            {
                "const": code,
                "title": metadata['name'],
                **({'x-scope': expand_scope(metadata['scope'])} if metadata.get('scope') else {}),
                **({'x-language-type': expand_language_type(metadata['language_type'])} if metadata.get('language_type') else {}),
                **({'x-name-french': metadata['name_french']} if metadata.get('name_french') else {}),
                **({'x-set-1': metadata['part1']} if metadata.get('part1') else {})
            }
            for code, metadata in sorted(set_2_bibliographic.items())
        ]
    })

    file_path = os.path.join(output_dir, "set-2-bibliographic.json")
    with open(file_path, 'w') as file:
        json.dump(schema, file, indent=2)
        file.write('\n')
    print(f"Generated {file_path} with {len(set_2_bibliographic)} codes")


def generate_set_2_terminologic_schema(set_2_terminologic, output_dir):
    """Generate schema for ISO 639-2 terminologic codes."""
    schema = build_base_schema()
    schema.update({
        "$comment": "Set 2 terminologic is a superset of Set 1 and a subset of Set 3. Terminologic codes are based on native language names. Only about 20 languages have both bibliographic and terminologic codes",
        "title": "ISO 639-2:2023 Terminologic Language Code",
        "description": "A three-letter terminologic language code from ISO 639-2",
        "examples": sorted(set_2_terminologic.keys())[:4],
        "anyOf": [
            {
                "const": code,
                "title": metadata['name'],
                **({'x-scope': expand_scope(metadata['scope'])} if metadata.get('scope') else {}),
                **({'x-language-type': expand_language_type(metadata['language_type'])} if metadata.get('language_type') else {}),
                **({'x-name-french': metadata['name_french']} if metadata.get('name_french') else {}),
                **({'x-set-1': metadata['part1']} if metadata.get('part1') else {})
            }
            for code, metadata in sorted(set_2_terminologic.items())
        ]
    })

    file_path = os.path.join(output_dir, "set-2-terminologic.json")
    with open(file_path, 'w') as file:
        json.dump(schema, file, indent=2)
        file.write('\n')
    print(f"Generated {file_path} with {len(set_2_terminologic)} codes")


def generate_set_3_schema(set_3, output_dir):
    """Generate schema for ISO 639-3 (comprehensive language codes)."""
    schema = build_base_schema()
    schema.update({
        "$comment": "Set 3 is a superset of Set 1 and Set 2. It provides comprehensive coverage of individual languages, macrolanguages, and special codes",
        "title": "ISO 639-3:2023 Language Code",
        "description": "A three-letter language code from ISO 639-3",
        "examples": sorted(set_3.keys())[:4],
        "anyOf": [
            {
                "const": code,
                "title": metadata['name'],
                **({'x-scope': expand_scope(metadata['scope'])} if metadata.get('scope') else {}),
                **({'x-language-type': expand_language_type(metadata['language_type'])} if metadata.get('language_type') else {}),
                **({'x-set-2-bibliographic': metadata['part2b']} if metadata.get('part2b') else {}),
                **({'x-set-2-terminologic': metadata['part2t']} if metadata.get('part2t') else {}),
                **({'x-set-1': metadata['part1']} if metadata.get('part1') else {}),
                **({'$comment': metadata['comment']} if metadata.get('comment') else {})
            }
            for code, metadata in sorted(set_3.items())
        ]
    })

    file_path = os.path.join(output_dir, "set-3.json")
    with open(file_path, 'w') as file:
        json.dump(schema, file, indent=2)
        file.write('\n')
    print(f"Generated {file_path} with {len(set_3)} codes")


def generate_set_5_schema(set_5, output_dir):
    """Generate schema for ISO 639-5 (language families and groups)."""
    schema = build_base_schema()
    schema.update({
        "$comment": "Set 5 codes language families and groups, not individual languages. It is independent from Sets 1-3",
        "title": "ISO 639-5:2023 Language Family Code",
        "description": "A three-letter code for language families and groups from ISO 639-5",
        "examples": sorted(set_5.keys())[:4],
        "anyOf": [
            {
                "const": code,
                "title": metadata['name'],
                **({'x-name-french': metadata['name_french']} if metadata.get('name_french') else {})
            }
            for code, metadata in sorted(set_5.items())
        ]
    })

    file_path = os.path.join(output_dir, "set-5.json")
    with open(file_path, 'w') as file:
        json.dump(schema, file, indent=2)
        file.write('\n')
    print(f"Generated {file_path} with {len(set_5)} codes")


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(script_dir)))

    iso_639_2_file = os.path.join(project_root, "external", "iso", "language", "ISO-639-2_utf-8.txt")
    iso_639_3_file = os.path.join(project_root, "external", "iso", "language", "iso-639-3_Code_Tables", "iso-639-3.tab")
    output_dir = os.path.join(project_root, "schemas", "iso", "language", "2023")

    if not os.path.exists(iso_639_2_file):
        print(f"Error: Data file not found: {iso_639_2_file}", file=sys.stderr)
        print("Run 'make external-iso-language' first to download the ISO 639 data", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(iso_639_3_file):
        print(f"Error: Data file not found: {iso_639_3_file}", file=sys.stderr)
        print("Run 'make external-iso-language' first to download the ISO 639 data", file=sys.stderr)
        sys.exit(1)

    # Parse Set 3 first to build lookup tables
    print("Parsing ISO 639-3 data...")
    set_3 = parse_iso_639_3(iso_639_3_file)

    print("Building Set 3 lookup tables...")
    lookup_by_part1, lookup_by_part2b, lookup_by_part2t = build_set_3_lookups(set_3)

    # Parse ISO 639-2 data with Set 3 lookups
    print("Parsing ISO 639-2 data...")
    set_1, set_2_bibliographic, set_2_terminologic, set_5 = parse_iso_639_2(
        iso_639_2_file, lookup_by_part1, lookup_by_part2b, lookup_by_part2t
    )

    # Create output directory
    os.makedirs(output_dir, exist_ok=True)

    # Generate schemas
    print("Generating schemas...")
    generate_set_1_schema(set_1, output_dir)
    generate_set_2_bibliographic_schema(set_2_bibliographic, output_dir)
    generate_set_2_terminologic_schema(set_2_terminologic, output_dir)
    generate_set_3_schema(set_3, output_dir)
    generate_set_5_schema(set_5, output_dir)

    print("Done!")


if __name__ == "__main__":
    main()
