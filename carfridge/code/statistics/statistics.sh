#!/bin/bash
# statistics
# v1.0
# get average, max, and min

source /home/pi/carfridge/code/dao/tempSensorDAO


dataDir="/media/pi/USB_32GB/carfridge/data"
avgFile="${dataDir}/average.data"
minFile="${dataDir}/min.data"
maxFile="${dataDir}/max.data"



prepPrvVal(){
 file=$1
 if [ ! -e $file ] || [ -z $(cat $file) ]; then
  echo $(getTemp) > $file
 fi
}

getTemp(){
 echo $(temp "fridge")
}

getAvg(){
 echo $(cat $avgFile)
}

getMin(){
 if [ ! -e $minFile ]; then
  echo $(getTemp) > $minFile
 fi
 echo $(cat $minFile)
}

getMax(){
 cat $maxFile
}


calcAvg(){
 prvAvg=$(getAvg)
 t=$(getTemp)
 sum=$((prvAvg + t))
 avg=$((sum / 2))
 echo $avg
}

calcMin(){
 temp=$(getTemp)
 prvMin=$(getMin)
 if [ $temp -lt $prvMin ]; then
  echo $temp
 else
  echo $prvMin
 fi
}

calcMax(){
 temp=$(getTemp)
 prvMax=$(getMax)
 if [ $temp -gt $prvMax ]; then
  echo $temp
 else
  echo $prvMax
 fi
}


updateStats(){
 echo $(calcMax) > $maxFile
 echo $(calcMin) > $minFile
 echo $(calcAvg) > $avgFile
}

getStatsJSON(){
 updateStats
 echo "{\"avg\":\"$(getAvg)\",\"min\":\"$(getMin)\",\"max\":\"$(getMax)\"}"
}

prepPrvVal $avgFile
prepPrvVal $minFile
prepPrvVal $maxFile

$1

