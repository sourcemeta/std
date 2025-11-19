{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Numeric Currency Code",
  "description": ("A three-digit numeric currency code, excluding funds and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        .CcyNbr != null and
        (.CcyNm | type == "string") and
        (.Ccy | IN("XAU", "XPD", "XPT", "XAG", "XTS", "XXX") | not)
      ))
    | group_by(.CcyNbr)
    | sort_by(.[0].CcyNbr | tonumber)
    | .[0:4]
    | map(.[0].CcyNbr | tonumber)
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        .CcyNbr != null and
        (.CcyNm | type == "string") and
        (.Ccy | IN("XAU", "XPD", "XPT", "XAG", "XTS", "XXX") | not)
      ))
    | group_by(.CcyNbr)
    | sort_by(.[0].CcyNbr | tonumber)
    | map({
        "title": .[0].CcyNm,
        "x-country-names": (map(.CtryNm) | unique),
        "x-minor-unit": (if .[0].CcyMnrUnts == "N.A." then null else (.[0].CcyMnrUnts | tonumber) end),
        "const": (.[0].CcyNbr | tonumber)
      })
  )
}
