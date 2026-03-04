#!/usr/bin/env bash
. $(dirname $0)/.env
START_TIME=$(date +%s)
LIST_RAW=$(curl -sL $PROXYFLY_LIST | sort | uniq)
AMOUNT_RAW=$(echo "$LIST_RAW" | wc -l)
TIMEOUT=2
FILE_SAVE=/etc/proxychains.conf
echo "Loaded $AMOUNT_RAW not tested proxies"
echo "[ProxyList]" > /etc/proxychains.conf

test_list() {
  HOST_REAL=$(curl -s -m $TIMEOUT -x $i $PROXYFLY_TARGET)
  HOST_LIST=$(echo $i | awk -F: '{print $2}' | sed 's/\/\///g')
  if [ "$HOST_LIST" == "$HOST_REAL" ]; then
    echo $i | sed -e 's/\:/ /g' | sed -e 's/https/http/g' | sed -e 's/\/\///g' >> $FILE_SAVE
    echo "$(($(wc -l < $FILE_SAVE) - 1)) $i"
  fi
}

for i in $LIST_RAW
do
  test_list $i &
done
wait
END_TIME=$(date +%s)
echo "Done in $(echo "($END_TIME-$START_TIME)" | bc) seconds"
echo "Tested $AMOUNT_RAW hosts, found echo $(($(wc -l < $FILE_SAVE) - 1)) working hosts"
