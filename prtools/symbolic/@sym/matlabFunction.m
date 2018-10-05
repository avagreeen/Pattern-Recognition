function g = matlabFunction(f,varargin)
%matlabFunction Generate a MATLAB file or anonymous function from a sym
%   G = matlabFunction(F) generates a MATLAB anonymous function from sym object
%   F. The free variables of F become the inputs for the resulting function
%   handle G. For example, if x is the free variable of F then G(z) computes in
%   MATLAB what subs(F,x,z) computes in the symbolic engine. The function handle
%   G can be used by functions in MATLAB like FZERO or by functions in other
%   toolboxes. The order of the inputs of G matches the order returned by
%   symvar(F).
%
%   G = matlabFunction(F1,F2,...,FN) generates a MATLAB function
%   with N outputs F1 through FN.
%
%   G = matlabFunction(...,PARAM1,VALUE1,...) uses the specified parameter/value
%   pairs to customize the generated function. The parameters modify the
%   declaration that appears in the generated code. The template for the
%   generated code is
%      function [OUT1, OUT2,..., OUTN] = NAME(IN1, IN2, ... INM)
%   The parameter names can be any of the following
%
%     'File': The value, FILE, must be a string with a valid MATLAB function
%             name. If FILE does not end in '.m' it will be appended. If the
%             file already exists it will be overwritten.  A function handle to
%             the function will be returned in G. If the file name parameter is
%             empty an anonymous function is generated. The NAME in the function
%             template is the file name in FILE.
%
%  'Outputs': The value must be a cell array of N strings specifying the output
%             variable names OUT1, OUT2,... OUTN in the function template.  The
%             default output variable name for OUTk is the variable name of Fk,
%             or 'outk' if Fk is not a simple variable. If the 'File' parameter
%             is not given then the 'Outputs' parameter is ignored.
%
%     'Vars': The value, IN, must be either
%                1) a cell array of M strings or sym arrays, or
%                2) a vector of M symbolic variables.
%             IN specifies the input variable names and their order IN1,
%             IN2,... INM in the function template. If INj is a sym array then
%             the name used in the function template is 'inj'.  The variables
%             listed in IN must be a superset of the free variables in all the
%             Fk. The default value for IN is the union of the free variables in
%             all the Fk.
%
% 'Optimize': The value must be true or false. The internal default value is true.
%             If 'Optimize' is true and used in combination with 'File',
%             then a file with optimized code is generated. Otherwise,
%             if 'Optimize' is set to false the code is not optimized.
%             If 'Optimize' is explictly set to true and a function handle 
%             should be generated then an error is thrown.
%             So explictly setting 'Optimize' to true is only allowed in
%             combination with a non empty 'File'.
%
% 'Sparse'  : The value must be true or false. The internal default value is false.
%             If 'Sparse' is true then matlabFunction() generates a function which
%             convert symbolic matrices to numeric sparse matrices. 
%             Otherwise symbolic matrices are converted to numeric dense matrices
%             which is the default.
%
%   Note: not all MuPAD expressions can be converted to a MATLAB function.
%   For example sets will not be converted.
%
%   Examples:
%     syms x y
%     r = x^2+y^2;
%     f = log(r)+1/r;
%     matlabFunction(f,'File','sample')
%     type sample.m
%       function f = sample(x,y)
%       %SAMPLE
%       %    F = SAMPLE(X,Y)
%       t7 = x.^2;
%       t8 = y.^2;
%       t9 = t7 + t8;
%       f = log(t9)+1./t9;
%
%     % create a sym expression for the Van der Pol ODE and use ode45
%     % to solve and then plot the solution for particular initial conditions.
%     syms t x y
%     mu = 1;
%     vdp = [y; mu*(1-x^2)*y-x];
%     % the generated function will have two inputs and the rows of the second
%     % input will be mapped to the x and y variables. The ode45 function
%     % expects the input function to have this form.
%     vdpf = matlabFunction(vdp,'Vars',{t,[x;y]});
%     % vdpf is @(t,in2)[in2(2,:);-in2(1,:)-in2(2,:).*(in2(1,:).^2-1)]
%     % now pass the function handle to ode45 with initial conditions [2 0]
%     % and plot the result
%     [ts,ys] = ode45(vdpf,[0 20],[2 0]);
%     plot(ts,ys(:,1))
%
%     % create a sym expression for the Van der Pol ODE using symbolic mu and
%     % generate a MATLAB file named 'vdp2' from it
%     syms mu x y
%     vdp = [y; mu*(1-x^2)*y-x];
%     % generate the file vdp2.m with inputs x, y and mu and output
%     % variable named dvdt.
%     matlabFunction(vdp,'File','vdp2','Vars',[x y mu],'Outputs',{'dvdt'});
%     type vdp2
%       function dvdt = vdp2(x,y,mu)
%       %VDP2
%       %    DVDT = VDP2(X,Y,MU)
%       dvdt = [y;- x - mu.*y.*(x.^2 - 1)];
%
%     % create a file with optimized code.
%     syms x 
%     r = x^2 * (x^2+1);
%     matlabFunction(r,'File','sample');
%     % Note: The call is synonymous with 
%     % matlabFunction(r,'File','sample','Optimize',true);
%     type sample.m
%       function r = sample(x)
%       %SAMPLE
%       %    R = SAMPLE(X)
%       t2 = x.^2;
%       r = t2.*(t2+1.0);
%
%     % Create a file with non-optimized code.
%     syms x 
%     r = x^2 * (x^2+1);
%     matlabFunction(r,'File','sample','Optimize',false);
%     type sample.m
%       function r = sample(x)
%       %SAMPLE
%       %    R = SAMPLE(X)
%       r = x.^2.*(x.^2+1.0);
%
%     % Create a function which will return numeric sparse matrices
%     syms x
%     A = diag(x*ones(1,5))
%     matlabFunction(A^2,'File','sample','Sparse',true);
%     type sample.m
%       function out1 = sample(x)
%       %SAMPLE
%       %    OUT1 = SAMPLE(X)
%       t2 = x.^2;
%       out1 = sparse([1,2,3,4,5],[1,2,3,4,5],[t2,t2,t2,t2,t2],5,5);
%      
%
%   See also: function_handle, subs, fzero, ode45

