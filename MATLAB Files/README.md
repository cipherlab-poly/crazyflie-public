#MATLAB Simulation Environment and ROS Interface
=============

For the mathematical explanation and design considerations of the different functions and block diagrams, refer to our technical report.

####Dependencies

The ROS interface and MATLAB files were done using version R2015B. It is necessary to have the Robotic System Toolbox for the communication between MATLAB and ROS.

###Peter Corke's Robotic Toolbox files modified for the Crazyflie 2.0
####mdl_quadrotor.m
Specifies the physical parameters and dimensions of the quad to be used in the Non-linear and linearised mathematical models.

####quadrotor_plot.m
Plots a quadcopter given its dimensions and it moves dynamically depending on the Euler angles and XYZ position.


## Cascaded PID Position controller
The simulation for this controller can be found on PID/PID_Controller.slx

Change the setpoints on the Trajectory block to play around with the simulation. To quickly plot the outputs of the simulation, use the file Plot_PID.m

To implement it on the Crazyflie 2.0, follow the instructions below:

1.- Flash the Custom Firmware named "crazyflie-firmware" found in folder "Crazyflie Custom Firmwares".

2.- In crazyflie_ros-master/crazyflie_controller/src/ rename controller.cpp to another name (controllerLQT.cpp is suggested to be organized), and rename controllerPID.cpp to controller.cpp

3.- In crazyflie_ros-master/crazyflie_driver/src/ rename crazyflie_server.cpp to another name (crazyflie_serverLQT.cpp for example), and rename crazyflie_serverPID.cpp to crazyflie_server.cpp

4.- Make sure the changes were saved for both files and build your catkin workspace, don't forget to source your setup
```
$ catkin_make
$ source devel/setup.bash
```
5.- Launch MATLAB and don't forget to initialize the ROS node with
```
rosinit
```
6.- Run the first section in file PID/Plot_interface.m to declare the Kalman Filter constants used in the interface.

7.- Now you're ready to launch the controller, first launch your VICON system:
```
$ roslaunch vicon_bridge vicon.launch
```
8.-Turn on your Crazyflie2.0 making sure its XY axes are aligned with the XY axes of the VICON system for the initial calibration.

9.- Now you can launch the Crazyflie Server that communicates the Crazyflie2.0 with your computer:
```
$ roslaunch crazyflie_demo demo_localisation.launch uri:=radio://0/xx/2M
```
where xx is the channel of the Crazyflie which you can verify with the CFCLIENT made by Bitcraze. We recommend using frequency 2M to maximize the communication speed.

10.- The last step is to launch the Simulink file PID/ROS_PID.slx, the Quadcopter will now be flying depending on the Selector variable, you may customize your own trajectories and get creative with the Trajectory_Generator block. Once the flight is over you can review the data using the second section of file Plot_interface.m

**Better be safe than sorry!** Take security measures before deploying each flight, always make sure the data stream for VICON is logical.

A few examples of experimental data retrieved using this controller are found in PID/Flight Data, and can be visualized and replayed using the script Plot_realtime.m and Visualizer.slx Simulink file.

## Linear Quadratic Tracker (LQT)

By executing the script LQT_12states.m you can simulate all the system, from generating your own custom trajectory to analysing the trajectory tracking performance. Function getcurve2.m is a modified version of the Curve Fitting Toolbox file getcurve.m to increase the GUI box size, and it can be modified further if needed.

The Simulink file LQT_Simulation.slx is the heart of the simulation environment for the LQT controller, following the diagrams seen on the technical report.

To implement and execute this controller on the Crazyflie 2.0 follow the instructions:

1.- Flash the Custom Firmware named "crazyflie-firmware_mod" found in folder "Crazyflie Custom Firmwares".

2.- The default file controller.cpp and crazyflie_server.cpp are already set to work with the LQT controller, in case you changed it to their PID counterparts, make sure to go back to the other files and build your catkin workspace.

3.- Launch MATLAB and don't forget to initialize the ROS node with:
```
rosinit
```
4.- Run the script LQT_12states.m to generate your trajectory and calculate the gains for the LQT controller. Make sure the system is stable by watching the simulation results.

5.- Do steps 7,8 and 9 of the PID controller implementation.

6.- Run the simulink file ROS_LQT.slx and be ready to use the emergency exit if needed. After the flight is done you can run the script Plot_LQT.m to review the flight data and analyse the controller performance.

As in the previous case, the folder Flight Data has experimental flight data that can be visualized by running the script Plot_realtime.m

**NOTE:**

The first time you try to run any of the Simulink files with ROS blocks ("ROS_PID", "ROS_LQT", "ROS_LQT_UWB") an error similar to the following might pop up:
```
"Attempt to  use invalid data type id -594146824"
```
It is nothing to worry about, we suspect it has to do with some initialization of the ROS blocks, the solution is to just run again the simulation and it should disappear.
