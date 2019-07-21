FROM debian:buster

RUN set -xe && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		git make vmdb2 parted dosfstools debootstrap qemu-user-static schroot && \
	rm -rf /var/lib/apt/lists/*

RUN set -xe && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		sudo ca-certificates && \
	rm -rf /var/lib/apt/lists/*

ENV IMAGE_SPECS=957f6ed6

RUN set -xe && \
	git clone --recursive https://salsa.debian.org/raspi-team/image-specs.git /work/image-specs && \
	cd /work/image-specs && \
	git checkout ${IMAGE_SPECS}
	
ADD . /work/app
WORKDIR /work
ENTRYPOINT ["/work/app/entrypoint.sh"]
