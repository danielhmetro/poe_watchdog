echo "PoE Watchdog Script"
echo
host=$1
interval=$2
multiplier=$3
pin=$4

Help()
{
        echo "Syntax: poe_watchdog host interval multiplier pin"
        echo
        echo "host      ip or hostname of device to check"
        echo "interval  frequency of pings to device"
        echo "multiplier        threshold of failed pings to reset device"
        echo "pin       gpio pin to reset device"
        echo
        exit
}
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then Help; else echo "We are testing connectivity to $host."; fi

echo "I will check to see if the host is alive every $interval seconds, and will toggle pin $4 if the ping fails $multiplier times."

echo $pin > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio$pin/direction
echo 0 > /sys/class/gpio/gpio$pin/value

fails=0

while true
do
        ping -c 1 -w 1 $host > /dev/null
        if (( $? == 0 )); then
                fails=0
        else
                fails=$((fails+1))
        fi
        echo "Counter: $fails"
        sleep $interval
        if (( fails == $multiplier )); then
                fails=0
                echo "Failure count exceeded threshold. Toggling pin $pin..."
                echo 1 > /sys/class/gpio/gpio60/value
                sleep 5
                echo 0 > /sys/class/gpio/gpio60/value
                echo "Waiting for device to come back online..."
                while true
                do
                        ping -c 1 -w 1 $host > /dev/null
                        if (( $? == 0 )); then break; fi
                        sleep 1
                done
        fi
done
