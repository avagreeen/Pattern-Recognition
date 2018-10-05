function symWriteSSC(newComponentName, templateComponentName, equations, varargin)
%symWriteSSC  Creates a new Simscape component
%   symWriteSSC(newComponentName, templateComponentName, equations)
%   creates a new Simscape component newComponentName using an existing template component
%   templateComponentName.
%   The new component is created by using all the decorations from the template component.
%   The given equations are added to the new component.
%
%   symWriteSSC(newComponentName, templateComponentName, equations, NAME1, VALUE1,...) uses
%   the specified name-value pairs for customizing the newly created component. 
%   The names can be any of the following:
%
%   'H1Header': The value must be a string given as a row vector of chars. If the string does
%               not start with a '%' character the '%' character is prepended.
%
%   'HelpText': The value must be a cell array of strings given as a row vector of chars. If a
%               string does not start with a '%' character the '%   ' character is prepended.
% 
%   So the new component is a copy of the template component with the new H1 header line
%   and the new help text if specified. Additionally the given equations are added
%   to the new component. 
%
%   See also symReadSSCParameters, symReadSSCVariables

%   Copyright 2015 The MathWorks, Inc.

narginchk(3,7);

% check the parameters 

% First the name-value pairs
args = varargin(1:end);
opts = getOptions(args);

% first the type checks
validateattributes(templateComponentName, {'char'}, {'row'});
validateattributes(newComponentName, {'char'}, {'row'});


% If H1Header is not a valid h1 header line add the missing '% '
if ~isempty(regexp(opts.H1Header,'^\s*(%{|%%)','ONCE')) || ~isempty(regexp(opts.H1Header,'^\s*[^%]','ONCE'))
    opts.H1Header = ['%' opts.H1Header];
end

%  Add '%   ' to the help text if it is not a valid help line
for i=1:length(opts.HelpText)
    if ~isempty(regexp(opts.HelpText{i},'^\s*(%{|%%)','ONCE')) || ~isempty(regexp(opts.HelpText{i},'^\s*[^%]','ONCE')) || isempty(opts.HelpText{i})
        opts.HelpText{i} = ['%   ' opts.HelpText{i}];
    end
end 

% Check if the template component exist
try
    templatePath = simscape.smt.internal.get_full_path(templateComponentName);
catch ME
    if isequal(ME.identifier,'MATLAB:undefinedVarOrClass')
        error(message('symbolic:symSSC:SimscapeRequired'));
    else
        rethrow(ME);
    end
end
[~,templateComponentName,~] =  fileparts(templatePath);

% If the .ssc suffix is missing append it to the new component name
[~,componentName,ext] =  fileparts(newComponentName);
componentFileName = newComponentName;
if isempty(ext)
    componentFileName = [componentFileName, '.ssc'];
else
    if ~strcmp(ext, '.ssc')
        error(message('symbolic:symSSC:InvalidComponentName', newComponentName)); 
    end
end
componentFileName = pathToFullPath(componentFileName);
if strcmp(pathToFullPath(templatePath), componentFileName)
    error(message('symbolic:symSSC:DifferentComponentNamesNeeded', componentName, templateComponentName));
end

% equations must be a vector of symbolic equations
validateattributes(equations, {'sym'}, {'vector'});
retValue = boolean(feval(symengine,'symobj::isListOfEquations', equations));
if retValue == 0
    error(message('symbolic:symSSC:VectorOfEquationsExpected'));
end

% Do some plausibilty checks about the variables and parameters used inside the equations.
% This will also check if the template component is valid
try
    [varNames, ~, ~]  = symReadSSCVariables(templateComponentName);
    [parNames, ~, ~]  = symReadSSCParameters(templateComponentName); 
catch ME
    if isequal(ME.identifier,'symbolic:symSSC:DomainsNotSupported')
        error(message('symbolic:symSSC:DomainsNotSupported'));
    else
        rethrow(ME);
    end
end

vEquations = symvar(equations);
% In every case 't' is allowed in the equations
vEquations = setdiff(vEquations, sym('t'));
notDeclared = setdiff(vEquations,union([varNames{:}],[parNames{:}]));
if ~isempty(notDeclared)
    for i=1:length(notDeclared) 
        warning(message('symbolic:symSSC:UndeclaredVariablesInEquation', char(notDeclared(i))));
    end
end

% Read the template component and put it in a cell array line by line
templateString = fileread(templatePath);
newLine = char(10);
linesOfTemplateString = textscan(templateString, '%s', 'WhiteSpace', '', 'Delimiter', newLine);
linesOfTemplateString = linesOfTemplateString{1};

