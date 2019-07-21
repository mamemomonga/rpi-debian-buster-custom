#!/bin/bash

loopback_remove() {
	for i in $( losetup | grep /work/var/raspi3.img | awk '{print $1}' ); do
		echo "*** Remove loopback: $i ***"
		sudo losetup -v -d $i
	done
}

set -eu
IMAGE=builder
docker build -t $IMAGE .

mkdir -p $(pwd)/images

docker run --rm -it \
	-e "HUID=$(id -u)" \
	-e "HGID=$(id -g)" \
	-v $(pwd)/images:/work/images \
   --privileged  \
	$IMAGE $@

