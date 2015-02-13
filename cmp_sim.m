function [ Vo_m , Io_m, Po_m, Pi_m, Io_rms, Vi_m ] = cmp_sim(out_plcs,N)
% Process the results of the transient simulation of an SCC
% Average the measurements over the last N periods
% Input variables:
%   out_plcs -->  Simulation structure of the Stand-Alone Plecs
%   N        --> Number of averaged periods
%

t    = out_plcs.Time;
Ph1  = out_plcs.Values(1,:);
Vout = out_plcs.Values(2,:);
Io   = out_plcs.Values(3,:);
Po   = out_plcs.Values(4,:);
Pi   = out_plcs.Values(5,:);
Vi   = out_plcs.Values(6,:);

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
  

%% Compute averaged values
Vo_m = 1/T*trapz(t(Irng),Vout(Irng)); 
Io_m = 1/T*trapz(t(Irng),Io(Irng));  %Compute average value
Io_rms = sqrt(1/T*trapz(t(Irng),Io(Irng).^2));  %Compute average value

Po_m = 1/T*trapz(t(Irng),Po(Irng));  %Compute average value
Pi_m = 1/T*trapz(t(Irng),Pi(Irng));     %Compute average value
Vi_m = 1/T*trapz(t(Irng),Vi(Irng));     %Compute average value

end

