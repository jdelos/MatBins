% matlabfragPDF.m
% Version 0.41 (15-03-2013)
%
% MatlabfragPDF can be used to convert Matlab figures directly to PDF 
% images using LaTeX and a customisable LaTeX preamble. The matlabfrag
% function by Zebb Prime 
% (http://www.mathworks.nl/matlabcentral/fileexchange/21286-matlabfrag) is 
% used to this end. matlabfragPDF accepts a custom .tex header file or uses
% a default LaTeX header. The default header can be found in the
% matlabfragPDF directory (mfragPDFheader.tex).
%
% MatlabfragPDF requires matlabfrag to run. It is advisable to add both the
% matlabfrag and matlabfragPDF directories to the matlab path.
%
% Usage: matlabfragPDF(FileName, Header, OPTIONS)
% FileName - Output filename
% Header   - Latex header file. If left empty, the mfragPDFheader.tex file
%            in the matlabfragPDF folder is used, provided that the folder
%            is in the matlab path. If a mfragPDFheader.tex is present in
%            the current folder, that is used instead.
% OPTIONS  - matlabfrag options. See the matlabfrag help for more
%            information
%
% A Matlab function by TheBruceDickinson productions
% File written and Copyright (c) June 2012 by M.G.L. Roes
% e-mail: m.g.l.roes@tue.nl

function matlabfragPDF(FileName, varargin)
    %% Initialise

    % Remove .pdf at end of FileName, if necessary
    [OutputDir, FileName, ~] = fileparts(FileName);
    
    % Set the output directory
    CurDir = pwd; % Store the current path
    
    % Set the absolute path to the output directory
    if ~isempty(OutputDir)
        eval(['cd ''', OutputDir, '''']); % Go to the specified path
        OutputDir = pwd; % Get the absolute path
        eval(['cd ''', CurDir, '''']); % Go back to the current directory
    else
        OutputDir = CurDir;
    end

    % Create a FileName string without spaces
    FileName_ = strrep(FileName, ' ', '_');
    
    tempdir = ['mfragPDFtemp_', FileName_];
    
    % Choose which LaTeX header to use
    if isempty(varargin)
        HeaderFile = which('mfragPDFheader.tex');
    elseif isempty(varargin{1})
        HeaderFile = which('mfragPDFheader.tex');
    else
        HeaderFile = varargin{1};
        
        % Check whether the specified header file exists
        if ~exist(HeaderFile, 'file')
            error(['Specified header file ', HeaderFile, ...
                ' does not exist']);
        end
    end
    
    % Get the absolute path to the header file
    [HeaderPath, HeaderName, HeaderExt] = fileparts(HeaderFile); % separate the path + filename
    
    if ~isempty(HeaderPath)
        eval(['cd ''', HeaderPath, '''']); % Go to the specified path
        HeaderPath = pwd; % Get the absolute path
    else
        HeaderPath = CurDir;
    end

    HeaderFile = fullfile(HeaderPath, [HeaderName, HeaderExt]); % Construct the full path to the header file
    
    % If the temporary files directory does not exist, create one
    if ~exist(tempdir, 'dir')
        if ~exist(tempdir, 'file')
            eval(['mkdir ', tempdir, '']);
        else
            error(['Temporary folder could not be created, a file named ', ...
                tempdir, ' already exists'])
        end
    end
    
    %% Run MatlabFrag
    if isempty(varargin(2:end))
        matlabfrag('matlabfragtmp');
    else
        matlabfrag('matlabfragtmp', varargin{2:end});
    end
    if (~exist('matlabfragtmp.eps', 'file'))
        error(['No MatlabFrag output (matlabfragtmp.tex and/or matlabfragtmp.eps) found']);
    end
    
    % If there is no text present in the figure, Matlabfrag does not create
    % the matlabfragtmp.tex file. In this case an empty file should be
    % created.
    if (~exist('matlabfragtmp.tex', 'file'))
        fid = fopen('matlabfragtmp.tex', 'w+');
        fclose(fid);
    end
    
    %% Prepare the .tex file for LaTeX
    % Create a .tex file from the header
    copyfile(HeaderFile, [FileName_, '.tex']);
    
    % Text to append to the header file
    texstr = ['\n\n', ...
     '\\begin{document}%%\n', ...
     '\\pagestyle{empty}%%\n', ...
     '\\input{matlabfragtmp.tex}%%\n', ...
     '\\includegraphics{matlabfragtmp.eps}%%\n%%\n', ...
     '\\end{document}'];
    
    % Open the header file
    fid = fopen([FileName_, '.tex'], 'r+');
    
    % Move to EOF
    fseek(fid, 0, 'eof');
    
    % Append text
    fprintf(fid, texstr);
    
    % Close the file
    fclose(fid);
    
    %% PDFify the figure
    % Run latex
    system(['latex -quiet -interaction=nonstopmode -output-directory=', ...
        tempdir, ' ', FileName_, '.tex']);

    % Move the necessary files to the temporary directory
    movefile('matlabfragtmp.eps', tempdir);
    movefile('matlabfragtmp.tex', tempdir);
    movefile([FileName_, '.tex'], tempdir);

    % Run dvips and ps2pdf from the temporary directory
    % Letting 'system' write status and result variables suppresses output
    % in the command window.
    eval(['cd ''', tempdir, '''']);
    [~, ~] = system(['dvips ', FileName_, '.dvi']);
    [~, ~] = system(['ps2pdf ', FileName_, '.ps ', ...
        FileName_, '.pdf']);

    
    %% Clean up
    % Copy the PDF output to the desired output directory
    copyfile([FileName_, '.pdf'], fullfile(OutputDir, [FileName, '.pdf']));

    % Try to remove the temporary directory, and display a warning if
    % unsuccesful
    cd('..');
    try
        try
			rmdir(tempdir, 's');
		catch exception
			pause(2);rmdir(tempdir, 's'); % second try to prevent errors with dropbox
		end
    catch exception
        warning('Temporary folder could not be removed. Please check the generated PDF file.')
    end
    
    % Go back to the working directory
    eval(['cd ''', CurDir, '''']);
    rehash path;
end