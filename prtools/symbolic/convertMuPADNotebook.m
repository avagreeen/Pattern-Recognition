function matlabFile = convertMuPADNotebook(notebook, outputfile)
%convertMuPADNotebook Convert a MuPAD notebook file to a MATLAB Live Script.
%    convertMuPADNotebook(notebook,targetfile) converts a MuPAD Notebook to
%    a MATLAB Live Script and saves it to the file targetfile. The function 
%    automatically adds the file extension '.mn' to notebook and '.mlx' to
%    outputfile if no file extension is specified in the file names. 
%    No other file extensions are accepted for these file names.
%
%    convertMuPADNotebook(notebook) converts a MuPAD Notebook to a MATLAB 
%    Live Script. For a notebook file '<path>.mn' it creates an output  
%    file '<path>.mlx'.
%
%    The function returns the absolute file name of the output file.
%
%    The function displays a side-effect message 
%
%        Created 'TestDoc.mlx'. For verifying the document, see help.
%
%    if the MuPAD notebook was converted successfully, or
%
%        Created 'TestDoc.mlx'. 13 translation errors, 1 warnings. 
%            For verifying the document, see help.
%
%    if the MuPAD nNtebook was converted, but MuPAD code to MATLAB code
%    translation failed for some code regions.
%    In both cases the word 'help' provides a link into the documentation
%    that explains the final manual verification process.
%
%    Examples:
%      >> newDocument = convertMuPADNotebook('TestDoc.mn', 'results/TestDoc.mlx');
%      Created 'TestDoc.mlx'. For verifying the document, see help.
%      >> edit(newDocument);
%
%      >> newDocument = convertMuPADNotebook('TestDoc.mn');
%      Created 'TestDoc.mlx'. For verifying the document, see help.
%      >> edit(newDocument);

%   Copyright 2015 The MathWorks, Inc.

narginchk(1,2);

% Is existing MuPAD Notebook with extension '.mn'?
try
    validateattributes(notebook, {'char'}, {'row'});
catch
    error(message('symbolic:convertMuPADNotebook:MustBeNotebookFileName'));
end
notebook = sym.pathToFullPath(notebook);
[path,name,ext] = fileparts(notebook);
if isempty(ext)
    ext = '.mn';
    notebook = [notebook ext];
end
if ~strcmpi(ext, '.mn') || exist(notebook, 'file') ~= 2
    error(message('symbolic:convertMuPADNotebook:MustBeNotebookFileName'));
end
if isempty(name) || name(end) == ' '
    error(message('symbolic:convertMuPADNotebook:InvalidNotebookFileName'));
end

if nargin == 2 
    % Use the given target file name for creating a new MATLAB Live Script.
    try
        validateattributes(outputfile, {'char'}, {'row'});
    catch
        error(message('symbolic:convertMuPADNotebook:MustBeTargetFileName'));
    end
    outputfile = sym.pathToFullPath(outputfile);
    [opath,oname,oext] = fileparts(outputfile);
    if isempty(oext)
        oext = '.mlx';
        outputfile = [outputfile oext];
    end
    if ~strcmp(oext, '.mlx') || exist(opath, 'dir') ~= 7
        error(message('symbolic:convertMuPADNotebook:MustBeTargetFileName'));
    end
    if isempty(oname) || oname(end) == ' '
        error(message('symbolic:convertMuPADNotebook:InvalidTargetFileName'));
    end
    matlabFile = outputfile;
else
    % For a MuPAD Notebook '<path>.mn' create a MATLAB Live Script '<path>.mlx'.
    matlabFile = [fullfile(path, name) '.mlx'];
    [~,oname,oext] = fileparts(matlabFile);
end

% Create a temporary folder for storing all temporary data.
tempFolder = tempname;
if ~mkdir(tempFolder)
    error(message('symbolic:convertMuPADNotebook:UnableToUnpackNotebook', notebook));
end
removeAllTempData = onCleanup(@() rmdir(tempFolder, 's'));

% Unpack MuPAD Notebook in the temporary folder.
notebookFolder = fullfile(tempFolder, name);
unzip(notebook, notebookFolder);
if exist(notebookFolder, 'dir') ~= 7
    error(message('symbolic:convertMuPADNotebook:UnableToUnpackNotebook', notebook));
end

% Read MuPAD Notebook XML files and convert to MATLAB file ('.m').
% All temporary files are created in the temporary folder. 
notebookMuPAD = [ '"' notebookFolder '.mn"'];
notebookMuPAD = strrep(notebookMuPAD, '\', '/'); 
tempFolderMuPAD = [ '"' tempFolder '"'];
tempFolderMuPAD = strrep(tempFolderMuPAD, '\', '/');
try
    mupadConversionStatus = feval(symengine, 'export::mn2m', notebookMuPAD, sym('TargetFolder') == evalin(symengine, tempFolderMuPAD), 'CopyImages', 'NoWarnings');
catch
    error(message('symbolic:convertMuPADNotebook:UnableToConvertToScript', notebook));
end
matlabScript = [notebookFolder '.m'];
if exist(matlabScript, 'file') ~= 2
    error(message('symbolic:convertMuPADNotebook:UnableToConvertToScript', notebook));
end

% Convert MATLAB file ('.m') to MATLAB Live Script ('.mlx').
try
    matlab.internal.richeditor.openAndSave(matlabScript, matlabFile);
catch
    error(message('symbolic:convertMuPADNotebook:UnableToConvertToLiveScript', notebook));
end
if exist(matlabFile, 'file') ~= 2
    error(message('symbolic:convertMuPADNotebook:UnableToConvertToLiveScript', notebook));
end

% Display report
if mupadConversionStatus(1) > 0 && mupadConversionStatus(2) > 0 
    report = message('symbolic:convertMuPADNotebook:ReportErrorsWarnings', ...
                ['<a href="matlab:edit(''' matlabFile ''')">' oname oext '</a>'], ...
                char(mupadConversionStatus(1)), ...
                char(mupadConversionStatus(2)) ...
             );
elseif mupadConversionStatus(1) > 0 
    report = message('symbolic:convertMuPADNotebook:ReportErrors', ...
                ['<a href="matlab:edit(''' matlabFile ''')">' oname oext '</a>'], ...
                char(mupadConversionStatus(1)) ...
             );
elseif mupadConversionStatus(2) > 0 
    report = message('symbolic:convertMuPADNotebook:ReportWarnings', ...
                ['<a href="matlab:edit(''' matlabFile ''')">' oname oext '</a>'], ...
                char(mupadConversionStatus(2)) ...
             );
else
    report = message('symbolic:convertMuPADNotebook:Report', ...
                ['<a href="matlab:edit(''' matlabFile ''')">' oname oext '</a>'] ...
             );
end
disp(getString(report));
end
