import json
import os
import sys

def is_fund(entry):
    if "CcyNm" not in entry:
        return False
    currency_name = entry["CcyNm"]
    if isinstance(currency_name, dict):
        attributes = currency_name.get("@attributes", {})
        return attributes.get("IsFund") == "true"
    return False


def get_currency_name(entry):
    currency_name = entry.get("CcyNm", "")
    if isinstance(currency_name, dict):
        return currency_name.get("@text", "")
    return currency_name


def get_country_name(entry):
    return entry.get("CtryNm", "")


def get_minor_units(entry):
    minor_units = entry.get("CcyMnrUnts", "")
    if minor_units == "N.A.":
        return None
    try:
        return int(minor_units)
    except (ValueError, TypeError):
        return None


def get_withdrawal_date(entry):
    return entry.get("WthdrwlDt", "")


def generate_schemas(currency_entries, published_date, output_dir, is_historical=False):
    # Historical schemas go in historical/ subdirectory without suffix
    if is_historical:
        output_dir = os.path.join(output_dir, "historical")
        os.makedirs(output_dir, exist_ok=True)
    suffix = ""

    currency_alpha_codes = {}
    fund_alpha_codes = {}
    precious_metal_alpha_codes = {}
    currency_numeric_codes = {}
    fund_numeric_codes = {}
    precious_metal_numeric_codes = {}
    special_codes = {
        "XXX": "unknown",
        "XTS": "test"
    }
    precious_metals = {"XAU", "XAG", "XPT", "XPD"}

    for entry in currency_entries:
        if "Ccy" in entry and "CcyNbr" in entry:
            alpha_code = entry["Ccy"]
            numeric_code = int(entry["CcyNbr"])
            if isinstance(alpha_code, str) and len(alpha_code) == 3 and alpha_code.isupper():
                if alpha_code in special_codes:
                    continue
                name = get_currency_name(entry)
                country_name = get_country_name(entry)
                minor_units = get_minor_units(entry)
                withdrawal_date = get_withdrawal_date(entry) if is_historical else None

                metadata = {
                    "name": name,
                    "country": country_name,
                    "minor_units": minor_units,
                    "withdrawal_date": withdrawal_date
                }

                if alpha_code in precious_metals:
                    precious_metal_alpha_codes[alpha_code] = metadata
                    precious_metal_numeric_codes[numeric_code] = metadata
                elif is_fund(entry):
                    fund_alpha_codes[alpha_code] = metadata
                    fund_numeric_codes[numeric_code] = metadata
                else:
                    currency_alpha_codes[alpha_code] = metadata
                    currency_numeric_codes[numeric_code] = metadata

    all_alpha_codes = sorted(set(currency_alpha_codes.keys()) | set(fund_alpha_codes.keys()))
    all_numeric_codes = sorted(set(currency_numeric_codes.keys()) | set(fund_numeric_codes.keys()))

    # Build base schema fields
    def build_base_schema():
        base = {"$schema": "https://json-schema.org/draft/2020-12/schema"}
        if is_historical:
            base["deprecated"] = True
        return base

    # Build alpha-code schema references only for non-empty categories
    alpha_code_refs = []
    if len(currency_alpha_codes) > 0:
        alpha_code_refs.append({"$ref": f"alpha-currency{suffix}.json"})
    if len(fund_alpha_codes) > 0:
        alpha_code_refs.append({"$ref": f"alpha-fund{suffix}.json"})
    if len(precious_metal_alpha_codes) > 0:
        alpha_code_refs.append({"$ref": f"alpha-precious-metal{suffix}.json"})

    # Build examples from actual codes
    alpha_code_examples = []
    alpha_code_examples.extend(sorted(currency_alpha_codes.keys())[:4])
    alpha_code_examples.extend(sorted(fund_alpha_codes.keys())[:2])
    alpha_code_examples.extend(sorted(precious_metal_alpha_codes.keys())[:1])

    alpha_code_schema = build_base_schema()
    alpha_code_schema.update({
        "title": f"ISO 4217:2015 Alphabetic Currency, Fund, and Precious Metal Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-letter alphabetic code including {'withdrawn ' if is_historical else ''}currencies, funds, and precious metals ({published_date})",
        "examples": alpha_code_examples,
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": alpha_code_refs
    })

    alpha_currency_schema = build_base_schema()
    alpha_currency_schema.update({
        "title": f"ISO 4217:2015 Alphabetic Currency Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-letter alphabetic {'withdrawn ' if is_historical else ''}currency code, excluding funds and precious metals ({published_date})",
        "examples": sorted(currency_alpha_codes.keys())[:4],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                "x-country-name": metadata["country"],
                **({"x-minor-unit": metadata["minor_units"]} if not is_historical else {}),
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(currency_alpha_codes.items())
        ]
    })

    alpha_fund_schema = build_base_schema()
    alpha_fund_schema.update({
        "title": f"ISO 4217:2015 Alphabetic Fund Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-letter alphabetic {'withdrawn ' if is_historical else ''}fund code ({published_date})",
        "examples": sorted(fund_alpha_codes.keys())[:4],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                "x-country-name": metadata["country"],
                **({"x-minor-unit": metadata["minor_units"]} if not is_historical else {}),
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(fund_alpha_codes.items())
        ]
    })

    alpha_precious_metal_schema = build_base_schema()
    alpha_precious_metal_schema.update({
        "title": f"ISO 4217:2015 Alphabetic Precious Metal Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-letter alphabetic code for {'withdrawn ' if is_historical else ''}precious metals ({published_date})",
        "examples": ["XAU", "XAG", "XPT", "XPD"],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(precious_metal_alpha_codes.items())
        ]
    })

    # Build numeric-code schema references only for non-empty categories
    numeric_code_refs = []
    if len(currency_numeric_codes) > 0:
        numeric_code_refs.append({"$ref": f"numeric-currency{suffix}.json"})
    if len(fund_numeric_codes) > 0:
        numeric_code_refs.append({"$ref": f"numeric-fund{suffix}.json"})
    if len(precious_metal_numeric_codes) > 0:
        numeric_code_refs.append({"$ref": f"numeric-precious-metal{suffix}.json"})

    # Build examples from actual numeric codes
    numeric_code_examples = []
    numeric_code_examples.extend(sorted(currency_numeric_codes.keys())[:4])
    numeric_code_examples.extend(sorted(fund_numeric_codes.keys())[:1])
    numeric_code_examples.extend(sorted(precious_metal_numeric_codes.keys())[:1])

    numeric_code_schema = build_base_schema()
    numeric_code_schema.update({
        "title": f"ISO 4217:2015 Numeric Currency, Fund, and Precious Metal Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-digit numeric code including {'withdrawn ' if is_historical else ''}currencies, funds, and precious metals ({published_date})",
        "examples": numeric_code_examples,
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": numeric_code_refs
    })

    numeric_currency_schema = build_base_schema()
    numeric_currency_schema.update({
        "title": f"ISO 4217:2015 Numeric Currency Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-digit numeric {'withdrawn ' if is_historical else ''}currency code, excluding funds and precious metals ({published_date})",
        "examples": sorted(currency_numeric_codes.keys())[:4],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                "x-country-name": metadata["country"],
                **({"x-minor-unit": metadata["minor_units"]} if not is_historical else {}),
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(currency_numeric_codes.items())
        ]
    })

    numeric_fund_schema = build_base_schema()
    numeric_fund_schema.update({
        "title": f"ISO 4217:2015 Numeric Fund Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-digit numeric {'withdrawn ' if is_historical else ''}fund code ({published_date})",
        "examples": sorted(fund_numeric_codes.keys())[:4],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                "x-country-name": metadata["country"],
                **({"x-minor-unit": metadata["minor_units"]} if not is_historical else {}),
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(fund_numeric_codes.items())
        ]
    })

    numeric_precious_metal_schema = build_base_schema()
    numeric_precious_metal_schema.update({
        "title": f"ISO 4217:2015 Numeric Precious Metal Code{' (Historical)' if is_historical else ''}",
        "description": f"A three-digit numeric code for {'withdrawn ' if is_historical else ''}precious metals ({published_date})",
        "examples": [959, 961, 962, 964],
        "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
        "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
        "anyOf": [
            {
                "const": code,
                "title": metadata["name"],
                **({"x-withdrawal-date": metadata["withdrawal_date"]} if is_historical else {})
            }
            for code, metadata in sorted(precious_metal_numeric_codes.items())
        ]
    })

    os.makedirs(output_dir, exist_ok=True)

    files_to_write = [
        (os.path.join(output_dir, f"alpha-code{suffix}.json"), alpha_code_schema, len(all_alpha_codes), f"alphabetic codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"alpha-currency{suffix}.json"), alpha_currency_schema, len(currency_alpha_codes), f"alphabetic currency codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"alpha-fund{suffix}.json"), alpha_fund_schema, len(fund_alpha_codes), f"alphabetic fund codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"alpha-precious-metal{suffix}.json"), alpha_precious_metal_schema, len(precious_metal_alpha_codes), f"alphabetic precious metal codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"numeric-code{suffix}.json"), numeric_code_schema, len(all_numeric_codes), f"numeric codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"numeric-currency{suffix}.json"), numeric_currency_schema, len(currency_numeric_codes), f"numeric currency codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"numeric-fund{suffix}.json"), numeric_fund_schema, len(fund_numeric_codes), f"numeric fund codes{' (historical)' if is_historical else ''}"),
        (os.path.join(output_dir, f"numeric-precious-metal{suffix}.json"), numeric_precious_metal_schema, len(precious_metal_numeric_codes), f"numeric precious metal codes{' (historical)' if is_historical else ''}"),
    ]

    # Only write non-historical specific schemas for current data
    if not is_historical:
        numeric_code_additional_schema = {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "ISO 4217:2015 Numeric Additional Currency Code",
            "description": "User-assigned numeric codes in the range 900-998",
            "examples": [900, 950, 998],
            "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
            "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
            "type": "integer",
            "minimum": 900,
            "maximum": 998
        }

        alpha_unknown_schema = {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "ISO 4217:2015 Alphabetic Unknown Currency Code",
            "description": "The alphabetic code for transactions where no currency is involved",
            "examples": ["XXX"],
            "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
            "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
            "const": "XXX"
        }

        numeric_unknown_schema = {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "ISO 4217:2015 Numeric Unknown Currency Code",
            "description": "The numeric code for transactions where no currency is involved",
            "examples": [999],
            "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
            "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
            "const": 999
        }

        alpha_test_schema = {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "ISO 4217:2015 Alphabetic Test Currency Code",
            "description": "The alphabetic code specifically reserved for testing purposes",
            "examples": ["XTS"],
            "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
            "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
            "const": "XTS"
        }

        numeric_test_schema = {
            "$schema": "https://json-schema.org/draft/2020-12/schema",
            "title": "ISO 4217:2015 Numeric Test Currency Code",
            "description": "The numeric code specifically reserved for testing purposes",
            "examples": [963],
            "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
            "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
            "const": 963
        }

        files_to_write.extend([
            (os.path.join(output_dir, "alpha-unknown.json"), alpha_unknown_schema, 1, "alphabetic unknown code"),
            (os.path.join(output_dir, "alpha-test.json"), alpha_test_schema, 1, "alphabetic test code"),
            (os.path.join(output_dir, "numeric-code-additional.json"), numeric_code_additional_schema, 99, "numeric additional codes (900-998)"),
            (os.path.join(output_dir, "numeric-unknown.json"), numeric_unknown_schema, 1, "numeric unknown code"),
            (os.path.join(output_dir, "numeric-test.json"), numeric_test_schema, 1, "numeric test code"),
        ])

    for file_path, schema, count, description in files_to_write:
        # Skip generating schemas with empty anyOf arrays
        if "anyOf" in schema and len(schema["anyOf"]) == 0:
            print(f"Skipped {file_path} - no {description}")
            continue
        with open(file_path, "w") as file:
            json.dump(schema, file, indent=2)
            file.write("\n")
        print(f"Generated {file_path} with {count} {description}")


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(os.path.dirname(os.path.dirname(script_dir)))
    current_data_file = os.path.join(project_root, "external", "iso", "currency", "list-one.json")
    historical_data_file = os.path.join(project_root, "external", "iso", "currency", "list-three.json")
    output_dir = os.path.join(project_root, "schemas", "iso", "currency", "2015")

    # Generate current schemas
    if not os.path.exists(current_data_file):
        print(f"Error: Data file not found: {current_data_file}", file=sys.stderr)
        print("Run 'make fetch' first to download the ISO 4217 data", file=sys.stderr)
        sys.exit(1)

    with open(current_data_file, "r") as file:
        data = json.load(file)

    published_date = data["ISO_4217"]["@attributes"]["Pblshd"]
    currency_entries = data["ISO_4217"]["CcyTbl"]["CcyNtry"]

    generate_schemas(currency_entries, published_date, output_dir, is_historical=False)

    # Generate historical schemas
    if os.path.exists(historical_data_file):
        with open(historical_data_file, "r") as file:
            historical_data = json.load(file)

        historical_published_date = historical_data["ISO_4217"]["@attributes"]["Pblshd"]
        historical_currency_entries = historical_data["ISO_4217"]["HstrcCcyTbl"]["HstrcCcyNtry"]

        generate_schemas(historical_currency_entries, historical_published_date, output_dir, is_historical=True)
    else:
        print(f"Warning: Historical data file not found: {historical_data_file}", file=sys.stderr)
        print("Skipping historical schema generation", file=sys.stderr)


if __name__ == "__main__":
    main()
