#!/bin/bash
# thermostat.sh 
# version 2.0
# car fridge thermostat 

# set data logging destination
dataName="thermostat.data"

dataDir="/media/pi/USB_32GB/carfridge/data/"
fallbackDir="/home/pi/carfridge/data/"

if [ ! -d $dataDir ]; then
 dataDir=$fallbackDir
fi

dataFile="${dataDir}${dataName}"



# signed int, Celcius thousandths
onTemp=3333
offTemp=1111

# gpio23, physical16
gpio=23

# fridge temperature sensor ds18b20 id
sensorId="28-0417c46ba8ff"


getTemp(){
 # REAL
#  cat /sys/bus/w1/devices/$sensorId/w1_slave | grep "t=" | sed 's/.*t=//'
 # MOCK
 # simulates fetching unknown fridge temperature from sensor, 
 # randomly, centered around the target temperature
 echo $((${RANDOM}-8000))
}


getState(){
 cat /sys/class/gpio/gpio${gpio}/value
}

turnOn(){
 echo "1" > /sys/class/gpio/gpio${gpio}/value
}

turnOff(){
 echo "0" > /sys/class/gpio/gpio${gpio}/value
}

jsonData(){
 temp=$1
 state=$2
 echo "{\"datetime\":\"$(date)\",\"state\":\"${state}\",\"temperature\":\"${temp}\",\"on-temp\":\"${onTemp}\",\"off-temp\":\"${offTemp}\"}"
}


# export gpio pin
if [ ! -e /sys/class/gpio/gpio${gpio} ]; then
 echo "$gpio" > /sys/class/gpio/export
fi

# set pin to output
echo "out" > /sys/class/gpio/gpio${gpio}/direction


while true
do

 temp=$(getTemp)
 state=$(getState)

 if [ $temp -ge $onTemp ] && [ $state -eq 0 ]
  then
  turnOn
  echo $(jsonData $temp $state) >> $dataFile
    
 elif [ $temp -le $offTemp ] && [ $state -eq 1 ]
  then
  turnOff
  echo $(jsonData $temp $state) >> $dataFile

 fi

sleep 1
done
