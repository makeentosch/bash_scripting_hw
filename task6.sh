#!/bin/bash

# Парсинг аргументов
path="."
mask="*"
number=$(nproc)

while [[ $# -gt 1 ]]; do
    case "$1" in
        --path) path="$2"; shift 2 ;;
        --mask) mask="$2"; shift 2 ;;
        --number) number="$2"; shift 2 ;;
        *) shift ;;
    esac
done
command="$1"

# Валидация
[[ ! -d "$path" ]] && { echo "Каталог $path не существует"; exit 1; }
[[ ! -x "$command" ]] && { echo "Команда $command не исполняема"; exit 1; }

# Поиск файлов
files=()
while IFS= read -r -d '' file; do
    [[ -f "$file" ]] && files+=("$file")
done < <(find "$path" -maxdepth 1 -name "$mask" -print0)

# Обработка файлов
for ((i=0; i<${#files[@]}; i++)); do
    "$command" "${files[$i]}" &
    
    if ((i >= number - 1)); then
        wait -n
    fi
done

wait
