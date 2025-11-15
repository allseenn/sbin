#!/bin/bash
ARC=$1
ROOT_DEV=$2
PART=$3
if [[ -z $ARC || -z $ROOT_DEV ]]; then
  echo "usage: ./restore.sh archivename.gz /dev/sda partitionNumber"
  exit
fi
ROOT_UUID=$(grep " /  " fstab | awk '{print $1}' | sed 's/UUID=//g')
apt install ../xfsdump.deb
#dd if=./boot.sec of=$ROOT_DEV bs=512 count=1
mkfs.xfs -L ROOT -f -m uuid=$ROOT_UUID $ROOT_DEV$PART
sleep 2
mkdir /r
sleep 2
mount $ROOT_DEV$PART /r
gzip -c -d $ARC | xfsrestore - /r
ls /r
mount --bind /dev /r/dev
mount --bind /proc /r/proc
mount --bind /sys /r/sys
echo "grub-install /dev/sdX --force"
chroot /r
umount /r

