#!/bin/bash

filename=$1
partition=$2

if ! adb shell -n id | grep -q uid=0
then
    echo <<EOF
Adbd must be run as root to use this script. Use `adb reboot recovery` to
boot into recovery mode or boot the setup system using fastboot.
EOF
    exit 1
fi
for binary in blkid dd e2fsck resize2fs gzip
do
    if [[ -z "$(adb shell -n \"which $binary\")" ]]
    then
        echo "Unable to find $binary binary in rescue system."
        exit 2
    fi
done

# First unmount if mounted
if adb shell -n "mount" | grep -q $partition
then
    echo $partition is mounted, unmounting ...
    adb shell -n "umount $partition"
fi

if adb shell -n "blkid" | grep -q -E "$partition:.*TYPE=\"ext4\""
then
    adb exec-in "gzip -c -d | dd of=$partition bs=1M" < $filename
    adb shell -n "e2fsck -f -y $partition"
    adb shell -n "resize2fs $partition"
else
    adb exec-in "gzip -c -d | dd of=$partition bs=1M" < $filename
fi
