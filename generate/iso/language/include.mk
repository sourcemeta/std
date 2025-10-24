# See https://standards.iso.org/iso/639/ed-2/en/Access%20to%20the%20databases%20of%20the%20ISO%20639%20Language%20Code.pdf
BASE_URL_LOC_GOV_ISO_639 = https://www.loc.gov/standards/iso639-2
BASE_URL_SIL_ISO_619 = https://iso639-3.sil.org/sites/iso639-3/files/downloads

# Covers Set 1, Set 2, and Set 5
.PHONY: external/iso/language/ISO-639-2_utf-8.txt
external/iso/language/ISO-639-2_utf-8.txt:
	$(CURL) --location --output $@ "$(BASE_URL_LOC_GOV_ISO_639)/ISO-639-2_utf-8"

# Covers Set 3
.PHONY: external/iso/language/iso-639-3_Code_Tables
external/iso/language/iso-639-3_Code_Tables:
	$(RMRF) $@
	$(MKDIRP) $@
	$(CURL) --location --output $@.zip "$(BASE_URL_SIL_ISO_619)/iso-639-3_Code_Tables_20251015.zip"
	$(BSDTAR) --strip-components=1 -xf $@.zip -C $@ --no-same-permissions
	$(RMRF) $@.zip

external-iso-language: \
	external/iso/language/ISO-639-2_utf-8.txt \
	external/iso/language/iso-639-3_Code_Tables

generate-iso-language: generate/iso/language/main.py
	$(PYTHON) $<

EXTERNAL += external-iso-language
GENERATE += generate-iso-language
