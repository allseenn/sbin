#!/bin/bash
# depends on x11vnc
# start vnc server for current x11 session
# to install: apt install x11vnc
# create pass: x11vnc -storepasswd /etc/x11vnc.pass
x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth /etc/x11vnc.pass -rfbport 5900 -shared -geometry 1280x960


