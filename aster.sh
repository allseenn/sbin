#!/bin/bash
# script controls balance and spends some mony to avoid blocking sim-card
HOST=$1
DONGLE=$2
ACTION=$3

if  [ -z "$HOST" ] || [ -z "$DONGLE" ] || [ -z "$ACTION" ]; then
    echo "usage: aster.sh HOST DONGLE ACTION"
    echo "HOST host from .ssh/config"
    echo "DONGLE phone DONGLE without +"
    echo "ACTION: balance|sms|call"
    return 1
fi

if [ "$ACTION" = "balance" ]; then
    ssh $HOST "asterisk -rx 'dongle ussd $DONGLE *102#'"
    echo "balance will be in telegram channel aster"
elif [ "$ACTION" = "sms" ]; then
    ssh $HOST "asterisk -rx 'dongle sms $DONGLE 8${DONGLE:1} antiblock'"
    echo "sms will be in send to telegram channel aster"
fi