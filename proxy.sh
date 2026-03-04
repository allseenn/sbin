#!/usr/bin/env bash
. $(dirname $0)/.env
LIST=$(curl -sL $PROXY_LIST_RU | sed -e 's/\:/ /g' | sed -e 's/https/http/g' | sed -e 's/\/\///g')
sudo bash -c "cat << EOF > /etc/proxychains.conf
[ProxyList]
$LIST
EOF"
