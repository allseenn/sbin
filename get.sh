#!/bin/bash
# Получение ссылки из буфера обмена с помощью xclip
download_link=$(xsel --clipboard --output)
# Проверка, что буфер обмена не пустой
if [ -z "$download_link" ]; then
    zenity --error --text="Буфер обмена пуст. Ссылка для скачивания не найдена."
    exit 1
fi
# Выполнение скачивания файла с использованием --content-disposition
wget --content-disposition --no-check-certificate --continue --background "$download_link"
# Получение имени скачанного файла
downloaded_file=$(basename "$download_link")

