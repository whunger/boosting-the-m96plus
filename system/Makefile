export ANDROID_SERIAL=0123456789ABCDEF

all: system-patched.img system-patched-mtp.img

include systemimage.mk

files-supersu.tgz: files-supersu $(shell find files-supersu/ -type f)
	tar czvf files-supersu.tgz -C files-supersu .

files-tpd.tgz: files-tpd $(shell find files-tpd/ -type f)
	tar czvf files-tpd.tgz -C files-tpd .

framework-res.apk: system.img
	test -d mp || mkdir mp
	sudo mount -o ro system.img mp
	cp mp/framework/framework-res.apk .
	sudo umount mp
	rmdir mp

files-config/framework/framework-res.apk: framework-res.apk files-config
	# See https://www.mobileread.com/forums/showpost.php?s=5d3d4f537ed8d2d3f8e7282bab483ced&p=3398726&postcount=14
	rm -rf fw framework-res
	../tools/apktool install-framework --frame-path fw framework-res.apk
	../tools/apktool decode --frame-path fw framework-res.apk
	# Remove forced bold font for all elements
	sed --in-place -e 3d framework-res/res/raw/webview_contrast_enchanced.css
	../tools/apktool build framework-res
	unzip -o framework-res.apk META-INF/* AndroidManifest.xml -d framework-res/build/apk/
	../tools/apktool build framework-res
	mkdir -p files-config/framework
	cp framework-res/dist/framework-res.apk files-config/framework
	rm -rf fw framework-res

files-config.tgz: files-config $(shell find files-config/ -type f) files-config/media/bootanimation.zip
	tar czvf files-config.tgz -C files-config .

files-mtp.tgz: files-mtp $(shell find files-mtp/ -type f)
	tar czvf files-mtp.tgz -C files-mtp .

install-supersu: install-supersu.sh files-supersu.tgz
	adb push install-supersu.sh files-supersu.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell -n "cd /mnt/sdcard && su -c 'sh install-supersu.sh /system; rm install-supersu.sh files-supersu.tgz'"
	adb shell -n "su -c 'mount -o remount,ro /system'"

install-tpd: install-tpd.sh files-tpd.tgz
	adb push install-tpd.sh files-tpd.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell -n "cd /mnt/sdcard && su -c 'sh install-tpd.sh /system; rm install-tpd.sh files-tpd.tgz'"
	adb shell -n "su -c 'mount -o remount,ro /system'"
	adb shell -n "su -c 'stop onyx_tpd && start onyx_tpd'"

install-config: install-config.sh files-config.tgz
	adb push install-config.sh files-config.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell -n "cd /mnt/sdcard && su -c 'sh install-config.sh /system; rm install-config.sh files-config.tgz'"
	adb shell -n "su -c 'mount -o remount,ro /system'"
	adb shell -n "su -c 'stop sleepd && start sleepd'"

put-adb: install-supersu install-tpd install-config

system-patched.img: system.img install-config.sh files-config.tgz install-tpd.sh files-tpd.tgz install-supersu.sh files-supersu.tgz
	test -d target || mkdir target
	cp system.img system-patched.img
	sudo mount system-patched.img target
	sudo sh install-config.sh target
	sudo sh install-tpd.sh target
	sudo sh install-supersu.sh target
	sudo rm target/etc/security/otacerts.zip
	sudo umount target
	rmdir target
	e2fsck -f system-patched.img
	resize2fs -M system-patched.img
	e2fsck -f -y system-patched.img || exit 0

system-patched-mtp.img: system-patched.img install-mtp.sh files-mtp.tgz
	cp system-patched.img system-patched-mtp.img
	resize2fs system-patched-mtp.img 600M
	test -d target || mkdir target
	sudo mount system-patched-mtp.img target
	sudo sh install-mtp.sh target
	sudo umount target
	rmdir target
	e2fsck -f system-patched-mtp.img
	resize2fs -M system-patched-mtp.img
	e2fsck -f -y system-patched-mtp.img || exit 0

clean:
	rm -f system.img system.tgz system.list
	sudo rm -rf system-orig
	rm -rf system-current.img system-current system-current.tgz system-current.list
	rm -f changes.list
	rm -f system-patched.img system-patched-mtp.img
	rm -f files-config.tgz files-config-mtp.tgz files-supersu.tgz files-tpd.tgz
	rm -rf bootanimation-825 bootanimation-1080
	rm -f framework-res.apk
