#!/bin/sh

set -o errexit
set -o nounset

UTR_DATA="$(pwd)/build/xbrl/utr/utr.json"
GENERATED_MK="$(pwd)/generated.mk"
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

# Extract all unique itemTypes from the data
"${JQ:-jq}" -r '.["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"][] | .["{http://www.xbrl.org/2009/utr}itemType"]' "$UTR_DATA" | sort -u > "$TMP/item_types.txt"

# Every itemType in the registry data must have its pair of generation
# rules, and every generation rule must correspond to a registry itemType
while read -r item_type
do
  kebab_name="$(camel_to_kebab "$item_type")"
  if ! grep -q "call MAKE_SCHEMA_UTR,$kebab_name,$item_type,false" "$GENERATED_MK"
  then
    echo "ERROR: Missing generation rule for item type '$item_type'" >&2
    EXIT_CODE=1
  fi
  if ! grep -q "call MAKE_SCHEMA_UTR,$kebab_name-normative,$item_type,true" "$GENERATED_MK"
  then
    echo "ERROR: Missing normative generation rule for item type '$item_type'" >&2
    EXIT_CODE=1
  fi
done < "$TMP/item_types.txt"

sed -n 's/.*call MAKE_SCHEMA_UTR,[a-z0-9-]*,\([a-zA-Z0-9]*\),.*/\1/p' "$GENERATED_MK" | sort -u > "$TMP/rule_item_types.txt"

while read -r item_type
do
  if ! grep -qx "$item_type" "$TMP/item_types.txt"
  then
    echo "ERROR: Generation rule for item type '$item_type' has no registry entry" >&2
    EXIT_CODE=1
  fi
done < "$TMP/rule_item_types.txt"

exit "$EXIT_CODE"
