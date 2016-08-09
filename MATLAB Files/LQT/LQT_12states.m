%% If you want to change trajectory, run this section before
Trajectory_generation
%%
clc
close all;

%Load Crazyflie's physical parameters and continuous/discrete state space
psi = 0*pi/180;
mdl_quadrotor

sys = ss(A,B,C,D);
Ts = 0.01; %Time step defining Controller @ 100Hz

sys_d = c2d(sys,Ts);
A_d = sys_d.a;
B_d = sys_d.b;
C_d = C;

%Simulation Time definitions
k0 = 0;
tsim = 40;
tsim_tra = tsim+5;
kf = tsim_tra;
xk = [0;0;0;0;0;0;0;0;0;0;0;0]; %Initial Conditions for the states

sim('Trajectory'); %File defines the trajectory for the LQT controller
%% RUN from here if you don't want to change trajectory
dim = size(zk);
zkf = zk(dim(1),:);
N = kf+1; %Unnecessary, simulation from 1->N+1 == 0->N
I = eye(12); %Identity matrix 12x12
Q = diag([2200,2200,4000,4000,4000,4000,20,20,10,10,10,10]);
F = Q;
R = eye(4)*0.00003;

%Matrices of LQT problem
E = B_d*R^(-1)*B_d'; 
V = C'*Q*C;
W = C'*Q;
Pkplus1 = C'*F*C;
gkplus1 = C'*F*zkf';

%Resolve Riccati algebraic equation backwards in time
%Calculate Feedback coefficient g(k)
i = length(N:-Ts:1);
for k=N-Ts:-Ts:1
    Pk = A_d'*Pkplus1*(I+E*Pkplus1)^(-1)*A_d+V;
    Lk = (R+B_d'*Pkplus1*B_d)^(-1)*B_d'*Pkplus1*A_d;
    gk = (A_d-B_d*Lk)'*gkplus1+W*zk(i,:)'; %(A_d'-(A_d')*Pkplus1*gk(I+E*Pkplus1)^(-1)*E)*gkplus1+W*zk;
    Pkplus1 = Pk;
    gkplus1 = gk;
    g(:,:,i)=gk;
    i= i-1;
end

