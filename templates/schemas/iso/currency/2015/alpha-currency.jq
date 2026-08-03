# XAD is absent from the EU currency authority table, so it mints no identifier
(
  .ISO_4217.CcyTbl.CcyNtry
  | map(select(
      .Ccy != null and
      (.CcyNm | type == "string") and
      (.Ccy | IN(($special[0]["precious-metals"] + [$special[0].test, $special[0].unknown])[]) | not)
    ))
  | group_by(.Ccy)
  | sort_by(.[0].Ccy)
  | map(.[0].Ccy)
) as $codes |
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency Code",
  "description": ("A three-letter alphabetic currency code, excluding funds and precious metals (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": ($codes | .[0:4]),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": ([
    {
      "x-jsonld-self": "http://publications.europa.eu/resource/authority/currency/{this}",
      "enum": ($codes | map(select(. != "XAD")))
    }
  ] + (if ($codes | index("XAD")) != null then [{"const": "XAD"}] else [] end))
}
