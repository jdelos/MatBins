function [opt_imp] = optimize_losses_hybrid_switches( implementation,Lo,Vin,...
Io,rel_ripple_Io)
% optimize_losses_hybrid: Finds the optimal design point for given conditions
%   J. Delos, Philips Research based on the previous work of M. Seeman , UC
%   Berkeley
%
%   optimize_loss(implementation, Vout, Iout, Ac)
%       implementation: implementation generated from implement_topology
%       Vin: converter input voltage for this calc [V]
%       Iout: converter output current for this calc [A]
%       Ac: capacitor area [m^2]
%
%   Returns: performance structure from evaluate_loss and optimal switching
%   frequency and switch area
%
%   Created 4/12/13,
%   Copyright 20012-20013, J. Delos, Philips Research
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.


options = optimset('fmincon');
options = optimset(options,'Algorithm','interior-point','TolFun', 1e-15,...
    'TolCon', 1e-15,'MaxIter', 400000,'Display','on');
 
Fsw_0 = 10e6;
Ac_0  = (10e-6).^2;  %1um^-2
Asw_0  = (10e-6).^2; %1um^2

Fsw_lb = 10e3;
Fsw_ub = 1e9;

Area_lb = (10e-9)^2;
Area_ub = (10e-3)^2;

lb= log([Fsw_lb Area_lb Area_lb])';
ub= log([Fsw_ub Area_ub Area_ub])';


x0 = log([Fsw_0 Ac_0 Asw_0])';


if mode == 1
    [x, fval, falg] = fmincon(@opt_loss_func,x0,[],[],[],[],lb,ub,[],options,implementation,...
        Vin,Io,rel_ripple_Io);
    
    
    Fsw=exp(x(1));
    Ac=exp(x(2));
    Asw=exp(x(3));
    
    
    
    
elseif mode == 2
    x0 = log([Fsw_0 Asw_0])';
    
    lb= log([Fsw_lb  Area_lb])';
    ub= log([Fsw_ub  Area_ub])';
    Ac = log(10e-6);
    
    Eff_th = 0.5;
    L_th = 10e-6;
    %Define constrain function
    fconst= @(x) opt_fcond([x(1) Ac x(2)],implementation,...
                                 Vin,Io,rel_ripple_Io,L_th,Eff_th);
    %Define objective function
    fobjective = @(x)opt_FoM_func([x(1) Ac x(2)],implementation,...
                                    Vin,Io,rel_ripple_Io,1/L_th);
                            
    [x, fval, falg] = fmincon(fobjective,x0,[],[],[],[],lb,ub,...
                              [],options);
    
    Ac=exp(Ac);                      
    Fsw=exp(x(1));
    Asw=exp(x(2));
elseif mode == 3
    
    % [x, fval, falg] = fminunc(@opt_FoM_func,[10; -10; -10],,implementation,...
    % Vin,Io,rel_ripple_Io);
    Eff_th = 0.1;
    L_th = 10e-6;
    
    %Define constrain function
    fconst= @(x) opt_fcond(x,implementation,...
                                 Vin,Io,rel_ripple_Io,L_th,Eff_th);
    %Define objective function
    fobjective = @(x)opt_FoM_func(x,implementation,...
                                Vin,Io,rel_ripple_Io,1/L_th);
                            
    [x, fval, falg] = fmincon(fobjective,x0,[],[],[],[],lb,ub,...
        fconst,options);
    
    %      [x, fval, falg] = fmincon(@opt_FoM_func,exp([10; -10; -10]),[],[],[],[],...
    %          exp(lb),exp(ub),[],options,implementation,Vin,Io,rel_ripple_Io);
    
    
    Fsw=exp(x(1));
    Ac=exp(x(2));
    Asw=exp(x(3));

else
    % [x, fval, falg] = fminunc(@opt_FoM_func,[10; -10; -10],,implementation,...
    % Vin,Io,rel_ripple_Io);
    [x, fval, falg] = fmincon(@opt_FoM_func,x0,[],[],[],[],lb,ub,[],...
        options,implementation,Vin,Io,rel_ripple_Io,1/1e-6);
    
    %      [x, fval, falg] = fmincon(@opt_FoM_func,exp([10; -10; -10]),[],[],[],[],...
    %          exp(lb),exp(ub),[],options,implementation,Vin,Io,rel_ripple_Io);
    
    
    Fsw=exp(x(1));
    Ac=exp(x(2));
    Asw=exp(x(3));

