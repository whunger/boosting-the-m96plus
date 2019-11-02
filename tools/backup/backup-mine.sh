#!/bin/bash

test -e data || mkdir data
adb shell -n "sfdisk -d /dev/block/mmcblk0" > data/partitions.sfdisk
adb shell -n "blkid" > data/blkid

while read partition filename
do
    if [[ -e $filename ]]
    then
        echo Skipping $partition, $filename exists.
    else
        case "$filename" in
        \#*)
            continue
            ;;
        *.img.gz)
            bash ./backup-partition.sh $partition $filename
            ;;
        *.cpio.gz | *.tar.gz | *.tgz | *.zip)
            bash ./backup-filesystem.sh $partition $filename
            ;;
        *)
            echo "Unknown backup file type, skipping $partition!"
            ;;
        esac
    fi
done <<"EOF"
#/dev/block/mmcblk0p1    data/boot.img.gz
#/dev/block/mmcblk0p2    data/recovery.img.gz
#/dev/block/mmcblk0p4    data/sdcard.img.gz
/dev/block/mmcblk0p4    data/sdcard.cpio.gz
#/dev/block/mmcblk0p5    data/system.img.gz
#/dev/block/mmcblk0p5    data/system.cpio.gz
#/dev/block/mmcblk0p6    data/cache.cpio.gz
#/dev/block/mmcblk0p7    data/data.img.gz
#/dev/block/mmcblk0p7    data/data.cpio.gz
#/dev/block/mmcblk0p8    data/misc.cpio.gz
#/dev/block/mmcblk0p9    data/vendor.img.gz
#/dev/block/mmcblk0p9    data/vendor.cpio.gz
EOF
