#!/bin/bash

# Make sure we are root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Check we are running in the correct directory
# The flasher.service file should be in the same directory as this script
if [ ! -f flasher.service ]; then
    echo "This script must be run from the directory containing flasher.service" 1>&2
    exit 1
fi

# Install gh dependency
echo Installing gh...
./scripts/install-gh-cli.sh

echo Installing dependencies...
if ! dpkg -s bmap-tools > /dev/null 2>&1; then
    echo - bmap-tools
    apt-get install bmap-tools -y
fi

# Check if the installation was successful
if [ $? -ne 0 ]; then
    echo "Failed to install gh" 1>&2
    exit 1
fi

# Save the gh token
echo "Enter your GitHub token: "
read -s token
echo $token > /root/.gh-token

# Install the scripts to /usr/sbin
echo Installing the scripts...
cp scripts/flash.sh /usr/sbin/flash
chmod +x /usr/sbin/flash
echo - /usr/sbin/flash
cp scripts/set_led_bri.sh /usr/sbin/set_led_bri
chmod +x /usr/sbin/set_led_bri
echo - /usr/sbin/set_led_bri
cp scripts/download.sh /usr/sbin/download_image
chmod +x /usr/sbin/download_image
echo - /usr/sbin/download_image

# Install the flasher.service
echo Installing the flasher.service...
cp flasher.service /etc/systemd/system/flasher.service
systemctl enable flasher.service

# Prepare the directory for the images
echo Creating /root/images
mkdir /root/images
echo Downloading the latest image...
download_image
# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download the image" 1>&2
    set_led_bri 0
    exit 1
fi

# Done
set_led_bri 1
echo Setup complete

