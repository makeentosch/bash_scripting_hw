#!/bin/bash

path="."
mask="*"
number=$(nproc)

while [[ $# -gt 1 ]]; do
    case "$1" in
        --path)   path="$2";   shift 2 ;;
        --mask)   mask="$2";   shift 2 ;;
        --number) number="$2"; shift 2 ;;
        *) echo "Неизвестный аргумент: $1"; exit 1 ;;
    esac
done
cmd="$1"

[[ -z "$cmd" ]] && { echo "Не задана команда"; exit 1; }
[[ ! -d "$path" ]] && { echo "Каталог $path не существует"; exit 1; }
[[ ! -x "$cmd" ]] && { echo "Команда $cmd не исполняема"; exit 1; }
[[ -z "$mask" ]] && { echo "mask не может быть пустой"; exit 1; }
[[ ! "$number" =~ ^[1-9][0-9]*$ ]] && { echo "number должен быть целым > 0"; exit 1; }

path=$(realpath "$path")

files=()
while IFS= read -r -d '' file; do
    [[ -f "$file" ]] && files+=("$file")
done < <(find "$path" -maxdepth 1 -name "$mask" -print0)

for ((i=0; i<${#files[@]}; i++)); do
    "$cmd" "${files[$i]}" &
    if (( i >= number - 1 )); then
        wait -n || true
    fi
done
wait