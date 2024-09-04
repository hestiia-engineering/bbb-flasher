# bbb-flasher

Scripts to flash a beaglebone black with a yocto image.

## How to prepare a BBB flasher

1. You need an SD card with the official debian [image](https://www.beagleboard.org/distros/am335x-11-7-2023-09-02-4gb-microsd-iot)

    * You can use the [etcher](https://www.balena.io/etcher/) tool to flash the image on the SD card
    * You can also use the raspberri pi imager tool to flash the image on the SD card

2. Start the BBB with the SD card inserted, while pressing the button next to the SD card slot to boot from the SD card

3. Connect to it over ssh or serial (user: debian, password: temppwd)

4. Clone this repository and run setup.sh

```
# Public repo, no PAT needed
git clone https://github.com/hestiia-engineering/bbb-flasher.git
cd bbb-flasher
sudo ./setup.sh
# Enter PAT when asked
```

The setup script will:

* install all dependencies
* ask you for a github PAT to fetch the latest release
* download the latest yocto image from the latest release of hestiia-os
* install all the scripts
* install the flasher.service and enable it at boot

## How to flash a BBB

1. Insert the SD card in the BBB

2. Power on the BBB while pressing the user button to boot from the SD card

3. The BBB will flash the image (and the led will flash with activity)

4. The LEDs will be all on when the flashing is done, or all off if an error occured.

5. Unplug: the BBB is ready