#!/bin/bash
# Получение ссылки из буфера обмена с помощью xsel
# apt install xsel
log=wget-$(date +%Y%m%d%H%M%S)
download_link=$(xsel --clipboard --output)
# Проверка, что буфер обмена не пустой
if [ -z "$download_link" ]; then
    zenity --error --text="Буфер обмена пуст. Ссылка для скачивания не найдена."
    exit 1
fi
# Выполнение скачивания файла с использованием --content-disposition
LANG=en_US.UTF-8 wget --content-disposition --no-check-certificate --continue "$download_link" --output-file=$log
# Получение имени скачанного файла
last_line=$(grep -v '^$' $log | tail -1) 
status=$(echo "$last_line" | awk '{ print $1 }')
file_name=$(echo "$last_line" | sed 's/.*‘//' | sed 's/’.*//')
file_ext=$(grep Length: $log | sed 's/.*\///' | sed 's/]//' | tail -1)

if [[ $status = 'Cannot' ]]; then
    file_name=$(echo "file_name" | sed 's/\\.*[0-9]//' )
    LANG=en_US.UTF-8 wget --no-check-certificate --continue --output-file=$log --output-document="$file_name.$file_ext" "$download_link"
fi

notify-send "Скачан $file_name"
rm $log

