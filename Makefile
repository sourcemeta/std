.DEFAULT_GOAL := all

JSONSCHEMA ?= ./node_modules/@sourcemeta/jsonschema/npm/cli.js
JQ ?= jq
SHELLCHECK ?= shellcheck
MKDIRP ?= mkdir -p
NODE ?= node
NPM ?= npm
TIME ?= time

include generated.mk

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test node_modules
	$(NODE) $(JSONSCHEMA) fmt schemas meta
	$(NODE) $(JSONSCHEMA) fmt test --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: common
common: $(GENERATED) node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) metaschema schemas meta
	$(TIME) $(NODE) $(JSONSCHEMA) lint schemas meta
	$(TIME) $(NODE) $(JSONSCHEMA) validate meta/schemas-root.json schemas
	$(TIME) $(NODE) $(JSONSCHEMA) validate meta/schemas.json schemas
	$(TIME) $(NODE) $(JSONSCHEMA) validate meta/test.json test
	$(SHELLCHECK) scripts/*.sh
	./scripts/quality-schemas-tests-mirror.sh
	./scripts/quality-templates-xbrl-utr-mirror.sh

# TODO: Make `jsonschema fmt` automatically detect test files
.PHONY: lint
lint: common node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) fmt schemas meta --check
	$(TIME) $(NODE) $(JSONSCHEMA) fmt test --check --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: test
test: node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) test ./test

node_modules: package.json package-lock.json
	$(NPM) ci
