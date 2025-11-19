{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Precious Metal Code",
  "description": ("A three-letter alphabetic code for precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": ["XAU", "XAG", "XPT", "XPD"],
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": (
    .ISO_4217.CcyTbl.CcyNtry
    | map(select(
        .Ccy != null and
        (.CcyNm | type == "string") and
        (.Ccy | IN("XAU", "XAG", "XPT", "XPD"))
      ))
    | group_by(.Ccy)
    | sort_by(.[0].Ccy)
    | map({
        "title": .[0].CcyNm,
        "const": .[0].Ccy
      })
  )
}
