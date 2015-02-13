% circle.m circle generator
%
%  circle(cx, cy, radius, ccode,forward)
%
%  Circle generator: da is the angle increment for line segments (does not affect
%       DXF file output), ccode is the plot code for the MATLAB plot.
%       forward is +1 or -1 and defines the direction in which the 
%       arc is plotted (again does not affect the DXF output).
%
function circle(cx, cy, radius, ccode,forward)
global fid fidd linecolour linetype ofsx ofsy dalpha drad

d2r = pi/180;
a1=0.0;
a2=360.0;

dang = dalpha;                             % angle error allowed
incang = 2/d2r*acos((radius-drad)/radius); % calculate max arc angle
if( incang < dang )
  dang = incang;                           % select tighter limit
end

nseg = ceil((a2-a1)/dang);
da=(a2-a1)/nseg;
alpha=a1;

n=nseg+1;
for i=1:n
  x(i) = cx+radius*cos(alpha*d2r);
  y(i) = cy+radius*sin(alpha*d2r);
  alpha=alpha+da;
end

plot(x,y,ccode);

if(forward<0)
  x=reverse(x,n);
  y=reverse(y,n);
end
  
for i=1:n
  fprintf(fid,'%8.4f\t%8.4f\n', x(i),y(i));
end

DXF_circle(fidd, cx+ofsx, cy+ofsy,radius,linecolour,linetype);
