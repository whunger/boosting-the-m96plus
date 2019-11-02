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
for binary in mount umount mkdir blkid find gzip cpio
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
if adb shell -n "mount" | grep -q /mnt/src
then
    echo "/mnt/src is mounted, unmounting ..."
    adb shell -n "umount /mnt/src"
fi

adb shell -n "mkdir -p /mnt/src"
if adb shell -n "blkid" | grep -q -E "$partition:.*TYPE=\"vfat\""
then
    adb shell -n "mount -t vfat -o ro,shortname=mixed,utf8 $partition /mnt/src"
else
    adb shell -n "mount -o ro $partition /mnt/src"
fi
echo "Backing up filesystem on $partition to $filename ..."
case "$filename" in
*.cpio.gz)
    adb exec-out "cd /mnt/src ; find . | cpio -o -H newc | gzip -c -1" > $filename
    ;;
*.tar.gz | *.tgz)
    adb exec-out "tar c -z -f - -C /mnt/src" > $filename
    ;;
*.zip)
    echo "*.zip creation is not yet supported :-("
    ;;
esac
adb shell -n "sync"
adb shell -n "umount /mnt/src"
