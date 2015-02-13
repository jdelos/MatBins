function z = rmsxy(x,y)
% function z = rmsxy(x,y)
% returns the RMS value of the y signal with respect ot the x vector

z = sqrt(1/(x(end)-x(1))*trapz(x,y.^2));


 