%Calculate Feedback coefficients L(k) and Lg(k)
i = length(N:-Ts:1);
for k = N:-Ts:1
    Lk = (R+B_d'*Pkplus1*B_d)^(-1)*B_d'*Pkplus1*A_d;
    Lgk = (R+B_d'*Pkplus1*B_d)^(-1)*B_d';
    L(:,:,i)=Lk;
    Lg(:,:,i)=Lgk;
    i= i-1;
end

x = zeros(12,2999); %random number just to declare the variable
x(:,1)=xk; % load initial conditions in the state vector

%Compute the states with the feedback optimal controller 
i=1;
for k=1:Ts:N-Ts 
    Lk = L(:,:,i);
    Lgk = Lg(:,:,i);
    gkplus1 = g(:,:,i+1);
    xk = x(:,i);
    xkplus1 = (A_d-B_d*Lk)*xk + B_d*Lgk*gkplus1;
    x(:,i+1)=xkplus1;
    i=i+1;
end

%Compute g(k+1) and add final condition to the feedback coefficient
i=1;
for k=1:Ts:N-Ts 
    g1(:,:,i) = g(:,:,i+1);
    i=i+1;
end
g1(:,:,length(1:Ts:N))= C'*F*zkf';

%Calculate the optimal control law u(k)
i=1;
for k=1:Ts:N
    Lk = L(:,:,i);
    Lgk = Lg(:,:,i);
    gkplus1 = g1(:,:,i);
    xk = x(:,i);
    U(:,:,i)=-Lk*xk + Lgk*gkplus1 + u';
    i=i+1;
end  

  g_pos = g1([1,2,3,7,8,9],:,:);
  L_pos = L(:,[1,2,3,7,8,9],:);
  Lg_pos = Lg(:,[1,2,3,7,8,9],:);
  
  L_ang = L(:,[4,5,6,10,11,12],:);
  g_ang = g1([4,5,6,10,11,12],:,:);
  Lg_ang = Lg(:,[4,5,6,10,11,12],:);

%Create the structures to export to Simulink
t = 0:Ts:N-1;
L_sim.time = t';
L_sim.signals.values = L_pos;
L_sim.signals.dimensions = [4 6];

L_sim1.time = t';
L_sim1.signals.values = L_ang;
L_sim1.signals.dimensions = [4 6];

Lg_sim.time = t';
Lg_sim.signals.values = Lg_pos;
Lg_sim.signals.dimensions = [4 6];

Lg_sim1.time = t';
Lg_sim1.signals.values = Lg_ang;
Lg_sim1.signals.dimensions = [4 6];

g_sim.time = t';
g_sim.signals.values = g_pos;
g_sim.signals.dimensions = [6 1];

g_sim1.time = t';
g_sim1.signals.values = g_ang;
g_sim1.signals.dimensions = [6 1];

u_sim.time = t';
u_sim.signals.values = U;
u_sim.signals.dimensions = [4 1];

T=t;

x_des = [T' zk(:,1)];
y_des = [T' zk(:,2)];
z_des = [T' zk(:,3)];

% Integral Gains definitions
Ki_coef = 5000;
Ki_coefz = 5000;

Ki_LQT = [Ki_coef  -Ki_coef   -Ki_coefz
         -Ki_coef  -Ki_coef   -Ki_coefz
         -Ki_coef   Ki_coef   -Ki_coefz
          Ki_coef   Ki_coef   -Ki_coefz];
      
Ki_coef_ang = 8660.3;

Ki = [-Ki_coef_ang  -Ki_coef_ang   -Ki_coef_ang
       Ki_coef_ang   Ki_coef_ang   -Ki_coef_ang
      -Ki_coef_ang   Ki_coef_ang    Ki_coef_ang
       Ki_coef_ang  -Ki_coef_ang    Ki_coef_ang];


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
%Choose between the VICON or UWB to simulate

%UWB
% Q_kal = diag([3e-5 3e-5 8e-8]);
% R_kal = diag([5e-5 5e-5 5e-9]);
% VAR_XY = 5e-5;
% VAR_Z  = 5e-9;

%VICON
Q_kal = diag([8e-8 8e-8 8e-8]);
R_kal = diag([5e-9 5e-9 5e-9]);
VAR_XY = 5e-9;
VAR_Z  = 5e-9;
%%
sim('LQT_Simulation')

%X,Y,Z Positions
figure(2)
subplot(3,1,1)
plot(t_sim,state_lqt(:,1),'LineWidth',1.5);
grid on;
hold on;
plot(T,zk(:,1),'--r','LineWidth',1.5);
xlim([0,tsim]);
title('X Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,2)
plot(t_sim,state_lqt(:,2),'LineWidth',1.5);
grid on;
hold on;
plot(T,zk(:,2),'--r','LineWidth',1.5);
xlim([0,tsim]);
title('Y Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,3)
plot(t_sim,state_lqt(:,3),'LineWidth',1.5);
grid on;
hold on;
plot(T,zk(:,3),'--r','LineWidth',1.5);
xlim([0,tsim]);
title('Z Position');
xlabel('Time (s)');
ylabel('Position (m)');
legend('LQT','Desired Trajectory');
%%
%Roll, Pitch, Yaw angles
figure(3)

subplot(3,1,1)
plot(t_sim,state_lqt(:,4)*180/pi,'LineWidth',1.5);
grid on;
xlim([0,tsim]);
title('Yaw angular Position');
xlabel('Time (s)');
ylabel('Angular Position (deg)');

subplot(3,1,2)
plot(t_sim,state_lqt(:,5)*180/pi,'LineWidth',1.5);
grid on;
xlim([0,tsim]);
title('Pitch angular Position');
xlabel('Time (s)');
ylabel('Angular Position (deg)');

subplot(3,1,3)
plot(t_sim,state_lqt(:,6)*180/pi,'LineWidth',1.5);
grid on;
xlim([0,tsim]);
title('Roll angular Position');
xlabel('Time (s)');
ylabel('Angular Position (deg)');

%Control effort
figure(4)
plot(t_sim,(pwm_lqt(1,:)'+pwm_lqt(2,:)'+pwm_lqt(3,:)'+pwm_lqt(4,:)'),'LineWidth',1.5);
grid on;
title('Total PWM of the four motors');
xlabel('Time (s)');
ylabel('PWM');

%Position Error
figure(5)
size_t = size(t);

subplot(3,1,1)
plot(t_sim,abs(state_lqt(:,1)-zk((1:size_t(1)),1)),'LineWidth',1.5);
grid on;
title('X Position Error');
xlabel('Time (s)');
ylabel('Error (m)');

subplot(3,1,2)
plot(t_sim,abs(state_lqt(:,2)-zk((1:size_t(1)),2)),'LineWidth',1.5);
grid on;
title('Y Position Error');
xlabel('Time (s)');
ylabel('Error (m)');

subplot(3,1,3)
plot(t_sim,abs(state_lqt(:,3)-zk((1:size_t(1)),3)),'LineWidth',1.5);
grid on;
title('Z Position Error');
xlabel('Time (s)');
ylabel('Error (m)');

% 3D Plot of trajectory followed
figure(6)
plot3(state_lqt(:,1),state_lqt(:,2),state_lqt(:,3),'LineWidth',1.5);
grid on;
hold on;
plot3(zk(:,1),zk(:,2),zk(:,3),'--r','LineWidth',1.5);
title('3D Trajectory');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
ylim([-1.5,1.5]);
xlim([-1.5,1.5]);
zlim([0,2]);
legend('LQT','Desired Trajectory');

%Kalman filter estimations of the body frame Velocity vector
figure (7)
subplot(3,1,1)
plot(t_sim,state_lqt(:,7))
grid on
hold on
plot(t_sim,state_lqt1(:,7),'r')
title('X Velocity in body frame estimation Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');

subplot(3,1,2)
plot(t_sim,state_lqt(:,8))
grid on
hold on
plot(t_sim,state_lqt1(:,8),'r')
title('Y Velocity in body frame estimation Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');

subplot(3,1,3)
plot(t_sim,state_lqt(:,9))
grid on
hold on
plot(t_sim,state_lqt1(:,9),'r')
title('Z Velocity in body frame estimation Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');
legend('Kalman Filter','True Dynamics')

%Kalman Filter error with respect to the Quad's true dynamics
figure (8)
subplot(3,1,1)
plot(t_sim,state_lqt(:,7)-state_lqt1(:,7))
grid on
title('X Velocity Estimation Error Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');

subplot(3,1,2)
plot(t_sim,state_lqt(:,8)-state_lqt1(:,8))
grid on
title('Y Velocity Estimation Error Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');

subplot(3,1,3)
plot(t_sim,state_lqt(:,9)-state_lqt1(:,9))
grid on
title('Z Velocity Estimation Error Kalman Filter')
xlabel('Time (s)');
ylabel('Velocity (m/s)');