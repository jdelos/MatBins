function plot_opt_contour(topology, ratio, Vin, Iout, Ac, switches, ...
    capacitors, esr, optMethod, plotPoints, plotAxes)
% plot_opt_contour: Plot optimization contour, including loss-dominant regions
%   Michael Seeman, UC Berkeley
%
%   plot_opt_contour(topology, ratio, Vout, Pout, Ac, switches, capacitors
%                   [esr, [optMethod, [plotPoints, [plotAxes]]]])
%       topology: The chosen topology to plot contour (a string), or a
%           topology structure or implementation structure
%       ratio: The step-up ratio of the converter.  If a step-down
%           converter is desired, use a fractional ratio (ie. 1/8).
%           Ignored for topology as a structure
%       Vout: Output voltage of converter (in V)
%       Iout: Output current of converter (in A)
%       Ac: Capacitor area constraint (in m^2).  fsw and Ac will be swept
%       switches: a row vector of switch technology structures
%       capacitors: a row vector of capacitor technology structures
%       esr: the output-referred constant esr of requisite metal (ie, bond
%          wires).  Default = 0
%       optMethod: specifies constraint on switch optimization (1=area
%          (default), 2=parasitic loss)
%       plotPoints: specifies grid size for contour plot.  (default=100)
%       plotAxes: A row vector giving the desired range of the plot, in log
%           input (ie, [6 9 -6 -3] goes from 1MHz-1GHz, 1mm^2-1000mm^2).
%
%   Created 4/14/08, Last modified: 4/15/09
%   Copyright 2008-2009, Mike Seeman, UC Berkeley
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

% Fix unspecified parameters:
if nargin < 7, error('plot_opt_contour requires at least seven inputs');
end
if nargin < 10, plotPoints=100;
    if nargin < 9, optMethod=1;
        if nargin < 8, esr = 0;
        end, end, end

if (ischar(topology)),
    % topology is a string
    topology = generate_topology(topology, ratio);
    imp = implement_topology(topology, Vin, switches, capacitors, optMethod);
elseif (isfield(topology, 'topology')),
    % topology is an implementation structure
    imp = topology;
    topology = imp.topology;
    ratio = topology.ratio;
else
    % topology is a topology structure
    ratio = topology.ratio;
    imp = implement_topology(topology, Vin, switches, capacitors, optMethod);
end

% Constant series resistance, output referred
imp.esr = esr;

% Find optimal point for auto axis scaling
[opt_perf, fsw_opt, Asw_opt] = optimize_loss(imp, Vin, Iout, Ac);
opt_perf.Vout
if (nargin < 11),
    fsw_min = floor(log10(fsw_opt)-1);
    fsw_max = ceil(log10(fsw_opt)+1);
    Asw_min = floor(log10(Asw_opt)-1);
    Asw_max = ceil(log10(Asw_opt)+1);
else
    fsw_min = plotAxes(1);
    fsw_max = plotAxes(2);
    Asw_min = plotAxes(3);
    Asw_max = plotAxes(4);
end

[fsw, Asw] = meshgrid(logspace(fsw_min,fsw_max,plotPoints),...
    logspace(Asw_min,Asw_max,plotPoints));

p = evaluate_loss(imp, Vin, [], Iout, fsw, Asw, Ac);
[maxeff1, min1] = max(p.efficiency);
[maxeff, min2] = max(maxeff1');
min1 = min1(min2);

[c,h] = contour(fsw, Asw*1e6, p.efficiency, ...
    [.05 .1 .2 .4 .6 .7 .8 .85 .9 .92 .94 .96 .98 1], 'b-');
clabel(c,h);
hold on;
contour(fsw, Asw*1e6, p.dominant_loss, [1.5 2.5 3.5 4.5], 'k-');
loglog(fsw(min1,min2), Asw(min1,min2)*1e6, 'bo');
hold off;
xlabel('Switching Frequency [Hz]');
ylabel('Switch Area [mm^2]');
title(strcat('I_{OUT} = ', num2str(Iout), 'A, A_{c} = ', num2str(Ac*1e6),...
    ' mm^2, Eff = ', num2str(maxeff*100,3), ' %'));
set(gca,'Xscale','log')
set(gca,'Yscale','log')