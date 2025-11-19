# Scope expansion map
def expand_scope:
  if . == "I" then "individual"
  elif . == "M" then "macrolanguage"
  elif . == "S" then "special"
  else . end;

# Language type expansion map
def expand_language_type:
  if . == "L" then "living"
  elif . == "E" then "extinct"
  elif . == "H" then "historic"
  elif . == "C" then "constructed"
  elif . == "S" then "special"
  elif . == "A" then "ancient"
  else . end;

{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "title": "ISO 639-2:2023 Bibliographic Language Code",
  "description": "A three-letter bibliographic language code from ISO 639-2",
  "$comment": "Set 2 bibliographic is a superset of Set 1 and a subset of Set 3. Bibliographic codes are based on English language names",
  "examples": (.set_2_bibliographic | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "anyOf": (
    .set_2_bibliographic
    | sort_by(.code)
    | map({
        "title": .name
      } +
      (if .scope then {"x-scope": (.scope | expand_scope)} else {} end) +
      (if .language_type then {"x-language-type": (.language_type | expand_language_type)} else {} end) +
      (if .name_french then {"x-name-french": .name_french} else {} end) +
      (if .part1 then {"x-set-1": .part1} else {} end) +
      {
        "const": .code
      })
  )
}
