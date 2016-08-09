#Crazyflie Custom Firmwares
Three different custom firmwares were made to be used with the PID controller and the Linear Quadratic Tracker.

##crazyflie-firmware
This was modified from the latest Bitcraze Crazyflie Firmware, just a few lines were modified in the controller section of the firmware as well as in the Power Distribution file.

##crazyflie-firmware_mod
Modified to implement the LQT controller (part of it, as explained in the technical report). The main changes were done in the files "controller_pid.c", "stabilizer.c", "commander.c" and "power_distribution_stock.c".


**NOTE**

The firmware "crazyflie-firmware_mod" can be used in teleoperated flight by:

1.- In file "controller_pid.c", uncomment lines 60-62 and comment lines 65-67.

2.- In file "power_distribution_stock.c" uncomment lines 58-62 and comment lines 64-68.

Then flash the firmware and use it with the cfclient for teleoperated flight.

**NOTE**

When compiling one of the projects using Eclipse or any similar IDE, sometimes it is difficult to make arm chain tool recognizable in the Makefile. If the configuration of the toolchain was done properly, it should work as it is in the repository, but if not you may add the whole path to your file in the CROSS_COMPILE line of the Makefile, as follows:
```
CROSS_COMPILE     ?= /usr/local/gcc-arm-none-eabi-4_9-2015q3/bin/arm-none-eabi-
```
