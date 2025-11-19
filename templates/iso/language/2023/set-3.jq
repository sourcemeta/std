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
  "title": "ISO 639-3:2023 Language Code",
  "description": "A three-letter language code from ISO 639-3",
  "$comment": "Set 3 is a superset of Set 1 and Set 2. It provides comprehensive coverage of individual languages, macrolanguages, and special codes",
  "examples": (.set_3 | sort_by(.code) | .[0:4] | map(.code)),
  "x-license": "https://github.com/sourcemeta/std/blob/main/LICENSE",
  "x-links": ["https://www.iso.org/standard/74575.html"],
  "anyOf": (
    .set_3
    | sort_by(.code)
    | map({
        "title": .name
      } +
      (if .scope then {"x-scope": (.scope | expand_scope)} else {} end) +
      (if .language_type then {"x-language-type": (.language_type | expand_language_type)} else {} end) +
      (if .part2b then {"x-set-2-bibliographic": .part2b} else {} end) +
      (if .part2t then {"x-set-2-terminologic": .part2t} else {} end) +
      (if .part1 then {"x-set-1": .part1} else {} end) +
      (if .comment then {"$comment": .comment} else {} end) +
      {
        "const": .code
      })
  )
}
