{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 3166-1:2020 Alpha-3 Country Code",
  "description": "A three-letter country code from ISO 3166-1",
  "examples": (
    map(select(.["alpha-3"] != null and .["alpha-3"] != ""))
    | sort_by(.["alpha-3"])
    | .[0:4]
    | map(.["alpha-3"])
  ),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-jsonld-self": "http://publications.europa.eu/resource/authority/country/{this}",
  "x-links": ["https://www.iso.org/iso-3166-country-codes.html"],
  "enum": (
    map(select(.["alpha-3"] != null and .["alpha-3"] != ""))
    | sort_by(.["alpha-3"])
    | map(.["alpha-3"])
  )
}
