{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-3:2023 Language Code",
  "description": "A three-letter language code from ISO 639-3",
  "$comment": "Set 3 is a superset of Set 1 and Set 2. It provides comprehensive coverage of individual languages, macrolanguages, and special codes",
  "examples": (.set_3 | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-jsonld-self": "http://lexvo.org/id/iso639-3/{this}",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "enum": (.set_3 | sort_by(.code) | map(.code))
}
