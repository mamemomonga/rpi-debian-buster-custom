# Debian 10 buster arm64 Raspberry Pi3向けイメージ作成

[Raspberry Pi image specs](https://salsa.debian.org/raspi-team/image-specs) を使用して、Raspberry Pi3 用 Debian Buster arm64イメージを生成します。

# 事前準備

このプログラムは Debian Buster(AMD64)でないとうまく動作しないと思われます。Debian BusterをVMwareなどにセットアップして実行してください。

sudo コマンドのインストールと、パスワードなしでrootになれるユーザを用意しておきます。

ここではそのユーザを debianとする。以下のコマンドを root権限で実行します。

	# bash -xeu << 'END_OF_SNIPPET'
	NEW_USER=debian
	apt-get install -y sudo
	cat > /etc/sudoers.d/wheel_user << EOS
	$NEW_USER ALL=(ALL) NOPASSWD:ALL
	EOS
	chmod 600 /etc/sudoers.d/wheel_user
	END_OF_SNIPPET

gitとmakeをインストール

	# sudo apt install git

ここからは上記に設定したユーザ(この例では debian)で実行

	$ git clone https://github.com/mamemomonga/rpi-debian-buster-custom
	$ cd rpi-debian-buster-custom
	$ make apt

# イメージの作成

raspi3 の作成

	$ make raspi3

rpi3-maemmo の作成

	$ make rpi3-mamemo

すべて作成

	$ make

イメージは var/[Raspberry Pi image specsのCommit Hash]/[名前(raspi3もしくはrpi3-mamemo)]/raspi3.img として作成されます。

