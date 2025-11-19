{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency, Fund, and Precious Metal Code",
  "description": ("A three-letter alphabetic code including currencies, funds, and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    [
      (.ISO_4217.CcyTbl.CcyNtry | map(select(.Ccy != null and (.CcyNm | type == "string") and (.Ccy | IN("XAU", "XPD", "XPT", "XAG", "XTS", "XXX") | not))) | group_by(.Ccy) | sort_by(.[0].Ccy) | .[0:4] | map(.[0].Ccy)),
      (.ISO_4217.CcyTbl.CcyNtry | map(select(.Ccy != null and (.CcyNm | type == "object") and (.CcyNm."@attributes".IsFund == "true"))) | group_by(.Ccy) | sort_by(.[0].Ccy) | .[0:2] | map(.[0].Ccy)),
      ["XAG"]
    ] | flatten
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": [
    {"$ref": "alpha-currency.json"},
    {"$ref": "alpha-fund.json"},
    {"$ref": "alpha-precious-metal.json"}
  ]
}
