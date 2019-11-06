#!/system/bin/sh

tar xzvf files-mtp.tgz -C $1

chmod 644 $1/build.prop
chown 0:0 $1/build.prop
