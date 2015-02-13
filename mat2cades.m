function  y  = mat2cades( x )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

x=[' ' x];

while(~isempty(regexp(x,'\^','once'))) 
    idx = regexp(x,'\^','once');
    A = zeros(1,length(x));
    %Identify parentesis
    A(regexp(x,'('))=1; %open 
    A(regexp(x,')'))=-1; %close
    p_levels = cumsum(A);
    
    pwr = x(idx+1);
    if x(idx-1) == ')'
        in_x=find(p_levels(1:(idx-2))==p_levels(idx),1,'last');
    else
        in_x = regexp(x(1:idx-1),'[ +-*/(]');
        in_x = in_x(end);
    end
    base = x(in_x+1:idx-1);    

x=[x(1:in_x) 'pow(' base ',' pwr ')' x(idx+2:end)];
end

y=x;

end

