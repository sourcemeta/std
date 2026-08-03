# XAD is absent from the EU currency authority table, so its branch mints no identifier
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency Code",
  "description": ("A three-letter alphabetic currency code, excluding funds and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "string") and
        (.Ccy | IN(($special[0]["precious-metals"] + [$special[0].test, $special[0].unknown])[]) | not)
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | .[0:4]
    | map(.[0].Ccy)
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "string") and
        (.Ccy | IN(($special[0]["precious-metals"] + [$special[0].test, $special[0].unknown])[]) | not)
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | map({
        "title": .[0].CcyNm,
        "x-country-names": map(.CtryNm),
        "x-minor-unit": (if .[0].CcyMnrUnts == "N.A." then null else (.[0].CcyMnrUnts | tonumber) end),
        "const": .[0].Ccy
      } +
      (if .[0].Ccy != "XAD" then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + .[0].Ccy)} else {} end))
  )
}
