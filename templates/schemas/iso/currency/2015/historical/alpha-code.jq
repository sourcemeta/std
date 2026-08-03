{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency Code (Historical)",
  "description": ("A three-letter alphabetic code including withdrawn currencies (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
    | map(select(.Ccy != null))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | .[0:4]
    | map(.[0].Ccy)
  ),
  "deprecated": true,
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": [
    {"$ref": "alpha-currency.json"}
  ]
}
