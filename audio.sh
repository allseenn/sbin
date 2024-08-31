#!/bin/bash

# Проверка наличия аргумента
if [ -z "$1" ]; then
  echo "Usage: $0 input_file.mp4"
  exit 1
fi

# Извлечение имени файла без расширения
filename=$(basename -- "$1")
filename_no_ext="${filename%.*}"

# Конвертация видео в аудио
ffmpeg -i $filename -vn -acodec copy $filename_no_ext.aac

echo "Conversion completed: $filename_no_ext.aac"

