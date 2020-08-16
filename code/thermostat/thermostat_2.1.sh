#!/bin/bash
# thermostat.sh 
# version 2.1
# car fridge thermostat 

echo "$(date) thermostat.sh starting"

source /home/pi/carfridge/code/dao/temperatureSensorDao

# set data logging destination
parentDir="/media/pi/USB_32GB1"
dataFile="/carfridge/data/thermostat.data"
dataPath="${parentDir}${dataFile}"
fallbackParentDir="/home/pi"
if [ ! -d $parentDir ] || [ ! -d $dataPath ]; then
 dataPath="${fallbackParentDir}${dataFile}"
fi


# signed int, Celcius thousandths
onTemp=3333
#offTemp=1111 plus 1800 (1.8C) anticipation
offTemp=2911

# gpio23, physical16
gpio=23

# fridge temperature sensor ds18b20 id
sensorId=$(id fridge)

getTemp(){
 # REAL
 echo $(temp fridge)
 # MOCK
 # simulates fetching unknown fridge temperature from sensor, 
 # randomly, centered around the target temperature
 #echo $((${RANDOM}-8000))
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
if [ ! -e "/sys/class/gpio/gpio${gpio}" ]; then
 echo "${gpio}" > /sys/class/gpio/export
fi

# set pin to output
echo "out" > /sys/class/gpio/gpio${gpio}/direction

# if sensor is not there, exit with warning
if [ ! -e "/sys/bus/w1/devices/$sensorId/w1_slave" ]; then
 echo "$(date) ERROR: fridge temp sensor is missing. sensor id ${sensorId}"
 echo "exiting"
 exit 1
fi

# log state and temp on startup
echo $(jsonData $(getTemp) $(getState)) >> $dataPath

while true
do

 temp=$(getTemp)
 state=$(getState)

 if [ $temp -ge $onTemp ] && [ $state -eq 0 ]
  then
  turnOn
  echo $(jsonData $temp $(getState)) >> $dataPath
    
 elif [ $temp -le $offTemp ] && [ $state -eq 1 ]
  then
  turnOff
  echo $(jsonData $temp $(getState)) >> $dataPath

 fi

sleep 1
done
