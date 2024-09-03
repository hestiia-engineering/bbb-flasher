#!/bin/sh

cd /root/

echo "[Checking new version]"
./download.sh

hmi_print() {
    /home/debian/.pyenv/shims/python3.10 -m hestiia.cli hmi print "$@"
}

hmi_roll() {
    /home/debian/.pyenv/shims/python3.10 -m hestiia.cli hmi roll "$@"
}

RELEASE=$(cat release.txt)

echo "[Flashing] $RELEASE"
hmi_roll "FLASHING $RELEASE"
echo "You have 5 seconds to cancel the operation (Press Ctrl+C to cancel)..." 
sleep 5

hmi_print FLASHING
bmaptool copy *.sdimg.bz2 /dev/mmcblk1

# Check if the flashing was successful
if [ $? -ne 0 ]; then
    hmi_print ERROR
    echo "[Error] Flashing failed"
    exit 1
fi

echo "[Done]"
hmi_print OK