%   Copyright 2008-2015 The MathWorks, Inc.

narginchk(1,inf);

% process inputs
N = getSyms(varargin);
funs = {f, varargin{1:N}};
funs = cellfun(@(f)sym(f),funs,'UniformOutput',false);
args = varargin(N+1:end);
opts = getOptions(args);

% compute non-trivial defaults and verify inputs
funvars = getFunVars(funs);
vars = checkVars(funvars,opts);
inputs = getInputs(vars);
if length(unique(sort(inputs))) ~= length(inputs)
    error(message('symbolic:sym:matlabFunction:RepeatedVarName', format(inputs)));
end
funnames = cell(1,N+1);
for k = 1:N+1
    funnames{k} = inputname(k);
end
outputs = getOutputs(funnames,opts);
varnames = format(inputs);

% generate anonymous function or file
if ~isempty(opts.File)
    if ~isempty(opts.Outputs) 
        if length(unique(sort(outputs))) ~= N+1
            error(message('symbolic:sym:matlabFunction:IncorrectNumberOfOutputVars', N+1));
        end
        if any(ismember(outputs,inputs))
            error(message('symbolic:sym:matlabFunction:InvalidOutputNames'));
        end
    end
    file = normalize(opts.File,'.m');
    body = renameFileInputs(vars,inputs,funvars);
    clear(char(file)); % necessary to avoid problems in for-loops
    g = writeMATLAB(funs,file,varnames,outputs,body, opts.Optimize, opts.Sparse);
    tmp = exist(char(file),'file'); %#ok
                                    % necessary to make the function available
                                    % on the PATH right away
else
    body = mup2matcell(funs, opts.Sparse);
    body = renameInputs(body,vars,inputs);
    g = symengine('makeFhandle',varnames,body);
end

