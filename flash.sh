#!/bin/sh
echo "[Checking new version]"
./download.sh


echo "[Flashing]"
echo "You have 5 seconds to cancel the operation (Press Ctrl+C to cancel)..."
sleep 5

bmaptool copy *.sdimg.bz2 /dev/mmcblk1

echo "[Done]"
