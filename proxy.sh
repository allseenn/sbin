#!/usr/bin/env bash
. $(dirname $0)/.env
START_TIME=$(date +%s)
LIST_RAW=$(curl -sL $PROXYFLY_LIST | sort | uniq)
AMOUNT_RAW=$(echo "$LIST_RAW" | wc -l)
COUNT_PROCESSED=0
COUNT_TESTED=0
TIMEOUT=1
FILE_SAVE=/etc/proxychains.conf
echo "Loaded $AMOUNT_RAW proxies, estimated time to test $(echo $AMOUNT_RAW*$TIMEOUT | bc) seconds"
echo "[ProxyList]" > /etc/proxychains.conf

for i in $LIST_RAW
do
  HOST_REAL=$(curl -s -m $TIMEOUT -x $i $PROXYFLY_TARGET &)
  HOST_LIST=$(echo $i | awk -F: '{print $2}' | sed 's/\/\///g')
  COUNT_PROCESSED=$((COUNT_PROCESSED+1))
  if [ "$HOST_LIST" == "$HOST_REAL" ]; then
    echo $i | sed -e 's/\:/ /g' | sed -e 's/https/http/g' | sed -e 's/\/\///g' >> $FILE_SAVE
    COUNT_TESTED=$((COUNT_TESTED+1))
    echo "$COUNT_TESTED $i remains $((AMOUNT_RAW-COUNT_PROCESSED))"
  fi
done
wait
END_TIME=$(date +%s)
echo "Done in $(echo "($END_TIME-$START_TIME)/60" | bc -l) minutes"
echo "Tested $COUNT_PROCESSED hosts, found $COUNT_TESTED working hosts"
