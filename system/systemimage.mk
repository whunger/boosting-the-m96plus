bootanimation-1080: system.img
	sudo debugfs -R "dump_inode /media/bootanimation.zip bootanimation.zip" system.img
	mkdir bootanimation-1080
	(cd bootanimation-1080; unzip ../bootanimation.zip)
	rm -f bootanimation.zip

bootanimation-825: bootanimation-1080
	mkdir -p bootanimation-825/part0
	sed -e "s/1080 1440/825 1200/" < bootanimation-1080/desc.txt > bootanimation-825/desc.txt
	(cd bootanimation-1080; for f in part0/*.png; do pngtopnm "$$f" | pnmscale -xsize=825 -ysize=1200 | pnmdepth 15 | pnmtopng > "../bootanimation-825/$$f"; done)

files-config/media/bootanimation.zip: bootanimation-screens
	mkdir -p files-config/media
	rm -f files-config/media/bootanimation.zip
	(cd bootanimation-screens; zip -r --compression-method store ../files-config/media/bootanimation.zip desc.txt part0)

files-config-mtp/media/bootanimation.zip: files-config/media/bootanimation.zip
	cp files-config/media/bootanimation.zip files-config-mtp/media/bootanimation.zip

framework-res.apk: system.img
	test -d mp || mkdir mp
	sudo mount -o ro system.img mp
	cp mp/framework/framework-res.apk .
	sudo umount mp
	rmdir mp

files-framework/framework-res.apk: framework-res.apk
	# See https://www.mobileread.com/forums/showpost.php?s=5d3d4f537ed8d2d3f8e7282bab483ced&p=3398726&postcount=14
	rm -rf fw framework-res
	../tools/apktool install-framework --frame-path fw framework-res.apk
	../tools/apktool decode --frame-path fw framework-res.apk
	# Remove forced bold font for all elements
	sed --in-place -e 3d framework-res/res/raw/webview_contrast_enchanced.css
	../tools/apktool build framework-res
	unzip -o framework-res.apk META-INF/* AndroidManifest.xml -d framework-res/build/apk/
	../tools/apktool build framework-res
	mkdir -p files-framework
	cp framework-res/dist/framework-res.apk files-framework
	rm -rf fw framework-res

system.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/system.img"

system-orig: system.img
	mkdir system-orig
	sudo debugfs -R "rdump / system-orig" system.img

system.tgz: system.img
	mkdir mp
	sudo mount -o ro system.img mp/
	sudo tar czvf - -C mp . > system.tgz
	sudo umount mp
	rmdir mp

system-current.tgz:
	./get-system

system.list: system.tgz
	tar tzvf system.tgz --numeric-owner > system.list

system-current.list: system-current.tgz
	tar tzvf system-current.tgz --numeric-owner > system-current.list
	# adb shell "busybox find /system -type f | while read f; do echo \$(busybox md5sum \$f) \$f; done"

compare: system.list system-current.list
	diff system.list system-current.list || true

changes.list:
	(cd changes; find . -type f | sed -e "s/^\./ ./"; find . -type d | sed -e 1d | while read d; do echo " $$d/\$$"; done ) > changes.list
