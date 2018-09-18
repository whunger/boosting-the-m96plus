#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-config.tgz -C /system

chmod 644 /system/build.prop

chown 0:0 /system/build.prop

mount -o remount,ro /system
