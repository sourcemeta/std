BASE_URL_XBRL_2003 = http://www.xbrl.org/2003

.PHONY: external/xbrl/instance/2003/2003-12-13.xsd
external/xbrl/instance/2003/2003-12-13.xsd: scripts/fetch.py
	$(PYTHON) $< "$(BASE_URL_XBRL_2003)/xbrl-instance-2003-12-31.xsd" $@

build/xbrl/instance/2003/%.json: scripts/xml2json.py external/xbrl/instance/2003/%.xsd
	$(PYTHON) $< $(word 2,$^) $@

external-xbrl-instance-2003: generate/xbrl/instance/2003/main.py \
	build/xbrl/instance/2003/2003-12-13.json
	$(PYTHON) $<

EXTERNAL += external-xbrl-instance-2003
