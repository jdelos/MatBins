% Spiral curve generator
%
% spiral.m - generate a spiral of constant radius growth per turn
%
%  spiral(cx, cy, r1, r2, a1, a2, ccode, forward)
%
%  cx, cy: centre point coords
%  r1, r2: radii at start and end
%  a1, a2: angles at start and end (can be multi-turn)
%  ccode:  MATLAB plot colour, linestyle code
%  forward: determines direction of curve (+1 or -1)
%
%  Generates a spline curve for a DXF file and demoonstrates how to make
%  a spline approximate a mathematical function curve.
%
%
function [clength]=spiral(cx, cy, r1, r2, a1, a2, ccode, forward)
global fid fidd linecolour linetype ofsx ofsy dalpha drad ifspline

d2r = pi/180;
growth_per_degree=(r2-r1)/(a2-a1);


dang = dalpha;                             % angle error allowed
incang = 2/d2r*acos((r1-drad)/r1);         % calculate max arc angle
if( incang < dang )
  dang = incang;                           % select tighter limit
end

nseg = ceil(abs(a2-a1)/dang);
da=(a2-a1)/nseg;
alpha=a1;

n=nseg+1;
for i=1:n
  ar = alpha - a1;
  x(i) = cx+(r1 + ar*growth_per_degree)*cos(alpha*d2r);
  y(i) = cy+(r1 + ar*growth_per_degree)*sin(alpha*d2r);
  alpha=alpha+da;
end

nt=floor(abs(a2-a1)/15);       % decide the number of tangent points.  I have
                               % chosen one every 15 degrees
if(nt<5)nt=5; end              % ensure there are at least 5 (including end points)

if ( ifspline ~= 0 )
  makespline(x,y,n,nt,ccode,forward);  %  Make spline curve to fit data
else
  makearcs(x,y,n,ccode,forward); % Make arcs to fit data
end

clength=0.0;

for i=2:n
  clength=clength+sqrt((x(i)-x(i-1))^2 + (y(i)-y(i-1))^2);
end