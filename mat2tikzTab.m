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
hdr = sprintf('x');
frmt_str = sprintf('%%2.12e\n');
for i=1:ly
   hdr = [hdr sprintf('\ty%u',i)];
   frmt_str = [ sprintf('%%2.12e\t') frmt_str ] ;
end

T = [x;data];
fileID = fopen([filename '.dat'],'w');


fprintf(fileID,'%s\n',hdr);
fprintf(fileID,frmt_str,T);
fclose(fileID);

end

