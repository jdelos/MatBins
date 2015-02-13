function [Rx, f_opt, S, fval, fval_local ] = lagrance_multiplier_dickson_fsl_num( n_stage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if isscalar(n_stage)
    %Generate Incidence Matrixes
    [A_caps, A_sw1, A_sw2] = dickson_matrix(n_stage,0);

    %Mosfet ON Res 13.3Ohms
    %Mosfet Cds 276.6fF
    Ron=0.01;

    %Output current 

    %Drawn at first top node
    %Cfly = e-6;

    %Operating frequency 20MHz
    Fsw=1;

    %Input voltage
    Vin=1;
%Create topology class class 
topology = SCC_node(A_caps,A_sw1,A_sw2,'Fsw',Fsw,...
    'Cfly',1,'ESR',0,'Cds',0,'Vin',Vin,'Ro',...
    Inf,'Duty',0.5);
else
     topology=n_stage;
end

x0=[];
lb=[];
ub=[];

S=[];
options = optimset('fmincon');
options = optimset(options,'Algorithm','interior-point','TolFun', 1e-20,...
    'TolCon', 1e-20,'MaxIter', 400000,'Display','off');

%Get the fsl functions
rfsl=topology.r_fsl;

n_var = length(symvar(rfsl));

%Inequalities vars greater than 0
A = -eye(n_var);
b = zeros([n_var 1]);


fval_local=[];
for j=1:length(rfsl)
    fopt= @(X)subs(rfsl(j),...
                symvar(rfsl(j)),X);
    
    Aeq = ones(1,n_var);
    beq = 1;
    x0(1:n_var,1) = 1/n_var;
    lb(1:n_var,1) = 0.01;
    ub(1:n_var,1) = 1;
    [x, fval, flag] = fmincon(fopt,x0,A,b,Aeq,beq,lb,ub,[],options);
    
    S(j).x=x;
    S(j).fval=fval;
    S(j).flag=flag;
    S(j).fopt=fopt;
    %Add local values
    fval_local = [fval_local fval];
end    
            
x0=[];
lb=[];
ub=[];  
           

%delete the DC capacitor output node and duplicated output
if n_stage>2
    rfsl([topology.dc_out_cap end])=[];
    fval_local([topology.dc_out_cap end])=[];
else
    rfsl([topology.dc_out_cap])=[];
    fval_local([topology.dc_out_cap ])=[];
end


f=sum(rfsl);
   
n_var = length(symvar(f));
f_opt = @(X)subs(f,symvar(f),X);


%Summ adds 1
Aeq = ones(1,n_var);
beq = 1;
x0(1:n_var,1) = 1/n_var;
lb(1:n_var,1) = 0.01;
ub(1:n_var,1) = 1;

[x, fval, flag] = fmincon(f_opt,x0,A,b,Aeq,beq,lb,ub,[],options);

Rx= x;

S(j+1).x=x;
S(j+1).fval=fval;
S(j+1).flag=flag;
S(j+1).fopt=f_opt;
fval = subs(rfsl,symvar(rfsl),Rx);
 
end

