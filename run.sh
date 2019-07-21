#!/bin/bash
set -eu
IMAGE=builder
docker build -t $IMAGE .

mkdir -p $(pwd)/images
exec docker run --rm -it \
	-e "HUID=$(id -u)" \
	-e "HGID=$(id -g)" \
	-v $(pwd)/images:/work/images \
	--privileged $IMAGE $@
