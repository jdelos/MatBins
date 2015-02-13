function [ y ] = g2table(x)
%% funciton y = g2table(x)
% Converts the 3-D NxMxP matrix into a 2-D table with P-rows of N*M columns 
%corresponding to the squeezed NxM matrix

[n,m,p]=size(x);
y=zeros(p,n*m);

for i=1:p
    z=x(:,:,i);
    y(i,:)=z(1:end);
end


end

