install-vendor: installer
	adb shell -n "mke2fs -t ext4 -O^extent $(DEV_VENDOR)"  # Formatting vendor partition
	adb shell -n "mkdir -p /mnt/vendor"
	adb shell -n "mount -t ext4 $(DEV_VENDOR) /mnt/vendor"
	adb shell -n "mkdir -p /mnt/vendor/firmware/imx/"
	unzip -j -o "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip" wf/97/$(EPDC).fw
	adb push $(EPDC).fw /mnt/vendor/firmware/imx/epdc.fw  # Sending waveform
	rm $(EPDC).fw
	adb shell -n "chmod 777 /mnt/vendor/firmware/imx/epdc.fw"
	adb shell -n "umount /mnt/vendor"  # Unmounting vendor partition

install-system:
	make -C ../system system-patched.img
	adb push ../system/system-patched.img $(DEV_SYSTEM)  # Sending and writing system.img
	adb shell -n "e2fsck -f -y $(DEV_SYSTEM)"
	adb shell -n "resize2fs $(DEV_SYSTEM)"

install-recovery:
	make -C ../recovery recovery-twrp.img
	adb push ../recovery/recovery-twrp.img $(DEV_RECOVERY)  # Sending and writing recovery.img
