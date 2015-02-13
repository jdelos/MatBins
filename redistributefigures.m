function redistributefigures(varargin)

% Sizes and positions within a figure axes in a figure
% 
% RedistribnuteFigures(H,Size,Resize,'PropertyName',PropertyValue,...)
%
% H          : vector of figure handles, if empty all figures, a NaN can be
%				used to create an empty space.
% Size [n m] : number of rows and columns used
% Resize     : resizes figures to fit screen
%				'yes', 'no', 'shrink' or 1 , 0, -1 {default 'no'/0}
%				
% Other properties are set for all figures.    
%
%
% J.M. Schellekens, TU/e, 23-04-2013
%


%% Settings in pixels

hstart  = 84; % height startbar hard to determine from Matlab



%% Argument check and extraction + execute Set on all figures


% defaults
resze = 0;
sze = [];
fh  = [];

%% Parse Inputs
nin = 1;
if nargin==0
	fh = sort(findobj(0, '-depth', 1,'Type','Figure'));	
elseif  isempty(varargin{nin})
	fh = sort(findobj(0, '-depth', 1,'Type','Figure'));	
	nin = nin+1;
else
	if all(ishandle(varargin{nin})|isnan(varargin{nin}))
		fh = varargin{nin};
		nin = nin+1;
	else
		fh = sort(findobj(0, '-depth', 1,'Type','Figure'));	
	end
end
	
while nin<=nargin
	if strcmpi(varargin{nin},'yes') || isequal(varargin{nin},1)
		resze = 1;
	elseif strcmpi(varargin{nin},'shrink') || isequal(varargin{nin},-1)
		resze = -1;
	elseif isvector(varargin{nin}) && isequal(length(varargin{nin}),2)
		sze = varargin{nin};
	elseif isprop(fh,varargin{nin})
		set(fh,varargin{nin},varargin{nin+1});
		nin = nin+1; % one additional step due to prop val pair
	end
	nin = nin+1;
end


%% Determine number of rows and columns if not given
if isempty(sze)
    sze(1)=round(sqrt(length(fh)));
    sze(2)=ceil(length(fh)/sze(1));
end


%% get width and height of screen
set(0,'Units','Pixels')
scrsze = get(0,'ScreenSize');


%%  make grid
cwidth  = scrsze(3)/sze(2); % column width
rheight = (scrsze(4)-hstart)/sze(1); % row height


%% Set Units of figures to default
figs = findobj(fh,'Type','figure');
set(figs,'Units','pixels')
    
%% Resize figures if requested
if resze
	for ii=1:length(figs)
		tmp		= get(figs(ii),'OuterPosition');
		border	= tmp-get(figs(ii),'Position');
		if resze == 1
			tmp(3) = cwidth+border(1);
			tmp(4) = rheight+border(1);
		else
			tmp(3) = min(tmp(3),cwidth+border(1)); 
			tmp(4) = min(tmp(4),rheight+border(1)); 
		end
	set(figs(ii),'OuterPosition',tmp);
	end
end

%% Redistribure Figures

kk=1;
for jj=1:sze(2) % step through grid
    for ii=1:sze(1)
        % get position and determine offset to center figure on grid
        if kk<=length(fh) && ~isnan(fh(kk))
            tmp = get(fh(kk),'OuterPosition');
			fwidth = tmp(3);
            fheight = tmp(4);
            coffset = (cwidth-fwidth)/2;
            roffset = (rheight-fheight)/2;
            % set position
            tmp(1) = (jj-1)*cwidth+coffset;
            tmp(2) = scrsze(4)-ii*rheight+roffset;
            set(fh(kk),'OuterPosition',tmp);
        end
        kk=kk+1;
    end
end
        
    


       