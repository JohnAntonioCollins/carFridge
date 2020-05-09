#!/bin/bash
# temperature.sh
# version 2.2

dataFile=/home/pi/temperature.data

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
 cat /sys/bus/w1/devices/$sensorId/w1_slave | grep "t=" | sed 's/.*t=//'
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
