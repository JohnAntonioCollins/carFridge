#!/bin/bash +e
# start scripts and do prep for carfridge and temperature logger
# v1.0

# wait for USB drive and peripherals
sleep 10

# keep starting the next scripts even if one has an error
set +e

# check for usb stick
rootPath="media/pi/USB_32GB1"
fallbackPath="home/pi"
if [ ! -d $rootPath ]
then
 rootPath=$fallbackPath
fi

# temperature logger
/home/pi/carfridge/code/temperature/temperature.sh &>> ${rootPath}/carfridge/log/temperature.log &
echo "$!" > /home/pi/carfridge/code/temperature/pid

# fridge thermostat
/home/pi/carfridge/code/thermostat/thermostat.sh &>> ${rootPath}/carfridge/log/thermostat.log &
echo "$!" > /home/pi/carfridge/code/thermostat/pid

