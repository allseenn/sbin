#!/bin/bash
git clone https://github.com/allseenn/$1.git /mnt/backup/github/$1
echo "alias $1='cd /mnt/backup/github/$1' # переходим в папку $1" >> /usr/local/sbin/.bashrc.d/dirs.sh
. /usr/local/sbin/.bashrc.d/dirs.sh                           
. /usr/local/sbin/.bashrc.d/apps.sh