componentLine  = findComponentLine(linesOfTemplateString);
if componentLine == 0 
    error(message('symbolic:symSSC:DomainsNotSupported'));
end
endOfComponent = findEndComponentLine(linesOfTemplateString, componentLine+1);
newComponentLine = getNewComponentLine(linesOfTemplateString, componentLine, componentName);

h1HeaderLine = findH1HeaderLine(linesOfTemplateString, componentLine+1);
if h1HeaderLine == 0 
    helpStart = 0;
    helpEnd   = 0;
else
    [helpStart, helpEnd] = findHelpText(linesOfTemplateString, h1HeaderLine+1);
end
[equationsStart, equationsEnd] = findEquations(linesOfTemplateString, componentLine+1, endOfComponent-1);

% Write the component
writeNewComponent(linesOfTemplateString, componentFileName, newComponentLine, opts.H1Header, opts.HelpText, equations, ...
                  componentLine, h1HeaderLine, helpStart, helpEnd, equationsStart, equationsEnd, endOfComponent) 
end

% helper functions
function line = skipBlockComments(linesOfTemplateString, startLine)
    numberOfCommentBlocks = 0;
    for i=startLine:length(linesOfTemplateString)
        found = regexp(linesOfTemplateString{i}, '^\s*%{\s*', 'once', 'start');
        if ~isempty(found)
            numberOfCommentBlocks = numberOfCommentBlocks+1;
            continue;
        end

        if numberOfCommentBlocks > 0
            found = regexp(linesOfTemplateString{i}, '^\s*%}\s*', 'once', 'start');
            if ~isempty(found)
                numberOfCommentBlocks = numberOfCommentBlocks-1;
            end
        else
            line = i;
            break;
        end      
    end
    if i == length(linesOfTemplateString) && numberOfCommentBlocks == 0 && ~isempty(found)
        line = 0;
    end
end

function componentLine = findComponentLine(linesOfTemplateString)
    componentLine = 0;

    k = 1 ;
    while k <= length(linesOfTemplateString)
        k = skipBlockComments(linesOfTemplateString, k);
        found = regexp(linesOfTemplateString{k}, '^\s*component[\s\(]', 'once', 'start');
        if ~isempty(found)
            componentLine=k;
            break;
        else
            k = k+1;
        end        
    end
end

function endLine = findEndComponentLine(linesOfTemplateString, startLine)
    endLine = 0;

    k = startLine;
    while k <= length(linesOfTemplateString)
        k = skipBlockComments(linesOfTemplateString, k);
        if k == 0 
            break;
        end
        found = regexp(linesOfTemplateString{k}, '^\s*end', 'once', 'start');
        if ~isempty(found)
            endLine=k;
        end
        k = k+1;     
    end
end

function newLine = getNewComponentLine(linesOfTemplateString, componentLine, componentName)
    pattern = '(?<start>\s*component(\s+)?)(?<name>\s[^\(\s%<]+|\(.*\)\s*[^%<\s]+)(?<rest>(.*)?)';
    res = regexp(linesOfTemplateString{componentLine}, pattern, 'names');
    startIndexName = regexp(res.name,'\S+$');
    newLine = [res.start res.name(1:startIndexName-1) componentName res.rest];
end

function h1HeaderLine = findH1HeaderLine(linesOfTemplateString, startLine)
    h1HeaderLine = 0;
    if startLine <= length(linesOfTemplateString)
        found = regexp(linesOfTemplateString{startLine}, '^\s*%([^%{])', 'once', 'start');
        if ~isempty(found)
            h1HeaderLine=startLine;
        end
    end
end

function [helpStart, helpEnd] = findHelpText(linesOfTemplateString, startLine)
    helpStart= 0;
    helpEnd  = 0;
    for i=startLine:length(linesOfTemplateString)
        % Search for the correct comment lines
        found = regexp(linesOfTemplateString{i}, '^\s*%([^%{])', 'once', 'start');
        if isempty(found)
            break;
        else
            if helpStart == 0 
                helpStart = i;
            end
            helpEnd = i;
        end
    end
end

function [equationsStart, equationsEnd] = findEquations(linesOfTemplateString, startLine, endLine)
    equationsStart = 0;
    equationsEnd   = 0;

    k = startLine ;
    % Get the start line
    while k <= length(linesOfTemplateString)
        k = skipBlockComments(linesOfTemplateString, k);
        if k == 0 
            break;
        end
        found = regexp(linesOfTemplateString{k}, '^\s*equations', 'once', 'start');
        if ~isempty(found)
            equationsStart=k;
            break;
        else
            k = k+1;
        end        
    end

    if equationsStart ~= 0
        % Get the end line
        while k <= endLine
            k = skipBlockComments(linesOfTemplateString, k);
            found = regexp(linesOfTemplateString{k}, '^\s*end', 'once', 'start');
            if ~isempty(found)
                equationsEnd=k;
            end        
            k = k+1;
        end
    end
