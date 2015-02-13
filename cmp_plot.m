function [ AX ] = cmp_plot(x,y1,y2,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[AX,~ , ~] = plotyy(x,[y1; y2],x,((y1-y2)./y1)*100 );

if length(varargin) >= 3
set(get(AX(1),'Ylabel'),'String',varargin{1})
set(get(AX(2),'Ylabel'),'String',varargin{2})
set(get(AX(1),'Xlabel'),'String',varargin{3})
end

if length(varargin)  ==5 
legend(varargin{4},varargin{5})
end

legend('Y1','Y2')

end

