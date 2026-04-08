#!/usr/bin/env bash
. $(dirname $0)/.env
DATE=$(date +%Y%m%d%H%M%S)
URL=$1
DURATION=$2
PARTS=$(echo "(28.40*60/5)+1" | bc)
mkdir /mnt/backup/video/$DATE
cd /mnt/backup/video/$DATE

for i in {0001..$PARTS}; do echo "file '$i.ts'" >> list.txt; done
