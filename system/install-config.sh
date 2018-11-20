#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-config.tgz -C /system

chmod 644 /system/build.prop
chmod 644 /system/media/bootanimation.zip
chmod 755 /system/xbin/sleepd
chmod 755 /system/xbin/enable-discard
chmod 755 /system/xbin/mount.static

chown 0:0 /system/build.prop
chown 0:0 /system/media/bootanimation.zip
chown 0:0 /system/xbin/sleepd
chown 0:0 /system/xbin/enable-discard
chown 0:0 /system/xbin/mount.static

#mount -o remount,ro /system

stop sleepd && start sleepd
