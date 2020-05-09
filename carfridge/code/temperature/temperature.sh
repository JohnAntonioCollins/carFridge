#!/bin/bash
# temperature.sh
# version 2.2

echo "$(date) temperature.sh starting"

# set data logging destination
dataName="temperature.data"
dataDir="/media/pi/USB_32GB/carfridge/data/"
fallbackDir="/home/pi/carfridge/data/"
if [ ! -d $dataDir ]; then
 dataDir=$fallbackDir
fi
dataFile="${dataDir}${dataName}"


# ds18b20 temperature sensor IDs 
sensorA=28-0417c46ba8ff
sensorB=28-0417c4295fff
sensorC=28-0517c45cb5ff

# sensor-id : sensor-name
declare -A sensorName
sensorName[$sensorA]=fridge
sensorName[$sensorB]=ambient
sensorName[$sensorC]=aux


getSensorTemperature(){
 sensorId=$1
 device="/sys/bus/w1/devices/${sensorId}/w1_slave"
 if [ -e ${device} ]; then
  cat ${device} | grep "t=" | sed 's/.*t=//'
 else
  echo "$(date) WARNING: temperature sensor missing. ${device}" >&2
 fi
}

getSensorName(){
 id=$1
 echo ${sensorName[$id]}
}

getSensorJson(){
 sensorId=$1
 temp=$(getSensorTemperature $sensorId)
 name=$(getSensorName $sensorId)
 echo "{\"id\":\"$sensorId\",\"temperature\":\"$temp\",\"name\":\"$name\"}"
}

getAllSensorJson(){
 sensorAjson=$(getSensorJson $sensorA)
 sensorBjson=$(getSensorJson $sensorB)
 sensorCjson=$(getSensorJson $sensorC)
 delim=", "
 allSensorJson="${sensorAjson}${delim}${sensorBjson}${delim}${sensorCjson}"
 echo $allSensorJson
}

getAllJson(){
 sensorDataJson=$(getAllSensorJson)
 allJson="{\"datetime\":\"$(date)\", \"sensorData\":[ $sensorDataJson ]}"
 echo $allJson
}


while true; do
getAllJson >> $dataFile
sleep 30 
done
