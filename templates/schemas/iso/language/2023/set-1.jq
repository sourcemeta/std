{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-1:2023 Language Code",
  "description": "A two-letter language code from ISO 639-1",
  "$comment": "Set 1 contains the most common languages (2-letter codes). All Set 1 codes have corresponding codes in Set 2 and Set 3",
  "examples": (.set_1 | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-jsonld-self": "http://id.loc.gov/vocabulary/iso639-1/{this}",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "enum": (.set_1 | sort_by(.code) | map(.code))
}
