#!/usr/bin/bash

DATA=RED
SAVE=WD
DISK=`blkid --label $DATA`
WAY=`mount | grep $(blkid --label $SAVE)| awk '{ print $3 }'`
NAME=$1
DATE=`date +%Y%m%d`

if [[ -z $NAME || $NAME == "--help" || $NAME == "-h" ]]; then
    echo "usage: backup.sh NAME"
    exit
fi
source clean.sh
xfsdump -L $DATA -M root -J - / | pigz -6 > $WAY/backup/$DATE.$NAME.gz

