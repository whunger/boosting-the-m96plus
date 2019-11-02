all: system-patched-img

include systemimage.mk

system.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/system.img"

files-supersu.tgz: files-supersu $(shell find files-supersu/ -type f)
	tar czvf files-supersu.tgz -C files-supersu .

files-tpd.tgz: files-tpd $(shell find files-tpd/ -type f)
	tar czvf files-tpd.tgz -C files-tpd .

files-config.tgz: files-config $(shell find files-config/ -type f) files-config/media/bootanimation.zip
	tar czvf files-config.tgz -C files-config .

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
	sudo umount target
	e2fsck -f system-patched.img
	resize2fs -M system-patched.img

clean:
	rm -rf system.img system-current.img system-current system-patched.img
	sudo rm -rf system-orig
	rm -rf files-config.tgz files-supersu.tgz files-tpd.tgz
	rm -rf bootanimation-825 bootanimation-1080
