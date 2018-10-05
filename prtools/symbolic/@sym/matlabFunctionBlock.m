function matlabFunctionBlock(block,varargin)
%matlabFunctionBlock Generate MATLAB Function block
%   matlabFunctionBlock(BLOCK,F) generates a 'MATLAB Function' block
%   with path BLOCK and sets the block definition to the MATLAB
%   code generated from F using matlabFunction. If BLOCK exists
%   it must be a MATLAB Function block and the existing block definition is
%   replaced with F.
%
%   matlabFunctionBlock(BLOCK,F1,F2,...,FN) generates a block with N outputs F1 
%   through FN. The inputs and outputs of the block are the same as the
%   inputs and outputs of the MATLAB function in the block definition.
%
%   matlabFunctionBlock(...,PARAM1,VALUE1,...) uses the specified parameter/value
%   pairs to change the generated block. The parameters customize the
%   function declaration that appears in the generated code. The template 
%   for the generated code is
%       function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   The parameter names can be any of the following
%
%   'FunctionName': the value, NAME, must be a string. The default is the name
%             of the block BLOCK.
%
%   'Outputs': The value must be a cell array of N strings specifying the output
%              variable names OUT1, OUT2,... OUTN in the function template.  The
%              default output variable name for OUTk is the variable name of Fk,
%              or 'outk' if Fk is not a simple variable.
%
%   With one exception matlabFunctionBlock accept all name-value pairs which are accepted
%   by matlabFunction. The exeption is the 'File' option. This option is not accepted 
%   by matlabFunctionBlock.
%
%   Note: not all MuPAD expressions can be converted to a MATLAB function.
%   For example sets will not be converted.
%
%   Example:
%      syms x y
%      f = x^2 + y^2;
%      new_system('mysys'); open_system('mysys');
%      matlabFunctionBlock('mysys/f',f);
%
%   See also: matlabFunction, simulink

%   Copyright 2008-2015 The MathWorks, Inc.

narginchk(2,inf);

% process inputs
N = getSyms(varargin);
funs = varargin(1:N);
funs = cellfun(@(f)sym(f),funs,'UniformOutput',false);
args = varargin(N+1:end);
funnames = cell(1,N);
for k = 1:N
    funnames{k} = inputname(1+k);
end
[opts, argsToForward] = getOptions(args,funnames);

if isempty(ver('Simulink'))
    error(message('symbolic:sym:matlabFunctionBlock:SimulinkRequired'));
end

b = getBlock(block);
tempfile_no_extension = tempname;
[~,fname] = fileparts(tempfile_no_extension);
file = [tempfile_no_extension '.m'];
funcname = opts.FunctionName;
if isempty(funcname)
    funcname = b.Name;
end
opts = rmfield(opts,'FunctionName');
matlabFunction(funs{:},opts,argsToForward,'File',file);
tmp = onCleanup(@()delete(file));
fid = fopen(file,'rt');
if fid > 0
    tmp2 = onCleanup(@()fclose(fid));
    contents = getContents(fid, fname, funcname);
    clear tmp2; % close file
    b.Script = contents;
else
    error(message('symbolic:sym:matlabFunctionBlock:FileOpen', file));
end

% find the index separating the functions from the option/value pairs
% return the last index of the functions, or 0 if none
function N = getSyms(args)
chars = cellfun(@ischar,args);
N = find(chars,1,'first');
if isempty(N)
    N = length(args);
else
    N = N-1;
end

% validator for 'FunctionName' parameter
function t = isFunc(x)
[~,file] = fileparts(x);
t = isvarname(file);

% parse inputs and return option structure output
function [opts, argsToForward] = getOptions(args,funnames)
ip = inputParser;
ip.addParameter('FunctionName','',@isFunc);
ip.addParameter('Outputs',{},@iscellstr);
ip.addParameter('File','');      %We want to disallow this so we catch it separately
ip.addParameter('Sparse',false); %We want to disallow this so we catch it separately
ip.KeepUnmatched = true;

ip.parse(args{:});
if ~ismember('File',ip.UsingDefaults)
    error(message('symbolic:sym:matlabFunctionBlock:InvalidOptionFile'));
end
if ~ismember('Sparse',ip.UsingDefaults)
    error(message('symbolic:sym:matlabFunctionBlock:InvalidOptionSparse'));
end
opts = ip.Results;
argsToForward = ip.Unmatched;
if isempty(opts.Outputs)
    outputs = funnames;
    for k = 1:length(outputs)
        if isempty(outputs{k})
            outputs{k} = sprintf('out%d',k);
        end
    end
    opts.Outputs = outputs;
end

% find or create block
function b = getBlock(block)
r = slroot;
b = r.find('-isa','Stateflow.EMChart','path',block);
if isempty(b)
    load_system('simulink');
    add_block('simulink/User-Defined Functions/MATLAB Function',block);
    b = r.find('-isa','Stateflow.EMChart','path',block);
    if isempty(b)
        error(message('symbolic:sym:matlabFunctionBlock:CouldNotCreate', block));
    end
end
if size(b) > 1
    error(message('symbolic:sym:matlabFunctionBlock:AmbiguousBlock', block));
end
if ~isa(b,'Stateflow.EMChart')
    error(message('symbolic:sym:matlabFunctionBlock:InvalidBlock', block));
end

% get the contents of the generated file and format for MATLAB Function content
function contents = getContents(fid, fname, funcname)
s = fgets(fid);
contents = [sprintf('%s%s\n', strrep(s,fname,funcname),'%#codegen') skipComments(fid)];
s = fread(fid,'*char');
contents = [contents s.'];

function s = skipComments(fid)
s = fgets(fid);
while ischar(s) && ~isempty(s) && s(1) == '%'
    s = fgets(fid);
end
