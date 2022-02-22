%% This script aims to compute the 2D vector of forces through the knee joint
% theta_1 = flexation of the knee (0,160 [deg])
% theta_2 = angle of torso (-5,80 [deg])
% theta_3 = angle of lower leg (-30,30 [deg])
%% Initialisations
close all;
clear all;

%% Parameters
% constants
g = 9.81; % [m/s^2]

% lengths

H = 1.55; % height [m]
d1 = 55/2/1000/H; % proximal tibia dimension in A-P sagital is 55mm.

Lub = 0.536; % length of upper body
Lll = 0.232; % length of lower leg
Lul = 0.232; % length of upper leg

% masses (fractional body weight) - data by Zatsiorsky et al. (1990), ...
% as modified by deLeva (1996). (Female)
mh = 6.68; % head
mt = 42.57; % trunk (torso)
mua = 2.55; % upper arm
mf = 1.38; % forearm
mhand = 0.56; % hand
mthigh = 14.78; %thigh
ms = 4.81; % shank
mfoot = 1.29; % foot


mub = mh + mt + (mua + mf + mhand)*2; % total mass of upper body

mtotal = 45; % [kg]

% CoM 
CMh = 58.94;
CMt = 41.51;
CMua = 57.54;
CMf = 45.59;
CMhand = 74.74;
CMthigh = 36.12;
CMs = 44.16;
CMfoot = 40.14;

% forces based on 1 unit body weight
% moments positive anticlockwise
theta_1 = linspace(0,160,50);
%theta_2 = linspace(-5,40,50);
%theta_1 = 0;
theta_2 = 0;
theta_3 = 0;
%theta_3 = linspace(-30,30,50);
Ful = mthigh/100*[0; -1]*g; % linear force from upper leg
Mul = mthigh/100*sin(theta_1*pi/180)*Lul*(1-CMthigh)/100*9.81; % moment from upper leg

Fub = mub/100*[0; -1]*g; % linear force from upper body
Mub = mub/100*(sin(theta_2*pi/180)*Lub*(1-CMt)/100 + sin(theta_1*pi/180)*Lul)*9.81; % moment from upper body

Ftotal = Ful + Fub; % total mass
Mtotal = Mul + Mub; % total moment 

p_ang = 10; % angle of PT relative to tibial axis
PT =  Mtotal/d1*cos(p_ang/180*pi).*[sin((theta_3-p_ang)/180*pi); cos((theta_3-p_ang)/180*pi)];
absPT = vecnorm(PT);
FT = zeros(2,50);
FT(1,:) = -PT(1,:);
FT(2,:) = -PT(2,:)-0.5*9.81; 
absFT = vecnorm(FT);

h = figure(1);
plot(theta_1,absFT/g,'LineWidth',2)
xlabel('$\theta\ -\ flexion\ [Degrees]$',Interpreter='latex')
ylabel('$|\textbf{FT}|\ [g]$',Interpreter='latex')

set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,'FT_with_flexation','-dpdf','-r0')
