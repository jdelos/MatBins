function [ implementation ] = implement_hybrid( topology,Vin,Io,...
                                r_rip_Io,capTechs,techInduct,switchTechs)
% implement_hybrid: Implements a floating hybrid cell with the technology
% with higest metric
%   Julia Delos, Philips Research based on the function implement_topology
%   written by Mike Sanders, UC Berkeley 
%
%   dickson_matrix_hybrid( n_stages )
%       n_stages: number of capacitors
%
%   Returns: topology structure with all the relevant functions to model
%   the behaviour of a Hyrbrid Switched Capacitro and compute the losses
%
%   Created 21/03/13, Last modified: ?
%   Copyright 2013-2014, Julia Delos, Philips Research 
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

ratio = topology.ratio;
compMetric=1;
ar = topology.ar;
vc = topology.vc*Vin;
vr = topology.vr*Vin;


if (nargin < 5)
    compMetric=1;
end

switch_assign = [];
cap_assign = [];
switch_rel_size = [];
cap_rel_size = [];

% Assign Capacitors
for i=1:size(vc,2),
    Mc = 0;
    Cc = 0;        % cap cost;
    for j=1:size(capTechs,2),
        if (vc(i) <= capTechs(j).op_voltage),
            % Cap could work ... let's see if it's good
            % Use area-limited metric, which is usually applicable
            C = 1;  %m^2
            M = capTechs(j).cap_area*vc(i)^2/C;
            if (M > Mc)
                if (Mc == 0),
                    cap_assign = [cap_assign capTechs(j)];
                else
                    cap_assign(i) = capTechs(j);
                end
                Mc = M;
            end
        end
    end
    
    % check to make sure a suitable device exists
    if (Mc == 0),
        error(strcat('No capacitors meet the voltage requirement of: ',...
            num2str(vc(i))));
    end
    % determine relative device size
    
end

%Size the capacitro to minimize the sum of the output impedances
[cap_size, f_cap_obj] = lagrange_multiplier_sizer( topology.f_ssl );
    


% Assign Switches
ar=mean(ar,2).';
for i=1:size(ar,2),
    Msw = 0;
    Csw = 0;        % switch cost;
    for j=1:size(switchTechs,2),
        if (vr(i) <= switchTechs(j).ds_voltage),
            % Switch could work ... let's see if it's good
            if (compMetric == 2),   % loss metric
                % assume full gate drive
                C = switchTechs(j).gs_cap_area*switchTechs(j).gs_voltage^2 + ...
                    switchTechs(j).ds_cap_area*vr(i)^2 ;
                    %switchTechs(j).body_cap*vrb(i)^2;
                M = switchTechs(j).ds_cond_area*vr(i)^2/C;
            else % area metric
                C = 1;
                M = switchTechs(j).ds_cond_area*vr(i)^2/C;
            end
            if (M > Msw)
                if (Msw == 0),
                    switch_assign = [switch_assign switchTechs(j)];
                else
                    switch_assign(i) = switchTechs(j);
                end
                Msw = M;
                Csw = C;
            end
        end
    end
    % check to make sure a suitable device exists
    if (Msw == 0),
        error(strcat('No switches meet the voltage requirement of: ',...
            num2str(vr(i))));
    end
    % determine relative device size
%     if (ar(i) == 0),
%         switch_rel_size = [switch_rel_size 0];
%     else
%         if (compMetric == 2),
%             switch_rel_size = [switch_rel_size (ar(i)*vr(i))/...
%                     (sqrt(Msw)*switch_assign(i).ds_cond_area)];
%         else
%             switch_rel_size = [switch_rel_size (ar(i)*vr(i))/...
%                     (sqrt(Msw)*switch_assign(i).area)];
%         end
%     end
end

%Size the capacitro to minimize the sum of the output impedances
[switch_size_opt, f_switch_obj] = lagrange_multiplier_sum( topology.f_fsl );
switch_size_opt=rel_res2rel_area(switch_size_opt);

% sw_area = 0;
% for i=1:size(ar,2),
%     sw_area = sw_area + switch_rel_size(i)*switch_assign(i).area;
% end
% switch_size = (switch_rel_size.*(sw_area > 0))./(sw_area+(sw_area == 0));

implementation.topology = topology;

%Capacitor data
implementation.capacitors = cap_assign;

implementation.cap_size = cap_size;
implementation.ssl_fobj = f_cap_obj;

%Switch data
implementation.switches = switch_assign;
%implementation.switch_size = switch_rel_size/sum(switch_rel_size);
implementation.switch_size_area = switch_size_opt;
implementation.fsl_fobj = f_switch_obj;

end

function y = rel_res2rel_area(rel_res)
    %Convert the relative resitence vecotr to a relative area vector
    %
    % Transformation function is
    %                           1
    %  rel_area_i  = ----------------------------------------------
    %                   1  +  rel_res_i * sum(1/rel_res_k) k!=i 
    
    y = rel_res;
    idx=1:length(rel_res);
    for i=idx
        y(i) = 1/(1+rel_res(i)*sum(1./rel_res(idx~=i)));
    end
    

end