end

% Write the new component to a file
function writeNewComponent(linesOfTemplateString, componentFileName, newComponentLine, h1Header, helpText, equations, ...
                           componentLine, h1HeaderLine, helpStart, helpEnd, equationsStart, equationsEnd, endOfComponent)
    [fid, message] = fopen(componentFileName, 'wt');
    if fid == -1 
        error(message);
    end
    try
        for i=1:componentLine-1
            fprintf(fid, '%s\n', linesOfTemplateString{i});
        end
        fprintf(fid, '%s\n', newComponentLine);        

        if isempty(h1Header) 
            if h1HeaderLine ~= 0
                % Write the existing one
                fprintf(fid, '%s\n', linesOfTemplateString{h1HeaderLine});
            end
        else
            % Write the new H1 header
            fprintf(fid, '%s\n', h1Header);
        end

        if isempty(helpText) 
            if helpStart ~= 0
                % Write the exiting help text
                for i=helpStart:helpEnd
                    fprintf(fid, '%s\n', linesOfTemplateString{i});
                end    
            end
        else
            % Write the new help text
            for i=1:length(helpText)
                fprintf(fid, '%s\n', helpText{i});
            end    
        end

        % Skip the help part from the template
        if helpStart == 0
            if h1HeaderLine ~= 0
                helpEnd = h1HeaderLine;
            else
                helpEnd = componentLine;
            end
        end

        if equationsStart == 0
            for i=helpEnd+1:endOfComponent-1
                fprintf(fid, '%s\n', linesOfTemplateString{i});
            end
            fprintf(fid, '  equations\n');
        else
            for i=helpEnd+1:equationsEnd-1
                fprintf(fid, '%s\n', linesOfTemplateString{i});
            end
        end


        % Insert the new equations before the end
        for elem = equations
            childs = children(elem);
            simElem = simscapeEquation(childs(1), childs(2));
            fprintf(fid, '%s\n', ['    ' simElem]);
        end
        if equationsStart == 0 
            fprintf(fid, '  end\n');
            % Write the rest of the file
            for i=endOfComponent:length(linesOfTemplateString)
                fprintf(fid, '%s\n', linesOfTemplateString{i});
            end
        else
            % Write the rest of the file
            for i=equationsEnd:length(linesOfTemplateString)
                fprintf(fid, '%s\n', linesOfTemplateString{i});
            end
        end
        fclose(fid);
    catch ME
        fclose(fid);
        rethrow(ME);
    end
end

% parse inputs and return options structure output using the input parser
function opts = getOptions(args)
    ip = inputParser;
    ip.addParameter('H1Header','',@isValidH1Header);
    ip.addParameter('HelpText',{},@isValidHelptext);
    ip.parse(args{:});
    opts = ip.Results;
    % 'H1Header' was set explicitly by the user
    if isempty(find(strcmp(ip.UsingDefaults, 'H1Header'),1))
        if isempty(opts.H1Header)
            opts.H1Header = '%';
        end
    end    
    % 'HelpText' was set explicitly by the user
    if isempty(find(strcmp(ip.UsingDefaults, 'HelpText'),1))
        if isempty(opts.HelpText)
            opts.HelpText = {'%'};
        end
    end  
end

function result = isValidH1Header(h1Header)
    % empty string is allowed
    if ~(ischar(h1Header) && isempty(h1Header))
        validateattributes(h1Header, {'char'}, {'row'});
    end
    result = true;
end

function result = isValidHelptext(helpText) 
    %  help text should be a cell array of strings
    validateattributes(helpText, {'cell'}, {});
    if ~isempty(helpText)
        validateattributes(helpText, {'cell'}, {'vector'});
        for i=1:length(helpText)
            % empty strings are allowed
            if ~(ischar(helpText{i}) && isempty(helpText{i}))
                validateattributes(helpText{i}, {'char'}, {'row'});
            end
        end 
    end
    result = true;
end

function fullPath = pathToFullPath(file)
    validateattributes(file, {'char'}, {'row'});
    if java.io.File.isAbsolute(java.io.File(file))
        fullPath = file;
    else
        fullPath = fullfile(pwd,file) ;
    end
    fullPath = char(java.io.File.getCanonicalPath(java.io.File(fullPath)));
end 
