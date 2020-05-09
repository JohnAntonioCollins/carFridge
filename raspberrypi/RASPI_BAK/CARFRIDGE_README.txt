NOTE: Installed raspAP on raspberry pi. 
wifi pass: mate ricks
admin: admin/Garfield

NOTE: r'pi has HDMI disabled in order to save power.
 To enable HDMI, in config file /etc/rc.local, delete line
        /usr/bin/tvservice -o
 (to enable it temporarily, do /usr/bin/tvservice -p)

NOTE: r'pi has an internal clock. But the date/time may be manually set.
 To set time/date on r'pi do:
	sudo date -s "12 MAY 2018 18:28:00"
	BUT REPLACE THAT DATA WITH THE CURRENT DATA.

NOTE: temperature.sh is called on r'pi boot. 
r'pi logs date and temperature every 30 seconds to temperature.log
REF: .config/lxsession/LXDE-pi/autostart:@/home/pi/temperature.sh

SENSORS:
get unique sensor id: 
		cd /sys/bus/w1/devices
		ls
test sensor by viewing raw sensor data:
		cd <your sensor id dir>
		cat w1-slave
