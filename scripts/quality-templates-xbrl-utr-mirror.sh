#!/bin/sh

set -o errexit
set -o nounset

UTR_DATA="$(pwd)/build/xbrl/utr/utr.json"
TEMPLATES_DIR="$(pwd)/templates/schemas/xbrl/utr"
EXIT_CODE=0

# Create temporary directory
TMP="$(mktemp -d)"
# shellcheck disable=SC2329
clean() {
  # shellcheck disable=SC2317
  rm -rf "$TMP"
}
trap clean EXIT

camel_to_kebab() {
  echo "$1" | sed 's/\([A-Z]\)/-\1/g' | tr '[:upper:]' '[:lower:]' | sed 's/^-//'
}

if [ ! -f "$UTR_DATA" ]
then
  echo "ERROR: UTR data file '$UTR_DATA' does not exist" >&2
  exit 1
fi

# Extract all unique itemTypes from the data and convert to kebab-case
# Store them in the temp file first, then validate
jq -r '.["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"][] | .["{http://www.xbrl.org/2009/utr}itemType"]' "$UTR_DATA" | sort -u > "$TMP/item_types.txt"

while IFS= read -r item_type
do
  kebab_name=$(camel_to_kebab "$item_type")
  echo "$kebab_name" >> "$TMP/expected_templates.txt"

  # Check for regular template
  expected_template="$TEMPLATES_DIR/${kebab_name}.jq"
  if [ ! -f "$expected_template" ]
  then
    echo "ERROR: itemType '$item_type' is missing template '$expected_template'" >&2
    EXIT_CODE=1
  fi

  expected_normative="$TEMPLATES_DIR/${kebab_name}-normative.jq"
  if [ ! -f "$expected_normative" ]
  then
    echo "ERROR: itemType '$item_type' is missing normative template '$expected_normative'" >&2
    EXIT_CODE=1
  fi
done < "$TMP/item_types.txt"

# Check the reverse: for each template, verify it corresponds to a known itemType
find "$TEMPLATES_DIR" -type f -name "*.jq" ! -name "*-normative.jq" > "$TMP/templates.txt"

while IFS= read -r template_file
do
  base_name=$(basename "$template_file" .jq)

  # Check if this base name is in our expected list
  if ! grep -q "^${base_name}$" "$TMP/expected_templates.txt"
  then
    echo "ERROR: Template '$template_file' does not correspond to any itemType in the data" >&2
    EXIT_CODE=1
  fi

  # Also check that corresponding normative template exists
  normative_template="${template_file%.jq}-normative.jq"
  if [ ! -f "$normative_template" ]
  then
    echo "ERROR: Template '$template_file' is missing corresponding normative template '$normative_template'" >&2
    EXIT_CODE=1
  fi
done < "$TMP/templates.txt"

exit $EXIT_CODE
