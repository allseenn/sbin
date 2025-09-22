#!/bin/bash
# apt install xsel ffmpeg zenity 
# pip install yt-dlp certifi Brotli websockets requests curl_cffi pycryptodomex phantomjs SecretStorage mutagen xattr
# OR
# apt instll mpv zenity
. $(dirname $0)/.env
DATE=$(date +%Y%m%d%H%M%S)
LINK=$(xsel --clipboard --output)
if [ -z "$LINK" ]; then
    zenity --error --text="Буфер обмена пуст. Ссылка для скачивания не найдена."
    exit 1
fi
yt-dlp --proxy http://192.168.1.1:8118 --cookies $YOUTUBE_COOKIES -o $DATE $LINK
ffmpeg -i $DATE.webm -c:v libx264 -crf 23 -preset fast -c:a aac -b:a 128k -movflags +faststart $DATE.mp4
rm $DATE.webm
notify-send "Скачан c youtube $DATE.mp4"
