.DEFAULT_GOAL := all

JSONSCHEMA ?= ./node_modules/@sourcemeta/jsonschema/npm/cli.js
SHELLCHECK ?= shellcheck
NODE ?= node
NPM ?= npm
TIME ?= time

include generated.mk

all: common test node_modules
	$(NODE) $(JSONSCHEMA) fmt schemas meta rules test

.PHONY: common
common: $(GENERATED) node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) metaschema schemas meta rules
	$(TIME) $(NODE) $(JSONSCHEMA) lint schemas meta
	$(TIME) $(NODE) $(JSONSCHEMA) validate meta/schemas-root.json schemas
	$(SHELLCHECK) scripts/*.sh
	./scripts/quality-schemas-tests-mirror.sh
	./scripts/quality-templates-xbrl-utr-mirror.sh

.PHONY: lint
lint: common node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) fmt schemas meta rules test --check

.PHONY: test
test: node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) test ./test

node_modules: package.json package-lock.json
	$(NPM) ci
