#!/bin/bash
SEC=1
if [[ $1 == "--help" || $1 == "-h" || $1 == "" ]]; then
    echo "usage: mpv.sh -fucnps [FILENAME | URL]"
    echo "-f FILENAME: plays FILENAME"
    echo "-f URL: plays URL"
    echo "-p: plays or pause the current file"
    echo "-n: rewind 5 seconds forward"
    echo "-b: rewind 5 seconds backward"
    echo "-s: screen toggle to/from fullscreen"
    echo "-q: quit mpv"
    exit
elif [[ $1 == "--file" || $1 == "-f" ]]; then
    mpv --input-ipc-server=/tmp/mpvsocket --fullscreen $2
elif [[ $1 == "--url" || $1 == "-u" ]]; then
    url=$(xsel)
    mpv --input-ipc-server=/tmp/mpvsocket --fullscreen $url
elif [[ $1 == "--quit" || $1 == "-q" ]]; then
    echo '{ "command": ["quit"] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--next" || $1 == "-n" ]]; then
    echo "{ \"command\": [\"seek\", $SEC] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--prev" || $1 == "-b" ]]; then
    echo "{ \"command\": [\"seek\", -$SEC] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--screen" || $1 == "-s" ]]; then
    echo '{ "command": ["cycle", "fullscreen"] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--play" || $1 == "-p" ]]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket
fi

