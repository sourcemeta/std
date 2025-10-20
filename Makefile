JSONSCHEMA = jsonschema
SHELLCHECK = shellcheck
PYTHON = python3

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find test/ -type f -name '*.json')

all: common test
	$(JSONSCHEMA) fmt schemas test conventions.json tests.json --verbose

common: .always
	$(JSONSCHEMA) metaschema schemas conventions.json tests.json --verbose
	$(JSONSCHEMA) lint schemas conventions.json tests.json --verbose
	$(JSONSCHEMA) validate conventions.json --verbose $(SCHEMAS)
	$(JSONSCHEMA) validate tests.json --verbose $(TESTS)
	$(SHELLCHECK) scripts/*.sh
	./scripts/schemas-tests-mirror.sh

lint: common
	$(JSONSCHEMA) fmt schemas test conventions.json tests.json --verbose --check

test: .always
	$(JSONSCHEMA) test ./test

generate: .always
	$(PYTHON) scripts/generate-iso-currency.py

fetch: .always
	$(PYTHON) scripts/fetch-xml.py \
		"https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml" \
		> data/six-group-iso-currency.json
	$(PYTHON) scripts/fetch-xml.py \
		"https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-three.xml" \
		> data/six-group-iso-currency-historical.json


.always:
