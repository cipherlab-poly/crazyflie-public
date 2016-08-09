%%Plot Position x,y,z of Crazyflie 2.0 Simulation
clc
clear
close all
mdl_quadrotor;
sim('PID_Controller');
green = [0 0.8 0];
subplot(2,2,1)
plot(t,state(:,1),'LineWidth',1.3);
grid on;
hold on;
plot(t,state_lin(:,1),'LineWidth',1.3,'Color',green);
plot(t,x_c,'--r','LineWidth',1.3);
title('X Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,2,2)
h1=plot(t,state(:,2),'LineWidth',1.3);
grid on;
hold on;
h2=plot(t,state_lin(:,2),'LineWidth',1.3,'Color',green);
h3=plot(t,y_c,'--r','LineWidth',1.3);
title('Y Position');
xlabel('Time (s)');
ylabel('Position (m)');
legend([h2 h1 h3],'Linear','Non-linear','Reference');

subplot(2,2,3)
plot(t,state(:,3),'LineWidth',1.3);
grid on;
hold on;
plot(t,state_lin(:,3),'LineWidth',1.3,'Color',green);
plot(t,z_c,'--r','LineWidth',1.3);
title('Z Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(2,2,4)
plot(t,state(:,4)*180/pi,'LineWidth',1.3);
grid on;
hold on;
plot(t,state_lin(:,4)*180/pi,'LineWidth',1.3,'Color',green);
plot(t,psi_c,'--r','LineWidth',1.3);
title('Yaw angle');
xlabel('Time (s)');
ylabel('Angle (deg)');

figure
h1=plot3(state(:,1),state(:,2),state(:,3),'LineWidth',1.3);
grid on
hold on
h2=plot3(state_lin(:,1),state_lin(:,2),state_lin(:,3),'LineWidth',1.3,'Color',green);
h3=plot3(x_c,y_c,z_c,'--r','LineWidth',1.3);
title('3D Trajectory');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
ylim([-1,1]);
xlim([-1,1]);
zlim([0,2.1]);
legend([h2 h1 h3],'Linear','Non-linear','Reference');
