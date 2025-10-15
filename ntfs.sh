#!/usr/bin/env bash

NTFS_DEV=$(sudo blkid -L BACKUP)
sudo ntfsfix $NTFS_DEV
sudo umount $NTFS_DEV
sudo mount $NTFS_DEV
