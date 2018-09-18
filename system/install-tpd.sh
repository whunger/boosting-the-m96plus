#!/system/bin/sh

mount -o remount,rw /system
busybox tar xzvf files-tpd.tgz -C /system

chmod 644 /system/etc/ts.conf
chmod 644 /system/lib/ts/plugins/median.so
chmod 644 /system/lib/ts/plugins/debounce.so
chmod 644 /system/lib/ts/plugins/skip.so
chmod 644 /system/lib/libts2.so

chown 0:0 /system/etc/ts.conf
chown 0:0 /system/lib/ts/plugins/median.so
chown 0:0 /system/lib/ts/plugins/debounce.so
chown 0:0 /system/lib/ts/plugins/skip.so
chown 0:0 /system/lib/libts2.so

mount -o remount,ro /system
