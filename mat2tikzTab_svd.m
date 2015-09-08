function mat2tikzTab(filename,data,x)
%% mat2tikzTab --> Create a tikzTab

if iscolumn(data)
   data=data';
end


if nargin == 2
    if ~ismatrix(data)
        x = data;
        x(:) = 1:size(data,2);   
    end
else
   if iscolumn(x)
        x=x';
   end
   
   if ismatrix(data)
       [~,lx] = size(data);
       if lx ~= length(x)
           data = data.';
       end   
   end
end

%% Generate format strings 
[ly,~] = size(data);
% Header string
hdr = sprintf('x_0\t');
frmt_str = sprintf('%%s2.12\t\n');
for i=1:ly
   hdr = [hdr sprintf([ 'y_' num2str(i) '\t'] ) ] ;
   frmt_str = [ sprintf('%%s2.12\t') frmt_str] ;
end

T = [x;data];
fileID = fopen([filename '.dat'],'w');


fprintf(fileID,'%s\n',hdr);
fprintf(fileID,frmt_str,T);
fclose(fileID);

end

