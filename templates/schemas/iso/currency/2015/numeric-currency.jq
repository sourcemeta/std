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
        (.Ccy | IN(($special[0]["precious-metals"] + [$special[0].test, $special[0].unknown])[]) | not)
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
        (.Ccy | IN(($special[0]["precious-metals"] + [$special[0].test, $special[0].unknown])[]) | not)
      ))
    | group_by(.CcyNbr)
    | sort_by(.[0].CcyNbr | tonumber)
    | map({
      } +
      (if .[0].Ccy != "XAD" then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + .[0].Ccy)} else {} end) +
      {
        "title": .[0].CcyNm,
        "const": (.[0].CcyNbr | tonumber)
      })
  )
}
