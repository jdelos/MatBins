function P = calculateaxespostions2(bx,by,mx,my,sze)
%
% P = calculateaxespostions(bx,by,mx,my,sze,linkaxes)
%
% Calculates Axes positions for multiple axes plots, units are normalized
% 
% bx = base margin in x direction (Ylabel)
% by = base margin in y direction (Xlabel)
% mx = margin between axes (width)
% my = margin between axes (hight)
% 
% sze = [r c] number of axes (rows, columns)
%
% linkaxes = 'x', 'y', 'xy', which axes are shared.
% 
% When no axes are shared separate figures are the better option, NOT 
% SUBPLOTS! 
%
% P = cell array of size 'sze' with apropriate settings in cellarray form
%
% EXAMPLE
%
% P = calculateaxespostions(0.1,0.1,0.05,0.05,[2 2],'xy')
% figure;
% axes(P{1}{:}) % 1st axes
% axes(P{2}{:}) % 2nd axes
% axes(P{3}{:}) % 3th axes
% axes(P{4}{:}) % 4th axes
%
% Jan Schellekens 09-11-2013

w  = (1-bx(1)-bx(2)-(sze(2)-1)*mx)/sze(2);
h  = (1-by(1)-by(2)-sze(1)*my)/sze(1);
    
P = cell(sze); % create empty array

for rr=1:sze(1)     % for all rows
    for cc=1:sze(2) % for all columns
        P{rr,cc} =  'Position';
        %P{rr,cc} =  'OuterPosition';
        P{rr,cc} =  [P{rr,cc} {[bx(1)+(cc-1)*(w+mx)...
                     by(1)+(sze(1)-rr)*(h+my) w h]}];
        if (sze(1)-rr)>0
           P{rr,cc} = [P{rr,cc} {'XTickLabel',{}}];
        end
    end
end

end
