function [performance, fsw, Asw] = optimize_loss (implementation, Vin, ...
    Iout, Ac)
% optimize_loss: Finds the optimal design point for given conditions
%   Michael Seeman, UC Berkeley
%
%   optimize_loss(implementation, Vout, Iout, Ac)
%       implementation: implementation generated from implement_topology
%       Vin: converter input voltage for this calc [V]
%       Iout: converter output current for this calc [A]
%       Io: converter output current for this calc [A]
%       Io_ac: relative current ripple peark-to-peak 
%
%   Returns: performance structure from evaluate_loss and optimal switching
%   frequency and switch area
%
%   Created 4/14/08, Last modified: 4/15/09
%   Copyright 2008-2009, Mike Seeman, UC Berkeley
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

options = optimset('fmincon');
options = optimset(options, 'TolFun', 1e-11, 'MaxIter', 400000, ...
    'Display', 'off', 'LargeScale', 'off');
opt_design = fmincon(@evaluate_loss_opt, [10 -10], [], [], [], [], ...
    [1 -100], [100 1], [], options, implementation, Vin, Iout, Ac);

opt_design_II = fmincon(@evaluate_loss_opt_II, exp([10 -10]), [], [], [], [], ...
    exp([1 -100]), exp([100 1]), [], options, implementation, Vin, Iout, Ac);
fsw = exp(opt_design(1));
Asw = exp(opt_design(2));

fsw_II = opt_design_II(1);
Asw_II = opt_design_II(2);

performance = evaluate_loss(implementation, Vin, [], Iout, fsw, Asw, Ac);


%----------- Minimization helper function
function ploss = evaluate_loss_opt (param, implementation, Vin, Iout, Ac)

p = evaluate_loss (implementation, Vin, [], Iout, exp(param(1)), ...
    exp(param(2)), Ac);
ploss = p.total_loss;

function ploss = evaluate_loss_opt_II (param, implementation, Vin, Iout, Ac)

p = evaluate_loss (implementation, Vin, [], Iout, param(1), ...
    param(2), Ac);
ploss = p.total_loss;