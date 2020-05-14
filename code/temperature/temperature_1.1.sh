#!/bin/bash
logFile=~/temperature.log

line(){
  echo "" >> $logFile 
}

timeStamp(){
  date >> $logFile 
}

getTemp(){
  #line
  #echo sensor 28-0517c45cb5ff >> $logFile 
  #cat /sys/bus/w1/devices/28-0517c45cb5ff/w1_slave >> $logFile 
  line
  echo sensor 28-0417c4295fff >> $logFile 
  cat /sys/bus/w1/devices/28-0417c4295fff/w1_slave >> $logFile 
  line
  echo sensor 28-0417c46ba8ff >> $logFile 
  cat /sys/bus/w1/devices/28-0417c46ba8ff/w1_slave >> $logFile 
}

while true; do
line
timeStamp
getTemp
line
line
sleep 30
done
