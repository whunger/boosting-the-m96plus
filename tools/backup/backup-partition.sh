#!/bin/bash

partition=$1
filename=$2

if ! adb shell -n id | grep -q uid=0
then
    echo <<EOF
Adbd must be run as root to use this script. Use `adb reboot recovery` to
boot into recovery mode or boot the setup system using fastboot.
EOF
    exit 1
fi

# First unmount if mounted
if adb shell -n "mount" | grep -q $partition
then
    echo $partition is mounted, unmounting ...
    adb shell -n "umount $partition"
fi

echo "Backing up partition $partition to $filename ..."
if adb shell -n "blkid" | grep -q -E "$partition:.*TYPE=\"ext.\""
then
    imgname=${filename%.gz}
    adb exec-out "gzip -1 < $partition" | gzip -cd > $imgname
    e2fsck -f -y $imgname
    resize2fs -M $imgname
    gzip $imgname
else
    adb exec-out "gzip -1 < $partition" > $filename
fi
