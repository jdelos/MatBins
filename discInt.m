function [ y ] = discInt( x,t )
%DISCINT Summary of this function goes here
%   Detailed explanation goes here

tv(:,1)=diff(t);
xmean(1,:)=(x(1:end-1)+x(2:end))/2;

y=xmean*tv;


end

