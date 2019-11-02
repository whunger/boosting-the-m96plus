#!/system/bin/sh

tar xzvf files-supersu.tgz -C $1

chmod 755 $1/bin/
chmod 755 $1/bin/busybox
chmod 711 $1/bin/.ext/
chmod 755 $1/bin/.ext/.su
chmod 755 $1/etc
chmod 666 $1/etc/.installed_su_daemon
chmod 755 $1/lib
chmod 644 $1/lib/libsupol.so
chmod 755 $1/xbin
chmod 755 $1/xbin/su
chmod 755 $1/xbin/daemonsu
chmod 755 $1/xbin/sugote
chmod 755 $1/xbin/sugote-mksh
chmod 755 $1/xbin/.tmpsu
chmod 755 $1/xbin/supolicy
chmod 755 $1/xbin/daemonsu_old

chown 0:2000 $1/bin/
chown 0:1000 $1/bin/busybox
chown 0:0 $1/bin/.ext/
chown 0:0 $1/bin/.ext/.su
chown 0:0 $1/etc
chown 0:0 $1/etc/.installed_su_daemon
chown 0:0 $1/lib
chown 0:0 $1/lib/libsupol.so
chown 0:2000 $1/xbin
chown 0:0 $1/xbin/su
chown 0:0 $1/xbin/daemonsu
chown 0:0 $1/xbin/sugote
chown 0:0 $1/xbin/sugote-mksh
chown 0:0 $1/xbin/.tmpsu
chown 0:0 $1/xbin/supolicy
chown 0:0 $1/xbin/daemonsu_old
chown -h 0:2000 $1/bin/install-recovery.sh
