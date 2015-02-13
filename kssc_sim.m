function [ k_matrix Vo_m] = kssc_sim(t,Ph1,Vin,Vout,Io,k,n)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

I_cross=find(and(xor(Ph1(1:end-1),Ph1(2:end)),Ph1(2:end))==1)+1;
%find a Switching Periode
if isempty(I_cross)
   error('Rssc_simPh1','No crossing found Ph1'); 
end

I_to=I_cross(end-n);
I_tend=I_cross(end);

Irng=I_to:I_tend;

to=t(I_to);
tend=t(I_tend);

T=tend-to;
n_vars=size(Vout,2);
Vo_m=zeros(n_vars,1);

for i=1:n_vars
    Vo_m(i)=1/T.*trapz(Vout(Irng,i),t(Irng)); %Compute average value
end

if isrow(k)
    k=k.';
end
k_matrix=zeros(1,n_vars);
k_matrix =(k*Vin-Vo_m)/Io;

%k_matrix=k_matrix.';

end

