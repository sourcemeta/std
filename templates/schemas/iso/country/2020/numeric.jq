{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 3166-1:2020 Numeric Country Code",
  "description": "A three-digit numeric country code from ISO 3166-1",
  "examples": (
    map(select(.["country-code"] != null and .["country-code"] != ""))
    | sort_by(.["country-code"])
    | .[0:4]
    | map(.["country-code"] | tonumber)
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
  "anyOf": (
    map(select(.["country-code"] != null and .["country-code"] != ""))
    | sort_by(.["country-code"])
    | map({
        "title": .name,
        "x-alpha-2": .["alpha-2"],
        "x-alpha-3": .["alpha-3"]
      } +
      (if .region != null and .region != "" then {"x-region": .region} else {} end) +
      (if .["sub-region"] != null and .["sub-region"] != "" then {"x-sub-region": .["sub-region"]} else {} end) +
      {
        "const": (.["country-code"] | tonumber)
      })
  )
}
