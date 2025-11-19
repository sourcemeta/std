JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
PYTHON ?= python3
CURL ?= curl
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
	$(JSONSCHEMA) validate meta/schemas-root.json --verbose $(SCHEMAS)
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

build/iso/currency/list-%.json: scripts/xml2json.py vendor/data/iso/currency/list-%.xml
	$(PYTHON) $< $(word 2,$^) $@
generate-iso-currency: generate/iso/currency/main.py \
	build/iso/currency/list-one.json \
	build/iso/currency/list-three.json
	$(PYTHON) $<
generate-iso-language: generate/iso/language/main.py
	$(PYTHON) $<
generate-iso-country: generate/iso/country/main.py
	$(PYTHON) $<
build/xbrl/utr/%.json: scripts/xml2json.py vendor/data/xbrl/utr/%.xml
	$(PYTHON) $< $(word 2,$^) $@
generate-xbrl-utr: generate/xbrl/utr/main.py build/xbrl/utr/utr.json
	$(PYTHON) $<

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
