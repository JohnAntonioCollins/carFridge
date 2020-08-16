#!/bin/bash
# temperature.sh
# version 2.4

echo "$(date) temperature.sh starting"

source /home/pi/carfridge/code/dao/temperatureSensorDao

# set data logging destination
dataName="/carfridge/data/temperature.data"
parentDir="/media/pi/USB_32GB1"
dataFile="${parentDir}${dataName}"
fallbackParentDir="/home/pi"
if [ ! -d $parentDir ] || [ ! -d $dataFile ]; then
 dataFile="${fallbackParentDir}${dataName}"
fi


getSensorJson(){
 name=$1
 t=$(temp $name)
 id=$(id $name)
 echo "{\"name\":\"$name\",\"temperature\":\"$t\",\"id\":\"$id\"}"
}

getAllSensorJson(){
 fridgeJson=$(getSensorJson fridge)
 ambientJson=$(getSensorJson ambient)
 auxJson=$(getSensorJson aux)
 delim=", "
 allSensorJson="${fridgeJson}${delim}${ambientJson}${delim}${auxJson}"
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
