%% BEFORE RUNNING ROS_PID YOU NEED TO RUN THIS SECTION
clc
clear;
Ts = 0.01;
% Kalman Filter for position and linear velocity
% State Space Model of the system 

A_kal = [1 0 0 Ts 0 0
         0 1 0 0 Ts 0
         0 0 1 0 0 Ts
         0 0 0 1 0 0
         0 0 0 0 1 0
         0 0 0 0 0 1];

C_kal = [1 0 0 0 0 0
         0 1 0 0 0 0
         0 0 1 0 0 0];
     
G_kal =[Ts/2  0     0
         0   Ts/2   0
         0    0    Ts/2
         1    0     0
         0    1     0
         0    0     1];

%Weighting matrices for the filter and noise for simulation

%VICON
Q_kal = diag([8e-8 8e-8 8e-8]);
R_kal = diag([5e-9 5e-9 5e-9]);
%%
figure(1)
subplot(2,2,1)
plot(t,state(:,1),'LineWidth',1.5);
grid on;
hold on;
plot(t,traj(:,1),'--r','LineWidth',1.5);
title('X Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,2,2)
plot(t,state(:,2),'LineWidth',1.5);
grid on;
hold on;
plot(t,traj(:,2),'--r','LineWidth',1.5);
title('Y Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,2,3)
plot(t,state(:,3),'LineWidth',1.5);
grid on;
hold on;
plot(t,traj(:,3),'--r','LineWidth',1.5);
title('Z Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,2,4)
plot(t,state(:,4)*180/pi,'LineWidth',1.5);
grid on;
hold on;
plot(t,traj(:,4),'--r','LineWidth',1.5);
title('Yaw Angular Position');
xlabel('Time (s)');
ylabel('Angular Position (deg)');
legend('Experimental','Reference');

figure(2)

plot3(state(:,1),state(:,2),state(:,3),'LineWidth',1.5);
grid on;
hold on;
plot3(traj(:,1),traj(:,2),traj(:,3),'--r','LineWidth',1.5);
title('3D Trajectory');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
ylim([-1,1]);
xlim([-1,1]);
zlim([0,2]);
legend('Experimental','Reference');
