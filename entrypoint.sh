#!/bin/bash
set -eu
cd /work

finalize() {
	echo "*** FINALIZE ***"
	for i in $( losetup | grep /work/var/raspi3.img | awk '{print $1}' ); do
		for j in $( find /dev/mapper | grep $( echo $i | perl -npE 's#/dev/loop##' )); do
			echo "Remove $j"
			dmsetup remove $j
		done
		echo "Remove $i"
		losetup -d $i	
	done
}

build() {
	local name=$1
	local config=$2
	local destdir=/work/var
	local image=debian-buster-rpi-$IMAGE_SPECS-$name.img

	mkdir -p $destdir
	cd /work/image-specs

	vmdb2 \
		--rootfs-tarball=$destdir/raspi3.tar.gz \
		--output $destdir/raspi3.img \
		--log stderr $config

	cp $destdir/raspi3.img /work/images/$image
	chown -R $HUID:$HGID /work/images/$image
}

trap finalize HUP INT QUIT KILL TERM CONT STOP

case "${1:-}" in
	"bash" )
		shift
		bash $@
		;;

	"rpi3-mamemo" )
		build rpi3-mamemo /work/app/rpi3-mamemo/raspi3.yaml
		;;

	"raspi3" )
		build raspi3 /work/image-specs/raspi3.yaml
		;;

	* )
		echo "USAGE: [ bash | rpi3-mamemo | raspi3 ]"
		exit 1
		;;
esac

finalize

