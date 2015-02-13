% DXF_line.m 
%
% DXF_line(fid,x,y,x1,y1,linecolour,linetype)
%
%  fid: file handle from DXF_start
%  x,y: start point
%  x1,y1: end point
% 
% Colours (standard AutoCAD):
%
% 1: red
% 2: yellow
% 3: green
% 4: cyan
% 5: blue
% 6: magenta
% 7: black
%
% Line types
%
% 1: CONTINUOUS
% 2: HIDDEN
% 3: CENTER
% 4: DOT
%
%

function DXF_line(fid,x,y,x1,y1,linecolour,linetype)
global unitscale

  fprintf(fid,'0\n');
  fprintf(fid,'LINE\n');
  DXF_pinc(fid);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEntity\n');
  fprintf(fid,'8\n');  % layer
  fprintf(fid,'DEFAULT\n');  % 0
  DXF_lint(fid,linetype);
  fprintf(fid,'62\n');
  fprintf(fid,'%d\n',linecolour);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbLine\n');
 
  fprintf(fid,'10\n');  % x coord code
  fprintf(fid,'%1.8g\n',x*unitscale);
  fprintf(fid,'20\n');  % y coord code
  fprintf(fid,'%1.8g\n',y*unitscale);  
  fprintf(fid,'30\n');  % z coord code
  fprintf(fid,'0.0\n'); 

  fprintf(fid,'11\n');  % x coord code
  fprintf(fid,'%1.8g\n',x1*unitscale);
  fprintf(fid,'21\n');  % y coord code
  fprintf(fid,'%1.8g\n',y1*unitscale);  
  fprintf(fid,'31\n');  % z coord code
  fprintf(fid,'0.0\n'); 