% find the index separating the functions from the option/value pairs
% return the last index of the functions, or 0 if none
function N = getSyms(args)
chars = cellfun(@ischar,args) | cellfun(@isstruct,args);
N = find(chars,1,'first');
if isempty(N)
    N = length(args);
else
    N = N-1;
end

% compute the default value for 'Vars'.
% returns the sorted union of the symvars of the funs
function funvars = getFunVars(funs)
vars = cellfun(@(x)symvar(x),funs,'UniformOutput',false);
vars = unique([vars{:}]);
funparams = cellfun(@(x)argnames(x),funs,'UniformOutput',false);
funvars = unique([funparams{:}, vars], 'stable');

% get the 'Vars' value and check it for errors
function v = checkVars(funvars,opts)
if isempty(opts.Vars)
    v = funvars;
else
    v = opts.Vars;
end

[v,vexpanded] = var2cell(v);
if ~isempty(vexpanded)
    if ~iscellstr(vexpanded)
        error(message('symbolic:sym:matlabFunction:InvalidVars'));
    elseif ~all(cellfun(@(x)isvarname(x),vexpanded))
        error(message('symbolic:sym:matlabFunction:InvalidVarName'));
    end
end
checkVarsSubset(vexpanded,funvars);

% check that the funvars are a subset of the expanded vars.
function checkVarsSubset(vexpanded,funvars)
vars = var2cell(funvars);
missing = cellfun(@(x)~any(strcmp(char(x),vexpanded)),vars);
if any(missing)
    misvars = vars(missing);
    varnames = format(misvars);
    if length(misvars) > 1
        error(message('symbolic:sym:matlabFunction:FreeVariables', varnames));
    end    
    error(message('symbolic:sym:matlabFunction:FreeVariable', varnames));
end

