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
        "x-jsonld-self": ("http://publications.europa.eu/resource/authority/country/" + .["alpha-3"]),
        "title": .name
      } +
      {
        "const": .["alpha-2"]
      })
  )
}
