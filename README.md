# Debian 10 buster arm64 Raspberry Pi3向けイメージ作成

[Raspberry Pi image specs](https://salsa.debian.org/raspi-team/image-specs) を使用して、Raspberry Pi3 用 Debian Buster arm64イメージを生成します。

こちらで生成されるイメージはまだ開発途中のようで、いくつか問題があるようです。

# ホストマシンに必要なもの

Docker, Bash

コンテナ内部でdevice mapperを使用するため、privileged権限を使用します。Dockerコンテナでの実行であっても重要なサービスを運用するマシンでの利用はお控え下さい。

# 設定

[Dockerfile](Dockerfile) の IMAGE\_SPECS を [こちらを確認](https://salsa.debian.org/raspi-team/image-specs)の上、必要に応じて対象とするCommit Hashに書き換えて下さい。なお、変更した場合はrpi3-mamemoで不具合が出る場合があります。

# 生成されるイメージ

## raspi3

[image specs](https://salsa.debian.org/raspi-team/image-specs)に含まれる raspi3.yaml をビルドします

### 気付いた問題点

* ACT LEDが点滅しない
* 初回起動で eth0 が up しない

## rpi3-mamemo

raspi3.yamlをベースに、以下の改変が行われています。

* ミラーをさくらインターネットに変更
* fstabオプション変更
* 無線LAN関連のソフト・ドライバを削除
* eth0が有効になるように調整
* GPUメモリを16MBに変更
* 日本時間(JST)に設定
* vim, git, wget, curl, ntp, sudo, htop の導入
* ntpはmfeedを参照
* ウオッチドックタイマー
* OOM Killerが発動したらカーネルパニックを起こしてリブート
* debianユーザの追加(パスワードなしでsudoでrootになることができます)

### ウオッチドックタイマー

/usr/local/sbin/softdog.sh として、ウオッチドックタイマーがインストールされます。15秒に一回softdogへ通知を行い、120秒間通知がなければリブートされます。通常ディスクアクセスLEDとして動作しているランプは、1秒ごとの点滅になります。

停止

	$ sudo systemctl stop softdog

開始

	$ sudo systemctl start softdog

# 実行

	$ ./run.sh raspi3
	$ ./run.sh rpi3-mamemo

images フォルダに現在のイメージが出来ます。

# イメージの作成(Linux)

USB-MicroSDアダプタを刺して、デバイスを確認、この例の場合 /dev/sdd

	$ lsblk -o NAME,SIZE,VENDOR,MODEL
	sdd        7.3G BUFFALO  BSCR17TU3_-2

書き込み **/dev/sdd は環境によって違います。間違えるとシステムを破壊しますので必ず確認して下さい。**

	$ sudo dd if=images/debian-buster-rpi-957f6ed6-rpi3-mamemo.img of=/dev/sdd bs=64k oflag=dsync status=progress

macOSやLinuxデスクトップ環境の場合、[Etcher](https://etcher.io/)がおすすめです。

# Raspberry Pi起動後のログイン

**User: root / Password: なし**

* rootユーザでSSHログインするためには、公開鍵の設定が必要です。
* 15秒ごとにsoftdogの通知が表示されます。ウザい場合は **systemctl stop softdog** で停止してください。

