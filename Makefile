JSONSCHEMA ?= jsonschema
SHELLCHECK ?= shellcheck
JQ ?= jq
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

GENERATED = \
	schemas/iso/currency/2015/alpha-code.json \
	schemas/iso/currency/2015/alpha-currency.json \
	schemas/iso/currency/2015/alpha-fund.json \
	schemas/iso/currency/2015/alpha-precious-metal.json \
	schemas/iso/currency/2015/alpha-test.json \
	schemas/iso/currency/2015/alpha-unknown.json \
	schemas/iso/currency/2015/numeric-code-additional.json \
	schemas/iso/currency/2015/numeric-code.json \
	schemas/iso/currency/2015/numeric-currency.json \
	schemas/iso/currency/2015/numeric-fund.json \
	schemas/iso/currency/2015/numeric-precious-metal.json \
	schemas/iso/currency/2015/numeric-test.json \
	schemas/iso/currency/2015/numeric-unknown.json \
	schemas/iso/currency/2015/historical/alpha-code.json \
	schemas/iso/currency/2015/historical/alpha-currency.json \
	schemas/iso/currency/2015/historical/numeric-code.json \
	schemas/iso/currency/2015/historical/numeric-currency.json

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test
	$(JSONSCHEMA) fmt schemas meta --verbose
	$(JSONSCHEMA) fmt test --verbose --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: common
common: $(GENERATED)
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
schemas/iso/currency/2015/historical/alpha-code.json: build/iso/currency/list-three.json templates/iso/currency/2015/historical/alpha-code.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/alpha-currency.json: build/iso/currency/list-three.json templates/iso/currency/2015/historical/alpha-currency.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/numeric-code.json: build/iso/currency/list-three.json templates/iso/currency/2015/historical/numeric-code.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/numeric-currency.json: build/iso/currency/list-three.json templates/iso/currency/2015/historical/numeric-currency.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/%.json: build/iso/currency/list-one.json templates/iso/currency/2015/%.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@

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
