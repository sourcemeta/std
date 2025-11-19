.DEFAULT_GOAL := all

JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
TAR ?= tar
ZIP ?= zip
UNZIP ?= unzip
GZIP ?= gzip
MKDIRP ?= mkdir -p
RMRF ?= rm -rf

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find test/ -type f -name '*.json')

# TODO: Add a version property to `jsonschema.json`
VERSION = $(shell tr -d '\n\r' < VERSION)

include generated.mk

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test
	$(JSONSCHEMA) fmt schemas meta
	$(JSONSCHEMA) fmt test --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: common
common: $(GENERATED)
	$(JSONSCHEMA) metaschema schemas meta
	$(JSONSCHEMA) lint schemas meta
	$(JSONSCHEMA) validate meta/schemas-root.json $(SCHEMAS)
	$(JSONSCHEMA) validate meta/schemas.json $(SCHEMAS)
	$(JSONSCHEMA) validate meta/test.json $(TESTS)
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

# TODO: Add a `jsonschema pkg` command instead
.PHONY: dist
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
