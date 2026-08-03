(
  .["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"]
  | map(select(.["{http://www.xbrl.org/2009/utr}itemType"] == $item_type
      and ($normative != "true" or .["{http://www.xbrl.org/2009/utr}status"] == "REC")))
) as $units |
($item_type
  | [splits("(?=[A-Z])")]
  | map(select(. != ""))
  | map((.[0:1] | ascii_upcase) + .[1:])
  | join(" ")
) as $title_name |
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": ("XBRL UTR " + $title_name + " Units"
    + (if $normative == "true" then " (Normative)" else "" end)),
  "description": (if $normative == "true"
    then ("Valid units with the recommended status for " + $item_type + " as defined in the XBRL Units Type Registry")
    else ("Valid units for " + $item_type + " as defined in the XBRL Units Type Registry")
    end),
  "examples": (
    $units
    | .[0:3]
    | map(.["{http://www.xbrl.org/2009/utr}unitId"])
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": [
    "https://www.xbrl.org/specification/utr/rec-2013-11-18/utr-rec-2013-11-18-clean.html",
    "https://www.xbrl.org/utr/utr.xml"
  ],
  "anyOf": (
    $units
    | map(
        (.["{http://www.xbrl.org/2009/utr}definition"] | gsub("\\s{2,}"; " ") | if endswith(".") then .[:-1] else . end) as $desc |
        {
          "const": .["{http://www.xbrl.org/2009/utr}unitId"],
          "description": $desc
        } +
        (if .["{http://www.xbrl.org/2009/utr}unitName"] != $desc then {"title": .["{http://www.xbrl.org/2009/utr}unitName"]} else {} end) +
        (if (.["{http://www.xbrl.org/2009/utr}nsUnit"] | IN("http://www.xbrl.org/2009/utr", "http://www.xbrl.org/2003/instance")) and $unit_iris[0][.["{http://www.xbrl.org/2009/utr}unitId"]] != null
         then {"x-jsonld-self": $unit_iris[0][.["{http://www.xbrl.org/2009/utr}unitId"]]}
         elif .["{http://www.xbrl.org/2009/utr}nsUnit"] == "http://www.xbrl.org/2003/iso4217"
         then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + .["{http://www.xbrl.org/2009/utr}unitId"])}
         else {} end)
      )
  )
}
