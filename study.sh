#!/usr/bin/env -S bash -i

YANDEX_PROFILE=~/.config/yandex-browser-beta/Default
YANDEX_BIN=yandex-browser-beta
CHROME_PROFILE=~/.config/google-chrome/Default/
CHROME_BIN=google-chrome
CLOUD_DIR=$(echo exit | cloud.sh 2)
~/.bashrc.d/dirs.sh

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
        xdg-open $CLOUD_DIR/Алгебра/07.pdf
        algebra.wiki && code .
        ;;
    2)
        xdg-open $CLOUD_DIR/Алгебра/07.pdf
        algebra && code .
        rm -f $YANDEX_PROFILE/Sessions/*
        $YANDEX_BIN --variations-override-country=us --lang=en-US --new-window https://gemini.google.com $PWD.wiki/Home.md &
        ;;
    3)
        xdg-open $CLOUD_DIR/Геометрия/07-09.pdf
        geometry.wiki && code .
        ;;
    4)
        xdg-open $CLOUD_DIR/Геометрия/07-09.pdf
        geometry && code .
        ;;
    5)
        xdg-open $CLOUD_DIR/TерВер/07-09_1.pdf
        probability.wiki && code .
        ;;
    6)
        xdg-open $CLOUD_DIR/TерВер/07-09_1.pdf
        probability && code .
        rm -f $YANDEX_PROFILE/Sessions/*
        $YANDEX_BIN --variations-override-country=us --lang=en-US --new-window https://gemini.google.com $PWD.wiki/Home.md &
        ;;
    7)
        xdg-open $CLOUD_DIR/Физика/07.pdf
        physics.wiki && code .
        ;;
    8)
        xdg-open $CLOUD_DIR/Физика/07.pdf
        physics && code .
        rm -f $YANDEX_PROFILE/Sessions/*
        $YANDEX_BIN --variations-override-country=us --lang=en-US --new-window https://gemini.google.com $PWD.wiki/Home.md &
        ;;
    21)
        ## ACE (Associate Cloud Engineer)
        ace.wiki &&git pull && code .
        rm -f $CHROME_PROFILE/Sessions/*
        $CHROME_BIN --variations-override-country=us --lang=en-US --new-window https://skills.google $PWD/home.md &
        ;;
    *)
        echo "Invalid choice. Please run the script again and select a valid option."
        ;;
esac
