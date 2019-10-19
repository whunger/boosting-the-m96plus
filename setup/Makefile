EPDC := V220_C228_97_WN3B41_ED097OD2_CTC

installer:
	unzip ../M96_KK_2015-11-29_19-41_dev_6b96172_eng.zip
	mv M96_2015-11-29_19-41_dev_6b96172_eng installer
	mv "installer/Profiles/MX6SL Linux Update" "installer/Profiles/original-eng"
	unzip ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip
	mv "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update" "installer/Profiles/original-user"
	rm -rf M96_2017-05-02_19-37_dev_fbc2cc2_user

ramdisk-orig: installer
	rm -rf ramdisk-orig && mkdir ramdisk-orig
	dumpimage -i installer/Profiles/original-user/OS\ Firmware/initramfs.cpio.gz.uboot -T ramdisk initramfs.gz
	zcat initramfs.gz | (cd ramdisk-orig; cpio -i --no-absolute-filenames)
	rm initramfs.gz

ramdisk-patched.gz: ramdisk-orig Makefile ramdisk-changes/*
	make -C ../recovery ramdisk-orig ramdisk-twrp
	rm -rf ramdisk-patched
	cp -a ../recovery/ramdisk-orig ramdisk-patched
	cp ramdisk-changes/default.prop ramdisk-patched/
	cp ramdisk-changes/init.rc ramdisk-patched/
	cp ramdisk-changes/fstab.freescale ramdisk-patched/
	cp -r ramdisk-orig/sbin/* ramdisk-patched/sbin/
	cp -r ramdisk-orig/bin ramdisk-patched/
	cp -r ramdisk-orig/etc/* ramdisk-patched/etc/
	cp -r ramdisk-orig/lib ramdisk-patched/
	cp -r ramdisk-orig/usr ramdisk-patched/
	cp -r ramdisk-orig/var ramdisk-patched/
	cp ../recovery/ramdisk-twrp/sbin/adbd ramdisk-patched/sbin/
	( cd ramdisk-patched; find | sort | cpio --quiet -o -H newc --owner=+0:+0) | gzip > ramdisk-patched.gz

recovery-setup.img: ramdisk-patched.gz Makefile
	make -C ../recovery recovery-orig
	../tools/mkbootimg/mkbootimg \
	  --kernel ../recovery/recovery-orig/recovery.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o recovery-setup.img

boot-setup: recovery-setup.img
	../../platform-tools/fastboot boot recovery-setup.img
	until adb devices | grep -q 0123456789ABCDEF; do echo Waiting for adbd to respond ...; sleep 3; done

install-mtp-base:
	make -C ../boot-mtp boot-patched.img
	adb shell -n "dd if=/dev/zero of=/dev/block/mmcblk0 bs=512 seek=1536 count=16"  # clean up u-boot parameter
	adb exec-in "dd of=/dev/block/mmcblk0 bs=512 seek=2 skip=2" < "installer/Profiles/original-user/OS Firmware/files/android/u-boot.bin"  # write U-Boot to sd card
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=1" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_waveform.bin"  # write uboot waveform
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=3" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_logo.bmp"  # write uboot logo
	adb push files/mksdcard-android_mtp.sh /mksdcard-android.sh  # Sending partition shell
	adb shell -n "sh mksdcard-android.sh /dev/block/mmcblk0"  # Partitioning ...
	adb shell -n "ls -l /dev/block/mmc*"  # Formatting sd partition
	adb push ../boot-mtp/boot-patched.img /dev/block/mmcblk0p1  # write boot.img
	adb shell -n "mkfs.ext4 /dev/block/mmcblk0p6"  # Formatting cache partition
	adb shell -n "mkfs.ext4 /dev/block/mmcblk0p7"  # Formatting device partition
	adb shell -n "mkfs.ext4 /dev/block/mmcblk0p8"  # Formatting misc partition

install-mtp-init-data:
	adb shell -n "mkfs.ext4 -b 4096 -m 0 /dev/block/mmcblk0p4"  # Formatting data partition
	adb push files/mk-encryptable-data-android_mtp.sh /mk-encryptable-data-android.sh  # Sending data partition shell
	adb shell -n "sh mk-encryptable-data-android.sh /dev/block/mmcblk0 /dev/block/mmcblk0p4"  # Making data encryptable
	adb shell -n "mkdir -p /mnt/mmcblk0p4"
	adb shell -n "mount -t ext4 /dev/block/mmcblk0p4 /mnt/mmcblk0p4"
	adb shell -n "mkdir -p /mnt/mmcblk0p4/media/"
	adb exec-in "unzip - -d /mnt/mmcblk0p4/media/" < "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip"
	adb shell -n "umount /mnt/mmcblk0p4"  # Unmounting data partition

install-mtp-vendor:
	adb shell -n "mkfs.ext4 -O^extent /dev/block/mmcblk0p9"  # Formatting vendor partition
	adb shell -n "mkdir -p /mnt/mmcblk0p9"
	adb shell -n "mount -t ext4 /dev/block/mmcblk0p9 /mnt/mmcblk0p9"
	adb shell -n "mkdir -p /mnt/mmcblk0p9/firmware/imx/"
	unzip -j -o "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip" wf/97/$(EPDC).fw
	adb push $(EPDC).fw /mnt/mmcblk0p9/firmware/imx/epdc.fw  # Sending waveform
	rm $(EPDC).fw
	adb shell -n "chmod 777 /mnt/mmcblk0p9/firmware/imx/epdc.fw"
	adb shell -n "umount /mnt/mmcblk0p9"  # Unmounting vendor partition

install-mtp-system:
	make -C ../system system-patched.img
	adb shell -n "mkfs.ext4 /dev/block/mmcblk0p5"  # Formatting system partition
	adb push ../system/system-patched.img /dev/block/mmcblk0p5  # Sending and writing system.img
	adb shell -n "e2fsck -f -y /dev/block/mmcblk0p5"
	adb shell -n "resize2fs /dev/block/mmcblk0p5"

install-mtp-recovery:
	make -C ../recovery recovery-twrp.img
	adb push ../recovery/recovery-twrp.img /dev/block/mmcblk0p2  # Sending and writing recovery.img

install-mtp: boot-setup install-mtp-base install-mtp-init-data install-mtp-vendor install-mtp-system install-mtp-recovery
	adb reboot

clean:
	rm -rf installer ramdisk-orig ramdisk-patched ramdisk-patched.gz recovery-setup.img
