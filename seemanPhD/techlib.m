% Technology Library
%   Copyright 2008-2009, Mike Seeman, UC Berkeley
%   May be freely used and modified but never sold.  The original author
%   must be cited in all derivative work.

% ------------------------------- Oxide Capacitors
% 90 nm Oxide Capacitors

itrs90cap.tech_name = 'ITRS 90nm';
itrs90cap.dev_name = 'ITRS 90nm Oxide Capacitor';
itrs90cap.capacitance = 40^2*1e-15*.7/.09;
itrs90cap.area = (40e-6*40e-6);            % in m^2
itrs90cap.bottom_cap = 135.3e-15;      % in F
itrs90cap.esr = 0;                 % in ohms
itrs90cap.rating = 1.2;              % in V
itrs90cap.cap_density = itrs90cap.capacitance /itrs90cap.area; % F/m^2
% 65 nm Oxide Capacitors

itrs65cap.tech_name = 'ITRS 65nm';
itrs65cap.dev_name = 'ITRS 65nm Oxide Capacitor';
itrs65cap.capacitance = 40^2*.9e-15*.6/.065;
itrs65cap.area = (40e-6*40e-6);            % in m^2
itrs65cap.bottom_cap = 135.3e-15;      % in F
itrs65cap.esr = 0;                 % in ohms
itrs65cap.rating = 1.2;              % in V
itrs65cap.cap_density = itrs65cap.capacitance /itrs65cap.area;
% 45 nm Oxide Capacitors

itrs45cap.tech_name = 'ITRS 45nm';
itrs45cap.dev_name = 'ITRS 45nm Oxide Capacitor';
itrs45cap.capacitance = 40^2*.84e-15*.5/.045;
itrs45cap.area = (40e-6*40e-6);            % in m^2
itrs45cap.bottom_cap = 135.3e-15;      % in F
itrs45cap.esr = 0;                 % in ohms
itrs45cap.rating = 1.2;              % in V
itrs45cap.cap_density = itrs45cap.capacitance /itrs45cap.area;% F/m^2
% 32 nm Oxide Capacitors

itrs32cap.tech_name = 'ITRS 32nm';
itrs32cap.dev_name = 'ITRS 32nm Oxide Capacitor';
itrs32cap.capacitance = 40^2*.8e-15*.45/.032;
itrs32cap.area = (40e-6*40e-6);            % in m^2
itrs32cap.bottom_cap = 135.3e-15;      % in F
itrs32cap.esr = 0;                 % in ohms
itrs32cap.rating = 1.2;              % in V
itrs32cap.cap_density = itrs32cap.capacitance /itrs32cap.area;% F/m^2
% 22 nm Oxide Capacitors

itrs22cap.tech_name = 'ITRS 22nm';
itrs22cap.dev_name = 'ITRS 22nm Oxide Capacitor';
itrs22cap.capacitance = 40^2*.58e-15*.4/.022;
itrs22cap.area = (40e-6*40e-6);            % in m^2
itrs22cap.bottom_cap = 135.3e-15;      % in F
itrs22cap.esr = 0;                 % in ohms
itrs22cap.rating = 1.2;              % in V
itrs22cap.cap_density = itrs22cap.capacitance /itrs22cap.area;% F/m^2
% 16 nm Oxide Capacitors

itrs16cap.tech_name = 'ITRS 16nm';
itrs16cap.dev_name = 'ITRS 16nm Oxide Capacitor';
itrs16cap.capacitance = 40^2*.48e-15*.35/.016;
itrs16cap.area = (40e-6*40e-6);            % in m^2
itrs16cap.bottom_cap = 135.3e-15;      % in F
itrs16cap.esr = 0;                 % in ohms
itrs16cap.rating = 1.2;              % in V
itrs16cap.cap_density = itrs16cap.capacitance /itrs16cap.area;% F/m^2
% Filler HV cap

fillercap.tech_name = 'ITRS 16nm';
fillercap.dev_name = 'ITRS 16nm Oxide Capacitor';
fillercap.capacitance = 40^2*.48e-15*.35/.016*.01;
fillercap.area = (40e-6*40e-6);            % in m^2
fillercap.bottom_cap = 135.3e-15;      % in F
fillercap.esr = 0;                 % in ohms
fillercap.rating = 12;              % in V
fillercap.cap_density = fillercap.capacitance /fillercap.area;% F/m^2



%Added by J. Delos

%Ptz Technology

%Type A 400nm
ptz400cap.tech_name = 'PTZ 400nm ';
ptz400cap.dev_name = 'PTZ 400nm  Thinfilm Ceramic MIM';
ptz400cap.capacitance = 5^2*20e-9;
ptz400cap.area = (5e-6)^2;
ptz400cap.bottom_cap = 10e-15;
ptz400cap.esr = 0;
ptz400cap.rating = 330e6*400e-9;
ptz400cap.cap_density = ptz400cap.capacitance /ptz400cap.area;

