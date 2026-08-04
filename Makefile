.DEFAULT_GOAL := all

JSONSCHEMA ?= ./node_modules/@sourcemeta/jsonschema/npm/cli.js
SHELLCHECK ?= shellcheck
NODE ?= node
NPM ?= npm
TIME ?= time

include generated.mk

all: common test node_modules
	$(NODE) $(JSONSCHEMA) fmt schemas examples rules test

.PHONY: common
common: $(GENERATED) node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) metaschema schemas examples rules
	$(TIME) $(NODE) $(JSONSCHEMA) lint schemas examples
	$(SHELLCHECK) scripts/*.sh
	./scripts/quality-schemas-tests-mirror.sh
	JQ="$(JQ)" ./scripts/quality-templates-xbrl-utr-mirror.sh
	JQ="$(JQ)" ./scripts/quality-data-xbrl-utr-iris.sh

.PHONY: lint
lint: common node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) fmt schemas examples rules test --check

.PHONY: test
test: common node_modules
	$(TIME) $(NODE) $(JSONSCHEMA) test ./test

.PHONY: clean
clean:
	rm -rf build

node_modules: package.json package-lock.json
	$(NPM) ci
