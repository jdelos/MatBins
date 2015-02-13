% makespline.m
% Generate spline in AutoCAD DXF file format
%
% nt = number of tangent points to be selected
% xc = control point array (yc, zc also)
% nk = no. of knots (3 for each tangent point plus extra at each end
% nc = no. of control points (3 for each tangent point)
%
% make 2 control points at each end (to define tagent) and 3 at each
% intermediate point
%
%
% We start with the profile defined numerically in a large number of coordinate points
% more or less uniformly spaced in the vectors x and y (total n points).
%
%
function makespline(x,y,n,nt,ccode,forward)
global fid fidd linecolour linetype ofsx ofsy

plot(x(1:n),y(1:n),ccode);

if(forward<0)
  x=reverse(x,n);
  y=reverse(y,n);
end
  
for i=1:n
  fprintf(fid,'%8.4f\t%8.4f\n', x(i),y(i));
end

if ( n < nt )
  fprintf(1,'Makepline: too few points (%d) to fit spline to\n', n);
  return;
end

if(nt<5)nt=5; end              % ensure there are at least 5 (including end points)
nd=floor(1:(n-1)/(nt-1):n);    % values of knot points at each tangent point triplet
                               % calculated so that the 'nd' values correspond to 
                               % data point positions - they are not 'exactly' distributed

nt=length(nd);  % to be sure!  %
nc=(nt-2)*3+4;                 % number of control points
nk=nc+4;                       % number of knot values

k=1;
for i=1:nt
  xk(k)=x(nd(i));  % main control points are tangent points on desired profile
  yk(k)=y(nd(i));  % spline will pass through these points
  k=k+3;
end
%
% Find distance between each pair of tangent points.  One third of this
% distance is a 'good' separation distance for the tangent direction
% points on either side of each tangent point.
%
k=1;
for i=1:nt-1
  d(i)=sqrt((xk(k)-xk(k+3))^2+(yk(k)-yk(k+3))^2);
  k=k+3;
end
d=d/3;
%
%  Fill in the coordinates for the tangent direction points on each side of the
%  intermediate tangent points, and the start and end points.
%
k=1;
[t0,tn]=endslope(x,y,n);  % estimate end tangents

for i=1:nt
  if ( i==1 )  % Do the start end of the curve
    knot(1)=0;
    knot(2)=0;
    knot(3)=0;
    knot(4)=0;
    c1=[xk(k);yk(k)];
	  c2=c1+t0*d(1);            
    xk(k+1)=c2(1);
    yk(k+1)=c2(2);             % generate tangent direction point
    
  elseif( i==nt )      % now do the end of the curve
    c1=[xk(k);yk(k)];
	  c0=c1-tn*d(nt-1);
    xk(k-1)=c0(1);
    yk(k-1)=c0(2);             % generate tangent direction point
    knot(k-1+2)=1.0;
    knot(k+2)=1.0;
    knot(k+1+2)=1.0;
    knot(k+2+2)=1.0;
    
  else            %  for each intermediate tangent point
    tanx=x(nd(i)+1)-x(nd(i)-1);
    tany=y(nd(i)+1)-y(nd(i)-1);
    tanm=sqrt(tanx^2+tany^2);
    tangv=[tanx;tany]/tanm;  % find tangent vector, normalised
    c1=[xk(k);yk(k)];
    c0=c1-tangv*d(i-1);
    c2=c1+tangv*d(i);
    xk(k-1)=c0(1);
    yk(k-1)=c0(2);
    xk(k+1)=c2(1);
    yk(k+1)=c2(2);  % generate tangent points
    knot(k-1+2)=(i-1)/(nt-1);
    knot(k+2)=(i-1)/(nt-1);
    knot(k+1+2)=(i-1)/(nt-1);
  end
  k=k+3;
end

plot(xk,yk,'ro');  % Plot control point positions to check (MATLAB plot only)

DXF_spline(fidd, nk, nc, knot, xk+ofsx, yk+ofsy,linecolour,linetype);

%DXF_poly(fidd,x+ofsx,y+ofsy,n,,linecolour,linetype); % useful for checking accuracy of
%                                           % spline approximation
%
%
% Display end points (used for debugging)
%
%fprintf(1,'spn: %1.8g %1.8g   %1.8g %1.8g\n',xk(1)+ofsx,yk(1)+ofsy,...
%  xk(nc)+ofsx,yk(nc)+ofsy);
