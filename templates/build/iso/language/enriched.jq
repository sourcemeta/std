# Build lookup tables from Set 3 (ISO-639-3) for enrichment
($iso3[0] | map(select(.Part1 != null and .Part1 != "")) | INDEX(.Part1)) as $lookup_by_part1 |
($iso3[0] | map(select(.Part2b != null and .Part2b != "")) | INDEX(.Part2b)) as $lookup_by_part2b |
($iso3[0] | map(select(.Part2t != null and .Part2t != "")) | INDEX(.Part2t)) as $lookup_by_part2t |

# Process the registration authority's ISO-639-2 file. The qaa-qtz row is a
# range marker for the reserved local-use codes, not a code element itself,
# so it is excluded here and modeled as a pattern branch in the templates
($iso2[0] | map(select(.part2b != "qaa-qtz") |
  {
    part1: (.part1 // "" | if . == "" then null else . end),
    part2b: (.part2b // "" | if . == "" then null else . end),
    part2t: (.part2t // "" | if . == "" then null else . end),
    name: .name,
    name_french: (.name_french // "" | if . == "" then null else . end)
  }
)) as $processed_iso2 |

# Set 1: 2-letter codes (part1)
($processed_iso2 | map(select(.part1 != null) |
  ($lookup_by_part1[.part1] // {}) as $set_3_data |
  {
    code: .part1,
    name: .name,
    name_french: .name_french,
    part2b: .part2b,
    part2t: .part2t,
    scope: ($set_3_data.Scope // "" | if . == "" then null else . end),
    language_type: ($set_3_data.Language_Type // "" | if . == "" then null else . end)
  }
)) as $set_1 |

# Set 2 bibliographic: every registered code element, including individual
# languages, special codes, and collective codes
($processed_iso2 | map(select(.part2b != null) |
  ($lookup_by_part2b[.part2b] // {}) as $set_3_data |
  {
    code: .part2b,
    name: .name,
    name_french: .name_french,
    part1: .part1,
    scope: ($set_3_data.Scope // "" | if . == "" then null else . end),
    language_type: ($set_3_data.Language_Type // "" | if . == "" then null else . end)
  }
)) as $set_2_bibliographic |

# Set 2 terminologic: the terminologic code equals the bibliographic code
# except for the twenty divergent pairs
($processed_iso2 | map(select(.part2b != null) |
  (.part2t // .part2b) as $code |
  ($lookup_by_part2t[$code] // $lookup_by_part2b[$code] // {}) as $set_3_data |
  {
    code: $code,
    name: .name,
    name_french: .name_french,
    part1: .part1,
    scope: ($set_3_data.Scope // "" | if . == "" then null else . end),
    language_type: ($set_3_data.Language_Type // "" | if . == "" then null else . end)
  }
)) as $set_2_terminologic |

# Set 3: All ISO-639-3 codes
($iso3[0] | map(select(.Id != null and .Id != "") | {
  code: .Id,
  name: .Ref_Name,
  scope: (.Scope // "" | if . == "" then null else . end),
  language_type: (.Language_Type // "" | if . == "" then null else . end),
  part2b: (.Part2b // "" | if . == "" then null else . end),
  part2t: (.Part2t // "" | if . == "" then null else . end),
  part1: (.Part1 // "" | if . == "" then null else . end),
  comment: (.Comment // "" | if . == "" then null else . end)
})) as $set_3 |

# Set 5: the registration authority's own ISO 639-5 list
($iso5[0] | map({
  code: .code,
  name: .["Label (English)"],
  name_french: (.["Label (French)"] // "" | if . == "" then null else . end)
})) as $set_5 |

# Output combined structure
{
  set_1: $set_1,
  set_2_bibliographic: $set_2_bibliographic,
  set_2_terminologic: $set_2_terminologic,
  set_3: $set_3,
  set_5: $set_5
}
