#!/bin/bash +e
# start scripts and do prep for carfridge and temperature logger
# v1.0

# wait for USB drive and peripherals
sleep 10

# keep starting the next scripts even if one has an error
set +e

# temperature logger
/home/pi/carfridge/code/temperature/temperature.sh &>> /media/pi/USB_32GB/carfridge/log/temperature.log &
echo "$!" > /home/pi/carfridge/code/temperature/pid

# fridge thermostat
/home/pi/carfridge/code/thermostat/thermostat.sh &>> /media/pi/USB_32GB/carfridge/log/thermostat.log &
echo "$!" > /home/pi/carfridge/code/thermostat/pid

