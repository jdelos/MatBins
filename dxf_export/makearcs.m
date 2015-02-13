% makearcs.m  - fit a series of arcs to represent a series of points
%
%  makearcs(x,y,n,ccode,forward)
%
%  x,y,n:   n pairs of x,y coordinates
%  ccode:   MATLAB plot code
%  forward: direction of path
%
%
function makearcs(x,y,n,ccode,forward)
global fid fidd linecolour linetype ofsx ofsy dalpha drad

d2r = pi/180;

plot(x(1:n),y(1:n),ccode);

if(forward<0)
  x=reverse(x,n);
  y=reverse(y,n);
end
  
for i=1:n
  fprintf(fid,'%8.4f\t%8.4f\n', x(i),y(i));
end

if ( n < 3 )
  fprintf(1,'Makearcs: too few points (%d) to fit arcs to\n', n);
  return;
end

i=1;
%n
while (i<n-1)
  %i
  [c,r1,a1,a2]=fitarc(x(i:i+2),y(i:i+2),1);
  if (i == n-2)
    [c,r1,a1,a2]=fitarc(x(i:i+2),y(i:i+2),2);
    %plot([c(1),x(i:i+2),c(1)],[c(2),y(i:i+2),c(2)],'g-');
    arc(c(1),c(2),a1/d2r,a2/d2r,r1,'k-',1);
    i=n;
  else
    l=i+1;
    for j=i+2:n-1  % ???
      [c2,r2,a1,a2]=fitarc([x(i),x(j:j+1)],[y(i),y(j:j+1)],2);
      dp = dist( [x(i),y(i)], [x(j+1),y(j+1)] );
      b1 = asin(dp/(2*r1));
      b2 = asin(dp/(2*r2));
      derr = abs( r1*(1-cos(b1)) - r2*(1-cos(b2)) );  % distance error
      aerr = abs(b2-b1)/d2r;   %  degrees error
      if ( derr > drad | aerr > dalpha )  %  error limit exceeded
        break;
      else
        l=j;
      end
    end
    mid=ceil((l+i)/2);
    if ( l==mid )
      l=l+1;
    end
    [c,r1,a1,a2]=fitarc([x(i),x(mid),x(l)],[y(i),y(mid),y(l)],1);
    %plot([c(1),x(i),x(mid),x(l),c(1)],[c(2),y(i),y(mid),y(l),c(2)],'r-');
    arc(c(1),c(2),a1/d2r,a2/d2r,r1,'k-',1);
    i=mid;
  end
  
end

