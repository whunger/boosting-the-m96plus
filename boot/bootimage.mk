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
