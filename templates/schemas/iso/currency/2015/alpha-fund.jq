{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Fund Code",
  "description": ("A three-letter alphabetic fund code (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "object") and
        (.CcyNm."@attributes".IsFund == "true")
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | .[0:4]
    | map(.[0].Ccy)
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-jsonld-self": "http://publications.europa.eu/resource/authority/currency/{this}",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "enum": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "object") and
        (.CcyNm."@attributes".IsFund == "true")
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | map(.[0].Ccy)
  )
}
