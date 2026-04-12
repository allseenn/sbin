#!/usr/bin/env bash
# set -euox pipefail
set -a
. $(dirname $0)/.env
DATE=$(date +%Y%m%d%H%M%S)
START=$(date +%s)
# tail -f /var/log/squid/access.log | grep mp2t
URL=$1/720p/
DURATION=$2
PARTS=$(echo "($DURATION*60/5)+($DURATION/5)" | bc)
mkdir /mnt/backup/video/$DATE
cd /mnt/backup/video/$DATE

MAX_JOBS=15

for i in $(seq 0 $PARTS); do
    FILE=$(printf "%04d.ts" $i)

    (
        curl --fail --silent --connect-timeout 5 "$URL/$i.ts" -o "$FILE"
    ) &

    while [ $(jobs -r | wc -l) -ge $MAX_JOBS ]; do
        sleep 0.2
    done
done

wait

ls *.ts | sort | xargs cat > video.mp4
rm *.ts -rf

END=$(date +%s)
echo "video.mp4 продолжительностью $(mediainfo video.mp4 | grep Duration | head -1 | awk -F: '{print $2}')"
echo "сохранено в папке /mnt/backup/video/$DATE"
echo "скачано и обработано за $(echo $END - $START | bc) секунд"
