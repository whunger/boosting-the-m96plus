#!/system/bin/sh

busybox tar xzvf files-framework.tgz -C $1

chmod 644 $1/framework/framework-res.apk

chown 0:0 $1/framework/framework-res.apk
