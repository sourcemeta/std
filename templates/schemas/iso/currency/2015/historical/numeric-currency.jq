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
    | map(
      ((map(.Ccy) | unique) as $alpha |
       if ($alpha | length) == 1 and ($alpha[0] | IN("AOK", "AYM", "BAD", "BEC", "BEL", "BUK", "BYB", "CHC", "CSD", "ECV", "ESA", "ESB", "GEK", "GHP", "GNS", "GWE", "HRD", "LSM", "LTT", "LUC", "LUL", "LVR", "MZE", "NIC", "PES", "RHD", "ROK", "SDP", "UGW", "UYP", "XFO", "ZAL") | not)
       then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + $alpha[0])}
       else {} end) +
      {
        "title": (map(.CcyNm) | unique | join(" / ")),
        "const": (.[0].CcyNbr | tonumber)
      })
  )
}
