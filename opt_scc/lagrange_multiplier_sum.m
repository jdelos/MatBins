function [OutX, f_opt, S, fval, fval_local ] = lagrange_multiplier_sum( fobjct )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here




S=[];
options = optimset('fmincon');
options = optimset(options,'Algorithm','interior-point','TolFun', 1e-20,...
    'TolCon', 1e-20,'MaxIter', 400000,'Display','off');




fval_local=[];
% for j=1:length(fobjct)
%     
%     %reset variables
%     x0=[];
%     lb=[];
%     ub=[];
%     %Numbe of variables in the objective function
%     n_var = length(symvar(fobjct(j)));
% 
%     fopt= @(X)subs(fobjct(j),...
%                 symvar(fobjct(j)),X);
%     
%             
%     
%     %Inequalities vars greater than 0
%     A = -eye(n_var);
%     b = zeros([n_var 1]);        
%     Aeq = ones(1,n_var);
%     beq = 1;
%     x0(1:n_var,1) = 1/n_var;
%     lb(1:n_var,1) = 0.01;
%     ub(1:n_var,1) = 1;
%     [x, fval, flag] = fmincon(fopt,x0,A,b,Aeq,beq,lb,ub,[],options);
%     
%     S(j).x=x';
%     S(j).fval=fval;
%     S(j).flag=flag;
%     S(j).fopt=fopt;
%     %Add local values
%     fval_local = [fval_local fval];
% end    
    
f=sum(fobjct);
  
n_var = length(symvar(f));
f_opt = @(X)subs(f,symvar(f),X);


%Summ adds 1
A = -eye(n_var);
b = zeros([n_var 1]);

Aeq = ones(1,n_var);
beq = 1;
x0(1:n_var,1) = 1/n_var;
lb(1:n_var,1) = 0.01;
ub(1:n_var,1) = 1;

[x, fval, flag] = fmincon(f_opt,x0,A,b,Aeq,beq,lb,ub,[],options);

OutX= x';

S.x=x';
S.fval=fval;
S.flag=flag;
S.fopt=f_opt;
fval = subs(fobjct,symvar(fobjct),OutX);
 
end

