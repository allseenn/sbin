#!/bin/bash
JSON_FILE="$HOME/.config/google-chrome/Local State"
DESKTOP_DIR="$HOME/.local/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/google-chrome.desktop"
SYS_DESKTOP="/usr/share/applications/google-chrome.desktop"

# Определяем путь к системному ярлыку
if [ ! -f "$SYS_DESKTOP" ] && [ -f "/usr/share/applications/google-chrome-stable.desktop" ]; then
    SYS_DESKTOP="/usr/share/applications/google-chrome-stable.desktop"
fi

# 1. Завершение работы Chrome и правка Local State
pkill -f "google-chrome"
sleep 2

chmod +w "$JSON_FILE" 2>/dev/null

jq '
  .profile.info_cache |= map_values(.is_glic_eligible = true) |
  .variations_country = "us" |
  .variations_safe_seed_permanent_consistency_country = "us" |
  .variations_safe_seed_session_consistency_country = "us" |
  .variations_safe_seed_locale = "en-US" |
  .variations_seed_signature = "" |
  .variations_safe_seed_signature = "" |
  .variations_permanent_consistency_country = ["152.0.7977.82", "us"]
' "$JSON_FILE" > "$JSON_FILE.tmp" && mv "$JSON_FILE.tmp" "$JSON_FILE"

chmod 444 "$JSON_FILE"

# 2. Проверка и обновление локального .desktop ярлыка
mkdir -p "$DESKTOP_DIR"

# Если ярлыка нет в ~/.local/share/applications — копируем системный
if [ ! -f "$DESKTOP_FILE" ]; then
    if [ -f "$SYS_DESKTOP" ]; then
        cp "$SYS_DESKTOP" "$DESKTOP_FILE"
    fi
fi

# Если ярлык существует — проверяем наличие флагов в командах Exec
if [ -f "$DESKTOP_FILE" ]; then
    if ! grep -q "variations-override-country=us" "$DESKTOP_FILE"; then
        sed -i -E 's|(/usr/bin/google-chrome[-a-z]*)|\1 --variations-override-country=us --lang=en-US|g' "$DESKTOP_FILE"
        update-desktop-database "$DESKTOP_DIR" &>/dev/null || true
    fi
fi
