#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-config.tgz -C /system

chmod 644 /system/build.prop
chmod 644 /system/media/bootanimation.zip

chown 0:0 /system/build.prop
chown 0:0 /system/media/bootanimation.zip

mount -o remount,ro /system
