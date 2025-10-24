BASE_URL_XBRL_FASB_US_GAAP = https://xbrl.fasb.org/us-gaap/2025

.PHONY: external/fasb/us-gaap/2025
external/fasb/us-gaap/2025:
	mkdir -p $@
	curl -L -o $@.zip $(BASE_URL_XBRL_FASB_US_GAAP)/us-gaap-2025.zip
	bsdtar --strip-components=1 -xf $@.zip -C $@ --no-same-permissions \
		'us-gaap-2025/elts/us-gaap-2025.xsd' \
		'us-gaap-2025/elts/us-gaap-doc-2025.xml' \
		'us-gaap-2025/elts/us-gaap-lab-2025.xml' \
		'us-gaap-2025/stm/us-gaap-stm-soi-cal-2025.xml' \
		'us-gaap-2025/stm/us-gaap-stm-soi-def-2025.xml'
	rm -f $@.zip
