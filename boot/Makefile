all: boot-patched.img

include bootimage.mk

boot.img:
	unzip -j ../M96_KK_2017-05-02_19-37_dev_fbc2cc2_user.zip "M96_2017-05-02_19-37_dev_fbc2cc2_user/Profiles/MX6SL Linux Update/OS Firmware/files/android/boot.img"

boot-patched.img: boot-orig ramdisk-patched.gz Makefile
	../tools/mkbootimg/mkbootimg \
	  --kernel boot-orig/boot.img-zImage \
	  --ramdisk ramdisk-patched.gz \
	  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc androidboot.hardware=freescale" \
	  --base 80800000 \
	  -o boot-patched.img

# No detectable change: vmalloc=64M fbmem=48M
# ok  --cmdline "$(shell cat boot-orig/boot.img-cmdline)" \
# nok --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 epdc consoleblank=0 androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc consoleblank=0 androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale" \
# ok  --cmdline "console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=32 epdc androidboot.hardware=freescale" \
# 4.4.4: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_OD2,bpp=16 epdc androidboot.hardware=freescale
# 1.8.2: console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 video=mxcepdcfb:E97_V110,bpp=16 video=mxc_elcdif_fb:off
