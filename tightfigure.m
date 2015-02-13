function  tightfigure(h)
% Clean empty space of the plot

 ax=get(h,'Children');
 
 arrayfun(@tightaxes,ax); set(h,'Color','w','InvertHardcopy','off','PaperPositionMode','auto')
end

function  tightaxes(ax)
% Clean empty space of the plot
 T = get(ax,'tightinset');
 set(ax,'position',[T(1) T(2) 1-T(1)-T(3) 1-T(2)-T(4)]);
 set(ax,'XLimMode','auto','YLimMode','auto','ZLimMode','auto');
end
