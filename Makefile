.DEFAULT_GOAL := all

JSONSCHEMA ?= ./node_modules/@sourcemeta/jsonschema/npm/cli.js
JQ ?= jq
SHELLCHECK ?= shellcheck
TAR ?= tar
ZIP ?= zip
UNZIP ?= unzip
GZIP ?= gzip
MKDIRP ?= mkdir -p
RMRF ?= rm -rf
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
	$(NODE) npm/cjs.test.js
	$(NODE) npm/esm.test.mjs

# TODO: Add a `jsonschema pkg` command instead
.PHONY: dist
VERSION = $(shell $(JQ) --raw-output '.["x-version"]' jsonschema.json)
dist:
	$(RMRF) $@
	$(MKDIRP) $@
	cd schemas && $(ZIP) -r ../$@/sourcemeta-std-v$(VERSION).zip * -x '*.DS_Store'
	$(ZIP) $@/sourcemeta-std-v$(VERSION).zip LICENSE
	$(UNZIP) -l $@/sourcemeta-std-v$(VERSION).zip
	cd schemas && $(TAR) -cf ../$@/sourcemeta-std-v$(VERSION).tar --exclude '.DS_Store' *
	$(TAR) -rf $@/sourcemeta-std-v$(VERSION).tar LICENSE
	$(GZIP) $@/sourcemeta-std-v$(VERSION).tar
	$(TAR) -tzf $@/sourcemeta-std-v$(VERSION).tar.gz
	$(MKDIRP) $@/npm
	$(NPM) version --no-git-tag-version --allow-same-version "$(VERSION)"
	$(NPM) pack --pack-destination $@/npm

node_modules: package.json package-lock.json
	$(NPM) ci
