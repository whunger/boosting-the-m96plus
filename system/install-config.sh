#!/system/bin/sh

busybox tar xzvf files-config.tgz -C $1

chmod 644 $1/build.prop
chmod 755 $1/media
chmod 644 $1/media/bootanimation.zip
chmod 755 $1/xbin
chmod 755 $1/xbin/sleepd
chmod 644 $1/etc/security/cacerts/*

chown 0:0 $1/build.prop
chown 0:0 $1/media
chown 0:0 $1/media/bootanimation.zip
chown 0:2000 $1/xbin
chown 0:0 $1/xbin/sleepd
chown 0:0 $1/etc/security/cacerts/*
