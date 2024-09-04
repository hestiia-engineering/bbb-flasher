#!/bin/sh

IMAGES_DIR=/root/images
RELEASE_FILE=$IMAGES_DIR/release.txt

BOARD=myeko-board
NAME=myeko-image
TYPE=dev
PATTERN_BMAP=$NAME-$TYPE-$BOARD.sdimg.bmap
PATTERN_BZ2=$NAME-$TYPE-$BOARD.sdimg.bz2

echo "Checking for the latest release..."
download_image

RELEASE=$(cat $RELEASE_FILE)

echo "Flashing $RELEASE !"
bmaptool copy $IMAGES_DIR/$PATTERN_BZ2 /dev/mmcblk1 --bmap $IMAGES_DIR/$PATTERN_BMAP

# Check if the flashing was successful
if [ $? -ne 0 ]; then
    echo "[Error] Flashing failed"
    set_led_bri 0
    exit 1
fi

echo "Flashing complete"
set_led_bri 1