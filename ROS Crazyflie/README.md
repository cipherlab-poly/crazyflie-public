#crazyflie_ros
=============

This is the original whoenig's Crazyflie ROS package found [here](https://github.com/whoenig/crazyflie_ros) with some modifications in the controller node and the server node in order to implement the control system developed.

The main files modified were:

##Controller node
In the folder crazyflie_controller there are two different nodes:

1.- controller.cpp is the node to be used with the LQT controller.

2.- controllerPID.cpp is the node to be used with the PID controller.

When executing the launch file, only the file named "controller.cpp" will be executed, hence you should verify that the node you want to execute is indeed the one named "controller.cpp".

**Subscribers:**

-m_joy_sub (topic /joy): subscribes to the input of a joystick, we used a PS4 controller and the debouncing routine found in the node was done for this controller in particular, it might or it might not work for other controllers.

-m_imu_sub (topic /crazyflie/imu): displays information coming from the IMU of the Crazyflie 2.0, in particular the gyroscope measurements and then the Euler angles (roll, pitch, yaw) coming from the Sensor Fusion algorithm embedded in the Crazyflie.

-m_viconpos_sub (topic /vicon/pos): subscribes to the position estimations of the VICON system, using only one marker on top of the Crazyflie, should be modified to subscribe to /vicon/markers topic if you want to use more than one marker.

-m_goal_sub (topic /goal): subscribes to the data coming from the MATLAB node. When using the LQT controller, it represents the PWM inputs sent to the Crazyflie's motors, and when using the PID controller it represents the Euler angles setpoints and other configurations (check the nodes for better understanding).

**Publisher:**

-m_pubNav (topic /cmd_vel): publishes the commands that need to be sent to the Crazyflie via the crazyflie_server node.

##Crazyflie Server node
Located in crazyflie_driver/src/crazyflie_server.cpp. Once again, there are two different nodes:

1.- crazyflie_server.cpp is the node to be used with the LQT controller.

2.- crazyflie_serverPID.cpp is the node to be used with the PID controller.

Same as before, only the file named "crazyflie_server.cpp" will be executed with the launch file, thus make sure the controller.cpp and crazyflie_server.cpp are consistent with each other (LQT files or PID files, don't mix them!).

**Publishers:**

-m_pubImu (topic /crazyflie/imu): IMU data from the Crazyflie in degrees(Euler angles) and degrees per second(Gyroscope readings).

-m_pubMotors (topic /crazyflie/motor): publishes the PWM signals sent to the motors (16 bit value).

##Launch File

Use the launch file /crazyflie_demo/launch/demo_localisation.launch as shown below:
```
$ roslaunch crazyflie_demo demo_localisation.launch uri:=radio://0/XX/XXXX
```
If you don't know the channel and frequency of your Crazyflie 2.0, you may first try with uri:=radio://0/80/250K which is the default address or else, you should install the client found [here](https://github.com/bitcraze/crazyflie-clients-python) that lets you change the channel and/or frequency. We suggest using frequency 2M as it offers maximum speed in the communication.

#vicon_bridge
=============
vicon_bridge is a ros package providing data from VICON motion capture systems.
The package was updated to track and publish tf of unlabeled markers using vicon_listener node.
The ip address of DataStream server machine is 132.207.24.6:801 (801 is the default port). To change the ip address for the VICON server, go to vicon_bridge/launch/vicon.launch and modify accordingly to your needs

## Quick Start
To use it, you have to be connected through ethernet to the local network associated with your VICON server
```
$ roslaunch vicon_bridge vicon.launch
```
If you are using just one marker you can visualize the position data from the vicon using:
```
$ rostopic echo vicon/pos
```

For more than one marker, you should create an object in the VICON interface and use the markers topic
```
$ rostopic echo vicon/markers
```
