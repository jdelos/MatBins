% reverse.m   reverse order of elements in a vector
%
function xr = reverse(x,n)

for i=1:n
  xr(i)=x(n-i+1);
end

  