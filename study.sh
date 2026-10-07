#!/usr/bin/env bash

echo "Choose discipline:"
echo "1. Algebra"
echo "2. Algebra lab"
echo "3. Geometry"
echo "4. Geometry lab"
echo "5. Probability"
echo "6. Probability lab"
echo "7. Physics"
echo "8. Physics lab"
echo "21. ACE (Associate Cloud Engineer)"

read -p "Enter the number of your choice: " choice

case $choice in
    1)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Алгебра/07.pdf
        code /mnt/sdcard/github/algebra.wiki &
        ;;
    2)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Алгебра/07.pdf
        rm -f /home/slava/.config/google-chrome/Default/Sessions/*
        google-chrome --variations-override-country=us --lang=en-US --new-window https://gemini.google.com /mnt/sdcard/github/algebra/Home.md &
        code /mnt/sdcard/github/algebra &
        ;;
    3)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Геометрия/07-09.pdf
        code /mnt/sdcard/github/geometry.wiki &
        ;;
    4)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Геометрия/07-09.pdf
        code /mnt/sdcard/github/geometryi &
        ;;
    5)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/ТерВер/07-09_1.pdf
        code /mnt/sdcard/github/probability.wik &
        ;;
    6)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/ТерВер/07-09_1.pdf
        code /mnt/sdcard/github/probability &
        ;;
    7)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Физика/07.pdf
        code /mnt/sdcard/github/physics.wiki &
        ;;
    8)
        xdg-open /mnt/sdcard/cloud/allseen@yandex.ru/Физика/07.pdf
        code /mnt/sdcard/github/physics &
        ;;

    21)
        ## ACE (Associate Cloud Engineer)
        rm -f /home/slava/.config/google-chrome/Default/Sessions/*
        google-chrome --variations-override-country=us --lang=en-US --new-window https://skills.google /mnt/sdcard/gitlab/gcnet/ace.wiki/home.md &
        cd /mnt/sdcard/gitlab/gcnet/ace.wiki
        git pull
        code . &
        ;;
    *)
        echo "Invalid choice. Please run the script again and select a valid option."
        ;;
esac