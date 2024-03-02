# BBB_Bootstrap

## How to

A SD carte with the official debian [image](https://www.beagleboard.org/distros/am335x-11-7-2023-09-02-4gb-microsd-iot)

Start the BBB (press user button to swith between EMMC and SD card while pluggin the BBB)

Install github cli [link](https://github.com/cli/cli/blob/trunk/docs/install_linux.md)

Install bmaptools on debian: 
```bash
sudo apt install bmap-tools
```

login using github cli as root (UNSAFE, need improvement):
```bash
gh auth login
```

As root :
 checkout this repo in /root/

launch the ./flash script and wait for completion

Reboot the beagle and remove the SD card.
The yocto image is now installed. 


## TODO: 

* A some fancy led blinking to show there is activity
* Add somme feedback
* Add a script to launch the flash process at boot
* Handle any non-nominal event