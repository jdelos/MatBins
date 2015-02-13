function plot_regulation(topologies, Vin, Vout, Iout, Ac, switches, ...
    capacitors, esr, idesign)
% plot_regulation: Plot efficiency vs. input/output voltage based on fsw-based
% regulation
%   Michael Seeman, UC Berkeley
%
%   plot_regulation2(topologies, Vin, Vout, Pout, Ac, switches, capacitors
%                   [noplot, [esr, [optMethod]]])
%       topologies: A matrix of topologies and ratios:
%           [{'Series-Parallel'} {1/2};
%            {'Ladder'} {1/3}]
%           or a column vector of topology or implementation structures
%       Vin: Input voltage of converter (could be a vector)
%       Vout: Output voltage of converter (a vector if Vin is a scalar)
%       Iout: Matching vector of output currents [A]
%       Ac: Capacitor area constraint (in m^2).  fsw will be swept, Asw
%           will be chosen automatically
%       switches: a row vector of switch technology structures
%       capacitors: a row vector of capacitor technology structures
%       esr: the output-referred constant esr of requisite metal (ie, bond
%          wires).  Default = 0
%       idesign: a vector (size = number of topologies) containing the
%           nominal design current for each topology
%
%   Created 6/30/08, Last modified: 4/15/09
%   Copyright 2008-2009, Mike Seeman, UC Berkeley
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

% Fix unspecified parameters:
if nargin < 7, error('plot_opt_contour needs at least seven input arguments');
end
if nargin < 8, esr = 0; end
optMethod = 1;

type = 0; % 1 = Vout, 2 = Vin swept
if (size(Vout,2) > 1)
    type = 1;
    indim = size(Vout,2);
    xval = Vout;
end
if (size(Vin,2) > 1)
    if (type == 1),
        error('Cannot sweep both Vin and Vout');
    end
    type = 2;
    indim = size(Vin,2);
    xval = Vin;
end

numtops = size(topologies,1);  % number of topologies

EFF = zeros(numtops, indim);
ASW = [];
pkeff = [];
pkv = [];
RATIO = [];
FSW = [];

Vin_nom = Vin;

for t=1:numtops,
    if (iscell(topologies(t,1))),
        % this topology is a string and ratio
        top = topologies(t,1);
        ratio = cell2mat(topologies(t,2));
        topology = generate_topology(top, ratio);
        if (type == 2), Vin_nom = Vout/ratio; end
        imp = implement_topology(topology, Vin_nom, switches, capacitors, ...
            optMethod);
    elseif ((size(topologies,2) == 1) && (isfield(topologies(t), 'topology'))),
        % implementation structure
        imp = topologies(t);
        topology = imp.topology;
        ratio = topology.ratio;
        if (type == 2), Vin_nom = Vout/ratio; end
    elseif (size(topologies,2) == 1),
        topology = topologies(t);
        ratio = topology.ratio;
        if (type == 2), Vin_nom = Vout/ratio; end
        imp = implement_topology(topology, Vin_nom, switches, capacitors, ...
            optMethod);
    else
        error('Unknown topology element');
    end
    
    % add topology ratio to vector for plot annotation
    RATIO = [RATIO ratio];
    
    % calculate nominal design current
    if (nargin < 9)
        if ((type == 1) & (size(Iout,2) == indim))
            Iout_nom = interp1(Vout, Iout, Vin*ratio, 'linear', 'extrap');
        else
            Iout_nom = max(Iout);
        end
    else
        if (size(idesign,2) > 1), Iout_nom = idesign(t);
        else, Iout_nom = idesign; end
    end

    % Constant series resistance, output referred
    imp.esr = esr;

    % Find optimal point for base
    [opt_perf, fsw_opt, Asw_opt] = optimize_loss(imp, Vin_nom, Iout_nom, Ac);
%     ASW(t) = Asw_opt;

    p(t) = evaluate_loss(imp, Vin, Vout, Iout, [], Asw_opt, Ac);
    EFF(t,:) = p(t).efficiency.*p(t).is_possible;
%     FREQ(t,:) = p(t).fsw;
    [y,i] = max(EFF(t,:));
    pkeff(t) = y;
    pkv(t) = xval(i);
end

[maxeff, mind] = max(EFF);
% for i=1:size(FREQ,2),
%     fsw(i) = FREQ(mind(i),i);
% end

plot(xval, EFF*100,'b:', xval, maxeff*100, 'b-', pkv, pkeff*100, 'bo');
if (type == 1),
    xlabel('Output Voltage [V]');
elseif (type == 2),
    xlabel('Input Voltage [V]');
end
% add labels representing conversion ratios
for i=1:size(pkv,2),
    [n, m] = rat(RATIO(i), .001);
    text(pkv(i)*1.01, pkeff(i)*100+1, strcat(num2str(m), ':', num2str(n)));
end
ylabel('Efficiency [%]');
