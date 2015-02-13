function varargout = createfig(varargin)
% handle = createfig(fignumber,'Property',Value,...)
%
% creates a figure with the following defaults set to make ceartion of
% multiple plots with the same settings more easy by setting all the
% defaults for the figure

optargin = size(varargin,2);
stdargin = mod(optargin,2);
optargin = optargin-stdargin;

%% Set figure defaults
%
%
SetFigure = {
    'Color','w',                           ...   
    'Units','centimeters',                 ...
    'PaperPositionMode','auto',            ...  % For print as apears on screen
};

%% Set axes defaults
%
%
ColorOrder4    = [ 0    0    0     ;...
                   0.5  0.5  0.5   ;...
                   0.25 0.25 0.25  ;...
                   0.75 0.75 0.75 ];
               
ColorOrder3    = [ 0    0    0     ;...
                   0.33 0.33 0.33  ;...
                   0.66 0.66 0.66 ];
ColorOrder = ColorOrder4;
               
DefaultAxes = {                     ... 
    'Color',           'none'      ,...       % transparant
    'LineStyleOrder',  '-'         ,...       % example '-|--|:|-'
    'ColorOrder',      ColorOrder4 ,...
    'FontName',        'times'     ,...
    'NextPlot',        'add'       ,...        % example 'add', 'replace'
    'XGrid',           'off'        ,...
    'YGrid',           'off'        ,...
    'ZGrid',           'off'         ...
    };


%% Set line defaults
%
%
DefaultLine = {                 ...
	'LineWidth',      1         ...
    };




%% Apply Settings

% create figure
%
%
if stdargin == 1
    if ishandle(varargin{1}); clf(varargin{1}); end % clear figure if exists
    H = figure(varargin{1});
elseif stdargin == 0
    H = figure;
else
    error(['Invalid input arguments, nargin = ' num2str(nargin) ', stdargin = ' num2str(stdargin)])
end

if nargout==1
    varargout = {H};
end


% apply default settings plus print settings
%
%
DefaultAxes(1:2:end) = strcat('defaultAxes',DefaultAxes(1:2:end));
DefaultLine(1:2:end) = strcat('defaultLine',DefaultLine(1:2:end));
set(H,SetFigure{:},DefaultAxes{:},DefaultLine{:});  % Default text results in errors with matlabfrag

% apply other settings
if optargin>0
    set(H,varargin{stdargin+1:end});
end
       