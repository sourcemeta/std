#!/bin/sh

set -o errexit
set -o nounset

TESTS_DIR="$(pwd)/test"
EXIT_CODE=0

for source_root in schemas examples
do
  SOURCE_DIR="$(pwd)/$source_root"

  find "$SOURCE_DIR" -type f -name "*.json" | while IFS= read -r source_file
  do
    relative_path="${source_file#"$SOURCE_DIR"/}"
    base_name="${relative_path%.json}"
    expected_test="$TESTS_DIR/$source_root/${base_name}.test.json"

    if [ ! -f "$expected_test" ]
    then
      echo "ERROR: Schema '$source_file' is missing corresponding test '$expected_test'" >&2
      exit 1
    fi
  done || EXIT_CODE=1

  find "$TESTS_DIR/$source_root" -type f -name "*.test.json" | while IFS= read -r test_file
  do
    relative_path="${test_file#"$TESTS_DIR/$source_root"/}"
    base_name="${relative_path%.test.json}"
    expected_source="$SOURCE_DIR/${base_name}.json"

    if [ ! -f "$expected_source" ]
    then
      echo "ERROR: Test '$test_file' is missing corresponding schema '$expected_source'" >&2
      exit 1
    fi
  done || EXIT_CODE=1
done

exit $EXIT_CODE
