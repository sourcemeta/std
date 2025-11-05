BASE_URL_XBRL_UTR = https://www.xbrl.org/utr

.PHONY: external/xbrl/utr/utr.xml
external/xbrl/utr/utr.xml:
	$(CURL) --location --output $@ "$(BASE_URL_XBRL_UTR)/utr.xml"

external/xbrl/utr/%.json: scripts/xml2json.py external/xbrl/utr/%.xml
	$(PYTHON) $< $(word 2,$^) $@

external-xbrl-utr: \
	external/xbrl/utr/utr.json \
	external/xbrl/utr/utr.xml

generate-xbrl-utr: generate/xbrl/utr/main.py
	$(PYTHON) $<

EXTERNAL += external-xbrl-utr
GENERATE += generate-xbrl-utr
