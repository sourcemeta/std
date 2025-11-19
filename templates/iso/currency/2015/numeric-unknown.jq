(.ISO_4217.CcyTbl.CcyNtry[] | select(.Ccy == "XXX")) as $entry |
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Numeric Unknown Currency Code",
  "description": $entry.CcyNm,
  "examples": [999],
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "const": 999
}
