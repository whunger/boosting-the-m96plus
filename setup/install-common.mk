install-vendor: installer
	adb shell -n "mke2fs -t ext4 -O^extent $(DEV_VENDOR)"  # Formatting vendor partition
	adb shell -n "mkdir -p /mnt/vendor"
	adb shell -n "mount -t ext4 $(DEV_VENDOR) /mnt/vendor"
	adb shell -n "mkdir -p /mnt/vendor/firmware/imx/"
	unzip -j -o "installer/Profiles/original-user/OS Firmware/files/waveform/wf.zip" wf/97/$(EPDC).fw
	adb push $(EPDC).fw /mnt/vendor/firmware/imx/epdc.fw  # Sending waveform
	rm $(EPDC).fw
	adb shell -n "chmod 777 /mnt/vendor/firmware/imx/epdc.fw"
	#adb shell -n "echo '0 1000 0 1000 0 0 1000 6144 8192' > /mnt/vendor/pointercal"
	# Mine:
	adb shell -n "echo '-3 1005 19000 1005 7 16000 1000 6144 8192' > /mnt/vendor/pointercal"
	adb shell -n "umount /mnt/vendor"  # Unmounting vendor partition

install-recovery:
	make -C ../recovery recovery-twrp.img
	adb push ../recovery/recovery-twrp.img $(DEV_RECOVERY)  # Sending and writing recovery.img
