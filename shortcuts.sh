#!/bin/bash

if [[ $1 == "-e" || $1 == "--export" ]]; then
    cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml /usr/local/sbin/
elif [[ $1 == "-i" || $1 == "--import" ]]; then
    cp /usr/local/sbin/xfce4-keyboard-shortcuts.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml
else
    echo "USAGE: $0 -i|--import | -e|--export"
fi


