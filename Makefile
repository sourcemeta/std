.DEFAULT_GOAL := all

JSONSCHEMA ?= jsonschema
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

include generated.mk

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test
	$(JSONSCHEMA) fmt schemas meta
	$(JSONSCHEMA) fmt test --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: common
common: $(GENERATED)
	$(JSONSCHEMA) metaschema schemas meta
	$(JSONSCHEMA) lint schemas meta
	$(JSONSCHEMA) validate meta/schemas-root.json schemas
	$(JSONSCHEMA) validate meta/schemas.json schemas
	$(JSONSCHEMA) validate meta/test.json test
	$(SHELLCHECK) scripts/*.sh
	./scripts/quality-schemas-tests-mirror.sh
	./scripts/quality-templates-xbrl-utr-mirror.sh

# TODO: Make `jsonschema fmt` automatically detect test files
.PHONY: lint
lint: common
	$(JSONSCHEMA) fmt schemas meta --check
	$(JSONSCHEMA) fmt test --check --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: test
test:
	$(JSONSCHEMA) test ./test
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