end

FoM = fval;

% Fsw=x(1);
% Ac=x(2);
% Asw=x(3);


[  Ploss, L_out, Eff ] = evaluate_loss_hybrid(implementation,Fsw,Ac,Asw,...
    Vin,Io,rel_ripple_Io);

opt_imp.FoM=FoM;
opt_imp.Fsw = Fsw;
opt_imp.Ac = Ac;
opt_imp.Asw = Asw;
opt_imp.Eff = Eff;
opt_imp.Eff = Ploss;
opt_imp.L_out = L_out;




end

function [Ploss ] = opt_loss_func(design_var,implementation,...
                                    Vin,Io,rel_ripple_Io)

        Ploss = evaluate_loss_hybrid(implementation,exp(design_var(1)),...
            exp(design_var(2)),exp(design_var(3)),Vin,Io,rel_ripple_Io);
end

function [FoM ] = opt_FoM_func(design_var,implementation,...
                                 Vin,Io,rel_ripple_Io,k)

       [ Ploss, L_out ] = evaluate_loss_hybrid(implementation,exp(design_var(1)),...
            exp(design_var(2)),exp(design_var(3)),Vin,Io,rel_ripple_Io);
%      [ ~, L_out, Eff] = evaluate_loss_hybrid(implementation,design_var(1),...
%             design_var(2),design_var(3),Vin,Io,rel_ripple_Io);
          
        At = exp(design_var(2))+exp(design_var(3)) ;
        %At = (design_var(2))+(design_var(3)) ;
        
        FoM = Ploss.^2*(At*(1+k*L_out));
end



% function [FoM ] = opt_FoM_func_Ac(design_var,implementation,...
%                                  Vin,Io,rel_ripple_Io,k,Ac)
% 
%        [ Ploss, L_out ] = evaluate_loss_hybrid(implementation,exp(design_var(1)),...
%             Ac,exp(design_var(2)),Vin,Io,rel_ripple_Io);
% %         [ ~, L_out, Eff] = evaluate_loss_hybrid(implementation,design_var(1),...
% %             design_var(2),design_var(3),Vin,Io,rel_ripple_Io);
%           
%         At = exp(design_var(2))+Ac ;
%         %At = (design_var(2))+(design_var(3)) ;
%         
%         FoM = Ploss*(At*(1+k*L_out));
% end


function [c, ceq] = opt_fcond(design_var,implementation,...
                                 Vin,Io,rel_ripple_Io,L_th,Eff_th)

       [ ~, L_out, Eff ] = evaluate_loss_hybrid(implementation,exp(design_var(1)),...
            exp(design_var(2)),exp(design_var(3)),Vin,Io,rel_ripple_Io);
%         [ ~, L_out, Eff] = evaluate_loss_hybrid(implementation,design_var(1),...
%             design_var(2),design_var(3),Vin,Io,rel_ripple_Io);
         ceq=0;
         
        L_cond = (L_out-L_th) > 0;
        
        Eff_cond = Eff-Eff_th < 0;
        
        c = L_cond + Eff_cond;       
        
end

function [c, ceq] = opt_fcond2(d1,d2,d3,implementation,...
                                 Vin,Io,rel_ripple_Io,L_th,Eff_th)

       [ ~, L_out, Eff ] = evaluate_loss_hybrid(implementation,exp(d1),...
            exp(d2),exp(d3),Vin,Io,rel_ripple_Io);
%         [ ~, L_out, Eff] = evaluate_loss_hybrid(implementation,design_var(1),...
%             design_var(2),design_var(3),Vin,Io,rel_ripple_Io);
         ceq=0;
         
        L_cond = (L_out-L_th) > 0;
        
        Eff_cond = Eff-Eff_th < 0;
        
        c = L_cond + Eff_cond;       
        
end