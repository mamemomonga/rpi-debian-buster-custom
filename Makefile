SPECS_REV=$(shell  cd image-specs && git rev-parse --short HEAD )
DESTDIR=var/$(SPECS_REV)/$(NAME)

all: raspi3 rpi3-mamemo

usaget:
	@echo "USAGE: make [ raspi3 | rpi3-mamemo ]"

raspi3: image-specs
raspi3: NAME=rpi3-mamemo
raspi3: builder

rpi3-mamemo: image-specs
rpi3-mamemo: NAME=rpi3-mamemo
rpi3-mamemo: builder

builder:
	mkdir -p $(DESTDIR)
	cd image-specs; sudo vmdb2 \
		--rootfs-tarball=../$(DESTDIR)/raspi3.tar.gz \
		--output ../$(DESTDIR)/raspi3.img \
		--log stderr ../configs/$(NAME).yaml \
		| tee $(DESTDIR)/vmdb2.log 2>&1
	sudo chown -R $(id -u):$(id -g) $(DESTDIR)

image-specs:
	git clone --recursive https://salsa.debian.org/raspi-team/image-specs.git

apt:
	sudo apt-get -y install git vmdb2 parted dosfstools debootstrap qemu-user-static schroot


