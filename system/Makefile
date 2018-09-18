all: install-supersu install-tpd install-config

files-supersu.tgz: files-supersu $(shell find files-supersu/ -type f)
	tar czvf files-supersu.tgz -C files-supersu .

files-tpd.tgz: files-tpd $(shell find files-tpd/ -type f)
	tar czvf files-tpd.tgz -C files-tpd .

files-config.tgz: files-config $(shell find files-config/ -type f)
	tar czvf files-config.tgz -C files-config .

install-supersu: install-supersu.sh files-supersu.tgz
	adb push install-supersu.sh files-supersu.tgz /mnt/sdcard/
	adb shell "cd /mnt/sdcard && su -c 'sh install-supersu.sh'"

install-tpd: install-tpd.sh files-tpd.tgz
	adb push install-tpd.sh files-tpd.tgz /mnt/sdcard/
	adb shell "cd /mnt/sdcard && su -c 'sh install-tpd.sh'"

install-config: install-config.sh files-config.tgz
	adb push install-config.sh files-config.tgz /mnt/sdcard/
	adb shell "cd /mnt/sdcard && su -c 'sh install-config.sh'"

system.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/system.img"

system-orig: system.img
	mkdir system-orig
	sudo debugfs -R "rdump / system-orig" system.img

system-current.tgz:
	./get-system

system.list: system.tgz
	tar tzvf system.tgz --numeric-owner > system.list

system-current.list: system-current.tgz
	tar tzvf system-current.tgz --numeric-owner > system-current.list
	# adb shell "busybox find /system -type f | while read f; do echo \$(busybox md5sum \$f) \$f; done"

compare: system.list system-current.list
	diff system.list system-current.list || true

changes.list:
	(cd changes; find . -type f | sed -e "s/^\./ ./"; find . -type d | sed -e 1d | while read d; do echo " $$d/\$$"; done ) > changes.list

system.tgz: system.img
	mkdir mp
	sudo mount -o ro system.img mp/
	sudo tar czvf - -C mp . > system.tgz
	sudo umount mp
	rmdir mp

clean:
	rm -rf system.img system-current.img system-orig system-current
	rm -rf files-config.tgz files-supersu.tgz files-tpd.tgz
