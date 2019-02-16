all: recovery-twrp.img

twrp.img:
	curl -o twrp.img 'https://eu.dl.twrp.me/twrp/twrp-3.2.1-0-twrp.img' --compressed -H 'Referer: https://eu.dl.twrp.me/twrp/twrp-3.2.1-0-twrp.img.html' -H 'DNT: 1' -H 'Upgrade-Insecure-Requests: 1'

recovery.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/recovery.img"

recovery-orig: recovery.img
	mkdir recovery-orig
	../tools/mkbootimg/unpackbootimg -i recovery.img -o recovery-orig || (rmdir recovery-orig && exit 1)

recovery-twrp: twrp.img
	rm -rf recovery-twrp && mkdir recovery-twrp
	../tools/mkbootimg/unpackbootimg -i twrp.img -o recovery-twrp || (rmdir recovery-twrp && exit 1)

ramdisk-orig: recovery-orig/recovery.img-ramdisk.gz
	rm -rf ramdisk-orig && mkdir ramdisk-orig
	zcat recovery-orig/recovery.img-ramdisk.gz | ( cd ramdisk-orig; cpio -i )

ramdisk-twrp: recovery-twrp
	rm -rf ramdisk-twrp && mkdir ramdisk-twrp
	zcat recovery-twrp/twrp.img-ramdisk.gz | ( cd ramdisk-twrp; cpio -i )

ramdisk-patched.gz: ramdisk-orig ramdisk-twrp Makefile
	rm -rf ramdisk-patched
	cp -a ramdisk-orig ramdisk-patched
	sed -e "s/ro.secure=1/ro.secure=0/" -e "s/ro.debuggable=0/ro.debuggable=1/" < ramdisk-orig/default.prop > ramdisk-patched/default.prop
	( cd ramdisk-patched/sbin; mv recovery _recovery; mv healthd _healthd )
	cp -r ramdisk-twrp/sbin/* ramdisk-patched/sbin/
	( cd ramdisk-patched/sbin; mv _recovery recovery; mv _healthd healthd )
	( cd ramdisk-patched; find | sort | cpio --quiet -o -H newc ) | gzip > ramdisk-patched.gz

recovery-twrp.img: recovery-orig ramdisk-patched.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel recovery-orig/recovery.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o recovery-twrp.img

clean:
	rm -rf recovery-orig recovery-twrp ramdisk-orig ramdisk-twrp ramdisk-patched ramdisk-patched.gz

put-adb: recovery-twrp.img
	adb shell id | grep -q "uid=0" && (adb push recovery-twrp.img /dev/block/mmcblk0p2 && adb shell sync) || true
	adb shell id | grep -q "uid=0" || (adb push recovery-twrp.img /mnt/sdcard/home/ && adb shell 'su -c "dd if=/mnt/sdcard/home/recovery-twrp.img of=/dev/block/mmcblk0p2 && sync"')

flash: recovery-twrp.img
	../platform-tools/fastboot flash recovery recovery-twrp.img

reboot:
	[ -n "$(../../platform-tools/fastboot devices)" ] && ../../platform-tools/fastboot reboot || adb reboot
