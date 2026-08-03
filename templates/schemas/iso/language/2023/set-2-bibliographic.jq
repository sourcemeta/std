{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-2:2023 Bibliographic Language Code",
  "description": "A three-letter bibliographic language code from ISO 639-2",
  "$comment": "Set 2 bibliographic is a superset of Set 1 and covers every registered code element, including special and collective codes that are not part of Set 3. Bibliographic codes are based on English language names. Codes reserved for local use have no registered identity",
  "examples": (.set_2_bibliographic | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "if": {
    "not": {
      "pattern": "^q[a-t][a-z]$"
    }
  },
  "then": {
    "x-jsonld-self": "http://id.loc.gov/vocabulary/iso639-2/{this}"
  },
  "type": "string",
  "anyOf": [
    {
      "enum": (.set_2_bibliographic | sort_by(.code) | map(.code))
    },
    {
      "pattern": "^q[a-t][a-z]$"
    }
  ]
}
