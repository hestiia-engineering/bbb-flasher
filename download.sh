#!/bin/sh
#download the latest release from github using the github cli

BOARD=myeko-board
NAME=myeko-image
TYPE=dev

PATERN_BMAP=$NAME-$TYPE-$BOARD.sdimg.bmap
PATERN_BZ2=$NAME-$TYPE-$BOARD.sdimg.bz2

REPO=hestiia-engineering/yocto-cooker-myeko
LINE=$(gh release list -R $REPO | grep Latest)
#echo $LINE

TAG=$(echo $LINE | awk '{print $1}')

#echo $TAG
#echo $PATERN_BZ2
#echo $PATERN_BMAP

cd /root/

if [ -f release.txt ]; then
        if [ "$TAG" = "$(cat release.txt)" ]; then
                echo "TAG MATCH, no download"
                exit
        else
                echo "New version available"
                echo $TAG > release.txt
        fi
else
        echo $TAG > release.txt
fi

echo "downloading $TAG"
gh release download -p $PATERN_BMAP -p $PATERN_BZ2 -R $REPO --clobber

echo "Done"