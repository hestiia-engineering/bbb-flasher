#!/bin/bash

# This script controls the brightness of the LEDs on the BeagleBone Black.
# usage: set_led_bri 1
#        set_led_bri 0
#        set_led_bri --help

LED_PATH=/sys/class/leds
LED1=$LED_PATH/beaglebone:green:usr0
LED2=$LED_PATH/beaglebone:green:usr1
LED3=$LED_PATH/beaglebone:green:usr2
LED4=$LED_PATH/beaglebone:green:usr3

# Set the trigger to none
# This will allow us to control the LED from the command line
echo none > $LED1/trigger
echo none > $LED2/trigger
echo none > $LED3/trigger
echo none > $LED4/trigger

if [ $1 -eq 1 ]; then
    echo "Turning on all LEDs"
    echo 255 > $LED1/brightness
    echo 255 > $LED2/brightness
    echo 255 > $LED3/brightness
    echo 255 > $LED4/brightness
elif [ $1 -eq 0 ]; then
    echo "Turning off all LEDs"
    echo 0 > $LED1/brightness
    echo 0 > $LED2/brightness
    echo 0 > $LED3/brightness
    echo 0 > $LED4/brightness
elif [ $1 == "--help" ]; then
    echo "usage: set_led_bri 1"
    echo "       set_led_bri 0"
    echo "       set_led_bri --help"
else
    echo "Invalid argument"
    echo "usage: set_led_bri 1"
    echo "       set_led_bri 0"
    echo "       set_led_bri --help"
fi
