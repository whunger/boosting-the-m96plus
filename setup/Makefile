DEV_BOOT := /dev/block/mmcblk0p1
DEV_RECOVERY := /dev/block/mmcblk0p2
DEV_SYSTEM := /dev/block/mmcblk0p5
DEV_CACHE := /dev/block/mmcblk0p6
DEV_MISC := /dev/block/mmcblk0p8
DEV_VENDOR := /dev/block/mmcblk0p9

DEV_FAT_SDCARD := /dev/block/mmcblk0p4
DEV_FAT_DATA := /dev/block/mmcblk0p7
DEV_FAT_DEVICE := /dev/block/mmcblk0p10

DEV_MTP_DATA := /dev/block/mmcblk0p4
DEV_MTP_DEVICE := /dev/block/mmcblk0p7

EPDC := V220_C228_97_WN3B41_ED097OD2_CTC

installer:
	unzip ../M96_KK_2015-11-29_19-41_dev_6b96172_eng.zip
	mv M96_2015-11-29_19-41_dev_6b96172_eng installer
	mv "installer/Profiles/MX6SL Linux Update" "installer/Profiles/original-eng"
	unzip ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip
	mv "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update" "installer/Profiles/original-user"
	rm -rf M96_2017-05-02_19-37_dev_fbc2cc2_user

files/busybox:
	# This one supports streaming unzip
	curl -o files/busybox "https://busybox.net/downloads/binaries/1.16.1/busybox-armv6l"
	chmod a+x files/busybox

boot-setup:
	make -C ../recovery boot-twrp

include install-common.mk
include install-fat.mk
include install-mtp.mk
include install-eng.mk

clean:
	rm -rf installer
