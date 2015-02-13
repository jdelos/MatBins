function [ Fsw ] = evaluate_fsw_hybrid (implementation,Lout,...
            Vin,Io,Io_ac)
        
% evaluate_fsw_hybrid: evaluates the switching frequecny for a specific 
% output inductor value and  operating condition of a implemented 
% Hybrid-SC converter
%
%   implementation: implementation generated from implement_hybrid
%   Lout: output inductor[H]
%   Vin: converter input voltage for this calc [V]
%   Io: converter output current for this calc [A]
%   Io_ac: relative current ripple peark-to-peak 
%
%   Created: 4/12/13
%   Copyright 2013-2014, Julià Delos, Philips Research 2013 
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.


vo_swing=  implementation.topology.vo_swing;
duty = implementation.topology.duty; 

ripple_Io=Io_ac*Io;

Fsw = Vin.*vo_swing.*(1-duty)*duty./(ripple_Io.*Lout);

end

