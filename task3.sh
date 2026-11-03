#!/bin/bash

board=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0)

# Перемешивание
for i in {15..1}; do
    j=$((RANDOM % (i + 1)))
    tmp=${board[$i]}; board[$i]=${board[$j]}; board[$j]=$tmp
done

step=0
while true; do
    ((step++))
    echo "Ход № $step"

    # Вывод поля
    echo "+-------------------+"
    for i in 0 4 8 12; do
        printf "|"
        for j in {0..3}; do
            val=${board[$((i+j))]}
            ((val == 0)) && printf " %2s |" "" || printf " %2d |" "$val"
        done
        echo
        ((i < 12)) && echo "|-------------------|"
    done
    echo "+-------------------+"

    read -p "Ваш ход (q - выход): " move
    [[ "$move" =~ ^[qQ]$ ]] && exit 0

    # Поиск пустой ячейки
    empty=-1
    for i in {0..15}; do ((board[i] == 0)) && empty=$i && break; done

    # Проверка соседей
    row=$((empty / 4)); col=$((empty % 4))
    neighbors=()
    ((row > 0)) && neighbors+=(${board[$((empty - 4))]})
    ((row < 3)) && neighbors+=(${board[$((empty + 4))]})
    ((col > 0)) && neighbors+=(${board[$((empty - 1))]})
    ((col < 3)) && neighbors+=(${board[$((empty + 1))]})

    # Валидация хода
    valid=false
    for n in "${neighbors[@]}"; do ((n == move)) && valid=true && break; done

    if ! $valid; then
        echo "Неверный ход!"
        echo "Невозможно костяшку $move передвинуть на пустую ячейку."
        echo "Можно выбрать: ${neighbors[*]}"
        ((step--))
        continue
    fi

    # Перемещение
    for i in {0..15}; do
        if ((board[i] == move)); then
            board[$i]=0; board[$empty]=$move; break
        fi
    done

    # Проверка победы
    win=true
    for i in {0..14}; do ((board[i] != i + 1)) && win=false && break; done

    if $win; then
        echo "Вы собрали головоломку за $step ходов."
        echo "+-------------------+"
        for i in 0 4 8 12; do
            printf "|"
            for j in {0..3}; do printf " %2d |" "${board[$((i+j))]}"; done
            echo
            ((i < 12)) && echo "|-------------------|"
        done
        echo "+-------------------+"
        exit 0
    fi
done
