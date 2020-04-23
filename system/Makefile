all: system-patched.img system-patched-mtp.img

include systemimage.mk

files-supersu.tgz: files-supersu $(shell find files-supersu/ -type f)
	tar czvf files-supersu.tgz -C files-supersu .

files-tpd.tgz: files-tpd $(shell find files-tpd/ -type f)
	tar czvf files-tpd.tgz -C files-tpd .

files-config.tgz: files-config $(shell find files-config/ -type f) files-config/media/bootanimation.zip
	tar czvf files-config.tgz -C files-config .

files-mtp.tgz: files-mtp $(shell find files-mtp/ -type f)
	tar czvf files-mtp.tgz -C files-mtp .

install-supersu: install-supersu.sh files-supersu.tgz
	adb push install-supersu.sh files-supersu.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell "cd /mnt/sdcard && su -c 'sh install-supersu.sh /system; rm install-supersu.sh files-supersu.tgz'"
	adb shell "su -c 'mount -o remount,ro /system'"

install-tpd: install-tpd.sh files-tpd.tgz
	adb push install-tpd.sh files-tpd.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell -n "cd /mnt/sdcard && su -c 'sh install-tpd.sh /system; rm install-tpd.sh files-tpd.tgz'"
	adb shell -n "su -c 'mount -o remount,ro /system'"
	adb shell -n "stop onyx_tpd && start onyx_tpd"

install-config: install-config.sh files-config.tgz
	adb push install-config.sh files-config.tgz /mnt/sdcard/
	adb shell -n "su -c 'mount -o remount,rw /system'"
	adb shell -n "cd /mnt/sdcard && su -c 'sh install-config.sh /system; rm install-config.sh files-config.tgz'"
	adb shell -n "su -c 'mount -o remount,ro /system'"
	adb shell -n "stop sleepd && start sleepd"

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
	rm -rf system.img system.tgz system.list
	sudo rm -rf system-orig
	rm -rf system-current.img system-current system-current.tgz system-current.list
	rm -rf changes.list
	rm -rf system-patched.img system-patched-mtp.img
	rm -rf files-config.tgz files-config-mtp.tgz files-supersu.tgz files-tpd.tgz
	rm -rf bootanimation-825 bootanimation-1080
