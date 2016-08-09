%Trajectory generation SPLINE
clear
clc
Ts = 0.01;
%GUI for waypoint locations and spline interpolation
figure(1)
[xy, spcv] = getcurve2;
x = [0 xy(1,:)];
y = [0 xy(2,:)];
t = 1:length(x);
figure(2);
h1=plot(x,y,'ro');
grid on;
%Create the XY Trajectory described by the spline interpolation of
%the desired waypoints selected in the GUI
time_traj = 20; %Time in which we want to execute the desired trajectory
xx = interp1(t,x,1:0.01:length(x),'spline');
yy = interp1(t,y,1:0.01:length(x),'spline');
Tau = (length(x)-1)/(time_traj*100);
t_traj = 1:Tau:length(x);
x_traj = interp1(1:0.01:length(x),xx,t_traj);
y_traj = interp1(1:0.01:length(x),yy,t_traj);
hold on; 
h2=plot(xx,yy,'LineWidth',1.5);
title('XY Plane of generated trajectory')
xlabel('X Position (m)')
ylabel('Y Position (m)')
xlim([-2,2]);
ylim([-2,2]);

xx_p = interp1(t,x,1:0.01:length(x),'pchip');
yy_p = interp1(t,y,1:0.01:length(x),'pchip');
x_traj_p = interp1(1:0.01:length(x),xx_p,t_traj);
y_traj_p = interp1(1:0.01:length(x),yy_p,t_traj);

h3=plot(xx_p,yy_p,'LineWidth',1.5);
legend([h2,h3,h1],'Spline','Pchip','Waypoints')

figure(3)
subplot(2,1,1)
plot((0:Ts:time_traj),x_traj,'LineWidth',1.5);
grid on;
hold on;
plot((0:Ts:time_traj),x_traj_p,'LineWidth',1.5);

subplot(2,1,2)
plot((0:Ts:time_traj),y_traj,'LineWidth',1.5);
grid on;
hold on;
plot((0:Ts:time_traj),x_traj_p,'LineWidth',1.5);
legend('Spline','Pchip')

reply='a';
while(reply~='p' && reply~='s')
reply = input('Type the letter s to use Spline trajectory\nor p for pchip trajectory\nThen press ENTER\n','s');

if(reply=='s')
x_fin = x_traj(length(t_traj));
y_fin = y_traj(length(t_traj));
x_traj = [(0:Ts:time_traj)' x_traj'];
y_traj = [(0:Ts:time_traj)' y_traj'];
end

if(reply=='p')
x_fin = x_traj(length(t_traj));
y_fin = y_traj(length(t_traj));
x_traj = [(0:Ts:time_traj)' x_traj_p'];
y_traj = [(0:Ts:time_traj)' y_traj_p'];
end
end

input('\nNow choose the altitude command as if it were the X position of the plot\nPress ENTER to continue')
% Do the same thing but for Z position
figure(1)
[z, spcv] = getcurve2;
z = [0 z(1,:) 0];
t = 1:length(z);
zz = interp1(t,z,1:0.01:length(z),'spline');
Tau = (length(z)-1)/(time_traj*100);
t_traj = 1:Tau:length(z);
z_traj = interp1(1:0.01:length(z),zz,t_traj);
figure(4)
plot((0:Ts:time_traj),1+z_traj,'LineWidth',1.5);
grid on;
hold on;
zz_p = interp1(t,z,1:0.01:length(z),'pchip');
z_traj_p = interp1(1:0.01:length(z),zz_p,t_traj);
plot((0:Ts:time_traj),1+z_traj_p,'LineWidth',1.5);
legend('Spline','Pchip')

reply='a';
while(reply~='p' && reply~='s')
reply = input('Type the letter s to use Spline trajectory\nor p for pchip trajectory\nThen press ENTER\n','s');

if(reply=='s')
z_traj = [(0:Ts:time_traj)' z_traj'];
end

if(reply=='p')
z_traj = [(0:Ts:time_traj)' x_traj_p'];
end
end

