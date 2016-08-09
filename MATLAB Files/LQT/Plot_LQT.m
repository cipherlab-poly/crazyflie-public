%X,Y,Z Positions
clc
clear
close all;
load('lqt_rapport_slow')
figure(1)
subplot(3,1,1)
plot(t,states(:,1),'LineWidth',1.5);
grid on;
hold on;
plot(t,z_sim(:,1),'--r','LineWidth',1.5);
xlim([0.8,tsim]);
title('X Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,2)
plot(t,states(:,2),'LineWidth',1.5);
grid on;
hold on;
plot(t,z_sim(:,2),'--r','LineWidth',1.5);
xlim([0.8,tsim]);
title('Y Position');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,3)
plot(t,states(:,3),'LineWidth',1.5);
grid on;
hold on;
plot(t,z_sim(:,3),'--r','LineWidth',1.5);
xlim([0.8,tsim]);
title('Z Position');
xlabel('Time (s)');
ylabel('Position (m)');

legend('LQT','Reference');

figure(2)

subplot(3,1,1)
plot(t,z_sim(:,1)-states(:,1),'LineWidth',1.5);
grid on;
hold on;
plot(t,0.1*ones(size(t)),'--r');
plot(t,-0.1*ones(size(t)),'--r');
title('X Position Error');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,2)
plot(t,z_sim(:,2)-states(:,2),'LineWidth',1.5);
grid on;
hold on;
plot(t,0.1*ones(size(t)),'--r');
plot(t,-0.1*ones(size(t)),'--r');
title('Y Position Error');
xlabel('Time (s)');
ylabel('Position (m)');

subplot(3,1,3)
plot(t,z_sim(:,3)-states(:,3),'LineWidth',1.5);
grid on;
hold on;
plot(t,0.1*ones(size(t)),'--r');
plot(t,-0.1*ones(size(t)),'--r');
title('Z Position Error');
xlabel('Time (s)');
ylabel('Position (m)');


figure(3)
plot3(states(:,1),states(:,2),states(:,3),'LineWidth',1.5);
grid on
hold on
plot3(z_sim(:,1),z_sim(:,2),z_sim(:,3),'--r','LineWidth',1.5);
title('3D Trajectory');
xlabel('X (m)');
ylabel('Y (m)');
zlabel('Z (m)');
% ylim([0.2,1.2]);
%xlim([-1.2,1.2]);
% zlim([0,1.5]);
legend('LQT','Reference');

% Trajectory tracking performance index
perf_index_x = 0;
perf_index_y = 0;
perf_index_z = 0;
for i=1:length(states(:,1))
    if(abs(z_sim(i,1)-states(i,1))<=0.1)
        perf_index_x = perf_index_x+1;
    end
    
    if(abs(z_sim(i,2)-states(i,2))<=0.1)
        perf_index_y = perf_index_y+1;
    end
    
    if(abs(z_sim(i,3)-states(i,3))<=0.1)
        perf_index_z = perf_index_z+1;
    end
end

Ex_LQT = rms(z_sim(:,1)-states(:,1))
Ey_LQT = rms(z_sim(:,2)-states(:,2))
Ez_LQT = rms(z_sim(:,3)-states(:,3))

index_x = perf_index_x*100/length(states(:,1))
index_y = perf_index_y*100/length(states(:,2))
index_z = perf_index_z*100/length(states(:,3))