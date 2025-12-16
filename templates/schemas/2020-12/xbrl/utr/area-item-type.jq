{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": ("XBRL UTR area Item Type units (" + .["{http://www.xbrl.org/2009/utr}utr"]["@attributes"].lastUpdated + ")"),
  "description": "Valid units for areaItemType as defined in the XBRL Units Type Registry",
  "examples": (
    .["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"]
    | map(select(.["{http://www.xbrl.org/2009/utr}itemType"] == "areaItemType"))
    
    | .[0:3]
    | map(.["{http://www.xbrl.org/2009/utr}unitId"])
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": [
    "https://www.xbrl.org/specification/utr/rec-2013-11-18/utr-rec-2013-11-18-clean.html",
    "https://www.xbrl.org/utr/utr.xml"
  ],
  "anyOf": (
    .["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"]
    | map(select(.["{http://www.xbrl.org/2009/utr}itemType"] == "areaItemType"))
    
    | map(
        (.["{http://www.xbrl.org/2009/utr}definition"] | gsub("\\s{2,}"; " ") | if endswith(".") then .[:-1] else . end) as $desc |
        {
          "const": .["{http://www.xbrl.org/2009/utr}unitId"],
          "description": $desc
        } +
        (if .["{http://www.xbrl.org/2009/utr}unitName"] != $desc then {"title": .["{http://www.xbrl.org/2009/utr}unitName"]} else {} end) +
        (if .["{http://www.xbrl.org/2009/utr}symbol"] then {"x-symbol": .["{http://www.xbrl.org/2009/utr}symbol"]} else {} end) +
        (if .["{http://www.xbrl.org/2009/utr}status"] then {"x-status": .["{http://www.xbrl.org/2009/utr}status"]} else {} end)
      )
  )
}
