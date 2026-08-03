#!/bin/sh

set -o errexit
set -o nounset

SCHEMAS_DIR="$(pwd)/schemas"
TESTS_DIR="$(pwd)/test"
EXIT_CODE=0

find "$SCHEMAS_DIR" -type f -name "*.json" | while IFS= read -r schema_file
do
  relative_path="${schema_file#"$SCHEMAS_DIR"/}"
  base_name="${relative_path%.json}"
  expected_test="$TESTS_DIR/${base_name}.test.json"

  if [ ! -f "$expected_test" ]
  then
    echo "ERROR: Schema '$schema_file' is missing corresponding test '$expected_test'" >&2
    exit 1
  fi
done || EXIT_CODE=1

find "$TESTS_DIR" -type f -name "*.test.json" | while IFS= read -r test_file
do
  relative_path="${test_file#"$TESTS_DIR"/}"
  base_name="${relative_path%.test.json}"
  expected_schema="$SCHEMAS_DIR/${base_name}.json"

  if [ ! -f "$expected_schema" ]
  then
    echo "ERROR: Test '$test_file' is missing corresponding schema '$expected_schema'" >&2
    exit 1
  fi
done || EXIT_CODE=1

exit $EXIT_CODE
