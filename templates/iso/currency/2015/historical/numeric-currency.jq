{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Numeric Currency Code (Historical)",
  "description": ("A three-digit numeric withdrawn currency code, excluding funds and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
    | map(select(
        .Ccy != null and
        .CcyNbr != null and
        (.CcyNm | type == "string")
      ))
    | group_by(.CcyNbr)
    | sort_by(.[0].CcyNbr | tonumber)
    | .[0:4]
    | map(.[0].CcyNbr | tonumber)
  ),
  "deprecated": true,
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": (
    .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
    | map(select(
        .Ccy != null and
        .CcyNbr != null and
        (.CcyNm | type == "string")
      ))
    | group_by(.CcyNbr)
    | sort_by(.[0].CcyNbr | tonumber)
    | map({
        "title": (map(.CcyNm) | unique | join(" / ")),
        "x-country-names": (map(.CtryNm) | unique),
        "x-withdrawal-dates": (map(.WthdrwlDt) | unique),
        "const": (.[0].CcyNbr | tonumber)
      })
  )
}
