% fig2pdf.m
% Version 0.1 (08-01-2013)
% Version 0.2 (11-01-2013) added sorting of the figure handles for empty H.
% Version 0.3 (12-01-2013) fixed handle check for multiple handles
% Version 0.4 (23-07-2013) updated the help text
%
% This function saves multiple matlab figures to a single PDF file using
% the LaTeX functionality of matlabfragPDF and the PDF merge features of
% pdftk. Pdftk is an opensourse PDF commandline toolbox, which can be
% downloaded from http://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/. The
% folder of the pdftk executable should be in the system path.
%
% Usage: fig2pdf(H, FileName, Header, OPTIONS)
%
% H        - A vector of figure handles, if empty all figure handles are 
%			 used sorted ascending.
% FileName - Output filename
% Header   - Latex header file. If left empty '[]', the mfragPDFheader.tex 
%			 file in the matlabfragPDF folder is used, provided that the 
%			 folder is in the matlab path. If a mfragPDFheader.tex is 
%			 present in the current folder, that one is used instead.
% OPTIONS  - matlabfrag options (excluding Handle). See the matlabfrag help
%	    	 for more information. and an additional property value pair 
%            'pdftk','commandline option string' to controll pdftk, which 
%			 default executes without options
%
% This function requires matlabfragPDF (a matlabfrag wrapper by
% TheBruceDickinson productions), matlabfrag (which can be found on Matlab
% central), LaTeX, and pdftk (a free commandline pdf utility).
% 
% A Matlab function by TheBruceDickinson productions
% File written and Copyright (c) January 2013 by J.M. Schellekens
% e-mail: j.m.schellekens@tue.nl

function fig2pdf(H, FileName, Header, varargin)

%% Check for dependencies
if isempty(which('matlabfragPDF'))
	error('This function requires matlabfragPDF, by TBDP and matlabfrag')
end
[status,~] = system('pdftk');
if status==1
	error('pdftk is not installed or not in the system path')
end

%% Check input

% check for handles and if empty or 
if isempty(H) || ~all(ishandle(H))
	H = sort(findobj(0, '-depth', 1,'Type','Figure'));
end
% is there a filename?
if ~ischar(FileName) || isempty(FileName)
	error('the output filename should be a character string')
end
if any(strcmpi(varargin,'handle'))
	error('handle as matlabfrag option is not allowed! use input H instead')
end


% find pdftk options
if any(strcmpi(varargin,'pdftk'))
	pdftkin	= varargin{find(strcmpi(varargin,'pdftk'),1,'last')+1};
	% add a space at the end if it is missing	
	if ~strcmpi(pdftkin(end),' '); pdftkin = [pdftkin ' ']; end
	tmp		= strcmpi(varargin,'pdftk');
	tmp		= ~(tmp | [0 tmp(1:end-1)]); % the not pdftk options
	mfragin	= varargin(tmp); 
else
	pdftkin = '';
	mfragin	= varargin;
end



%% Create PDFs using matlabfragPDF
TmpFileName = 'fig2pdftmpfile';

for ii=1:length(H)
	matlabfragPDF([TmpFileName num2str(ii) '.pdf'],Header,mfragin{:},'Handle',H(ii));
end

%% merge PDFs

pdffiles = '';
for ii=1:length(H)
	pdffiles = [pdffiles TmpFileName num2str(ii) '.pdf '];
end

[OutputDir, FileName, ~] = fileparts(FileName);

[status,result] = system(['pdftk ' pdftkin pdffiles ...
				'output ' fullfile(OutputDir,[FileName '.pdf'])]);
			

%% Clean up
tempfiles = dir([TmpFileName '*.pdf']); 

delete(tempfiles.name);




