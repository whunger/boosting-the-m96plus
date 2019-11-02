all: recovery-twrp.img

twrp.img:
	#curl -o twrp.img 'https://eu.dl.twrp.me/twrp/twrp-3.2.1-0-twrp.img' --compressed -H 'Referer: https://eu.dl.twrp.me/twrp/twrp-3.2.1-0-twrp.img.html' -H 'DNT: 1' -H 'Upgrade-Insecure-Requests: 1'
	curl -o twrp.img 'https://eu.dl.twrp.me/twrp/twrp-3.3.1-0-twrp.img' --compressed -H 'Referer: https://eu.dl.twrp.me/twrp/twrp-3.3.1-0-twrp.img.html' -H 'DNT: 1' -H 'Upgrade-Insecure-Requests: 1'

recovery.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/recovery.img"

recovery-orig: recovery.img
	mkdir recovery-orig
	../tools/mkbootimg/unpackbootimg -i recovery.img -o recovery-orig || (rmdir recovery-orig && exit 1)

recovery-twrp: twrp.img
	rm -rf recovery-twrp && mkdir recovery-twrp
	../tools/mkbootimg/unpackbootimg -i twrp.img -o recovery-twrp || (rmdir recovery-twrp && exit 1)

recovery-M6: ../../android_M6.0.1_2.1.0_image_6slevk/SD/recovery-imx6sl.img
	mkdir recovery-M6
	../tools/mkbootimg/unpackbootimg -i ../../android_M6.0.1_2.1.0_image_6slevk/SD/recovery-imx6sl.img -o recovery-M6 || (rmdir recovery-M6 && exit 1)

ramdisk-orig: recovery-orig
	rm -rf ramdisk-orig && mkdir ramdisk-orig
	zcat recovery-orig/recovery.img-ramdisk.gz | ( cd ramdisk-orig; cpio -i )

ramdisk-twrp: recovery-twrp
	rm -rf ramdisk-twrp && mkdir ramdisk-twrp
	zcat recovery-twrp/twrp.img-ramdisk.gz | ( cd ramdisk-twrp; cpio -i )

ramdisk-M6: recovery-M6
	rm -rf ramdisk-M6 && mkdir ramdisk-M6
	zcat recovery-M6/recovery-imx6sl.img-ramdisk.gz | ( cd ramdisk-M6; cpio -i )

ramdisk-changes/busybox-armv7l:
	curl -o ramdisk-changes/busybox-armv7l 'https://busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-armv7l'

ramdisk-patched-twrp.gz: ramdisk-orig ramdisk-twrp Makefile ramdisk-changes/*
	rm -rf ramdisk-patched-twrp
	cp -a ramdisk-orig ramdisk-patched-twrp
	sed -e "s/ro.secure=1/ro.secure=0/" -e "s/ro.debuggable=0/ro.debuggable=1/" < ramdisk-orig/default.prop > ramdisk-patched-twrp/default.prop
	( cd ramdisk-patched-twrp/sbin; mv recovery _recovery; mv healthd _healthd )
	cp -r ramdisk-twrp/sbin/* ramdisk-patched-twrp/sbin/
	cp ramdisk-changes/busybox-armv7l ramdisk-patched-twrp/sbin/busybox
	chmod 750 ramdisk-patched-twrp/sbin/busybox
	cp ramdisk-changes/sfdisk ramdisk-patched-twrp/sbin/sfdisk
	chmod 750 ramdisk-patched-twrp/sbin/sfdisk
	( cd ramdisk-patched-twrp/sbin; mv _recovery recovery; mv _healthd healthd )
	( cd ramdisk-patched-twrp; find | sort | cpio --quiet -o -H newc ) | gzip > ramdisk-patched-twrp.gz

ramdisk-patched.gz: ramdisk-orig ramdisk-twrp Makefile ramdisk-changes/*
	make -C ../setup ramdisk-orig
	rm -rf ramdisk-patched
	cp -a ramdisk-orig ramdisk-patched
	cp ramdisk-changes/default.prop ramdisk-patched/
	cp ramdisk-changes/init.rc ramdisk-patched/
	cp -r ../setup/ramdisk-orig/sbin/* ramdisk-patched/sbin/
	cp -r ../setup/ramdisk-orig/bin ramdisk-patched/
	cp -r ../setup/ramdisk-orig/etc/* ramdisk-patched/etc/
	cp -r ../setup/ramdisk-orig/lib ramdisk-patched/
	cp -r ../setup/ramdisk-orig/usr ramdisk-patched/
	cp -r ../setup/ramdisk-orig/var ramdisk-patched/
	cp ramdisk-twrp/sbin/adbd ramdisk-patched/sbin/
	( cd ramdisk-patched; find | sort | cpio --quiet -o -H newc --owner=+0:+0) | gzip > ramdisk-patched.gz

recovery-twrp.img: recovery-orig ramdisk-patched-twrp.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel recovery-orig/recovery.img-zImage \
	  --ramdisk ramdisk-patched-twrp.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o recovery-twrp.img

recovery-patched.img: recovery-orig ramdisk-patched.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel recovery-orig/recovery.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o recovery-patched.img

clean:
	rm -rf recovery.img recovery-orig ramdisk-orig
	rm -rf twrp.img recovery-twrp ramdisk-twrp
	rm -rf recovery-M6 ramdisk-M6
	rm -rf ramdisk-patched ramdisk-patched.gz
	rm -rf ramdisk-patched-twrp ramdisk-patched-twrp.gz

put-adb: recovery-twrp.img
	adb shell id | grep -q "uid=0" && (adb push recovery-twrp.img /dev/block/mmcblk0p2 && adb shell sync) || true
	adb shell id | grep -q "uid=0" || (adb push recovery-twrp.img /mnt/sdcard/home/ && adb shell 'su -c "dd if=/mnt/sdcard/home/recovery-twrp.img of=/dev/block/mmcblk0p2 && sync"')

flash: recovery-twrp.img
	../../platform-tools/fastboot flash recovery recovery-twrp.img

boot-twrp: recovery-twrp.img
	echo "Hold [>] button while switching on the device to enter Fastboot mode"
	../../platform-tools/fastboot boot recovery-twrp.img
	until adb devices | grep -q 0123456789ABCDEF; do echo Waiting for adbd to respond ...; sleep 3; done

boot-patched: recovery-patched.img
	echo "Hold [>] button while switching on the device to enter Fastboot mode"
	../../platform-tools/fastboot boot recovery-patched.img
	until adb devices | grep -q 0123456789ABCDEF; do echo Waiting for adbd to respond ...; sleep 3; done

reboot:
	[ -n "$(../../platform-tools/fastboot devices)" ] && ../../platform-tools/fastboot reboot || adb reboot
