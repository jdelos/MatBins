% Plot CCM DCM BCM behavior of split leg with integrated bias
%
% By TheBruceDickinson productions, 23-12-2012
% Jan Schellekens, j.m.schellekens@tue.nl


%% Reset all data and clear terminal
clear all; close all; clc

%% Settings
m = -1:0.2:1;			% modulation index for boundery curve
iLf1n = 0:0.01:2;		% nonmalized current P-leg 
iLf2n = -2:0.01:0;		% normalized current N-leg

m_ = m(2:end-1);		% modulation index without +-1 (singularity)
%% Conduction modes P-leg

for ii=1:length(m_)
	di = (1-m_(ii).^2);
	%Udcm = (1+m_(ii)).^2./(iLf1n+(1+m_(ii)).^2); % referenced to 0..Udc
	%Uccm = ones(1,length(iLf1n))*1/2*(1+m_(ii)); % referenced to 0..Udc

	Udcm = ((1+m_(ii)).^2-iLf1n)./((1+m_(ii)).^2+iLf1n); % referenced to [-1/2..1/2]*Udc
	Uccm = ones(1,length(iLf1n))*m_(ii); % referenced to [-1/2..1/2]*Udc
	
	Uavg1n(ii,:) = Udcm.*(iLf1n<di)+ Uccm.*(iLf1n>=di);
end

%% Conduction modes N-leg

for ii=1:length(m_)
	di  = -(1-m_(ii).^2);
	%Udcm = iLf2n./(iLf2n-(1-m_(ii)).^2); % referenced to 0..Udc
	%Uccm = ones(1,length(iLf2n))*1/2*(1+m_(ii)); % referenced to 0..Udc
	
	Udcm = (iLf2n+(1-m_(ii)).^2)./(iLf2n - (1-m_(ii)).^2); % referenced to [-1/2..1/2]*Udc
	Uccm = ones(1,length(iLf2n))*m_(ii); % referenced to [-1/2..1/2]*Udc
	
	Uavg2n(ii,:) = Uccm.*(iLf2n<=di) + Udcm.*(iLf2n>di);
end


%% Plot settings

bx = 0.2;
by = 0.16;
mm = 0.05; 

SetFig		= {'Units','Centimeters','Position',[10 10 5.5 7]};
SetAxes		= {'Units','Normalized','ColorOrder',[0 0 0],'FontSize',8};
SetAxesP	= {'Position',[bx by 1-mm-bx 1-mm-by],'XTick',[0 0.5 1 2]};
SetAxesN	= {'Position',[mm by 1-mm-bx 1-mm-by],'XTick',[-2 -1 -0.5 0],...
				'YAxisLocation','Right'};
SetLabel	= {'Interpreter','LaTeX','Units','Normalized','FontSize',8};

SetText		= {'Interpreter','Latex','VerticalAlignment','bottom',...
				'FontSize',8};	
SetTextP	= {'HorizontalAlignment','right'};
SetTextN	= {'HorizontalAlignment','left'};

XlblPos     = [0.5 -0.125];
YlblPosP    = [-0.17 0.5];
YlblPosN    = [1.15 0.5];

%% Plot results

% P-cell
createfig(100,'name','Conductionmodes P-cell',SetFig{:});
a1 = axes(SetAxesP{:},SetAxes{:}); % generate axes P-cell

plot(iLf1n,Uavg1n)
%plot((1-m.^2),1/2.*(1+m),':');
plot((1-m.^2),m,':');

xlabel('$\langle{i_{L_f}}_{1}\rangle/\hat{\Delta} {i_{L_f}}_{1}$ (-)',SetLabel{:},...
		'UserData','matlabfrag:$\sfrac{\tavg{\iLfx[1]}}{\pk{\Delta} \iLfx[1]}$ (-)',...
		'Position',XlblPos);
ylabel('$\langle{u_{sn}}_{1}\rangle/0.5*U_{DC}$ (-)',SetLabel{:},...
		'UserData','matlabfrag:$\sfrac{\tavg{\usnx[1]}}{\tfrac{1}{2}\Udc}$ (-)',...
		'Position',YlblPosP);

for ii=1:size(Uavg1n,1)
	text(2-0.05,Uavg1n(ii,end)+0.005,['${m_{sn}}_1 = ' num2str(m_(ii)) '$'],...
		'Userdata',['matlabfrag:$\mix[1] = ' num2str(m_(ii)) '$'],SetTextP{:},SetText{:})
end

% N-cell
createfig(200,'name','Conductionmodes N-cell',SetFig{:});
a2 = axes(SetAxesN{:},SetAxes{:}); % generate axes N-cell

plot(iLf2n,Uavg2n)
%plot(-(1-m.^2),1/2.*(1+m),':');
plot(-(1-m.^2),m,':');

xlabel('$\langle{i_{L_f}}_{2}\rangle/\hat{\Delta} {i_{L_f}}_{2}$ (-)',SetLabel{:},...
		'UserData','matlabfrag:$\sfrac{\tavg{\iLfx[2]}}{\pk{\Delta} \iLfx[2]}$ (-)',...
		'Position',XlblPos);
ylabel('$\langle{u_{sn}}_{2}\rangle/0.5*U_{DC}$ (-)',SetLabel{:},...
		'UserData','matlabfrag:$\sfrac{\tavg{\usnx[2]}}{\tfrac{1}{2}\Udc}$ (-)',...
		'Position',YlblPosN,'VerticalAlignment','top');

for ii=1:size(Uavg2n,1)
	text(-2+0.05,Uavg2n(ii,1)+0.005,['${m_{sn}}_2 = ' num2str(m_(ii)) '$'],...
		'Userdata',['matlabfrag:$\mix[2] = ' num2str(m_(ii)) '$'],SetTextN{:},SetText{:})
end

%% Save Figures

redistributefigures([100 200],[1 2])

fig2pdf([],'OCC_ML_CCMDCM.pdf','..\..\..\..\mfragPDFthesisheader.tex')