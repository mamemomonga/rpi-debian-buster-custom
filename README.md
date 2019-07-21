# Debian 10 buster arm64 Raspberry Pi3向けイメージ作成

[Raspberry Pi image specs](https://salsa.debian.org/raspi-team/image-specs) を使用して、Raspberry Pi3 用 Debian Buster arm64イメージを生成します。

# ホストマシンに必要なもの

Docker, Bash

コンテナ内部でdevice mapperを使用するため、privileged権限を使用します。

# 実行

	$ ./run.sh raspi3
	$ ./run.sh rpi3-mamemo

images フォルダに現在のイメージが出来ます。

# Raspberry Pi起動後のログイン

***User: root / Password: なし***

rootユーザでSSHログインするためには、公開鍵の設定が必要です。