%Type B 360nm
ptz360cap.tech_name = 'PTZ 360nm ';
ptz360cap.dev_name = 'PTZ 360nm  Thinfilm Ceramic MIM';
ptz360cap.capacitance = 5^2*80e-9;
ptz360cap.area = (5e-6)^2;
ptz360cap.bottom_cap = 10e-15;
ptz360cap.esr = 0;
ptz360cap.rating = 330e6*360e-9;
ptz360cap.cap_density = ptz360cap.capacitance /ptz360cap.area;

%Type C 360nm
ptz270cap.tech_name = 'PTZ 270nm ';
ptz270cap.dev_name = 'PTZ 270nm  Thinfilm Ceramic MIM';
ptz270cap.capacitance = 5^2*105e-9;
ptz270cap.area = (5e-6)^2;
ptz270cap.bottom_cap = 10e-15;
ptz270cap.esr = 0;
ptz270cap.rating = 330e6*270e-9;
ptz270cap.cap_density = ptz270cap.capacitance /ptz270cap.area;

% -------------------------------- Switch models

% 90 nm switch

itrs90n.tech_name = 'ITRS 90 nm';
itrs90n.dev_name = 'ITRS 90 nm NMOS native transistor';
itrs90n.area = 1e-6 * 90e-9 / .4;       % in m^2
itrs90n.conductance = 1.11e-3;   % in S
itrs90n.gate_rating = 1.25;    % in V
itrs90n.drain_rating = 1.25;
itrs90n.gate_cap = 1e-15;
itrs90n.drain_cap = .33*itrs90n.gate_cap;
itrs90n.body_cap = .2*itrs90n.gate_cap;

% 65 nm switch

itrs65n.tech_name = 'ITRS 65 nm';
itrs65n.dev_name = 'ITRS 65 nm NMOS native transistor';
itrs65n.area = 1e-6 * 65e-9 / .35;       % in m^2
itrs65n.conductance = 1.3e-3;   % in S
itrs65n.gate_rating = 1.25;    % in V
itrs65n.drain_rating = 1.25;
itrs65n.gate_cap = .9e-15;
itrs65n.drain_cap = .33*itrs65n.gate_cap;
itrs65n.body_cap = .2*itrs65n.gate_cap;

% 45 nm switch

itrs45n.tech_name = 'ITRS 45 nm';
itrs45n.dev_name = 'ITRS 45 nm NMOS native transistor';
itrs45n.area = 1e-6 * 45e-9 / .35;       % in m^2
itrs45n.conductance = 1.51e-3;   % in S
itrs45n.gate_rating = 1.25;    % in V
itrs45n.drain_rating = 1.25;
itrs45n.gate_cap = .84e-15;
itrs45n.drain_cap = .33*itrs45n.gate_cap;
itrs45n.body_cap = .2*itrs45n.gate_cap;

% 32 nm switch

itrs32n.tech_name = 'ITRS 32 nm';
itrs32n.dev_name = 'ITRS 32 nm NMOS native transistor';
itrs32n.area = 1e-6 * 32e-9 / .3;       % in m^2
itrs32n.conductance = 1.82e-3;   % in S
itrs32n.gate_rating = 1.25;    % in V
itrs32n.drain_rating = 1.25;
itrs32n.gate_cap = .8e-15;
itrs32n.drain_cap = .33*itrs32n.gate_cap;
itrs32n.body_cap = .2*itrs32n.gate_cap;

% 22 nm switch

itrs22n.tech_name = 'ITRS 22 nm';
itrs22n.dev_name = 'ITRS 22 nm NMOS native transistor';
itrs22n.area = 1e-6 * 22e-9 / .3;       % in m^2
itrs22n.conductance = 2.245e-3;   % in S
itrs22n.gate_rating = 1.25;    % in V
itrs22n.drain_rating = 1.25;
itrs22n.gate_cap = .58e-15;
itrs22n.drain_cap = .33*itrs22n.gate_cap;
itrs22n.body_cap = .2*itrs22n.gate_cap;

% 16 nm switch

itrs16n.tech_name = 'ITRS 16 nm';
itrs16n.dev_name = 'ITRS 16 nm NMOS native transistor';
itrs16n.area = 1e-6 * 16e-9 / .25;       % in m^2
itrs16n.conductance = 2.535e-3;   % in S
itrs16n.gate_rating = 1.25;    % in V
itrs16n.drain_rating = 1.25;
itrs16n.gate_cap = .48e-15;
itrs16n.drain_cap = .33*itrs16n.gate_cap;
itrs16n.body_cap = .2*itrs16n.gate_cap;