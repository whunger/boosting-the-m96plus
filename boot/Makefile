all: boot-patched.img

include bootimage.mk

boot-fbc2cc2.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/boot.img"
	mv boot.img boot-fbc2cc2.img

boot-6b96172.img:
	unzip -j ../M96_KK_2015-11-29_19-41_dev_6b96172_eng.zip "M96_2015-11-29_19-41_dev_6b96172_eng/Profiles/MX6SL Linux Update/OS Firmware/files/android/boot.img"
	mv boot.img boot-6b96172.img

unpacked/boot-fbc2cc2.img-ramdisk.gz: boot-fbc2cc2.img
	test -e unpacked || mkdir unpacked
	../tools/mkbootimg/unpackbootimg -i boot-fbc2cc2.img -o unpacked

unpacked/boot-6b96172.img-ramdisk.gz: boot-6b96172.img
	test -e unpacked || mkdir unpacked
	../tools/mkbootimg/unpackbootimg -i boot-6b96172.img -o unpacked

ramdisk-fbc2cc2: unpacked/boot-fbc2cc2.img-ramdisk.gz
	rm -rf ramdisk-fbc2cc2 && mkdir ramdisk-fbc2cc2
	zcat unpacked/boot-fbc2cc2.img-ramdisk.gz | ( cd ramdisk-fbc2cc2; cpio -i )

ramdisk-6b96172: unpacked/boot-6b96172.img-ramdisk.gz
	rm -rf ramdisk-6b96172 && mkdir ramdisk-6b96172
	zcat unpacked/boot-6b96172.img-ramdisk.gz | ( cd ramdisk-6b96172; cpio -i )

ramdisk-patched.gz: ramdisk-fbc2cc2 ramdisk-changes $(shell find ramdisk-changes/ -type f) Makefile
	rm -rf ramdisk-patched
	cp -a ramdisk-fbc2cc2 ramdisk-patched
	cp -r ramdisk-changes/* ramdisk-patched/
	( cd ramdisk-patched; find | sort | cpio --quiet -o -H newc ) | gzip > ramdisk-patched.gz
	rm -rf ramdisk-patched

ramdisk-patched-mtp.gz: ramdisk-fbc2cc2 ramdisk-changes-mtp $(shell find ramdisk-changes-mtp/ -type f) Makefile
	rm -rf ramdisk-patched-mtp
	cp -a ramdisk-fbc2cc2 ramdisk-patched-mtp
	cp -r ramdisk-changes-mtp/* ramdisk-patched-mtp/
	( cd ramdisk-patched-mtp; find | sort | cpio --quiet -o -H newc ) | gzip > ramdisk-patched-mtp.gz
	rm -rf ramdisk-patched-mtp

boot-patched.img: ramdisk-patched.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel unpacked/boot-fbc2cc2.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o boot-patched.img

boot-patched-mtp.img: ramdisk-patched-mtp.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel unpacked/boot-fbc2cc2.img-zImage \
	  --ramdisk ramdisk-patched-mtp.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o boot-patched-mtp.img

# No detectable change: vmalloc=64M fbmem=48M
# ok  --cmdline "$(shell cat boot-orig/boot.img-cmdline)" \
# nok --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc consoleblank=0 androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc consoleblank=0 androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc androidboot.hardware=freescale" \
# 4.4.4: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale
# 1.8.2: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off

put-adb: boot-patched.img
	adb shell id | grep -q "uid=0" && (adb push boot-patched.img /dev/block/mmcblk0p1 && adb shell sync) || true
	adb shell id | grep -q "uid=0" || (adb push boot-patched.img /mnt/sdcard/home/ && adb shell 'su -c "dd if=/mnt/sdcard/home/boot-patched.img of=/dev/block/mmcblk0p1 && sync"')

flash: boot-patched.img
	../../platform-tools/fastboot flash boot boot-patched.img

reboot:
	[ -n "$(../../platform-tools/fastboot devices)" ] && ../../platform-tools/fastboot reboot || adb reboot

clean:
	rm -rf boot-fbc2cc2.img boot-fbc2cc2 ramdisk-fbc2cc2
	rm -rf boot-6b96172.img boot-6b96172 ramdisk-6b96172
	rm -rf ramdisk-patched.gz ramdisk-patched-mtp.gz
