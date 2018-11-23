%% Calcualations for Coils Paper Parameters
%% Method based on Abbott, J. J. Parametric design of tri-axial nested Helmholtz coils. Rev. Sci. Instrum. 86, (2015).
%% Paramater Definitions

close all
clear all
clc

%% Initial Parameters
mu_0 = 4E-7*pi; % T m A^-1
B = 10E-3; % T, desired field strength
H = B/mu_0; % magnetic field, A m^-1
Sc = [0 0 0]; % m, spool bottom thickness
Tc = [0 0 0]; % m, spool side thickness
% Wire Properties
eta = 4.23e-3; % ohm/m
di = 1.02362e-3; % m, 18 Gauage Wire inner diameter (without insulation)     https://www.powerstream.com/Wire_Size.htm
do = (di+0.1e-3); % m, 18 Gauage Wire outer diameter (with insulation)
rho_i = 0.0004064; % m
t = (do-di)/2; % insulation thickenss
J = 2.5e6; % A/m^2, current density
I = (di^2-0.8584*rho_i^2)*J; % Current
epsilon = (pi*di^2)/(4*do^2); % packing efficiency, circular wire
% epsilon = (di^2-0.8584*rho_i^2)/(do^2); % packing efficiency, square wire
xi = 1.43*J*epsilon/H; % constant across all three coil sets

%% First, Second, and Third Coil
for i = 1:3 % 1 = first coil, 2 = second coil, 3 = third coil
    % dimensions
    if i == 1
        Xc(i) = 1.5e-2; % m, wire bundle thickness coil 1
    else
        a4 = 1.25*xi^2;
        a3 = -5*xi^2*do-3*xi;
        a2 = 7.5*xi^2*do^2+6*xi*do-2*Tc(i)*xi-4*Sc(i)*xi+2;
        a1 = -5*xi^2*do^3-3*xi*do^2+4*(Tc(i)+2*Sc(i))*(xi*do+1);
        a0 = 1.25*xi^2*do^4-2*(Tc(i)+2*Sc(i))*xi*do^2+4*(Sc(i)^2+Tc(i)^2)-(Gc(i-1)+2*Xc(i-1)+4*Tc(i-1))^2-Doc(i-1)^2;
        placeHolder = roots([a4 a3 a2 a1 a0]);
        Xc(i) = placeHolder(1); % Wire Bundle thickness coil i
    end
    Dc(i) = xi*(Xc(i)-do)^2; % diameter coil i
    Doc(i) = Dc(i)+Xc(i); % outer diameter coil i
    Dic(i) = Dc(i)-Xc(i)-2*Sc(i); % inner diameter coil i
    Gc(i) = 0.5*Dc(i)-Xc(i)-2*Tc(i); %
    
    % Power
    psi(i) = pi/4*(Xc(i)-do)*(Dic(i)+2*Sc(i)+2*do*floor(Xc(i)/do))^2-pi/4*(Xc(i)-do)*(Dic(i)+2*Sc(i))^2; % Effective Volume
    lam(i) = 2*psi(i)/do^2; % Wire Length
    Rc(i) = eta*lam(i); % Resistance
    Vc(i) = I*Rc(i); % Voltage
    Pc(i) = I^2*Rc(i); % Power
    
end

% Inductance
syms alpha beta gamma
n = matlabFunction((beta-do)/do*floor((gamma/do)));
L_Circ = matlabFunction((7.9E-6)*alpha.^2.*n(beta,gamma).^2./(3*alpha+9*beta+10*gamma));
for i = 1:3
    L_Self(:,i) = L_Circ(Dc(:,i),Xc(:,i),Xc(:,i));
    L_mutual2(:,i) = (L_Circ(Dc(:,i),0.5*Dc(:,i)+Xc(:,i),Xc(:,i))+L_Circ(Dc(:,i),0.5*Dc(:,i)-Xc(:,i),Xc(:,i))...
        -2*L_Circ(Dc(:,i),0.5*Dc(:,i),Xc(:,i)))/2;
    L_C(:,i) = 2*L_Self(:,i)+2*L_mutual2(:,i);
    tau(:,i) = L_C(:,i)./Rc(:,i);
end

%%

s = Dc/4; % half coil distances
r = Dc/2; % radius of coils
n = ((Xc-do)/do).*(Xc/do);
I = [I I I];
clear B
for k = 1:3 % 1 = first coil, 2 = second coil, 3 = third coil
    j = 0;
    for i = -s(k):s(k)/200:s(k)
        j = j+1;
        B(j,k) = ((mu_0*n(k)*I(k)*r(k)^2)/...
            (2*(r(k)^2+(i+s(k))^2)^(3/2))+...
            (mu_0*n(k)*I(k)*r(k)^2)/...
            (2*(r(k)^2+(i-s(k))^2)^(3/2)))*10^3; %[mT]
    end
    [B_cen(k,1),IB] = max(B(:,k));
    x = [-s(k):s(k)/200:s(k)]'*10^2;
    subplot(3,1,k)    
    hold on
    plot(x,B(:,k),'color','b') % plot field profile
    plot(x(IB),B_cen(k,1),'r*') % plot max point
    text(x(IB),B_cen(k,1), num2str(B_cen(k,1)), 'VerticalAlignment','bottom', ...
        'HorizontalAlignment','Center')
    xlim([-1.2*max(s)*10^2 1.2*max(s)*10^2])
    xlabel('[cm]')
    ylabel('[mT]')
end
I
Vc
B_cen
B_per_I = B_cen./I' %mT/I
