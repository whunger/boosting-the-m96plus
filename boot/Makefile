all: boot-patched.img

boot.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/boot.img"

boot-orig: boot.img
	mkdir boot-orig
	../tools/mkbootimg/unpackbootimg -i boot.img -o boot-orig

ramdisk-orig: boot-orig
	rm -rf ramdisk-orig && mkdir ramdisk-orig
	zcat boot-orig/boot.img-ramdisk.gz | ( cd ramdisk-orig; cpio -i )

ramdisk-patched.gz: ramdisk-orig ramdisk-changes $(shell find ramdisk-changes/ -type f) Makefile
	rm -rf ramdisk-patched
	cp -a ramdisk-orig ramdisk-patched
	cp -r ramdisk-changes/* ramdisk-patched/
	( cd ramdisk-patched; find | sort | cpio --quiet -o -H newc ) | gzip > ramdisk-patched.gz

boot-patched.img: boot-orig ramdisk-patched.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel boot-orig/boot.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o boot-patched.img

# ok  --cmdline "$(shell cat boot-orig/boot.img-cmdline)" \
# nok --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc androidboot.hardware=freescale" \
# 4.4.4: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale
# 1.8.2: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off

test: boot-orig boot-patched.img
	rm -rf boot-patched; mkdir boot-patched
	../tools/mkbootimg/unpackbootimg -i boot-patched.img -o boot-patched
	bash -c '(cd boot-patched; for f in boot-patched.img-*; do echo $$f; mv $$f $${f/-patched/}; done)'
	diff -r boot-orig/ boot-patched/ || exit 0
	(cd boot-orig; ls -lR --time-style=+) > test-orig
	(cd boot-patched; ls -lR --time-style=+) > test-patched
	diff test-orig test-patched; rm test-orig test-patched
	rm -rf ramdisk-test; mkdir ramdisk-test
	zcat boot-patched/boot.img-ramdisk.gz | ( cd ramdisk-test; cpio -i )
	(cd ramdisk-orig; ls -lR --time-style=+) > test-orig
	(cd ramdisk-test; ls -lR --time-style=+) > test-patched
	rm -rf ramdisk-test
	rm -rf boot-patched
	diff test-orig test-patched; rm test-orig test-patched

clean:
	rm -rf boot-orig ramdisk-orig ramdisk-patched ramdisk-patched.gz

put-adb: boot-patched.img
	adb shell id | grep -q "uid=0" && (adb push boot-patched.img /dev/block/mmcblk0p1 && adb shell sync) || true
	adb shell id | grep -q "uid=0" || (adb push boot-patched.img /mnt/sdcard/home/ && adb shell 'su -c "dd if=/mnt/sdcard/home/boot-patched.img of=/dev/block/mmcblk0p1 && sync"')

flash: boot-patched.img
	../../platform-tools/fastboot flash boot boot-patched.img

reboot:
	[ -n "$(../../platform-tools/fastboot devices)" ] && ../../platform-tools/fastboot reboot || adb reboot
