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
for binary in mount umount mkdir blkid rm gzip cpio
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
    echo "$partition is mounted, unmounting ..."
    adb shell -n "umount $partition"
fi
if adb shell -n "mount" | grep -q /mnt/target
then
    echo "/mnt/target is mounted, unmounting ..."
    adb shell -n "umount /mnt/target"
fi
	
adb shell -n "mkdir -p /mnt/target"
if adb shell -n "blkid" | grep -q -E "$partition:.*TYPE=\"vfat\""
then
    adb shell -n "mount -t vfat -o shortname=mixed,utf8 $partition /mnt/target"
else
    adb shell -n "mount $partition /mnt/target"
fi
echo "Removing files from filesystem on $partition ..."
adb shell -n "rm -rf /mnt/target/*"
echo "Restoring files from $filename to filesystem on $partition ..."
case "$filename" in
*.cpio.gz)
    adb exec-in "cd /mnt/target ; gzip -c -d | cpio -i -m" < $filename
    ;;
*.tar.gz | *.tgz)
    adb exec-in "tar x -z -f - -C /mnt/target" < $filename
    ;;
*.zip)
    make -C ../../setup files/busybox
	adb push ../../setup/files/busybox /tmp/unzip
    adb exec-in "/tmp/unzip - -d /mnt/target/" < $filename
    ;;
esac
adb shell -n "sync"
adb shell -n "umount /mnt/target"
