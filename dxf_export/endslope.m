%  endslope.m
%
%  return estimate of tangent at end of a curve defined
%  only by data points
%
%
function [t1,t2]=endslope(x,y,n)

p2=[x(3)-x(1);y(3)-y(1)];
p1=[x(2)-x(1);y(2)-y(1)];
mp2=dist([x(3),y(3)],[x(1),y(1)]);
mp1=dist([x(2),y(2)],[x(1),y(1)]);
p2=p2/mp2;
p1=p1/mp1;
t1=(mp2*p1-mp1*p2)/(mp2-mp1);
tm=sqrt(t1(1)^2+t1(2)^2);
t1=t1/tm;

p2=[x(n)-x(n-2);y(n)-y(n-2)];
p1=[x(n)-x(n-2);y(n)-y(n-2)];
mp2=dist([x(n-2),y(n-2)],[x(n),y(n)]);
mp1=dist([x(n-1),y(n-1)],[x(n),y(n)]);
p2=p2/mp2;
p1=p1/mp1;
t2=(mp2*p1-mp1*p2)/(mp2-mp1);
tm=sqrt(t2(1)^2+t2(2)^2);
t2=t2/tm;
