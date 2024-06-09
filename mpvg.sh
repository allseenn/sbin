#!/bin/bash

user=$USER
host="localhost"
port="22"

execute_command() {
    local button=$1
    
    case $button in
        2) 
            ssh -p $port $user@$host 'mpv.sh -b'
            ;;
        4) 
            ssh -p $port $user@$host 'mpv.sh -p'
            ;;
        6) 
            ssh -p $port $user@$host 'mpv.sh -n'
            ;;
        8) 
            ssh -p $port $user@$host 'mpv.sh -sd'
            ;;
        10) 
            ssh -p $port $user@$host 'mpv.sh -su'
            ;;
        12) 
            ssh -p $port $user@$host 'mpv.sh -vd'
            ;;
        14) 
            ssh -p $port $user@$host 'mpv.sh -vu'
            ;;
        *) 
            echo "Неверная кнопка"
            ;;
    esac
}

while true; do
    result=$(yad --form --title="MPV Player" \
        --field="":ENTRY "$user" \
        --field="  @":LBL '@' \
        --field="":ENTRY "$host" \
        --field="❣":LBL ':' \
        --field="":ENTRY "$port" \
        --button="⏪":2 \
        --button="▶️":4 \
        --button="⏩":6 \
        --button="⏬":8 \
        --button="⏫":10 \
        --button="🔉":12 \
        --button="🔊":14 \
        --columns=5 \
        --width=250 --height=0 \
        --separator="|")

    button=$?
    if [ $button -eq 252 ]; then
        break
    fi

    IFS='|' read -r user _ host _ port <<< "$result"
    execute_command $button &
done
