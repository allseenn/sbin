#!/bin/bash -l
cd "$1"
exec > >(tee -a $(basename $0).log) 2>&1
set -euox pipefail
DATE=$(date +%Y%m%d%H%M%S)
LINK=$(xsel --clipboard --output)
if [ -z "$LINK" ]; then
    zenity --error --text="Буфер обмена пуст. Ссылка для скачивания не найдена."
    exit 1
fi
uv tool upgrade yt-dlp
TITLE=$(yt-dlp --get-title $LINK)
yt-dlp $LINK
status=$(pwd) 
notify-send "$status Скачана $TITLE"
