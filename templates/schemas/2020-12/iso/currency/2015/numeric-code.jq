{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Numeric Currency, Fund, and Precious Metal Code",
  "description": ("A three-digit numeric code including currencies, funds, and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    [
      (.ISO_4217.CcyTbl.CcyNtry | map(select(.Ccy != null and .CcyNbr != null and (.CcyNm | type == "string") and (.Ccy | IN("XAU", "XPD", "XPT", "XAG", "XTS", "XXX") | not))) | group_by(.CcyNbr) | sort_by(.[0].CcyNbr | tonumber) | .[0:4] | map(.[0].CcyNbr | tonumber)),
      (.ISO_4217.CcyTbl.CcyNtry | map(select(.Ccy != null and .CcyNbr != null and (.CcyNm | type == "object") and (.CcyNm."@attributes".IsFund == "true"))) | group_by(.CcyNbr) | sort_by(.[0].CcyNbr | tonumber) | .[0:1] | map(.[0].CcyNbr | tonumber)),
      [959]
    ] | flatten
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": [
    {"$ref": "numeric-currency.json"},
    {"$ref": "numeric-fund.json"},
    {"$ref": "numeric-precious-metal.json"}
  ]
}
