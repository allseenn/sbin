#!/bin/bash

# Проверка наличия аргумента
if [ -z "$1" ]; then
  zenity --error --text="Использование: $0 input_file.mp4"
  exit 1
fi

input_file="$1"

# Извлечение имени файла без расширения
filename=$(basename -- "$input_file")
filename_no_ext="${filename%.*}"

# Запрос формата конвертации с помощью zenity
conversion_format=$(zenity --list --title="Выберите формат конвертации" --text="Выберите формат для конвертации" --radiolist --column="" --column="Формат" TRUE "AAC" FALSE "MP3-Low" FALSE "MP3-Medium" FALSE "MP3-High")

# Конвертация видео в выбранный аудио формат
case $conversion_format in
    "AAC")
        output_extension="aac"
        ffmpeg -i "$input_file" -vn -acodec copy "${filename_no_ext}.${output_extension}"
        ;;
    "MP3-Low")
        output_extension="mp3"
        audio_quality="9"
        ffmpeg -i "$input_file" -vn -acodec libmp3lame -q:a $audio_quality "${filename_no_ext}.${output_extension}"
        ;;
    "MP3-Medium")
        output_extension="mp3"
        audio_quality="5"
        ffmpeg -i "$input_file" -vn -acodec libmp3lame -q:a $audio_quality "${filename_no_ext}.${output_extension}"
        ;;
    "MP3-High")
        output_extension="mp3"
        audio_quality="2"
        ffmpeg -i "$input_file" -vn -acodec libmp3lame -q:a $audio_quality "${filename_no_ext}.${output_extension}"
        ;;
    *)
        zenity --error --text="Выбор формата конвертации отменен. Выход."
        exit 1
        ;;
esac

zenity --info --text="Конвертация завершена. Файл сохранен как ${filename_no_ext}.${output_extension}"

