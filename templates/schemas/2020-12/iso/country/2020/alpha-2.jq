{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 3166-1:2020 Alpha-2 Country Code",
  "description": "A two-letter country code from ISO 3166-1",
  "examples": (
    map(select(.["alpha-2"] != null and .["alpha-2"] != ""))
    | sort_by(.["alpha-2"])
    | .[0:4]
    | map(.["alpha-2"])
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
  "anyOf": (
    map(select(.["alpha-2"] != null and .["alpha-2"] != ""))
    | sort_by(.["alpha-2"])
    | map({
        "title": .name,
        "x-alpha-3": .["alpha-3"],
        "x-numeric": (.["country-code"] | tonumber)
      } +
      (if .region != null and .region != "" then {"x-region": .region} else {} end) +
      (if .["sub-region"] != null and .["sub-region"] != "" then {"x-sub-region": .["sub-region"]} else {} end) +
      {
        "const": .["alpha-2"]
      })
  )
}
