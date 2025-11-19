PYTHON ?= python3

define MAKE_SCHEMA
schemas/$1.json: templates/schemas/$1.jq $2.json
	$(MKDIRP) $$(dir $$@)
	$(JQ) --from-file $$< $$(word 2,$$^) > $$@
	$(JSONSCHEMA) fmt $$@
GENERATED += schemas/$1.json
endef

build/iso/currency/list-%.json: \
	scripts/xml2json.py \
	vendor/data/iso/currency/list-%.xml
	$(PYTHON) $< $(word 2,$^) $@

$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/historical/alpha-code,build/iso/currency/list-three))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/historical/alpha-currency,build/iso/currency/list-three))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/historical/numeric-code,build/iso/currency/list-three))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/historical/numeric-currency,build/iso/currency/list-three))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-code,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-currency,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-fund,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-precious-metal,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-test,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/alpha-unknown,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-code-additional,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-code,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-currency,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-fund,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-precious-metal,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-test,build/iso/currency/list-one))
$(eval $(call MAKE_SCHEMA,2020-12/iso/currency/2015/numeric-unknown,build/iso/currency/list-one))

build/xbrl/utr/%.json: scripts/xml2json.py vendor/data/xbrl/utr/%.xml
	$(PYTHON) $< $(word 2,$^) $@

$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/area-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/area-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/duration-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/duration-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/electric-charge-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/electric-charge-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/electric-current-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/electric-current-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/energy-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/energy-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/energy-per-monetary-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/energy-per-monetary-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/flow-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/flow-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/force-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/force-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/frequency-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/frequency-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/ghg-emissions-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/ghg-emissions-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/ghg-emissions-per-monetary-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/ghg-emissions-per-monetary-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/length-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/length-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/mass-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/mass-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/memory-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/memory-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/monetary-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/monetary-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/per-share-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/per-share-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/per-unit-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/per-unit-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/plane-angle-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/plane-angle-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/power-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/power-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/pressure-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/pressure-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/pure-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/pure-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/shares-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/shares-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/temperature-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/temperature-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/voltage-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/voltage-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/volume-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/volume-item-type,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/volume-per-monetary-item-type-normative,build/xbrl/utr/utr))
$(eval $(call MAKE_SCHEMA,2020-12/xbrl/utr/volume-per-monetary-item-type,build/xbrl/utr/utr))

$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/alpha-2,vendor/iso3166/all/all))
$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/alpha-3,vendor/iso3166/all/all))
$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/numeric,vendor/iso3166/all/all))

build/iso/language/iso-639-2.json: \
	vendor/data/iso/language/ISO-639-2_utf-8.txt \
	scripts/csv2json.py
	$(PYTHON) $(word 2,$^) --delimiter '|' --encoding utf-8-sig --no-header \
		--field-names "part2b,part2t,part1,name,name_french" $< $@
build/iso/language/iso-639-3.json: \
	vendor/data/iso/language/iso-639-3_Code_Tables/iso-639-3_Code_Tables_20251015/iso-639-3.tab \
	scripts/csv2json.py
	$(PYTHON) $(word 2,$^) --tab $< $@
build/iso/language/%.json: \
	build/iso/language/iso-639-2.json \
	build/iso/language/iso-639-3.json \
	templates/build/iso/language/%.jq
	$(JQ) --slurpfile iso2 $< --slurpfile iso3 $(word 2,$^) -n -f $(word 3,$^) > $@

$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-1,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-2-bibliographic,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-2-terminologic,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-3,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-5,build/iso/language/enriched))
