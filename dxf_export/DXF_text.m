% DXF_text.m 
%
% DXF_text(fid,x,y,textcolour,height,angle,text)
%
% fid:    file pointer from DXF_start
% x,y:    position of text
% height: height of tallest character
% angle:  rotation angle in degrees
% text:   character string
%

function DXF_text(fid,x,y,textcolour,height,angle,textstr)
global unitscale

  d2r = pi/180;
  xp = x + height*sin(angle*d2r);
  yp = y + height*cos(angle*d2r);

  fprintf(fid,'0\n');
  fprintf(fid,'TEXT\n');
  DXF_pinc(fid);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEntity\n');
  fprintf(fid,'8\n');  % layer
  fprintf(fid,'DEFAULT\n');  % 0
  fprintf(fid,'6\n');
  fprintf(fid,'CONTINUOUS\n');
  fprintf(fid,'62\n');
  fprintf(fid,'%d\n',textcolour);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbText\n');
 
  fprintf(fid,'10\n');  % x coord code
  fprintf(fid,'%1.8g\n',x*unitscale);
  fprintf(fid,'20\n');  % y coord code
  fprintf(fid,'%1.8g\n',y*unitscale);  
  fprintf(fid,'30\n');  % z coord code
  fprintf(fid,'0.0\n'); 
  fprintf(fid,'40\n');  % text height
  fprintf(fid,'%1.8g\n',height*unitscale); 
  
  fprintf(fid,'1\n');  % text code
  fprintf(fid,'%s\n',textstr); 
  fprintf(fid,'50\n');  % text angle
  fprintf(fid,'%1.8g\n',angle); 
  fprintf(fid,'7\n');  % font code
  fprintf(fid,'STANDARD\n'); 

  fprintf(fid,'11\n');  % x coord code
  fprintf(fid,'%1.8g\n',xp*unitscale);
  fprintf(fid,'21\n');  % y coord code
  fprintf(fid,'%1.8g\n',yp*unitscale);  
  fprintf(fid,'31\n');  % z coord code
  fprintf(fid,'0.0\n'); 
  
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbText\n');

  fprintf(fid,'73\n');  % alignment code
  fprintf(fid,'        3\n'); 

