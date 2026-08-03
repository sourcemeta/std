{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-2:2023 Terminologic Language Code",
  "description": "A three-letter terminologic language code from ISO 639-2",
  "$comment": "Set 2 terminologic equals Set 2 bibliographic except for the twenty languages with divergent codes, and is a superset of Set 1. Terminologic codes are based on native language names. Codes reserved for local use have no registered identity",
  "examples": (.set_2_terminologic | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "type": "string",
  "anyOf": [
    {
      "x-jsonld-self": "http://id.loc.gov/vocabulary/iso639-2/{this}",
      "enum": (.set_2_terminologic | sort_by(.code) | map(.code))
    },
    {
      "pattern": "^q[a-t][a-z]$"
    }
  ]
}
