%% Reproduces an experimental flight of the Crazyflie 2.0
% With the LQT controller
% Using data from the VICON system and the drone's IMU
% Choose between 1 of the 5 trajectories .mat files containes in folder
% named "Flight Data"
% Intructions: replace line 14 of this file with either:
% load('Circle')
% load('Pacman')
% load('Random')
% load('Shoe')
% load('Spiral')
% and then just click on the "Run" Button
% See Simulink file "ROS_LQT" to understand the meaning of the variables
clear
load('Circle')
Ts = 0.01; %Step time for the visualizer
yaw_inter = interp1(t_real,states_all(:,4),t);
pitch_inter = interp1(t_real,states_all(:,5),t);
roll_inter = interp1(t_real,states_all(:,6),t);

x = [t states(:,1)];
y = [t states(:,2)];
z = [t states(:,3)];
yaw = [t yaw_inter];
pitch = [t pitch_inter];
roll = [t roll_inter];
Time = max(t);

sim('Visualizer')

%% Using the PID controller

% Choose between 1 of the 4 trajectories .mat files containes in folder
% named "Flight Data"
% Intructions: replace line 14 of this file with either:
% load('Circle_PID')
% load('Step_x')
% load('Step_y')
% load('Step_z')
% and then just click on the "Run" Button
% See Simulink file "ROS_PID" to understand the meaning of the variables
clear
load('Step_z')
Ts = 0.01; %Step time for the visualizer

x = [t state(:,1)];
y = [t state(:,2)];
z = [t state(:,3)];
yaw = [t state(:,4)];
pitch = [t state(:,5)];
roll = [t state(:,6)];
Time = max(t);

sim('Visualizer')