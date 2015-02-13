%  vangle.m - angle of line between two points
%  result is radians
%
function angle=vangle(p,q)

angle=atan2( (p(2)-q(2)) , (p(1)-q(1)) );
