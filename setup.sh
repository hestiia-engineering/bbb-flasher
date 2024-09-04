#!/bin/bash

# Make sure we are root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install gh dependency
echo Installing gh...
apt-get update
apt-get install -y gh
# Check if the installation was successful
if [ $? -ne 0 ]; then
    echo "Failed to install gh" 1>&2
    exit 1
fi

# Save the gh token
echo "Enter your GitHub token: "
read -s token
echo $token > /root/.gh-token

# Log in to gh
echo Logging in to GitHub...
gh auth login --with-token < /root/.gh-token
# Check if the login was successful
if [ $? -ne 0 ]; then
    echo "Failed to log in to GitHub" 1>&2
    exit 1
fi

# Clone the flasher repo
echo Cloning the flasher repo...
cd /root
gh repo clone https://github.com/hestiia-engineering/BBB_Bootstrap
mv BBB_Bootstrap flasher
cd flasher
echo Cloned the flasher repo to /root/flasher

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
    exit 1
fi

# Blink the LEDs to signal that the setup is complete
echo Blinking the LEDs...
for i in {1..10} ; do
    set_led_bri 0
    sleep 0.5
    set_led_bri 1
    sleep 0.5
done

# Done
set_led_bri 1
echo Setup complete

