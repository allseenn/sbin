#!/bin/bash

# Проверка наличия аргумента
if [ -z "$1" ]; then
  echo "Usage: $0 input_audio.aac"
  exit 1
fi

# Извлечение имени файла без расширения
filename=$(basename -- "$1")
filename_no_ext="${filename%.*}"

# Конвертация аудио из AAC в MP3
ffmpeg -i "$1" -acodec libmp3lame -q:a 4 "${filename_no_ext}.mp3"

echo "Conversion completed: ${filename_no_ext}.mp3"

