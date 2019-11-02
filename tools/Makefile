all: mkbootimg/mkbootimg

mkbootimg/mkbootimg:
	make -C mkbootimg

u-boot-master.tar.gz:
	curl -o u-boot-master.tar.gz "https://gitlab.denx.de/u-boot/u-boot/-/archive/master/u-boot-master.tar.gz?path=tools"

u-boot-tools: u-boot-master.tar.gz
	tar xzf u-boot-master.tar.gz
	mv u-boot-master-tools/tools u-boot-tools
	rmdir u-boot-master-tools

clean:
	rm -rf u-boot-master.tar.gz u-boot-tools