% convert a string or sym array into a 1-by-N cell array of strings
% also optionally return the cellstr of expanded sym array vars joined together
function [v,vexpand] = var2cell(v)
if isa(v,'sym')
    v = privsubsref(v,':');
    v = num2cell(v.');
    v = cellfun(@(x)char(x),v,'UniformOutput',false);
elseif ischar(v)
    v = {v};
end
if nargout > 1
    vexpand = cellfun(@var2cell,v,'UniformOutput',false);
    vexpand = [vexpand{:}];
end

% get the input names for the function
function inputs = getInputs(v)
inputs = cell(size(v));
for k = 1:length(v)
    if isa(v{k},'sym') && ~isscalar(v{k})
        inputs{k} = sprintf('in%d',k);
    else
        inputs{k} = char(v{k});
    end
end

% get the output names for the function
function outputs = getOutputs(funnames,opts)
if isempty(opts.Outputs)
    outputs = funnames;
    for k = 1:length(outputs)
        if isempty(outputs{k})
            outputs{k} = sprintf('out%d',k);
        end
    end
else
    outputs = opts.Outputs;
end


% Rename the variables (and sym array variables) in 'Vars' to be 'inputs'.
% A sym array variable gets replaced with an indexed variable from inputs.
% Other variables are simply renamed to the corresponding inputs name.
% 'body' is a string with the body of the anonymous function to create
% that gets modified to contain the renamed variables.
% assumes length(inputs) == length(vars)
function body = renameInputs(body,vars,inputs)
for k=1:length(inputs)
    body = replaceOneInput(body,vars{k},inputs{k});
end

% Rename the variables (and sym array variables) in 'Vars' to be 'inputs'.
% A sym array variable gets replaced with an indexed variable from inputs.
% Other variables are simply renamed to the corresponding inputs name.
% 'funvars' is the list of scalar symbolic variables to rename. The output
% 'mapping' is a string of MATLAB code to perform the renaming. It is
% empty if no renaming is needed.
% assumes length(inputs) == length(vars)
function mapping = renameFileInputs(vars,inputs,funvars)
body = format(funvars);
if isempty(body)
    mapping = '';
    return;
end
body(body==',') = '#'; % use # as a separator
for k=1:length(inputs)
    body = replaceOneInput(body,vars{k},inputs{k});
end
% now form 'x = A;\n y = B;\n' ...
rhs = regexp(body,'#','split');
cfunvars = num2cell(funvars);
lhs = cellfun(@(x)char(x),cfunvars,'UniformOutput',false);
same = strcmp(lhs,rhs);
rhs(same) = [];
lhs(same) = [];
eq = repmat({' = '},size(rhs));
eol = repmat({';\n'},size(rhs));
mapping = [lhs;eq;rhs;eol];
mapping = [mapping{:}];

% possibly replace 'var' with 'input' in 'body'. If 'var' is a sym array
% then replace the names in 'var' with indexed expressions using 'input'
function body = replaceOneInput(body,var,input)
if isa(var,'sym') && ~isscalar(var)
    % array sym replacement.
    if isvector(var)
        % vectorize the indexing along orthogonal direction of var
        format = getFormat(var);
        body = replaceArrayInput(body,var,input,format);
    else
        % use scalar indexing
        body = replaceArrayInput(body,var,input,'%s(%d)');
    end
end

% get the format to use for vectorized indexing expression from var.
function format = getFormat(var)
[m,n]=size(var); %#ok
if m == 1
    % row vector so vectorize along columns
    format = '%s(:,%d)';
else
    % column vector so vectorize along rows
    format = '%s(%d,:)';
end

% replace 'var' names with indexed strings into 'input' according to
% the specified sprintf 'format'.
function body = replaceArrayInput(body,var,input,format)
N = numel(var);
v = mupadmex('symobj::flattenSymOrder',var.s);
for k = 1:N
    index = sprintf(format,input,k);
    vk = mupadmex(sprintf('op(%s,%d)',v.s,k),0);
    body = replaceIdentifier(body,vk,index);
end

% replace full identifier instances of id with rep in body.
function body = replaceIdentifier(body,id,rep)
word_id = ['\<' id '\>'];
body = regexprep(body,word_id,rep);

% Removes the last char from an expr if it is the statement
% delimiter ';'
function result = stripLastChar(expr)
if expr(end) == ';' 
    result = expr(1:end-1);
else
    result = expr;
end

% Convert cell array of sym expressions to body of an anon fun
function r = mup2matcell(c,sparseMat)
if isscalar(c)
    r = mup2mat(c{1},true,sparseMat);
else
    anonymousArgs = num2cell(true(1,length(c)));
    if sparseMat
        sparseArgs = num2cell(true(1,length(c)));
    else
        sparseArgs = num2cell(false(1,length(c)));
    end
    c = cellfun(@mup2mat,c,anonymousArgs,sparseArgs,'UniformOutput',false);
    c = cellfun(@stripLastChar,c,'UniformOutput',false);
    r = sprintf('%s,',c{:});
    r = ['deal(' r(1:end-1) ')'];
end

function res = mup2mat(r,anonymous,sparseMat)
% MUP2MAT Mupad to MATLAB string conversion.
%   MUP2MAT(r) converts the Mupad string r containing
%   matrix, vector, or array to a valid MATLAB string.
if anonymous 
    ano='TRUE';
else
    ano='FALSE';
end
if sparseMat 
    spa='TRUE';
else
    spa='FALSE';
end
res = mupadmex('symobj::generateMATLAB',r.s,ano,spa,0); 
res = vectorize(res(2:end-1)); % remove quotes

% file = normalizeFile(file,ext) append extension ext if file doesn't
% have one already.
function file = normalize(file,ext)
[~,~,x] = fileparts(file);
if isempty(x)
    file = [file ext];
end

% Horzcat sym array or cell array v with commas
function varnames = format(v)
if isempty(v)
    varnames = '';
else
    if ~iscell(v)
        v = num2cell(v);
    end
    varnames = cellfun(@(x)[char(x) ','],v,'UniformOutput',false);
    varnames = [varnames{:}];
    varnames(end) = [];
end

% Generate MATLAB. f is the expr to generate. file is file name.
% varnames is the formatted input variables
% outputs is the cell array of output names
% mapping is string with input to variable mapping
% optim is true or false
% sparseMat is true or false
function g = writeMATLAB(f,file,varnames,outputs,mapping,optim,sparseMat)
[fid,msg] = fopen(file,'wt');
if fid == -1
    error(message('symbolic:sym:matlabFunction:FileError', file, msg));
end
tmp = onCleanup(@()fclose(fid));
[f,tvalues,tnames] = optimize(f,optim);
[~,fname] = fileparts(file);
outnames = formatOutputs(outputs);
writeHeader(fid,fname,varnames,outnames);
if ~isempty(mapping)
    fprintf(fid,mapping);
end
if isscalar(outputs)
    writeBody(fid,tvalues,sparseMat);
    writeOutput(fid,outputs,f,1,sparseMat);
else
    writeMultiOutputBody(fid,outputs,f,tvalues,tnames,sparseMat);
end
g = str2func(fname);

function [f,tvalues,tnames] = optimize(f,optim)
if isscalar(f)
    % This will force scalars to use the same indexing logic as nonscalars.
    % It will be ignored when writing the output. see writeOutputs.
    f = [f {'0'}];
end

if optim
    % now ask MuPAD to optimize with intermediate temporary expressions
    [tvalues,f,tnames] = mupadmexnout('symobj::optimizeWithIntermediates',f{:});
else
    % We have to return the format which
    % mupadmexnout('symobj::optimizeWithIntermediates',f{:});
    % would return if it can't optimize f.
    tvalues = sym(zeros(1, 0)); 
    f = feval(symengine, 'DOM_LIST', f{:});
    tnames = sym(zeros(1, 0)); 
end
tnames = tocell(tnames);% list of temp variables in order of assignment

% write out the function declaration and help
function writeHeader(fid,fname,varnames,outnames)
symver = ver('symbolic');
if ~isempty(varnames)
    varnames = ['(' varnames ')'];
end
symver = symver(1);
fprintf(fid,'function %s = %s%s\n',outnames,fname,varnames);
fprintf(fid,'%%%s\n',upper(fname));
fprintf(fid,'%%    %s = %s%s\n\n',upper(outnames),upper(fname),upper(varnames));
fprintf(fid,'%%    This function was generated by the Symbolic Math Toolbox version %s.\n',symver.Version);
fprintf(fid,'%%    %s\n\n',datestr(now));

% write the body of the optimized code
% if indent is supplied prepend that number of spaces to the code
function writeBody(fid,f,sparseMat,indent)
fmt = '';
if nargin == 4
    fmt = repmat(' ',1,indent);
end
for k = 1:length(f)
    eqnk = privsubsref(f,k);
    body = mup2mat(eqnk,false,sparseMat);
    fprintf(fid,[fmt body]);
end

% get the string for the declaration and help from the cell array of names
function outnames = formatOutputs(outputs)
outnames = format(outputs);
if length(outputs)>1
    outnames = ['[' outnames ']'];
end

% write the assignments to the output variables
function writeOutput(fid,outputs,expr,N,sparseMat)
% expr looks something like
% array(1..1, 1..2, (1,1) = array(1..1, 1..2, (1,1) = sin(t5), (1,2) = cos(t)), (1,2) = cos(t5))
% which is an array of arrays (or scalars). each array element is an output.
% We need to deal the elements of expr to outputs
% Note if length(outputs) == 1 then expr has length 2 to keep indexing the
% same as in the array case. This is ok since we never index expr(2).
fmt = '';
if N > 1
    fmt = '    ';
end
y = mupadmex(['symobj::fixupVar("' outputs{N} '") = ' expr.s '[' num2str(N) ']']);
body = mup2mat(y,false,sparseMat);
body = [fmt body];
fprintf(fid,body);

% write the body of the optimized code involving multiple outputs
% Optimize the code so that if nargout is less than all the outputs
% the computation skips any intermediates that will be discarded.
% Well, actually some extra intermediates will be computed if
% those intermediates are interspersed between "earlier" computations.
function writeMultiOutputBody(fid,outputs,f,tvalues,tnames,sparseMat)
for k = 1:length(outputs)
    [inter,tvalues,tnames] = computeIntermediates(tvalues,f,k,tnames);
    writeOneOutputOfMultiOutputBody(fid,f,inter,outputs,k,sparseMat);
end

% write a single output of a multi-output body. The first output is
% written directly but others are wrapped inside nargout checks.
function writeOneOutputOfMultiOutputBody(fid,f,tvalues,outputs,N,sparseMat)
indent = 0;
if N > 1
    fprintf(fid,'if nargout > %d\n',N-1);
    indent = 4;
end
writeBody(fid,tvalues,sparseMat,indent);
writeOutput(fid,outputs,f,N,sparseMat);
if N > 1
    fprintf(fid,'end\n');
end

% extract from tvalues the intermediate computations that are required for
% computing fend(k). Returns the array of intermediates in the
% same order they appeared in f and return the arrays f and temps
% with those entries removed. (will be empty at k=end)
function [inter,tvalues,tnames] = computeIntermediates(tvalues,fend,k,tnames)
% find the largest index of the tNNN identifiers in fend(k)
inter = [];
fk = privsubsref(fend,k);
expr = char(fk);
if ~isempty(tvalues)
    reqs = unique(regexp(expr,'\<t[0-9]+\>','match'));
    if isempty(reqs), return, end
    inds = cellfun(@(x){find(strcmp(x,tnames),1,'last')},reqs);
    last = max([inds{:}]);
    if ~isempty(last)
        inter = privsubsref(tvalues,1:last);
        tvalues = privsubsref(tvalues,last+1:numel(tvalues));
        tnames = tnames(last+1:end);
    end
end

% validator for variable parameter
function t = isVars(x)
if iscell(x)
    if ~isvector(x) && ~isempty(x)
        error(message('symbolic:sym:matlabFunction:InvalidVars')); 
    end
    for k = 1:length(x)
        if ~(isa(x{k},'sym') || (ischar(x{k}) && isvector(x{k}))) || isa(x{k},'symfun')
            error(message('symbolic:sym:matlabFunction:InvalidVars')); 
        end
    end
    t = true;
elseif (ischar(x) && isvector(x))
    t = true;
elseif isa(x,'sym')
    if isa(x,'symfun')
        error(message('symbolic:sym:matlabFunction:InvalidVars'));  
    end
    t = true;
else
    error(message('symbolic:sym:matlabFunction:InvalidVars')); 
end

% validator for output parameter
function t = isOutputVars(x)
if iscellstr(x) && (isvector(x) || isempty(x))
    if all(cellfun(@isvarname,x))
        t = true;
    else
        error(message('symbolic:sym:matlabFunction:InvalidVarName'));
    end
else
    error(message('symbolic:sym:matlabFunction:InvalidOutputVars'));
end

% validator for file parameter
function t = isFunc(x)
[~,file] = fileparts(x);
t = isempty(file) || isvarname(file);

% parse inputs and return option structure output
function opts = getOptions(args)
ip = inputParser;
ip.addParameter('Vars',{},@isVars);
ip.addParameter('File','',@isFunc);
ip.addParameter('Outputs',{},@isOutputVars);
ip.addParameter('Optimize',true,@(x) isequal(x,true) || isequal(x,false));
ip.addParameter('Sparse',false,@(x) isequal(x,true) || isequal(x,false));
ip.parse(args{:});
% 'Optimize' was set explicitly by the user
if isempty(find(strcmp(ip.UsingDefaults, 'Optimize'),1))
    if isempty(ip.Results.File) && ip.Results.Optimize
        error(message('symbolic:sym:matlabFunction:OptimizeNotAllowed'));
    end
end
opts = ip.Results;

function c = tocell(x)
if isempty(x)
    c = {};
elseif isscalar(x)
    str = char(x);
    if strncmp(str,'matrix(',7)
        str = str(10:end-3); % remove matrix([[...]])
    end
    c = {str};
else
    str = char(x);
    if strncmp(str,'matrix(',7)
        str = str(10:end-3); % remove matrix([[...]])
    end
    c = regexp(str,',','split');
    c = cellfun(@strtrim,c,'UniformOutput',false);
end
