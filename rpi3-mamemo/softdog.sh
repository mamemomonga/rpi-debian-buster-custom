#!/bin/bash
set -eu
do_trap() {
	echo "STOP SOFTDOG"
	echo "V" > /dev/watchdog0
}
trap do_trap HUP INT QUIT KILL TERM CONT STOP

rmmod softdog || true
modprobe softdog soft_margin=120
echo 'none' > /sys/class/leds/ACT/trigger
echo "START SOFTDOG"

while true; do
	for i in {1..15}; do
		echo 1 > /sys/class/leds/ACT/brightness
		sleep 0.5
		echo 0 > /sys/class/leds/ACT/brightness
		sleep 0.5
	done
	echo > /dev/watchdog0
done
EOS

chmod 755 /usr/local/sbin/softdog.sh
cat > /etc/systemd/system/softdog.service' << EOS

