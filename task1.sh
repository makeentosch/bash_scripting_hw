#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

step=0
hits=0
numbers=()

while :
do
    my_number=$(( RANDOM % 10 ))
    ((step++))

    read -p "Step: $step Please enter number from 0 to 9 (q - quit): " input

    case "$input" in
        q) echo "Bye!"; exit 0 ;;
        [0-9]) ;;
        *) echo "Invalid input"; ((step--)); continue ;;
    esac

    if (( my_number == input )); then
        ((hits++))
        echo -e "Hit! My number: $my_number"
        numbers+=("${GREEN}${my_number}${RESET}")
    else
        echo -e "Miss! My number: $my_number"
        numbers+=("${RED}${my_number}${RESET}")
    fi

    hit_percent=$(( hits * 100 / step ))
    echo -e "Hit: ${hit_percent}% Miss: $((100 - hit_percent))%"

    count=${#numbers[@]}
    if (( count > 10 )); then
        start=$(( count - 10 ))
    else
        start=0
    fi

    echo -e "Numbers: ${numbers[@]:start}"
done
