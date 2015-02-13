function [ h ] = contourf_log( X,Y,Z)
%% function h = contourf_log(X,Y,Z)
% Plots a filled contour plot in a logarithmic scale
%  Input arguments:
%   X -> X axsis Data
%   Y -> Y axsis Data
%   Z -> Z axsis Data
%
%  Output arguments:
%   h -> contourplot handle 

%% Find mins amd max points of the Z data

Zaux = Z(Z>-Inf & Z<Inf);
Zmin = min(min(Zaux));
Zmax = max(max(Zaux));

%% Linealize the colors in a logarithmic scale
a=-1/log10(Zmin/Zmax);
b=-a*log10(Zmin);

%% Plot a surface
h= surf(X,Y,Z,log10(Z)*a+b,'FaceColor','interp',...
'EdgeColor','none',...
'FaceLighting','phong');

%% Set axsis in to log mode
set(gca,'Yscale','log')
set(gca,'Xscale','log')
set(gca,'Zscale','log')
%% Place the color var
%hbc = colorbar('Location','West');
hbc = colorbar

%% Rearrange the ticks of the color bar in teh right way
Ticks = 10.^((get(hbc,'YTick')-b)/a);
TicksTxt = arrayfun(@(x) num2eng(x,3), Ticks, 'unif', 0); %Convert ticks to exponential values
set(hbc,'YTickLabel',TicksTxt);

%% Zenithal view of the plot  
view(2) 

%% Tight axis to the data space
axis tight

end

