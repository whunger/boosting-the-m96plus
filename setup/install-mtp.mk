install-mtp-base:
	make -C ../boot-mtp boot-patched.img
	adb shell -n "dd if=/dev/zero of=/dev/block/mmcblk0 bs=512 seek=1536 count=16"  # clean up u-boot parameter
	adb exec-in "dd of=/dev/block/mmcblk0 bs=512 seek=2 skip=2" < "installer/Profiles/original-user/OS Firmware/files/android/u-boot.bin"  # write U-Boot to sd card
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=1" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_waveform.bin"  # write uboot waveform
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=3" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_logo.bmp"  # write uboot logo
	adb push files/mksdcard-android_mtp.sh /mksdcard-android.sh  # Sending partition shell
	adb shell -n "sh mksdcard-android.sh /dev/block/mmcblk0"  # Partitioning ...
	adb push ../boot-mtp/boot-patched.img $(DEV_BOOT)  # write boot.img
	adb shell -n "mke2fs -t ext4 $(DEV_CACHE)"  # Formatting cache partition
	adb shell -n "mke2fs -t ext4 $(DEV_MISC)"  # Formatting misc partition
	adb shell -n "mke2fs -t ext4 $(DEV_MTP_DEVICE)"  # Formatting device partition

install-mtp-init-data: files/busybox
	adb shell -n "mke2fs -t ext4 -b 4096 -m 0 $(DEV_MTP_DATA)"  # Formatting data partition
	adb push files/mk-encryptable-data-android_mtp.sh /mk-encryptable-data-android.sh  # Sending data partition shell
	adb shell -n "sh mk-encryptable-data-android.sh /dev/block/mmcblk0 $(DEV_MTP_DATA)"  # Making data encryptable
	adb shell -n "mkdir -p /mnt/data"
	adb shell -n "mount -t ext4 $(DEV_MTP_DATA) /mnt/data"
	adb shell -n "mkdir -p /mnt/data/media/"
	adb push files/busybox /tmp/unzip
	adb exec-in "/tmp/unzip - -d /mnt/data/media/" < "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip"
	adb shell -n "sync"
	adb shell -n "umount /mnt/data"  # Unmounting data partition

install-mtp: boot-setup install-mtp-base install-mtp-init-data install-vendor install-system install-recovery
	adb reboot
