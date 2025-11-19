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
	schemas/iso/currency/2015/historical/numeric-currency.json \
	schemas/xbrl/utr/area-item-type-normative.json \
	schemas/xbrl/utr/area-item-type.json \
	schemas/xbrl/utr/duration-item-type-normative.json \
	schemas/xbrl/utr/duration-item-type.json \
	schemas/xbrl/utr/electric-charge-item-type-normative.json \
	schemas/xbrl/utr/electric-charge-item-type.json \
	schemas/xbrl/utr/electric-current-item-type-normative.json \
	schemas/xbrl/utr/electric-current-item-type.json \
	schemas/xbrl/utr/energy-item-type-normative.json \
	schemas/xbrl/utr/energy-item-type.json \
	schemas/xbrl/utr/energy-per-monetary-item-type-normative.json \
	schemas/xbrl/utr/energy-per-monetary-item-type.json \
	schemas/xbrl/utr/flow-item-type-normative.json \
	schemas/xbrl/utr/flow-item-type.json \
	schemas/xbrl/utr/force-item-type-normative.json \
	schemas/xbrl/utr/force-item-type.json \
	schemas/xbrl/utr/frequency-item-type-normative.json \
	schemas/xbrl/utr/frequency-item-type.json \
	schemas/xbrl/utr/ghg-emissions-item-type-normative.json \
	schemas/xbrl/utr/ghg-emissions-item-type.json \
	schemas/xbrl/utr/ghg-emissions-per-monetary-item-type-normative.json \
	schemas/xbrl/utr/ghg-emissions-per-monetary-item-type.json \
	schemas/xbrl/utr/length-item-type-normative.json \
	schemas/xbrl/utr/length-item-type.json \
	schemas/xbrl/utr/mass-item-type-normative.json \
	schemas/xbrl/utr/mass-item-type.json \
	schemas/xbrl/utr/memory-item-type-normative.json \
	schemas/xbrl/utr/memory-item-type.json \
	schemas/xbrl/utr/monetary-item-type-normative.json \
	schemas/xbrl/utr/monetary-item-type.json \
	schemas/xbrl/utr/per-share-item-type-normative.json \
	schemas/xbrl/utr/per-share-item-type.json \
	schemas/xbrl/utr/per-unit-item-type-normative.json \
	schemas/xbrl/utr/per-unit-item-type.json \
	schemas/xbrl/utr/plane-angle-item-type-normative.json \
	schemas/xbrl/utr/plane-angle-item-type.json \
	schemas/xbrl/utr/power-item-type-normative.json \
	schemas/xbrl/utr/power-item-type.json \
	schemas/xbrl/utr/pressure-item-type-normative.json \
	schemas/xbrl/utr/pressure-item-type.json \
	schemas/xbrl/utr/pure-item-type-normative.json \
	schemas/xbrl/utr/pure-item-type.json \
	schemas/xbrl/utr/shares-item-type-normative.json \
	schemas/xbrl/utr/shares-item-type.json \
	schemas/xbrl/utr/temperature-item-type-normative.json \
	schemas/xbrl/utr/temperature-item-type.json \
	schemas/xbrl/utr/voltage-item-type-normative.json \
	schemas/xbrl/utr/voltage-item-type.json \
	schemas/xbrl/utr/volume-item-type-normative.json \
	schemas/xbrl/utr/volume-item-type.json \
	schemas/xbrl/utr/volume-per-monetary-item-type-normative.json \
	schemas/xbrl/utr/volume-per-monetary-item-type.json \
	schemas/iso/country/2020/alpha-2.json \
	schemas/iso/country/2020/alpha-3.json \
	schemas/iso/country/2020/numeric.json

# TODO: Make `jsonschema fmt` automatically detect test files
all: common test
	$(JSONSCHEMA) fmt schemas meta --verbose
	$(JSONSCHEMA) fmt test --verbose --default-dialect "https://json-schema.org/draft/2020-12/schema"

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
	$(JSONSCHEMA) fmt test --default-dialect "https://json-schema.org/draft/2020-12/schema"

.PHONY: test
test:
	$(JSONSCHEMA) test ./test

build/iso/currency/list-%.json: \
	scripts/xml2json.py \
	vendor/data/iso/currency/list-%.xml
	$(PYTHON) $< $(word 2,$^) $@
schemas/iso/currency/2015/historical/alpha-code.json: \
	build/iso/currency/list-three.json \
	templates/iso/currency/2015/historical/alpha-code.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/alpha-currency.json: \
	build/iso/currency/list-three.json \
	templates/iso/currency/2015/historical/alpha-currency.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/numeric-code.json: \
	build/iso/currency/list-three.json \
	templates/iso/currency/2015/historical/numeric-code.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/historical/numeric-currency.json: \
	build/iso/currency/list-three.json \
	templates/iso/currency/2015/historical/numeric-currency.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@
schemas/iso/currency/2015/%.json: \
	build/iso/currency/list-one.json \
	templates/iso/currency/2015/%.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@

build/xbrl/utr/%.json: scripts/xml2json.py vendor/data/xbrl/utr/%.xml
	$(MKDIRP) $(dir $@)
	$(PYTHON) $< $(word 2,$^) $@
schemas/xbrl/utr/%.json: build/xbrl/utr/utr.json templates/xbrl/utr/%.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@

schemas/iso/country/2020/%.json: \
	vendor/iso3166/all/all.json \
	templates/iso/country/2020/%.jq
	$(MKDIRP) $(dir $@)
	$(JQ) --from-file $(word 2,$^) $< > $@
	$(JSONSCHEMA) fmt $@


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
