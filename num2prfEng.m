function [prf base] =num2prfEng(x)

% function xstr=num2strEng(x,[n])
%
% Converts the vector of numbers in x to a string array with mantissa and
% metric prefix, e.g. 1e-10 -> '100 p'
%
% Numbers out of the range 1e-24 <= x < 1e27 are left unscaled
% Enforces a column result
% Can optionally specify length for num2str

prefices={'Y','Z','E','P','T','G','M','k','','m','\mu','n','p','f','a','z','y'};

x=x(:);
logx=log10(x);
logbase=3*floor(logx/3);
base=-1;
prf='-';
if (logbase>=-24)&(logbase<=24);
    ibase=1-(logbase-24)/3; %
    prf = prefices{ibase};
    base = logbase;
end
end    



