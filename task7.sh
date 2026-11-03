#!/bin/bash

# Парсинг аргументов
if [[ $# -eq 3 ]]; then
    dir="$1"; old_suf="$2"; new_suf="$3"
else
    echo "Использование: $0 <каталог> <старый_суффикс> <новый_суффикс>"
    exit 1
fi

# Валидация
[[ ! -d "$dir" ]] && { echo "Ошибка: $dir не каталог"; exit 1; }
[[ ! "$old_suf" =~ ^\.[^.]+$ ]] && { echo "Ошибка: невалидный старый суффикс"; exit 1; }
[[ ! "$new_suf" =~ ^\.[^.]+$ ]] && { echo "Ошибка: невалидный новый суффикс"; exit 1; }

# Поиск и переименование
while IFS= read -r -d '' file; do
    base=$(basename "$file")
    [[ "$base" == .* ]] && base="${base#.}"
    
    if [[ "$base" == *"$old_suf" ]]; then
        new_name="${file%"$old_suf"}$new_suf"
        mv "$file" "$new_name"
        echo "Переименовано: $file -> $new_name"
    fi
done < <(find "$dir" -type f -print0)
