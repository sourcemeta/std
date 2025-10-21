JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
PYTHON ?= python3

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find test/ -type f -name '*.json')

all: common test
	$(JSONSCHEMA) fmt schemas test meta --verbose

.PHONY: common
common:
	$(JSONSCHEMA) metaschema schemas meta --verbose
	$(JSONSCHEMA) lint schemas meta --verbose
	$(JSONSCHEMA) validate meta/schemas.json --verbose $(SCHEMAS)
	$(JSONSCHEMA) validate meta/test.json --verbose $(TESTS)
	$(SHELLCHECK) scripts/*.sh
	./scripts/schemas-tests-mirror.sh

.PHONY: lint
lint: common
	$(JSONSCHEMA) fmt schemas test meta --verbose --check

.PHONY: test
test:
	$(JSONSCHEMA) test ./test

.PHONY: external
include generate/iso/currency/include.mk
external: $(EXTERNAL)
