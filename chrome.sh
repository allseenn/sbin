#!/bin/bash
# Данный скрипт активирует боковую кнопку для открытия чата c агентом Gemini,
# Меняет регион на US. Скрипт нужно запускать при выключенном Хроме.
# После смены региона необходимо пользоваться VPN или Proxy, Socks
JSON_FILE="$HOME/.config/google-chrome/Local State"
BACKUP_FILE="$HOME/.config/google-chrome/Local State.bak"

# 1. Проверяем наличие утилиты jq
if ! command -v jq &> /dev/null; then
    echo "Ошибка: утилита 'jq' не установлена. Установите её (например, sudo dnf install jq или sudo apt install jq)."
    exit 1
fi

# 2. Проверяем существование файла конфигурации
if [ ! -f "$JSON_FILE" ]; then
    echo "Ошибка: Файл конфигурации не найден по пути: $JSON_FILE"
    exit 1
fi

# 3. Закрываем Chrome, чтобы он не заблокировал и не перезаписал файл
echo "Закрываем Google Chrome..."
pkill -f "google-chrome"
# Даем процессам секунду на завершение
sleep 1

# 4. Создаем резервную копию файла на всякий случай
cp "$JSON_FILE" "$BACKUP_FILE"
echo "Создана резервная копия: $BACKUP_FILE"

# 5. Модифицируем JSON с помощью jq
# Конструкция .[-1] = "us" меняет последний элемент массива variations_permanent_consistency_country, сохраняя версию
if jq '
  .profile.info_cache.Default.is_glic_eligible = true |
  .variations_country = "us" |
  if (.variations_permanent_consistency_country | type) == "array" then
    .variations_permanent_consistency_country[-1] = "us"
  else
    .variations_permanent_consistency_country = ["us"]
  end
' "$JSON_FILE" > "$JSON_FILE.tmp"; then
    
    # Если jq отработал без ошибок, заменяем оригинальный файл
    mv "$JSON_FILE.tmp" "$JSON_FILE"
    echo "Настройки успешно обновлены!"
    echo "Запустите Chrome заново и проверьте кнопку Gemini."
else
    echo "Ошибка: Не удалось корректно изменить JSON файл."
    rm -f "$JSON_FILE.tmp"
    exit 1
fi

