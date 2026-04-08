#!/usr/bin/env bash
DATE=$(date +%Y%m%d%H%M%S)
LINK=$(xsel --clipboard --output)
if [ -z "$LINK" ]; then
    zenity --error --text="Буфер обмена пуст. Ссылка для скачивания не найдена."
    exit 1
fi
uv tool upgrade yt-dlp
TITLE=$(yt-dlp --get-title $LINK)
yt-dlp $LINK
notify-send "Скачан $TITLE"
