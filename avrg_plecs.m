function [ varargout ] = avrg_plecs(out_plcs,N)
% Process the results of the transient simulation of an SCC
% Average the measurements over the last N periods
% Input variables:
%   out_plcs -->  Simulation structure of the Stand-Alone Plecs
%   N        --> Number of averaged periods
%

t    = out_plcs.Time;
Ph1  = out_plcs.Values(1,:);

%% Find a Switching Periode
I_cross=find(and(xor(Ph1(1:end-1),Ph1(2:end)),Ph1(2:end))==1)+1;

if isempty(I_cross)
    %Chech if converter was switching
   error('Rssc_simPh1','No crossing found Ph1'); 
end
%Define intial and final index
I_to=I_cross(end-N);
I_tend=I_cross(end);

%Range of integration
Irng=I_to:I_tend;

%Period of integration
to=t(I_to);
tend=t(I_tend);
T=tend-to;
  

n_out = size(out_plcs.Values,1)-1;
%% Compute averaged values
varargout = cell(1,2);
for i=1:n_out
    x = out_plcs.Values(i+1,Irng);
    varargout{i} = 1/T*trapz(t(Irng),x);
end
end

