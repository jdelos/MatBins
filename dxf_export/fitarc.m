%  fitarc.m
%
%  Fit arc through 3 points, optionally joining the first two only
%
%  [c,radius,a1,a2]=fitarc(x,y,opt,ccode,da)
%
%  x,y:   contain coords of 3 points
%  opt:   1 - join point 1 to point 2, 2 - joint point 1 to point 3
%  ccode: colour code for MATLAB plot
%
%  c:       centre of arc 
%  radius:  radius
%  an1,an2: start, end angles (radians)

function [c,radius,an1,an2]=fitarc(x,y,opt)

p1=[x(1);y(1)];       % points
p2=[x(2);y(2)];
p3=[x(3);y(3)];

d1=p2-p1;             % chords
d2=p3-p2;

s=p1+d1*0.5;          % mid points
t=p2+d2*0.5;

u=[-d1(2);d1(1)];    % perpendiculars
v=[-d2(2);d2(1)];

A=[u(1) -v(1);u(2) -v(2)];
if ( abs(det(A))>1E-8 )
  d=inv(A)*(t-s);
else
  fprintf(1,'Straight:\n');
  x,y,opt
  if(opt==1)
    c=p1;
    a1=p2(1);
    a2=p2(2);
    radius=0.0;
  else
    c=p1;
    a1=p3(1);
    a2=p3(2);
    radius=0.0;
  end
end

c=s+d(1)*u;
radius=sqrt((p1(1)-c(1))^2 + (p1(2)-c(2))^2);
dirn = d1(1)*d2(2) - d1(2)*d2(1);  % sign of angle change
a1=vangle(p1,c);
a2=vangle(p2,c);
a3=vangle(p3,c);
if ( sign(a2-a1) ~= sign(dirn) )
    a2 = a2 + 2*pi*sign(dirn);
end
if ( sign(a3-a2) ~= sign(dirn) )
    a3 = a3 + 2*pi*sign(dirn);
end
if ( opt==1 )
  an1=a1;
  an2=a2;
else
  an1=a1;
  an2=a3;
end
