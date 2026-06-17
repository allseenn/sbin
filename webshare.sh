#!/usr/bin/env bash
## Скрипт выводит список прокси WebShare.io и username:password
. $(dirname $0)/$(basename "${0%.*}.env")

curl "https://proxy.webshare.io/api/v2/proxy/list/?mode=direct&page=1&page_size=25" \
  -H "Authorization: Token $APIKEY" | jq '.results[] | {country_code, city_name, proxy_address, port, username, password}'