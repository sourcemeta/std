# Build lookup tables from Set 3 (ISO-639-3) for enrichment
($iso3[0] | map(select(.Part1 != null and .Part1 != "")) | INDEX(.Part1)) as $lookup_by_part1 |
($iso3[0] | map(select(.Part2b != null and .Part2b != "")) | INDEX(.Part2b)) as $lookup_by_part2b |
($iso3[0] | map(select(.Part2t != null and .Part2t != "")) | INDEX(.Part2t)) as $lookup_by_part2t |

# Process ISO-639-2 data to extract Sets 1, 2, and 5
($iso2[0] | map(
  . as $entry |
  ($entry.name | ascii_downcase | (contains("languages") or contains("language family"))) as $is_language_family |
  {
    is_family: $is_language_family,
    part1: ($entry.part1 // "" | if . == "" then null else . end),
    part2b: ($entry.part2b // "" | if . == "" then null else . end),
    part2t: ($entry.part2t // "" | if . == "" then null else . end),
    name: $entry.name,
    name_french: ($entry.name_french // "" | if . == "" then null else . end)
  }
)) as $processed_iso2 |

# Set 5: Language families (identified by name patterns)
($processed_iso2 | map(select(.is_family and .part2b != null) | {
  code: .part2b,
  name: .name,
  name_french: .name_french
})) as $set_5 |

# Set 1: 2-letter codes (part1)
($processed_iso2 | map(select(.is_family | not) | select(.part1 != null) |
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

# Set 2 bibliographic: 3-letter bibliographic codes (part2b)
($processed_iso2 | map(select(.is_family | not) | select(.part2b != null) |
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

# Set 2 terminologic: 3-letter terminologic codes (part2t)
($processed_iso2 | map(select(.is_family | not) | select(.part2t != null) |
  ($lookup_by_part2t[.part2t] // {}) as $set_3_data |
  {
    code: .part2t,
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

# Output combined structure
{
  set_1: $set_1,
  set_2_bibliographic: $set_2_bibliographic,
  set_2_terminologic: $set_2_terminologic,
  set_3: $set_3,
  set_5: $set_5
}
