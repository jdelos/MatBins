% dist.m  Euclidean distance norm between two points
%
%
function d = dist(p,q)
r = (p(1)-q(1))^2 + (p(2)-q(2))^2;
if ( r>0 ) 
  d = sqrt(r);
else
  d=0;
end
