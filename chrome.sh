#!/bin/bash
JSON_FILE="$HOME/.config/google-chrome/Local State"

pkill -f "google-chrome"
sleep 2

chmod +w "$JSON_FILE"

jq '
  .profile.info_cache |= map_values(.is_glic_eligible = true) |
  .variations_country = "us" |
  .variations_safe_seed_permanent_consistency_country = "us" |
  .variations_safe_seed_session_consistency_country = "us" |
  .variations_safe_seed_locale = "en-US" |
  .variations_permanent_consistency_country = ["152.0.7977.82", "us"]
' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

chmod 444 "$JSON_FILE"
