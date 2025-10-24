JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
PYTHON ?= python3
CURL ?= curl
BSDTAR ?= bsdtar
MKDIRP ?= mkdir -p
RMRF ?= rm -rf

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find test/ -type f -name '*.json')

all: generate common test
	$(JSONSCHEMA) fmt schemas meta --verbose
	$(JSONSCHEMA) fmt test --verbose --default-dialect "https://json-schema.org/draft/2020-12/schema"

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
	$(JSONSCHEMA) fmt schemas meta --verbose --check
	$(JSONSCHEMA) fmt test --verbose --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: test
test:
	$(JSONSCHEMA) test ./test

.PHONY: external
include generate/iso/currency/include.mk
include generate/iso/language/include.mk
external: $(EXTERNAL)
generate: $(GENERATE)
