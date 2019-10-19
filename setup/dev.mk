all: mksdcard-android_fat.sh mksdcard-android_mtp.sh \
	mk-encryptable-data-android_fat.sh mk-encryptable-data-android_mtp.sh \
    content_fat.txt content_mtp.txt \
	ucl2_fat.xml ucl2_mtp.xml

#ramdisk-fbk:
#	rm -rf ramdisk-fbk && mkdir ramdisk-fbk
#	dumpimage -i "kernel/fsl-image-mfgtool-initramfs-imx_mfgtools.cpio.gz.u-boot" -T ramdisk initramfs.gz
#	zcat initramfs.gz | (cd ramdisk-fbk; cpio -i --no-absolute-filenames)
#	#cd ramdisk-fbk && cpio -i --no-absolute-filenames < ../initramfs
#	rm initramfs.gz

#ramdisk-patched: ramdisk-orig ramdisk-fbk
#	rm -rf ramdisk-patched
#	cp -a ramdisk-orig ramdisk-patched
#	touch ramdisk-patched
#	cp ramdisk-fbk/usr/bin/uuc ramdisk-patched/usr/bin/uuc
#	cp linuxrc ramdisk-patched/linuxrc

#initramfs-patched.cpio.gz.uboot: ramdisk-patched
#	cd ramdisk-patched && find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../initramfs
#	mkimage -n 'uboot initramfs rootfs' -A arm -O linux -T ramdisk -C gzip -d initramfs initramfs-patched.cpio.gz.uboot
#	rm initramfs

#initramfs-recovery.cpio.gz.uboot: ../recovery/ramdisk-patched.gz
#	mkimage -n 'uboot initramfs rootfs' -A arm -O linux -T ramdisk -C gzip -d ../recovery/ramdisk-patched.gz initramfs-recovery.cpio.gz.uboot


content_fat.txt:
	unzip -lv ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip > content_fat.txt

content_mtp.txt:
	unzip -lv ../M96_KK_2015-11-29_19-41_dev_6b96172_eng.zip > content_mtp.txt

ucl2_fat.xml:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/ucl2.xml"
	mv ucl2.xml ucl2_fat.xml

ucl2_mtp.xml:
	unzip -j ../M96_KK_2015-11-29_19-41_dev_6b96172_eng.zip "M96_2015-11-29_19-41_dev_6b96172_eng/Profiles/MX6SL Linux Update/OS Firmware/ucl2.xml"
	mv ucl2.xml ucl2_mtp.xml

mksdcard-android_fat.sh: installer
	tar xf "installer/Profiles/original-user/OS Firmware/mksdcard-android.sh.tar"
	mv mksdcard-android.sh mksdcard-android_fat.sh

mksdcard-android_mtp.sh: installer
	tar xf "installer/Profiles/original-eng/OS Firmware/mksdcard-android.sh.tar"
	mv mksdcard-android.sh mksdcard-android_mtp.sh

mk-encryptable-data-android_fat.sh: installer
	tar xf "installer/Profiles/original-user/OS Firmware/mk-encryptable-data-android.sh.tar"
	mv mk-encryptable-data-android.sh mk-encryptable-data-android_fat.sh

mk-encryptable-data-android_mtp.sh: installer
	tar xf "installer/Profiles/original-eng/OS Firmware/mk-encryptable-data-android.sh.tar"
	mv mk-encryptable-data-android.sh mk-encryptable-data-android_mtp.sh

clean:
	rm -rf ramdisk-fbk
	rm -f mksdcard-android_fat.sh mksdcard-android_mtp.sh
	rm -f mk-encryptable-data-android_fat.sh mk-encryptable-data-android_mtp.sh
	rm -f content_fat.txt content_mtp.txt
	rm -f ucl2_fat.xml ucl2_mtp.xml
