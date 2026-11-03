#!/bin/bash

trap 'echo "Для выхода введите q или Q"' INT

secret=$(shuf -i 0-9 -n 4 | tr -d '\n')
history=()
step=0

echo "****************************************"
echo "* Я загадал 4-значное число с          *"
echo "* неповторяющимися цифрами.            *"
echo "****************************************"

while true; do
    ((step++))
    read -p "Попытка $step: " guess

    [[ "$guess" =~ ^[qQ]$ ]] && exit 0

    if [[ ! "$guess" =~ ^[0-9]{4}$ ]] || [[ $(echo "$guess" | grep -o . | sort -u | wc -l) -ne 4 ]]; then
        echo "Ошибка! Введите 4-значное число с уникальными цифрами"
        ((step--))
        continue
    fi

    bulls=0; cows=0
    for i in {0..3}; do
        if [[ "${secret:$i:1}" == "${guess:$i:1}" ]]; then
            ((bulls++))
        elif [[ "$secret" == *"${guess:$i:1}"* ]]; then
            ((cows++))
        fi
    done

    history+=("$step. $guess (Коров - $cows Быков - $bulls)")
    echo -e "\nИстория ходов:"
    printf '%s\n' "${history[@]}"
    echo

    ((bulls == 4)) && echo "Поздравляю! Вы угадали число!" && exit 0
done
