function  ssleq2file( topo, file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

fid = fopen([file_name '.sml'],'w');

n=length(topo.f_ssl);
Rtot = [];
Rtot2 = [];

%print the ssl equations
for i=1:n
    fprintf(fid,'Rssl_%d =  %s;\n',i,mat2cades(char(topo.f_ssl(i))));
    fprintf(fid,'k_%d =  %f;\n',i,topo.ratio(i));
    
    Rtot = [Rtot '+ Rssl_' num2str(i)];
    Rtot2 = [Rtot2 '+ Rssl_' num2str(i) '/k_' num2str(i)];   
end
%Total sum resitance is minimum
Rtot(1)=[];
Rtot2(1)=[];

Rtot= ['Rtot ='  Rtot];

Rtot2= ['Rtot_II ='  Rtot2 ];

%Optimitzation boundary
CT = [ 'C_tot = ' char(sum(symvar(topo.f_ssl)))];
fprintf(fid,'%s;\n', CT);

%Write FoM 
fprintf(fid,'%s;\n', Rtot);
%Write FoM 
fprintf(fid,'%s;\n', Rtot2);

fclose(fid);

end

