{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-5:2023 Language Family Code",
  "description": "A three-letter code for language families and groups from ISO 639-5",
  "$comment": "Set 5 codes language families and groups, not individual languages. It is independent from Sets 1-3",
  "examples": (.set_5 | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "anyOf": (
    .set_5
    | sort_by(.code)
    | map({
        "title": .name
      } +
      (if .name_french then {"x-name-french": .name_french} else {} end) +
      {
        "const": .code
      })
  )
}
