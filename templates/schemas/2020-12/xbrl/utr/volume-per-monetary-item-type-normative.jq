{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": ("XBRL UTR volume Per Monetary Item Type units (" + .["{http://www.xbrl.org/2009/utr}utr"]["@attributes"].lastUpdated + ")"),
  "description": "Valid units for volumePerMonetaryItemType as defined in the XBRL Units Type Registry",
  "examples": (
    .["{http://www.xbrl.org/2009/utr}utr"]["{http://www.xbrl.org/2009/utr}units"]["{http://www.xbrl.org/2009/utr}unit"]
    | map(select(.["{http://www.xbrl.org/2009/utr}itemType"] == "volumePerMonetaryItemType" and .["{http://www.xbrl.org/2009/utr}status"] == "REC"))
    
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
    | map(select(.["{http://www.xbrl.org/2009/utr}itemType"] == "volumePerMonetaryItemType" and .["{http://www.xbrl.org/2009/utr}status"] == "REC"))
    
    | map(
        (.["{http://www.xbrl.org/2009/utr}definition"] | gsub("\\s{2,}"; " ") | if endswith(".") then .[:-1] else . end) as $desc |
        {
          "const": .["{http://www.xbrl.org/2009/utr}unitId"],
          "description": $desc
        } +
        (if .["{http://www.xbrl.org/2009/utr}unitName"] != $desc then {"title": .["{http://www.xbrl.org/2009/utr}unitName"]} else {} end) +
        (if .["{http://www.xbrl.org/2009/utr}symbol"] then {"x-symbol": .["{http://www.xbrl.org/2009/utr}symbol"]} else {} end) +
        (if .["{http://www.xbrl.org/2009/utr}status"] then {"x-status": .["{http://www.xbrl.org/2009/utr}status"]} else {} end) +
        (if (.["{http://www.xbrl.org/2009/utr}nsUnit"] | IN("http://www.xbrl.org/2009/utr", "http://www.xbrl.org/2003/instance")) and $unit_iris[0][.["{http://www.xbrl.org/2009/utr}unitId"]] != null
         then {"x-jsonld-self": $unit_iris[0][.["{http://www.xbrl.org/2009/utr}unitId"]]}
         elif .["{http://www.xbrl.org/2009/utr}nsUnit"] == "http://www.xbrl.org/2003/iso4217"
         then {"x-jsonld-self": ("http://publications.europa.eu/resource/authority/currency/" + .["{http://www.xbrl.org/2009/utr}unitId"])}
         else {} end)
      )
  )
}
