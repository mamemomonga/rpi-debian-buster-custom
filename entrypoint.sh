#!/bin/bash
set -eu
cd /work

build() {
	local name=$1
	local config=$2
	local destdir=/work/var
	local image=debian-buster-$IMAGE_SPECS-$name.img

	set +x
	mkdir -p $destdir

	cd /work/image-specs

	vmdb2 \
		--rootfs-tarball=$destdir/raspi3.tar.gz \
		--output $destdir/raspi3.img \
		--log stderr $config

	cp $destdir/raspi3.img /work/images/$image
	chown -R $HUID:$HGID /work/images/$image
}

case "${1:-}" in
	"bash" )
		shift
		exec bash $@
		;;

	"rpi3-mamemo" )
		build rpi3-mamemo /work/app/rpi3-mamemo/raspi3.yaml
		;;

	* )
		echo "USAGE: [ bash | rpi3-mamemo ]"
		exit 1
		;;
esac
