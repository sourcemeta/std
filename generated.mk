PYTHON ?= python3
MKDIRP ?= mkdir -p
JQ ?= jq

define MAKE_SCHEMA
schemas/$1.json: templates/schemas/$1.jq $2.json | node_modules
	$(MKDIRP) $$(dir $$@)
	$(JQ) --from-file $$< $$(word 2,$$^) > $$@
	$(NODE) $(JSONSCHEMA) fmt $$@
GENERATED += schemas/$1.json
endef

define MAKE_SCHEMA_UTR
schemas/2020-12/xbrl/utr/$1.json: templates/schemas/2020-12/xbrl/utr/item-type.jq build/xbrl/utr/utr.json templates/data/xbrl/utr-unit-iris.json | node_modules
	$(MKDIRP) $$(dir $$@)
	$(JQ) --from-file $$< --slurpfile unit_iris $$(word 3,$$^) --arg item_type $2 --arg normative $3 $$(word 2,$$^) > $$@
	$(NODE) $(JSONSCHEMA) fmt $$@
GENERATED += schemas/2020-12/xbrl/utr/$1.json
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

$(eval $(call MAKE_SCHEMA_UTR,area-item-type-normative,areaItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,area-item-type,areaItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,duration-item-type-normative,durationItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,duration-item-type,durationItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,electric-charge-item-type-normative,electricChargeItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,electric-charge-item-type,electricChargeItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,electric-current-item-type-normative,electricCurrentItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,electric-current-item-type,electricCurrentItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,energy-item-type-normative,energyItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,energy-item-type,energyItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,energy-per-monetary-item-type-normative,energyPerMonetaryItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,energy-per-monetary-item-type,energyPerMonetaryItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,flow-item-type-normative,flowItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,flow-item-type,flowItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,force-item-type-normative,forceItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,force-item-type,forceItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,frequency-item-type-normative,frequencyItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,frequency-item-type,frequencyItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,ghg-emissions-item-type-normative,ghgEmissionsItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,ghg-emissions-item-type,ghgEmissionsItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,ghg-emissions-per-monetary-item-type-normative,ghgEmissionsPerMonetaryItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,ghg-emissions-per-monetary-item-type,ghgEmissionsPerMonetaryItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,length-item-type-normative,lengthItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,length-item-type,lengthItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,mass-item-type-normative,massItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,mass-item-type,massItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,memory-item-type-normative,memoryItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,memory-item-type,memoryItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,monetary-item-type-normative,monetaryItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,monetary-item-type,monetaryItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,per-share-item-type-normative,perShareItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,per-share-item-type,perShareItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,per-unit-item-type-normative,perUnitItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,per-unit-item-type,perUnitItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,plane-angle-item-type-normative,planeAngleItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,plane-angle-item-type,planeAngleItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,power-item-type-normative,powerItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,power-item-type,powerItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,pressure-item-type-normative,pressureItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,pressure-item-type,pressureItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,pure-item-type-normative,pureItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,pure-item-type,pureItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,shares-item-type-normative,sharesItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,shares-item-type,sharesItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,temperature-item-type-normative,temperatureItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,temperature-item-type,temperatureItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,voltage-item-type-normative,voltageItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,voltage-item-type,voltageItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,volume-item-type-normative,volumeItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,volume-item-type,volumeItemType,false))
$(eval $(call MAKE_SCHEMA_UTR,volume-per-monetary-item-type-normative,volumePerMonetaryItemType,true))
$(eval $(call MAKE_SCHEMA_UTR,volume-per-monetary-item-type,volumePerMonetaryItemType,false))

$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/alpha-2,vendor/iso3166/all/all))
$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/alpha-3,vendor/iso3166/all/all))
$(eval $(call MAKE_SCHEMA,2020-12/iso/country/2020/numeric,vendor/iso3166/all/all))

build/iso/language/iso-639-2.json: \
	vendor/data/iso/language/ISO-639-2_utf-8.txt \
	scripts/csv2json.py
	$(PYTHON) $(word 2,$^) --delimiter '|' --encoding utf-8-sig --no-header \
		--field-names "part2b,part2t,part1,name,name_french" $< $@
build/iso/language/iso-639-3.json: \
	vendor/data/iso/language/iso-639-3.tab \
	scripts/csv2json.py
	$(PYTHON) $(word 2,$^) --tab $< $@
build/iso/language/iso-639-5.json: \
	vendor/data/iso/language/iso639-5.tsv \
	scripts/csv2json.py
	$(PYTHON) $(word 2,$^) --tab $< $@

build/iso/language/%.json: \
	build/iso/language/iso-639-2.json \
	build/iso/language/iso-639-3.json \
	build/iso/language/iso-639-5.json \
	templates/build/iso/language/%.jq
	$(JQ) --slurpfile iso2 $< --slurpfile iso3 $(word 2,$^) --slurpfile iso5 $(word 3,$^) -n -f $(word 4,$^) > $@

$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-1,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-2-bibliographic,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-2-terminologic,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-3,build/iso/language/enriched))
$(eval $(call MAKE_SCHEMA,2020-12/iso/language/2023/set-5,build/iso/language/enriched))
