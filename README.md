# poe_watchdog
PoE Watchdog Script to control a GPIO pin based on ping to a network host

Syntax: poe_watchdog host interval multiplier pin

host    ip or hostname of device to check
interval        frequency of pings to device
multiplier      threshold of failed pings to reset device
pin     gpio pin to reset device

## Behavior

root@beaglebone:/home/debian# ./poe_watchdog.sh 192.168.132.160 1 5 60
PoE Watchdog Script

We are testing connectivity to 192.168.132.160.
I will check to see if the host is alive every 1 seconds, and will toggle pin 60 if the ping fails 5 times.
Counter: 0
> Network breaks 
connect: Network is unreachable
Counter: 1
connect: Network is unreachable
Counter: 2
connect: Network is unreachable
Counter: 3
connect: Network is unreachable
Counter: 4
connect: Network is unreachable
Counter: 5
Failure count exceeded threshold. Toggling pin 60...
> Pin goes high for 5 seconds
Waiting for device to come back online...
connect: Network is unreachable
> Connectivity is restored
Counter: 0
^Z
