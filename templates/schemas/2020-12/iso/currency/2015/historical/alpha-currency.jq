# The IN-listed codes are absent from the EU currency authority table, so their branches mint no identifier
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency Code (Historical)",
  "description": ("A three-letter alphabetic withdrawn currency code, excluding funds and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "string")
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | .[0:4]
    | map(.[0].Ccy)
  ),
  "deprecated": true,
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": (
    .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "string")
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | map({
        "title": .[0].CcyNm,
        "x-country-names": map(.CtryNm),
        "x-withdrawal-date": .[0].WthdrwlDt,
        "const": .[0].Ccy
      } +
      (if (.[0].Ccy | IN("AOK", "AYM", "BAD", "BEC", "BEL", "BUK", "BYB", "CHC", "CSD", "ECV", "ESA", "ESB", "GEK", "GHP", "GNS", "GWE", "HRD", "LSM", "LTT", "LUC", "LUL", "LVR", "MZE", "NIC", "PES", "RHD", "ROK", "SDP", "UGW", "UYP", "XFO", "ZAL") | not) then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + .[0].Ccy)} else {} end))
  )
}
