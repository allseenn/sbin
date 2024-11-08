#!/usr/bin/bash
# Script for changing monotors combinations (profiles)
# xfconf-query -c displays -p /ActiveProfile
# will print id of current profile
profile1=f4e20b0cb8430fd3ce7d21886de2b91f18ed0d0d
profile2=c74fd9714e38b26dbf7f58d75f93cfc977a05ba6
mon3=HDMI-2 # big monitor
if [ $1 = "1" ]; then
    xfconf-query --create --type string -c displays -p /Schemes/Apply -s $profile1
elif [ $1 = "big" ]; then
    xfconf-query --create --type string -c displays -p /Schemes/Apply -s $profile2
else
    echo "Usage: $0 [1|2]"
fi

