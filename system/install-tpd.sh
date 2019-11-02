#!/system/bin/sh

tar xzvf files-tpd.tgz -C $1

chmod 755 $1/etc
chmod 644 $1/etc/ts.conf
chmod 755 $1/lib
chmod 755 $1/lib/ts
chmod 755 $1/lib/ts/plugins
chmod 644 $1/lib/ts/plugins/median.so
chmod 644 $1/lib/ts/plugins/debounce.so
chmod 644 $1/lib/ts/plugins/skip.so
chmod 644 $1/lib/libts2.so

chown 0:0 $1/etc
chown 0:0 $1/etc/ts.conf
chown 0:0 $1/lib
chown 0:0 $1/lib/ts
chown 0:0 $1/lib/ts/plugins
chown 0:0 $1/lib/ts/plugins/median.so
chown 0:0 $1/lib/ts/plugins/debounce.so
chown 0:0 $1/lib/ts/plugins/skip.so
chown 0:0 $1/lib/libts2.so

