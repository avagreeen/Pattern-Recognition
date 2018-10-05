function G = subs(F,X,Y,swap) %#ok<INUSD>
%SUBS   Symbolic substitution.  Also used to evaluate expressions numerically.
%   SUBS(S,OLD,NEW) replaces OLD with NEW in the symbolic expression S.
%   OLD is a symbolic variable, a string representing a variable name, or
%   a symbolic expression. NEW is a symbolic or numeric variable
%   or expression.  That is, SUBS(S,OLD,NEW) evaluates S at OLD = NEW.
%
%   SUBS(S,VALUES), where VALUES is a STRUCT, replaces the symbolic
%   variables in S which are field names in VALUES by the corresponding
%   entries of the struct.
%
%   SUBS(S) replaces all the variables in the symbolic expression S with
%   values obtained from the calling function, or the MATLAB workspace.
%
%   SUBS(S,NEW) replaces the free symbolic variable in S with NEW.
%
%   If OLD and NEW are vectors or cell arrays of the same size, each element
%   of OLD is replaced by the corresponding element of NEW.  If S and OLD
%   are scalars and NEW is a vector or cell array, the scalars are expanded
%   to produce an array result.  If NEW is a cell array of numeric matrices,
%   the substitutions are performed elementwise.
%
%   Examples:
%     Single input:
%       Suppose
%          y = exp(-a*t)*C1
%       After that, set a = 980 and C1 = 3 in the workspace.
%       Then the statement
%          subs(y)
%       produces
%          ans = 3*exp(-980*t)
%
%     Single Substitution:
%       subs(a+b,a,4) returns 4+b.
%       subs(a*b^2, a*b, 5) returns 5*b.
%
%     Multiple Substitutions:
%       subs(cos(a)+sin(b),{a,b},[sym('alpha'),2]) or
%       subs(cos(a)+sin(b),{a,b},{sym('alpha'),2}) returns
%       cos(alpha)+sin(2)
%
%     Scalar Expansion Case:
%       subs(exp(a*t),'a',-magic(2)) returns
%
%       [   exp(-t), exp(-3*t)]
%       [ exp(-4*t), exp(-2*t)]
%
%     Multiple Scalar Expansion:
%       subs(x*y,{x,y},{[0 1;-1 0],[1 -1;-2 1]}) returns
%         0  -1
%         2   0
%
%   See also SYM/SUBEXPR, SYM/VPA, SYM/DOUBLE.

%   Copyright 1993-2015 The MathWorks, Inc.

if ~isa(F,'sym'), F = sym(F); end
if builtin('numel',F) ~= 1,  F = normalizesym(F);  end

if nargin == 4
    warning(message('symbolic:subs:swapDeprecated'));
end

if nargin == 1
    % initialize X and Y from workspace variables

    % Determine which variables are in the MATLAB workspace and
    % place them in the cell X.  Similarly, place the values of
    % variables in the MATLAB workspace into the cell Y.
    vars = arrayfun(@char, symvar(F), 'UniformOutput', false);
    nvars = length(vars);
    eflag = zeros(1,nvars);
    for k = 1:nvars
        str = sprintf('exist(''%s'',''var'')',vars{k});
        eflag(k) = evalin('caller',str);
        if ~eflag(k)
            eflag(k) = 2*evalin('base',str);
        end
    end
    einds = find(eflag);
    X = vars(einds);
    Y = cell(1,length(einds));
    for k = 1:length(einds)
        if eflag(einds(k)) == 1
            Y{k} = evalin('caller',vars{einds(k)});
        else
            Y{k} = evalin('base',vars{einds(k)});
        end
    end
elseif nargin == 2
    if isstruct(X)
        Y = struct2cell(X);
        X = fieldnames(X);
        % look for symfuns hiding behind those names.
        % Can't use a helper function, since we need to check the caller's workspace.
        for k=1:size(X,1)
            str = sprintf('exist(''%s'',''var'')',X{k});
            if evalin('caller',str)
                fn = evalin('caller', X{k});
                fname = isAbstractFun(fn);
                if ~isequal(fname, false) && isequal(char(fname), X{k})
                    X{k} = fn;
                end
            elseif evalin('base',str)
                fn = evalin('base', X{k});
                fname = isAbstractFun(fn);
                if ~isequal(fname, false) && isequal(char(fname), X{k})
                    X{k} = fn;
                end
            end
        end
    else
        % got Y and use free variable as X
        Y = X;
        X = symvar(F,1);
        if isempty(X), X = sym('x'); end
    end
end

if isempty(X)
    G = F;
elseif isempty(Y)
    G = formula(sym(Y));
else
    G = mupadsubs(F,X,Y);
end
if isa(F,'symfun')
    G = symfun(G,argnames(F));
end

%--------------------------------------------------------------------
function G = mupadsubs(F,X,Y)
% Check for appropriate forms of input.
error(inputchk(X,Y));

% convert X and Y to syms and wrap in cell array if needed
[X2,Y2,symX,symY] = normalize(X,Y); %#ok

% send all data to MuPAD for subs
G = mupadmex('symobj::fullsubs',F.s,X2,Y2);

