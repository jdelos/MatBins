function [ S ] = lagrance_multiplier_dickson( n_stage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Generate Incidence Matrixes
[A_caps A_sw1 A_sw2] = dickson_matrix(n_stage,0);

%Mosfet ON Res 13.3Ohms
%Mosfet Cds 276.6fF
Ron=0.01;
Cds=0;

%Output current 
% Io = 3.5mA
Io=3.5e-3;

% Drawn at first top node
%Cfly = e-6;

%Operating frequency 20MHz
Fsw=1;

%Input voltage
Vin=1;


%Create topology class class 
topology = SCC_node(A_caps,A_sw1,A_sw2,'Fsw',Fsw,...
    'Ron',Ron,'ESR',0,'Cds',0,'Vin',Vin,'Ro',Inf);

%Get beta vector
beta= topology.beta;

%Generate symvolic capacitor vector
Cvar= sym('C', [1 n_stage]);

%constrain function
g = sum(Cvar)-1;

%Lagrange multiplier
syms lmb

%Create string variables 
strVar=[];
for ic=1:n_stage
    strVar = [strVar 'C' num2str(ic) ', ' ];
end
strVar=[strVar 'lmb'];


for j=1:length(beta)
   fopt = beta(j) + lmb*g;
   f=g;
   
   for ic=n_stage:-1:1; %f contains the partial derivatices in oreder C1 C2 .. Cn lmb
   f = [diff(fopt,Cvar(ic)); f];
   end
   
   S(j)= solve(f,strVar);
    
end



end

