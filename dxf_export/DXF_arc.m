% DXF_arc.m
%
%  DXF_arc(fid,cx,cy,radius,angle1,angle2,linecolour,linetype)
%
%  fid: file handle from DXF_start
%  cx, cy: centre point
%  angle1, angle2: start and end angles (degrees)
%  linecolour - see DXF_line
%  linetype - see DXF_line
%
function DXF_arc(fid,cx,cy,radius,angle1,angle2,linecolour,linetype)
global unitscale

  fprintf(fid,'0\n');
  fprintf(fid,'ARC\n');
  DXF_pinc(fid);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEntity\n');
  fprintf(fid,'8\n');  % layer
  fprintf(fid,'DEFAULT\n');  % 0
  DXF_lint(fid,linetype);
  fprintf(fid,'62\n');
  fprintf(fid,'%d\n',linecolour);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbCircle\n');

  
  fprintf(fid,'10\n');  % x coord code
  fprintf(fid,'%1.8g\n',cx*unitscale); 
  fprintf(fid,'20\n');  % y coord code
  fprintf(fid,'%1.8g\n',cy*unitscale);  
  fprintf(fid,'30\n');  % z coord code
  fprintf(fid,'0.0\n'); 
  fprintf(fid,'40\n');  % radius code
  fprintf(fid,'%1.8g\n',radius*unitscale);  

  fprintf(fid,'100\n');
  fprintf(fid,'AcDbArc\n');
  
  fprintf(fid,'50\n');  % 
  fprintf(fid,'%1.8g\n',angle1); 
  fprintf(fid,'51\n');  % 
  fprintf(fid,'%1.8g\n',angle2);  
