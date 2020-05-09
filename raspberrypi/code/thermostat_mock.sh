# this is a test mock of a refrigerator thermostat
# thermostat.sh, launched on boot, gpio23, physical16

# set initial state, only in this mock test
state=0

# signed int, Celcius thousandths
onTemp=3333
offTemp=1111

getTemp(){
  # simulates fetching unknown fridge temperature from sensor
  # signed int, Celcius thousandths
  t=$((${RANDOM}-8000))
  echo $t
}

getState(){
  # simulates fetching the state of the gpio output pin
  echo $state
}

turnOn(){
  # simulates setting gpio pin to high 1
  state=1
}

turnOff(){
  # simulates setting the gpio pin to low 0
  state=0
}

while true
do
  temp=$(getTemp)
  state=$(getState)
  echo "temp is $temp, state is $state, hi/lo set is $onTemp / $offTemp"
  if [ $temp -ge $onTemp ] && [ $state -eq 0 ]
    then
    echo "hot! cooling..."
    turnOn
  elif [ $temp -le $offTemp ] && [ $state -eq 1 ]
    then
    echo "cooled!"
    turnOff
  fi
sleep 1
done
