#!/bin/bash

[[ $# -ne 1 || ! -d "$1" ]] && { echo "Ошибка: укажите путь к каталогу"; exit 1; }

declare -A stats

while IFS= read -r -d '' file; do
    base=$(basename "$file")
    [[ "$base" == .* ]] && base="${base#.}"
    
    if [[ "$base" == *.* ]]; then
        suffix=".${base##*.}"
    else
        suffix="no suffix"
    fi
    
    ((stats["$suffix"]++))
done < <(find "$1" -type f -print0)

for key in "${!stats[@]}"; do
    echo "${stats[$key]} $key"
done | sort -rn | while read count suffix; do
    echo "$suffix: $count"
done

