#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-supersu.tgz -C /system

chmod 755 /system/bin/busybox
chmod 711 /system/bin/.ext/
chmod 755 /system/bin/.ext/.su
chmod 666 /system/etc/.installed_su_daemon
chmod 644 /system/lib/libsupol.so
chmod 755 /system/xbin/su
chmod 755 /system/xbin/daemonsu
chmod 755 /system/xbin/sugote
chmod 755 /system/xbin/sugote-mksh
chmod 755 /system/xbin/.tmpsu
chmod 755 /system/xbin/supolicy
chmod 755 /system/xbin/daemonsu_old

chown 0:1000 /system/bin/busybox
chown 0:0 /system/bin/.ext/
chown 0:0 /system/bin/.ext/.su
chown 0:0 /system/etc/.installed_su_daemon
chown 0:0 /system/lib/libsupol.so
chown 0:0 /system/xbin/su
chown 0:0 /system/xbin/daemonsu
chown 0:0 /system/xbin/sugote
chown 0:0 /system/xbin/sugote-mksh
chown 0:0 /system/xbin/.tmpsu
chown 0:0 /system/xbin/supolicy
chown 0:0 /system/xbin/daemonsu_old

#mount -o remount,ro /system
