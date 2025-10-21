BASE_URL_SIX_GROUP_ISO_CURRENCY = https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency

.PHONY: external/iso/currency/list-one.xml
external/iso/currency/list-one.xml: scripts/fetch.py
	$(PYTHON) $< "$(BASE_URL_SIX_GROUP_ISO_CURRENCY)/lists/list-one.xml" $@

.PHONY: external/iso/currency/list-three.xml
external/iso/currency/list-three.xml: scripts/fetch.py
	$(PYTHON) $< "$(BASE_URL_SIX_GROUP_ISO_CURRENCY)/lists/list-three.xml" $@

build/iso/currency/list-%.json: scripts/xml2json.py external/iso/currency/list-%.xml
	$(PYTHON) $< $(word 2,$^) $@

external-iso-currency: generate/iso/currency/main.py \
	build/iso/currency/list-one.json build/iso/currency/list-three.json
	$(PYTHON) $<

EXTERNAL += external-iso-currency
