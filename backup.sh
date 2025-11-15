#!/bin/bash
## Input check
LABEL=$1
if [[ -z $LABEL || $LABEL == "--help" || $LABEL == "-h" ]]; then
	echo "usage: ./backup.sh labelname"
	exit
fi
## VARS set
DATE=`date +%Y%m%d`
cp /etc/fstab .
ROOT_UUID=$(grep " /  " fstab | awk '{print $1}' | sed 's/UUID=//g')
# BOOT_UUID=$(grep " /boot  " fstab | awk '{print $1}' | sed 's/UUID=//g')
BOOT_DEV=$(blkid -U $ROOT_UUID)
## Clean from gabarge
source ./clean.sh
## Copy boot sector
dd if=$BOOT_DEV of=boot.sec bs=512 count=1
## Dump ext4 /boot
#dump -0uf $DATE.$LABEL.dump $BOOT_DEV
## Dump xfs /
xfsdump -L $LABEL -M root -J - / | pigz -6 > $DATE.$LABEL.gz
