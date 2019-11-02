#!/bin/bash

test -e data || mkdir data
adb shell -n "sfdisk -d /dev/block/mmcblk0" > data/partitions.sfdisk
adb shell -n "blkid" > data/blkid

cut -d: -f1 data/partitions.sfdisk | grep /dev/block | while read partition
do
    if grep -q -E "$partition:.*TYPE=\"(ext4|vfat)\"" data/blkid
    then
        filename=data/${partition#/dev/block/}.cpio.gz
        bash ./backup-filesystem.sh $partition $filename
    else
        filename=data/${partition#/dev/block/}.img.gz
        bash ./backup-partition.sh $partition $filename
    fi
done
