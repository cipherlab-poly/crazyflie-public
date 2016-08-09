%MDL_QUADCOPTER Dynamic parameters for a quadrotor.
%
% MDL_QUADCOPTER is a script creates the workspace variable quad which
% describes the dynamic characterstics of a quadrotor flying robot.
%
% Properties::
%
% This is a structure with the following elements:
%
% nrotors   Number of rotors (1x1)
% J         Flyer rotational inertia matrix (3x3)
% h         Height of rotors above CoG (1x1)
% d         Length of flyer arms (1x1)
% nb        Number of blades per rotor (1x1)
% r         Rotor radius (1x1)
% c         Blade chord (1x1)
% Ct        Non-dim. thrust coefficient (1x1)
% Cq        Non-dim. torque coefficient (1x1)
% A         Rotor disc area (1x1)
% gamma     Lock number (1x1)
%
%
% Notes::
% - SI units are used.
%
% References::
% - Design, Construction and Control of a Large Quadrotor micro air vehicle.
%   P.Pounds, PhD thesis, 
%   Australian National University, 2007.
%   http://www.eng.yale.edu/pep5/P_Pounds_Thesis_2008.pdf
% - This is a heavy lift quadrotor
%
% See also sl_quadrotor.

% MODEL: quadrotor

% Copyright (C) 1993-2015, by Peter I. Corke
%
% This file is part of The Robotics Toolbox for MATLAB (RTB).
% 
% RTB is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% RTB is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Leser General Public License
% along with RTB.  If not, see <http://www.gnu.org/licenses/>.
%
% http://www.petercorke.com

% MODIFIED VERSION by Carlos Luis, 2016
quad.nrotors = 4;                %   4 rotors
quad.g = 9.81;                   %   g       Gravity                             1x1
quad.rho = 1.225;                %   rho     Density of air                      1x1
quad.muv = 1.5e-5;               %   muv     Viscosity of air                    1x1

% Airframe
quad.M = 0.03327; %0.029; %0.03327;                      %   M       Mass                                1x1
Ixx =  1.395e-05;  %2.3951e-5; %1.39e-05; %2.51943e-5; % % %
Iyy = 1.395e-05; %2.3951e-5; %1.436e-05; % 2.54379e-5; % %         %
Izz =  2.173e-05;  %3.2347e-5; %2.173e-05 ; %4.51407e-5; % %         %;%0.160;
quad.J = diag([Ixx Iyy Izz]);    %   I       Flyer rotational inertia matrix     3x3

quad.h = -0.00336747;                 %   h       Height of rotors above CoG          1x1
quad.d = 39.73e-3;                  %   d       Length of flyer arms                1x1

%Rotor
quad.nb = 2;                      %   b       Number of blades per rotor          1x1
quad.r =23.1348e-3;                  %   r       Rotor radius                        1x1
%quad.r = quad.r*sin(pi/4); %Just to flight in X mode

quad.c = 9.59e-3;                  %   c       Blade chord                         1x1

quad.Ct = 0.15; %0.0187336 %1.92558e-03;                    %2.11163e-05 for rad/s                            %            %   Ct      Non-dim. thrust coefficient         1x1
quad.Cq = 0.11; % quad.Ct*sqrt(quad.Ct/2);         %   Cq      Non-dim. torque coefficient         1x1
quad.Mb = 0.00025                     %Rotor Blade Mass
quad.Jr = 0.5*quad.Mb*quad.r^2;


% derived constants
quad.A = pi*quad.r^2;                 %   A       Rotor disc area                     1x1

quad.b = 1.35*quad.Ct*quad.rho*(2*pi*9.5493)^(-2)*(2*quad.r)^4; %1.55 for quad without UWB T = b w^2 1.16
quad.k = quad.Cq*quad.rho*(2*pi*9.5493)^(-2)*(2*quad.r)^5; % Q = k w^2

quad.verbose = false;

%% Definition of state model

x_e = [0 0 0 0 0 0 0 0 0 0 0 0];
we = sqrt(quad.M*quad.g/(4*quad.b));
pwm = (we-4070.3)/0.2685;
% u = [we we we we];
u=[pwm pwm pwm pwm];
[A,B,C,D]=linmod('Quad_Model_X',x_e,u);
sys = ss(A,B,C,D);
Ts = 0.01;

sys_d = c2d(sys,Ts);
A_d = sys_d.a;
B_d = sys_d.b;
C_d = C;
