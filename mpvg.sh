#!/bin/bash

user=$USER
host="localhost"
port="22"

execute_command() {
    local command=$1
    
    case $command in
        "prev") 
            ssh -p $port $user@$host 'mpv.sh -b'
            ;;
        "play") 
            ssh -p $port $user@$host 'mpv.sh -p'
            ;;
        "next") 
            ssh -p $port $user@$host 'mpv.sh -n'
            ;;
        "sub_down") 
            ssh -p $port $user@$host 'mpv.sh -sd'
            ;;
        "sub_up") 
            ssh -p $port $user@$host 'mpv.sh -su'
            ;;
        "vol_down") 
            ssh -p $port $user@$host 'mpv.sh -vd'
            ;;
        "vol_up") 
            ssh -p $port $user@$host 'mpv.sh -vu'
            ;;
        *) 
            echo "Неверная команда"
            ;;
    esac
}

(
    echo "Start"
    while true; do
        command=$(yad --form --title="MPV Player" \
            --field="":ENTRY "$user" \
            --field="  @":LBL '@' \
            --field="":ENTRY "$host" \
            --field="❣":LBL ':' \
            --field="":ENTRY "$port" \
            --field="⏪":FBTN "echo prev" \
            --field="▶️":FBTN "echo play" \
            --field="⏩":FBTN "echo next" \
            --field="⏬":FBTN "echo sub_down" \
            --field="⏫":FBTN "echo sub_up" \
            --field="🔉":FBTN "echo vol_down" \
            --field="🔊":FBTN "echo vol_up" \
            --buttons-layout=center \
            --columns=5 \
            --width=250 --height=0 \
            --separator="|")

        if [ $? -eq 252 ]; then
            break
        fi

        IFS='|' read -r user _ host _ port cmd <<< "$command"
        execute_command $cmd &
    done
) &
