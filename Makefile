JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
PYTHON ?= python3
CURL ?= curl
BSDTAR ?= bsdtar
TAR ?= tar
ZIP ?= zip
UNZIP ?= unzip
GZIP ?= gzip
MKDIRP ?= mkdir -p
RMRF ?= rm -rf

# TODO: Extend `validate` to take a directory as argument
SCHEMAS = $(shell find schemas/ -type f -name '*.json')
TESTS = $(shell find test/ -type f -name '*.json')

VERSION = $(shell tr -d '\n\r' < VERSION)

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test
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

# TODO: Make `jsonschema fmt` automatically detect test files
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
include generate/iso/country/include.mk
external: $(EXTERNAL)
generate: $(GENERATE)

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
