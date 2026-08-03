#!/bin/sh

set -o errexit
set -o nounset

UTR_DATA="$(pwd)/build/xbrl/utr/utr.json"
IRIS="$(pwd)/templates/data/xbrl/utr-unit-iris.json"
EXCLUSIONS="$(pwd)/templates/data/xbrl/utr-unit-iris-exclusions.json"
EXIT_CODE=0

# Create temporary directory
TMP="$(mktemp -d)"
# shellcheck disable=SC2329
clean() {
  # shellcheck disable=SC2317
  rm -rf "$TMP"
}
trap clean EXIT

if [ ! -f "$UTR_DATA" ]
then
  echo "ERROR: UTR data file '$UTR_DATA' does not exist" >&2
  exit 1
fi

# The registry units in the namespaces that the templates map to authority
# identities. Every one of them must either have a verified IRI or an
# explicit exclusion, so that a registry refresh forces a decision
"${JQ:-jq}" -r '.["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"][] | select(.["{http://www.xbrl.org/2009/utr}nsUnit"] | IN("http://www.xbrl.org/2009/utr", "http://www.xbrl.org/2003/instance")) | .["{http://www.xbrl.org/2009/utr}unitId"]' "$UTR_DATA" | sort -u > "$TMP/eligible.txt"
"${JQ:-jq}" -r 'keys[]' "$IRIS" | sort -u > "$TMP/mapped.txt"
"${JQ:-jq}" -r 'keys[]' "$EXCLUSIONS" | sort -u > "$TMP/excluded.txt"

sort "$TMP/mapped.txt" "$TMP/excluded.txt" > "$TMP/decided.txt"

comm -23 "$TMP/eligible.txt" "$TMP/decided.txt" > "$TMP/undecided.txt"
while read -r unit_id
do
  echo "ERROR: Unit '$unit_id' has neither a verified IRI nor an exclusion" >&2
  EXIT_CODE=1
done < "$TMP/undecided.txt"

comm -12 "$TMP/mapped.txt" "$TMP/excluded.txt" > "$TMP/overlap.txt"
while read -r unit_id
do
  echo "ERROR: Unit '$unit_id' is both mapped and excluded" >&2
  EXIT_CODE=1
done < "$TMP/overlap.txt"

comm -23 "$TMP/mapped.txt" "$TMP/eligible.txt" > "$TMP/stale-mapped.txt"
while read -r unit_id
do
  echo "ERROR: Mapped unit '$unit_id' is not in the registry" >&2
  EXIT_CODE=1
done < "$TMP/stale-mapped.txt"

comm -23 "$TMP/excluded.txt" "$TMP/eligible.txt" > "$TMP/stale-excluded.txt"
while read -r unit_id
do
  echo "ERROR: Excluded unit '$unit_id' is not in the registry" >&2
  EXIT_CODE=1
done < "$TMP/stale-excluded.txt"

exit "$EXIT_CODE"
