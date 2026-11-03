#!/bin/bash

trap 'echo "Для выхода введите q или Q"' INT

A=(1 2 3 4 5 6 7 8); B=(); C=()
step=0

while true; do
    # Вывод стеков
    for i in {0..7}; do
        for s in A B C; do
            eval "arr=(\"\${$s[@]}\")"
            (($i < ${#arr[@]})) && printf "|%d|" "${arr[$i]}" || printf "| |"
        done
        echo
    done
    echo "+-+ +-+ +-+"; echo " A  B  C"
    
    ((step++))
    read -p "Ход № $step (откуда, куда): " input
    input="${input// /}"; input="${input^^}"
    
    [[ "$input" =~ ^[qQ]$ ]] && exit 1
    [[ ! "$input" =~ ^[ABC]{2}$ || "${input:0:1}" == "${input:1:1}" ]] && { echo "Ошибка!"; ((step--)); continue; }
    
    src="${input:0:1}"; dst="${input:1:1}"
    eval "src_arr=(\"\${$src[@]}\"); dst_arr=(\"\${$dst[@]}\")"
    
    ((${#src_arr[@]} == 0)) && { echo "Стек $src пуст!"; ((step--)); continue; }
    
    top_src=${src_arr[0]}
    ((${#dst_arr[@]} > 0 && top_src > dst_arr[0])) && { echo "Такое перемещение запрещено!"; ((step--)); continue; }
    
    eval "unset '$src[0]'; $src=(\"\${$src[@]}\"); $dst=($top_src \"\${$dst[@]}\")"
    
    # Проверка победы
    for s in B C; do
        eval "arr=(\"\${$s[@]}\")"
        if ((${#arr[@]} == 8)) && [[ "${arr[*]}" == "8 7 6 5 4 3 2 1" ]]; then
            echo "Победа! Ходов: $step"
            exit 0
        fi
    done
done
