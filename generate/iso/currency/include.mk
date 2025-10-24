BASE_URL_SIX_GROUP_ISO_CURRENCY = https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency

.PHONY: external/iso/currency/list-one.xml
external/iso/currency/list-one.xml:
	$(CURL) --location --output $@ "$(BASE_URL_SIX_GROUP_ISO_CURRENCY)/lists/list-one.xml"

.PHONY: external/iso/currency/list-three.xml
external/iso/currency/list-three.xml:
	$(CURL) --location --output $@ "$(BASE_URL_SIX_GROUP_ISO_CURRENCY)/lists/list-three.xml"

external/iso/currency/list-%.json: scripts/xml2json.py external/iso/currency/list-%.xml
	$(PYTHON) $< $(word 2,$^) $@

external-iso-currency: \
	external/iso/currency/list-one.json \
	external/iso/currency/list-three.json \
	external/iso/currency/list-one.xml \
	external/iso/currency/list-three.xml

generate-iso-currency: generate/iso/currency/main.py
	$(PYTHON) $<

EXTERNAL += external-iso-currency
GENERATE += generate-iso-currency
