install-fat-base:
	make -C ../boot boot-patched.img
	adb shell -n "dd if=/dev/zero of=/dev/block/mmcblk0 bs=512 seek=1536 count=16"  # clean up u-boot parameter
	adb shell -n "echo 0x38 > /sys/devices/platform/sdhci-esdhc-imx.1/mmc_host/mmc0/mmc0:0001/boot_config"  # Formatting sd partition
	adb exec-in "dd of=/dev/block/mmcblk0 bs=512 seek=2 skip=2" < "installer/Profiles/original-user/OS Firmware/files/android/u-boot.bin"  # write U-Boot to sd card
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=1" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_waveform.bin"  # write uboot waveform
	adb exec-in "dd of=/dev/block/mmcblk0 bs=1M seek=3" < "installer/Profiles/original-user/OS Firmware/files/logo/uboot_logo.bmp"  # write uboot logo
	adb push files/mksdcard-android_fat.sh /mksdcard-android.sh  # Sending partition shell
	adb shell -n "sh mksdcard-android.sh /dev/block/mmcblk0"  # Partitioning ...
	adb push ../boot/boot-patched.img $(DEV_BOOT)  # write boot.img
	adb shell -n "mke2fs -t ext4 $(DEV_CACHE)"  # Formatting cache partition
	adb shell -n "mke2fs -t ext4 $(DEV_MISC)"  # Formatting misc partition
	adb shell -n "mke2fs -t ext4 $(DEV_FAT_DEVICE)"  # Formatting device partition

install-fat-init-data:
	adb shell -n "mke2fs -t ext4 -b 4096 -m 0 $(DEV_FAT_DATA)"  # Formatting data partition
	adb push files/mk-encryptable-data-android_mtp.sh /mk-encryptable-data-android.sh  # Sending data partition shell
	adb shell -n "sh mk-encryptable-data-android.sh /dev/block/mmcblk0 $(DEV_FAT_DATA)"  # Making data encryptable

install-fat-init-sdcard: files/busybox
	#adb exec-in "cut -d = -f2 - > /tmp/name" < "installer/Profiles/original-user/OS Firmware/files/android/android-info.txt"  # Write product info
	adb shell -n "mkfs.fat -F 32 -n M96Plus $(DEV_FAT_SDCARD)"  # Formatting userdata partition
	adb shell -n "mkdir -p /mnt/sdcard"
	adb shell -n "mount -t vfat -o shortname=mixed,utf8 $(DEV_FAT_SDCARD) /mnt/sdcard"
	adb shell -n "mkdir -p /mnt/sdcard/media/"
	adb push files/busybox /tmp/unzip
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/media/" < "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip"  # Sending waveform
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/" < "installer/Profiles/original-user/OS Firmware/files/additional/slide.zip"  # Extracting slide
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/" < "installer/Profiles/original-user/OS Firmware/files/additional/Books.zip"  # Extracting Books
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/" < "installer/Profiles/original-user/OS Firmware/files/additional/user_manual.zip"  # Extracting User's manual
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/" < "installer/Profiles/original-user/OS Firmware/files/dic/dicts.zip"  # Extracting dic data
	adb exec-in "/tmp/unzip - -d /mnt/sdcard/" < "installer/Profiles/original-user/OS Firmware/files/tts/ivona.zip"
	adb shell -n "sync"
	adb shell -n "umount /mnt/sdcard"  # Unmounting data partition

install-fat: boot-setup install-fat-base install-fat-init-data install-fat-init-sdcard install-vendor install-system install-recovery
	adb reboot
