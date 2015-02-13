function  float_ladder2cades( topo, file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen([file_name '.sml'],'w');

n=length(topo.f_ssl_in);
Rtot = [];
%print the ssl equations
for i=1:n
    fprintf(fid,'Rssl_%d =  %s;\n',i,mat2cades(char(topo.f_ssl_in(i))));
    Rtot = [Rtot '+ Rssl_' num2str(i) '*Irms_' num2str(i)];
end
%Total sum resitance is minimum
Rtot(1)=[];
Rtot= ['Rtot ='  Rtot];

%Optimitzation boundary
CT = [ 'C_tot = ' char(sum(symvar(topo.f_ssl)))];
fprintf(fid,'%s;\n', CT);

%Write FoM 
fprintf(fid,'%s;\n', Rtot);


fclose(fid);

end