%--------------------------------------------------------------------
% convert input X to cell array of sym objects
function [X2,Y2,X,Y] = normalize(X,Y)
if iscell(X)
    X = cellfun(@(x)sym(x),X,'UniformOutput',false);
elseif ischar(X) || isnumeric(X)
    X = {sym(X)};
elseif isa(X, 'symfun') % array-valued symfun? expand, for subs(f(1)+g(1), [f g], {@sin @cos})
    X = arrayfun(@(x) symfun(x,argnames(X)),formula(X),'UniformOutput',false);
elseif isa(X,'sym') % expand arrays here, too
    X = arrayfun(@(x) x,X,'UniformOutput',false);
else
    error(message('symbolic:subs:InvalidXClass'));
end

% if X contains symfuns, check for "abstract symfuns"
abstract_X = cellfun(@isAbstractFun, X, 'UniformOutput', false);
is_abstract = cellfun(@(x) isa(x, 'sym'), abstract_X);
is_abstract = reshape(is_abstract, 1, numel(is_abstract));
if any(is_abstract)
    % make sure Y is cell array of appropriate size, too
    if iscell(Y)
        % nothing
    elseif ischar(Y) || isnumeric(Y)
        Y = {sym(Y)};
    end
    if isa(Y, 'symfun') % array-valued symfun? expand, for subs(f(1)+g(2), [f g], [g f])
        Y = arrayfun(@(x) symfun(x,argnames(Y)),formula(Y),'UniformOutput',false);
    elseif isa(Y,'sym')
        if numel(is_abstract) == 1
            Y = arrayfun(@(x) x, fun2sym(Y,argnames(X{1})),'UniformOutput',false);
        else
            Y = arrayfun(@(x) x, Y,'UniformOutput',false);
        end
    elseif isa(Y,'function_handle')
        Y = {Y};
    end
    if ~iscell(Y)
        error(message('symbolic:subs:InvalidXClass'));
    end
    for i=find(is_abstract)
        Y{i} = fun2sym(Y{i},argnames(X{i}));
        X{i} = abstract_X{i};
    end
end

if iscell(Y)
    Y = cellfun(@(x)sym(x),Y,'UniformOutput',false);
elseif ischar(Y) || isnumeric(Y)
    Y = {sym(Y)};
elseif isa(Y, 'symfun') % array-valued symfun? expand, for subs(f(1)+g(1), [f g], [g f])
    Y = arrayfun(@(x) symfun(x,argnames(Y)),formula(Y),'UniformOutput',false);
elseif isa(Y,'sym')
    Y = {Y};
else
    error(message('symbolic:subs:InvalidXClass'));
end

% check number of variables and number of subs targets
if ~isequal(size(X), size(Y)) && numel(Y) == 1
  % expand sym array and check again
  Y = arrayfun(@(x) x,Y{1},'UniformOutput',false);
end
if ~isequal(size(X), size(Y)) && numel(X) ~= 1
  error(message('symbolic:subs:InconsistentLengths'));
end

% we can only vectorize over NEW
if ~all(cellfun(@isscalar, X))
  error(message('symbolic:subs:NonScalarOLD'));
end

% we need to keep X alive so that the reference is not collected
X2 = tolist(X);
Y2 = tolist(Y);

%--------------------------------------------------------------------
function msg = inputchk(x,y)
%INPUTCHK Generate error message for invalid cases

msg = '';
if isa(x,'sym') && length(x)==1
  if ischar(y) && size(y,1)~=1
    msg = message('symbolic:subs:errmsg1');
    return;
  end
elseif ischar(x) && ischar(y) && ...
      (length(sym(x))~=1 || length(sym(y))~=1) && isvarname(char(x))
    msg = message('symbolic:subs:errmsg1');
    return;
elseif (ischar(x) || isa(x,'sym')) && isvarname(char(x))
  if ischar(y) && size(y,1)~=1
    msg = message('symbolic:subs:errmsg1');
    return;
  end
end

%--------------------------------------------------------------------
% convert A to a MuPAD list
function s = tolist(A)
s = cellfun(@(x)[x.s ','],A,'UniformOutput',false);
s = [s{:}];
s = ['[' s(1:end-1) ']'];

%--------------------------------------------------------------------
function funcname = isAbstractFun(ex)
% check for abstract symfun
if ~isa(ex, 'symfun')
    funcname = false;
    return;
end
funcname = mupadmex('symobj::isAbstractFun', ex.s, char(argnames(ex)));
if strcmp(char(funcname), 'FAIL')
    funcname = false;
end

%--------------------------------------------------------------------
function f = fun2sym(ex, args)
% convert rhs for abstract symfun
if isa(ex, 'function_handle')
    % if this errors, just let the user know
    argscell = num2cell(args);
    ex = ex(argscell{:});
end
ex = sym(ex);
if isa(ex, 'symfun')
    f = mupadmex('fp::unapply',ex.s,char(argnames(ex)));
elseif logical(mupadmex('(t->testtype(eval(t), Type::Function))',ex.s))
    f = ex;
else
    argscell = num2cell(args);
    argsrefcell = cellfun(@(x) x.s, argscell, 'UniformOutput', false);
    f = mupadmex('fp::unapply', ex.s, argsrefcell{:});
end

