function [ Ploss ] = evaluate_loss_hybrid_Fsw(implementation,fsw,Ac,Asw,...
            Vin,Io,Io_ac)
% evaluate_loss: evaluates the loss and other peformance metrics for a 
% specific size and operating condition of a implemented SC converter
%
%   implementation: implementation generated from implement_topology
%   fsw: switching frequency [Hz]
%   Asw: switch area [m^2]
%   Ac: capacitor area [m^2]
%   Vin: converter input voltage for this calc [V]
%   Io: converter output current for this calc [A]
%   Io_ac: relative current ripple peark-to-peak 
%   
%  
%   Created: 4/15/08, Last Modified: 4/12/13
%   Original version Mike Seeman, UC Berkeley
%   modified by Julià Delos, Philips Research 2013
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

% Break implementation into components for brevity

%Extract the variables
%duty = implementationp.duty;

%Capacitor parameters
cap_size = implementation.cap_size;
ssl_fobj = implementation.ssl_fobj;

cap_area = implementation.capacitors(1).cap_area;
cap_esr_sqrt =[];

%Switches parameters
switch_size = implementation.switch_size_area;
fsl_fobj = implementation.fsl_fobj;
ds_cond_area = implementation.switches(1).ds_cond_area;
gs_cap_area = implementation.switches(1).gs_cap_area;
ds_cap_area = implementation.switches(1).ds_cap_area;

gs_voltage = implementation.switches(1).gs_voltage;
%ds_voltage = implementation.switches(1).ds_voltage;
ds_voltage = implementation.topology.vr.*Vin;

%Inductor parameters
% vo_swing = implementation.topology.vo_swing;
% esr_dc_l = implementation.esr_dc_l;
% esr_ac_f = implementation.esr_ac_l;
vo_swing=  implementation.topology.vo_swing;
duty = implementation.topology.duty;    

%Determine the current ac ripple, dc rms and ac rms
ripple_Io=Io_ac*Io;
Iac_rms = ripple_Io./(2*sqrt(3));

%Compute the R_ssl resistance

R_ssl = 1./(2.*fsw).*ssl_fobj(Ac.*cap_area.*cap_size).*Io^2;


%Compute the R_fsl due to the switches
Ron_switches = 1./(Asw.*ds_cond_area*switch_size);
R_fsl = fsl_fobj(Ron_switches).*Io^2;

%and due to the cap ESR
%C_esr = cap_esr_sqrt/(Ac*cap_size);
%R_esr = fval_esr(C_esr);
R_esr=0;

%Gate-source switching losses
P_gs = fsw*sum(gs_voltage.^2.*switch_size.*gs_cap_area.*Asw);
P_ds = fsw*sum(ds_voltage.^2.*switch_size.*ds_cap_area.*Asw);

%Inductive requirementes
%L_out = Vin.*vo_swing.*(1-duty)*duty./(ripple_Io.*fsw);

% R_ind_dc = Lout*esr_dc_l;
% Rind_ac = esr_ac_l(Lout,fsw);

R_ind_dc = 0; 
R_ind_ac = 0;

Pssl = R_ssl.*Io^2;
Pfsl = (R_fsl + R_esr).*Io^2;
Psw = P_gs + P_ds;

Ploss = Pssl + Pfsl + Psw;

end

