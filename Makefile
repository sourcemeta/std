JSONSCHEMA = jsonschema
SHELLCHECK = shellcheck

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find tests/ -type f -name '*.json')

all: common test
	$(JSONSCHEMA) fmt schemas tests conventions.json tests.json --verbose

common: .always
	$(JSONSCHEMA) metaschema schemas conventions.json tests.json --verbose
	$(JSONSCHEMA) lint schemas conventions.json tests.json --verbose
	$(JSONSCHEMA) validate conventions.json --verbose $(SCHEMAS)
	$(JSONSCHEMA) validate tests.json --verbose $(TESTS)
	$(SHELLCHECK) scripts/*.sh
	./scripts/schemas-tests-mirror.sh

lint: common
	$(JSONSCHEMA) fmt schemas tests conventions.json tests.json --verbose --check

test: .always
	$(JSONSCHEMA) test ./tests

.always:
