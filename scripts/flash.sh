#!/bin/sh

IMAGES_DIR=/root/images
RELEASE_FILE=$IMAGES_DIR/release.txt

echo "Checking for the latest release..."
download_image

RELEASE=$(cat $RELEASE_FILE)

echo "Flashing $RELEASE !"
bmaptool copy *.sdimg.bz2 /dev/mmcblk1

# Check if the flashing was successful
if [ $? -ne 0 ]; then
    echo "[Error] Flashing failed"
    set_led_bri 0
    exit 1
fi

echo "Flashing complete"
set_led_bri 1