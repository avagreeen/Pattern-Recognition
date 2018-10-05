function [Y, errcode] = funm(A,f,~,varargin)
%FUNM  Matrix calculus.
%   FUNM(A, f) returns f(A), interpreted as a matrix function.

%   Copyright 2014 The MathWorks, Inc.

errcode = 0;
narginchk(2,inf);

if isa(f,'symfun')
    narginchk(2,numel(argnames(f))+2);
end

if isa(f, 'sym') && numel(formula(f)) ~= 1
    error(message('symbolic:funm:NonScalarFunction'));
end


Asym = sym(A);
if isa(Asym, 'symfun') || any(cellfun(@(x) isa(x, 'symfun'), varargin))
    error(message('symbolic:funm:NoSYMFUNs'));
end

symf = fun2sym(f, varargin);

if ~ismatrix(Asym) || (size(Asym, 1) ~= size(Asym, 2))
    error(message('symbolic:funm:FirstInputMustBe2D'));
end

Anan = isnan(A);
Ainf = isinf(A);
if any(Anan(:)) || any(Ainf(:))
    error(message('symbolic:funm:NoNANorInf'));
end

if isempty(Asym)
    Y = Asym;
else
    if isscalar(Asym)
        Y = mupadmex('fp::apply', symf.s, Asym.s);
    else
        Y = mupadmex('funm', Asym.s, symf.s);
    end
end
Y = mupadmex('symobj::normalize', Y.s);
if isa(f,'symfun') && numel(argnames(f)) > numel(varargin)+1
    args_f = argnames(f);
    args_f = privsubsref(args_f, (numel(varargin)+2):numel(args_f));
    Y = symfun(Y, args_f);
end
end

%--------------------------------------------------------------------
function symf = fun2sym(fun, args)
% convert f to a unary MuPAD function, applying all additional parameters

if ischar(fun)
    fun = str2func(fun); % compatibility with double/funm
end

symf = false; % any dummy sentinel
if isa(fun,'function_handle') && isequal(fun,@cos), symf = mupadmex('cos'); end
if isa(fun,'function_handle') && isequal(fun,@sin), symf = mupadmex('sin'); end
if isa(fun,'function_handle') && isequal(fun,@cosh), symf = mupadmex('cosh'); end
if isa(fun,'function_handle') && isequal(fun,@sinh), symf = mupadmex('sinh'); end
if isa(fun,'function_handle') && isequal(fun,@exp), symf = mupadmex('exp'); end
if isa(fun,'function_handle') && isequal(fun,@log), symf = mupadmex('ln'); end

if symf ~= false
    % all of these are univariate
    if ~isempty(args)
        error(message('MATLAB:TooManyInputs'));
    end
    return
end

% find a new variable t to compute f(t, 0, args{:})
symargs = sym(args(cellfun(@(x) isa(x, 'sym'), args)));
usedvars = mupadmex('indets', symargs.s);

if isa(fun, 'function_handle')
    % if inserting a sym errors or we have the wrong number of arguments, just let the user know
    newvar = mupadmex('solvelib::getIdent', 'Any', usedvars.s);
    f = fun(newvar, 0, args{:});
    f = sym(f);
    if numel(formula(f)) ~= 1
        error(message('symbolic:funm:NonScalarFunction'));
    end
    symf = mupadmex('fp::unapply',f.s,newvar.s);
else
    f = sym(fun);
    fvars = mupadmex('indets', f.s);
    usedvars = mupadmex('_union', usedvars.s, fvars.s);
    newvar = mupadmex('solvelib::getIdent', 'Any', usedvars.s);
    if logical(mupadmex('(t->testtype(eval(t), Type::Function))',f.s))
        symf = f;
        if ~isempty(args)
            symf = feval(symengine, 'fp::apply', symf, newvar, args{:});
            symf = mupadmex('fp::unapply', symf.s, newvar.s);
        end
    else
        nargs = numel(args)+1;
        argsvars = symvar(f, nargs);
        if nargs > 1 && numel(argsvars) < nargs
            error(message('MATLAB:narginchk:tooManyInputs'));
        end
        if ~isempty(argsvars)
            f = subs(f, privsubsref(argsvars, 1), newvar);
            f = subs(f, privsubsref(argsvars, 2:nargs), args);
        end
        if numel(formula(f)) ~= 1
            error(message('symbolic:funm:NonScalarFunction'));
        end

        symf = mupadmex('fp::unapply', f.s, newvar.s);
    end
end
end
