#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-config.tgz -C /system

chmod 644 /system/build.prop
chmod 644 /system/media/bootanimation.zip
chmod 755 /system/xbin/sleepd

chown 0:0 /system/build.prop
chown 0:0 /system/media/bootanimation.zip
chown 0:0 /system/xbin/sleepd

mount -o remount,ro /system

stop sleepd && start sleepd
