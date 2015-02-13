% DXF_xyspline.m   B-Spline function
%
% This function specifies a (fixed) 3rd order B-Spline curve which
% starts at the first control point and runs to the last control point
%
%  DXF_spline(fid,nknot,ncontrol,knot,x,y,linecolour,linetype)
%
% fid:      file handle from DXF_start
% nknot:    number of knots (=ncontrol+4 for 3rd order spline)
% ncontrol: number of control points
% knot:     knot vector - u values for control points
% x,y:      vectors specifying control point coordinates
% linecolour, linetype: see DXF_line
%
% For a 3rd order B-spline, the 1st two knots are 0 and the last two are 1.
% Intermediate knot values reflect the control points.
%
% A typical spline curve is defined as follows
%
% knot value    control point
%
%   0           (no control point)
%   0           (no control point)
%   0           start point of curve
%   0           defines tangent direction at start of curve
%   1/m         intermediate tangent direction point
%   1/m         tangent point (colinear with previous and next control points)
%   1/m         intermediate tangent direction point 
%   2/m         intermediate tangent direction point
%   2/m         tangent point (colinear with previous and next control points)
%   2/m         intermediate tangent direction point 
%   3/m         intermediate tangent direction point
%   3/m         tangent point (colinear with previous and next control points)
%   3/m         intermediate tangent direction point 
%
%   ... etc...  until ....
%
%   1           defines tangent direction at end of curve
%   1           end point of curve
%   1           (no control point)
%   1           (no control point)
%
%   where m = 1/(number of intermediate tangent points + 1)
%
%   This is a typical engineering curve construction where the curve passes through
%   each intermediate tangent point with a tangent direction defined by the two
%   adjacent points which form a colinear triplet with the intermediate tangent point.
%
%   If in doubt, use a polyline call to display the control point locations
%   while debugging your code to generate the control points.
%
function DXF_spline(fid,nknot,ncontrol,knot,x,y,linecolour,linetype);
global unitscale

  fprintf(fid,'0\n');
  fprintf(fid,'SPLINE\n');
  DXF_pinc(fid);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbEntity\n');
  fprintf(fid,'8\n');  % layer
  fprintf(fid,'DEFAULT\n');  % 0
  DXF_lint(fid,linetype);
  fprintf(fid,'62\n');
  fprintf(fid,'%d\n',linecolour);
  fprintf(fid,'100\n');
  fprintf(fid,'AcDbSpline\n');
  
  fprintf(fid,'210\n');
  fprintf(fid,'0.0\n');
  fprintf(fid,'220\n');
  fprintf(fid,'0.0\n');
  fprintf(fid,'230\n');
  fprintf(fid,'1.0\n'); % normal vector
  fprintf(fid,' 70\n');
  fprintf(fid,'8\n');   % planar spline
  fprintf(fid,' 71\n');
  fprintf(fid,'3\n');   % degree
  fprintf(fid,' 72\n');
  fprintf(fid,'%d\n',nknot);  % knots
  fprintf(fid,' 73\n');
  fprintf(fid,'%d\n',ncontrol);  %  control points
  fprintf(fid,' 74\n');
  fprintf(fid,'0\n');   % no fit points
  fprintf(fid,' 42\n');
  fprintf(fid,'0.0\n'); % default fit fit points
  fprintf(fid,' 43\n');
  fprintf(fid,'0.0\n'); % default fit control points
  fprintf(fid,'40\n%1.8g\n',knot);  % knot vector (u values)
  
  for i=1:ncontrol
    fprintf(fid,'10\n%1.8g\n20\n%1.8g\n30\n0.0\n',...
      x(i)*unitscale,y(i)*unitscale); % control points
  end
  
  

