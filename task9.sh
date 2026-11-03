#!/bin/bash

[[ $# -ne 1 || ! -d "$1" ]] && { echo "Ошибка: укажите путь к каталогу"; exit 1; }

dir="$1"
user=$(whoami)
date=$(date -I)

for file in "$dir"/*.txt; do
    [[ -f "$file" ]] && sed -i "1i Approved $user $date" "$file"
done
