#!/bin/bash

SEC=1
SPEED=0.1

if [[ $1 == "--help" || $1 == "-h" || $1 == "" ]]; then
    echo "usage: mpv.sh -fucnps [FILENAME | URL]"
    echo "-f FILENAME: plays FILENAME"
    echo "-f URL: plays URL"
    echo "-p: plays or pause the current file"
    echo "-n: rewind 5 seconds forward"
    echo "-b: rewind 5 seconds backward"
    echo "-t: screen toggle to/from fullscreen"
    echo "-vu: volume up"
    echo "-vd: volume down"
    echo "-su: speed up"
    echo "-sd: slow down"
    echo "-q: quit mpv"
    exit
elif [[ $1 == "--file" || $1 == "-f" ]]; then
    mpv --input-ipc-server=/tmp/mpvsocket --fullscreen "$2"
elif [[ $1 == "--url" || $1 == "-u" ]]; then
    url=$(xsel)
    mpv --input-ipc-server=/tmp/mpvsocket --fullscreen "$url"
elif [[ $1 == "--quit" || $1 == "-q" ]]; then
    echo '{ "command": ["quit"] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--next" || $1 == "-n" ]]; then
    echo "{ \"command\": [\"seek\", $SEC] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--prev" || $1 == "-b" ]]; then
    echo "{ \"command\": [\"seek\", -$SEC] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--speed-up" || $1 == "-su" ]]; then
    echo "{ \"command\": [ \"add\", \"speed\", $SPEED ] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--speed-down" || $1 == "-sd" ]]; then
    echo "{ \"command\": [ \"add\", \"speed\", -$SPEED ] }" | socat - /tmp/mpvsocket
elif [[ $1 == "--toggle-screen" || $1 == "-t" ]]; then
    echo '{ "command": ["cycle", "fullscreen"] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--play" || $1 == "-p" ]]; then
    echo '{ "command": ["cycle", "pause"] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--volume-up" || $1 == "-vu" ]]; then
  echo '{ "command": ["add", "volume", 5 ] }' | socat - /tmp/mpvsocket
elif [[ $1 == "--volume-down" || $1 == "-vd" ]]; then
  echo '{ "command": ["add", "volume", -5 ] }' | socat - /tmp/mpvsocket
fi

