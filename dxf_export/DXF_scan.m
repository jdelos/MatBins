% DXF_scan.m   Scan DXF file
%
%
[filename,path]=uigetfile('*.dxf','DXF File');

fidh = fopen(filename,'rt');

%  read the file
clear D
buflen=12000;
count=buflen;
line=0;

while ( count==buflen )
  
  [D,count]=fread(fidh,buflen);

  D=char(D);

  if ( strcmp(computer,'PCWIN') )newline=setstr([10]); end
  if ( strcmp(computer,'MAC2') )newline=setstr([13]); end

  [txt,D]=strtok(D,newline);
  line=line+1;
  
  while (~isempty(txt) & length(D)>0)
    
    n=str2num(txt);
    nopoint=1;
    if(~isempty(n))
      if(n==5)
        [txt,D]=strtok(D,newline);
        m=str2num(txt);
        if(~isempty(n))
          if(n~=100)
            fprintf(1,'%s\n',txt);
            nopoint=0;
          end
        else
          fprintf(1,'%s\n',txt);
          nopoint=0;
        end
      end
    end
    
    if(~nopoint)
      [txt,rest]=strtok(txt,' ');  % remove leading blanks
      pt=sscanf(txt,'%x');
      ptarray(pt)=line;
    end  
        
    
    [txt,D]=strtok(D,newline);
    line=line+1;

  end
  
end
fclose(fidh);

fprintf(1,'Pointer array is up to %x (%d)\n',length(ptarray),length(ptarray));

for i=1:length(ptarray)
  if(ptarray(i)==0)
    fprintf(1,'%x not used\n',i)
  end
end

fprintf(1,'Handseed line number: %d\n',ptarray(length(ptarray)));

