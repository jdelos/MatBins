% DXF_ellipse.m
%
%  DXF_ellipse(fid,cx,cy,mx,my,mr,start,end,linecolour,linetype)
%
%  fid: file handle from DXF_start
%  cx, cy:     centre point
%  mx,my:      end of major axis (relative to centre)
%  mr:         size ratio of minor axis (<1)
%  start,end:  0, 2*pi for full ellipse, else partial ellipse
%  linecolour: see DXF_line
%  linetype:   see DXF_line
%
function DXF_ellipse(fid,cx,cy,mx,my,mr,start_phi,end_phi,linecolour,linetype)
global unitscale

  fprintf(fid,'0\n');
  fprintf(fid,'ELLIPSE\n');
  DXF_pinc(fid);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEntity\n');
  fprintf(fid,'8\n');  % layer
  fprintf(fid,'DEFAULT\n');  % 0
  DXF_lint(fid,linetype);
  fprintf(fid,'62\n');
  fprintf(fid,'%d\n',linecolour);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEllipse\n');

  
  fprintf(fid,'10\n');  % x coord code
  fprintf(fid,'%1.8g\n',cx*unitscale); 
  fprintf(fid,'20\n');  % y coord code
  fprintf(fid,'%1.8g\n',cy*unitscale);  
  fprintf(fid,'30\n');  % z coord code
  fprintf(fid,'0.0\n'); 
  fprintf(fid,'11\n');  % x coord code
  fprintf(fid,'%1.8g\n',mx*unitscale); 
  fprintf(fid,'21\n');  % y coord code
  fprintf(fid,'%1.8g\n',my*unitscale);  
  fprintf(fid,'31\n');  % z coord code
  fprintf(fid,'0.0\n'); 
  fprintf(fid,'40\n');  % radius code
  fprintf(fid,'%1.8g\n',mr);  

  fprintf(fid,'41\n');  % radius code
  fprintf(fid,'%1.8g\n',start_phi);  
  fprintf(fid,'42\n');  % radius code
  fprintf(fid,'%1.8g\n',end_phi);  
  
