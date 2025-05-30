#!/bin/bash
overlap=3  # Количество секунд перекрытия
# Проверка наличия входного файла в аргументах
if [ "$#" -ne 1 ]; then
    zenity --error --text="Использование: $0 <входной_файл>"
    exit 1
fi
input_file="$1"
input_extension="${input_file##*.}"  # Получение расширения входного файла
output_file_base="${input_file%.*}"  # Получение имени файла без расширения
output_file_base="${output_file_base// /_}"  # Замена пробелов на _
# Определение продолжительности входного файла с помощью ffprobe
duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$input_file")
# Проверка, что продолжительность получена
if [ -z "$duration" ]; then
    zenity --error --text="Не удалось определить продолжительность файла"
    exit 1
fi
# Запрос количества выходных файлов с помощью zenity
output_count=$(zenity --entry --title="Количество выходных файлов" --text="На сколько частей разбить файл?" --entry-text="2")
# Проверка, что пользователь ввел количество выходных файлов
if [ -z "$output_count" ]; then
    output_count=2  # Установка значения по умолчанию
fi
# Разделение файла на указанное количество частей
for ((i=0; i<output_count; i++)); do
    # Вычисление начального времени для текущего сегмента
    if [ "$i" -eq 0 ]; then
        start=0  # Для первого сегмента начало с 0
    else
        # Для последующих сегментов добавляем перекрытие
        start=$(echo "$duration * $i / $output_count - $overlap" | bc -l)
    fi
    # Вычисление длительности сегмента
    if [ "$i" -eq $((output_count - 1)) ]; then
        # Для последнего сегмента нет необходимости в уменьшении длительности
        segment_duration=$(echo "$duration / $output_count" | bc -l)
    else
        # Увеличиваем длительность сегмента на количество секунд перекрытия
        segment_duration=$(echo "$duration / $output_count + $overlap" | bc -l)
    fi
    # Используем формат времени для -ss и -t
    start_time=$(printf "%02d:%02d:%02d" $(echo "$start/3600" | bc) $(echo "($start%3600)/60" | bc) $(echo "$start%60" | bc))
    segment_duration_time=$(printf "%02d:%02d:%02d" $(echo "$segment_duration/3600" | bc) $(echo "($segment_duration%3600)/60" | bc) $(echo "$segment_duration%60" | bc))
    
    ffmpeg -i "$input_file" -ss "$start_time" -t "$segment_duration_time" -c copy "${output_file_base}_$((i + 1)).$input_extension"
done
rm -rf "$input_file"
zenity --info --text="$1 разделен на $output_count частей с перекрытием по $overlap секунды"
