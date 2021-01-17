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

