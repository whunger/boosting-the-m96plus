#!/bin/bash

test -e data || exit

while read filename partition
do
    case "$filename" in
    \#*)
        continue
        ;;
    *.img.gz)
        bash ./restore-partition.sh $filename $partition
        ;;
    *.cpio.gz | *.tar.gz | *.tgz | *.zip)
        bash ./restore-filesystem.sh $filename $partition
        ;;
    *)
        echo "Unknown backup file type, skipping $partition!"
        ;;
    esac
done <<"EOF"
data/sdcard.cpio.gz  /dev/block/mmcblk0p4
data/data.cpio.gz    /dev/block/mmcblk0p7
#data/sdcard.img.gz  /dev/block/mmcblk0p4
#data/data.img.gz    /dev/block/mmcblk0p7
EOF
