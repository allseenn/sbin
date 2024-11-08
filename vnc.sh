#!/bin/bash
# depends on x11vnc
# start vnc server for current x11 session
# to install: apt install x11vnc
# create pass: x11vnc -storepasswd
x11vnc -noxdamage -rfbauth ~/.vnc/passwd -rfbport 5900 -shared -display :0


