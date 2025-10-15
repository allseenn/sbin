#!/bin/bash
# /usr/local/sbin/hddtemp.sh
# Ультракомпактный индикатор температуры HDD для genmon

DEVICE="/dev/sda"

# Получаем температуру
get_hdd_temp() {
    temp=$(sudo /usr/sbin/smartctl -A "$DEVICE" 2>/dev/null | grep -i "Temperature_Celsius" | awk '{print $10}')
    echo "$temp"
}

temp=$(get_hdd_temp)

if [ -n "$temp" ] && [ "$temp" -gt 0 ]; then
    # Определяем символ и цвет в зависимости от температуры
    if [ "$temp" -ge 50 ]; then
        symbol="▌"  # Сплошная полоса для критической температуры
        color="red"
    elif [ "$temp" -ge 45 ]; then
        symbol="▌"
        color="orange"
    else
        symbol="▌"  # Самая тонкая полоса для нормальной температуры
        color="lightgreen"
    fi

    # Вывод тонкой вертикальной полосы
    echo "<txt><span font='Monospace 8' foreground='$color'>$symbol</span></txt>"
    echo "<tool>sda ${temp}°C</tool>"
    echo "<txtclick>$0</txtclick>"
else
    # Индикатор ошибки
    echo "<txt><span font='Monospace 8' foreground='grey'>┆</span></txt>"
    echo "<tool>HDD Temp: N/A</tool>"
fi
