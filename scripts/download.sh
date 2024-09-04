#!/bin/sh

IMAGES_DIR=/root/images
RELEASE_FILE=$IMAGES_DIR/release.txt

mkdir -p $IMAGES_DIR

BOARD=myeko-board
NAME=myeko-image
TYPE=dev
PATTERN_BMAP=$NAME-$TYPE-$BOARD.sdimg.bmap
PATTERN_BZ2=$NAME-$TYPE-$BOARD.sdimg.bz2

# Login to GitHub
echo Logging in to GitHub...
gh auth login --with-token < /root/.gh-token
# Check if the login was successful
if [ $? -ne 0 ]; then
    echo "Failed to log in to GitHub. Skipping" 1>&2
    exit 1
fi

# Fetch the latest release tag
REPO=hestiia-engineering/yocto-cooker-myeko
LINE=$(gh release list -R $REPO | grep Latest)
NEW_TAG=$(echo $LINE | awk '{print $1}')

# If we failed to fetch the latest release tag, exit
if [ -z "$NEW_TAG" ]; then
    echo "Failed to fetch the latest release tag. Skipping." 1>&2
    exit 1
fi

# Fetch the current release tag
if [ -f $RELEASE_FILE ]; then
    CUR_TAG=$(cat $RELEASE_FILE)
else
    CUR_TAG=0
fi

echo "Current tag: $CUR_TAG"
echo "Github tag: $NEW_TAG"

if [ "$CUR_TAG" = "$NEW_TAG" ]; then
    echo "No new release"
    exit 0
fi

# Back up the current release
if [ -f $IMAGES_DIR/$PATTERN_BMAP ] && [ -f $IMAGES_DIR/$PATTERN_BZ2 ]; then
    echo "Backing up the current release"
    mv $IMAGES_DIR/$PATTERN_BMAP $IMAGES_DIR/$PATTERN_BMAP.old
    mv $IMAGES_DIR/$PATTERN_BZ2 $IMAGES_DIR/$PATTERN_BZ2.old
fi

echo "Downloading $NEW_TAG"
gh release download --dir $IMAGES_DIR -p $PATTERN_BMAP -p $PATTERN_BZ2 -R $REPO --clobber
if [ $? -ne 0 ]; then
    echo "Failed to download the image" 1>&2
    [ -f $IMAGES_DIR/$PATTERN_BMAP ] && rm $IMAGES_DIR/$PATTERN_BMAP
    [ -f $IMAGES_DIR/$PATTERN_BZ2 ] && rm $IMAGES_DIR/$PATTERN_BZ2

    if [ -f $IMAGES_DIR/$PATTERN_BMAP.old ] && [ -f $IMAGES_DIR/$PATTERN_BZ2.old ]; then
        echo "Restoring the backup..."
        mv $IMAGES_DIR/$PATTERN_BMAP.old $IMAGES_DIR/$PATTERN_BMAP
        mv $IMAGES_DIR/$PATTERN_BZ2.old $IMAGES_DIR/$PATTERN_BZ2
    fi
    exit 1
fi

echo "Downloaded $NEW_TAG successfully"

echo "Updating the local release tag"
echo $NEW_TAG > $IMAGES_DIR/release.txt
echo "Done"
exit 0
