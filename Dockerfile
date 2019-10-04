FROM debian:buster

RUN set -xe && \
	export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y --no-install-recommends \
		git make vmdb2 parted dosfstools debootstrap qemu-user-static schroot \
		sudo ca-certificates && \
	rm -rf /var/lib/apt/lists/*

# https://salsa.debian.org/raspi-team/image-specsを確認し
# 必要に応じて対象のHASHに書き換える
ENV IMAGE_SPECS=d74005dd11a16586343e1129d53e97bf76a677e3

RUN set -xe && \
	git clone --recursive https://salsa.debian.org/raspi-team/image-specs.git /work/image-specs && \
	cd /work/image-specs && \
	git checkout ${IMAGE_SPECS}
	
ADD . /work/app
WORKDIR /work
ENTRYPOINT ["/work/app/entrypoint.sh"]

