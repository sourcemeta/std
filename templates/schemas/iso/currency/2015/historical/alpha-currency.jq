# The unidentified codes are absent from the EU currency authority table, so they mint no identifier
["AOK", "AYM", "BAD", "BEC", "BEL", "BUK", "BYB", "CHC", "CSD", "ECV", "ESA", "ESB", "GEK", "GHP", "GNS", "GWE", "HRD", "LSM", "LTT", "LUC", "LUL", "LVR", "MZE", "NIC", "PES", "RHD", "ROK", "SDP", "UGW", "UYP", "XFO", "XFU", "XRE", "ZAL"] as $unidentified |
(
  .ISO_4217.HstrcCcyTbl.HstrcCcyNtry
  | map(select(.Ccy != null))
  | group_by(.Ccy)
  | sort_by(.[0].Ccy)
  | map(.[0].Ccy)
) as $codes |
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 4217:2015 Alphabetic Currency Code (Historical)",
  "description": ("A three-letter alphabetic withdrawn currency code, including withdrawn funds (" + .ISO_4217."@attributes".Pblshd + ")"),
  "examples": ($codes | .[0:4]),
  "deprecated": true,
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-4217-currency-codes.html"],
  "anyOf": ([
    {
      "x-jsonld-self": "http://publications.europa.eu/resource/authority/currency/{this}",
      "enum": ($codes - $unidentified)
    }
  ] + (if (($codes - ($codes - $unidentified)) | length) > 0 then [{"enum": ($codes - ($codes - $unidentified))}] else [] end))
}
