function G = gradient(f,x)
%GRADIENT gradient.
%   G = GRADIENT(f,x) computes the gradient of the scalar f with respect
%   to the vector x. Note that scalar x is allowed although this
%   is just DIFF(f,x).
%
%   Example:
%       syms x y z; gradient(x*y + 2*z*x, [x, y, z])
%       returns  [y + 2*z; x; 2*x]
%
%   See also SYM/CURL, SYM/DIFF, SYM/HESSIAN, SYM/JACOBIAN, SYM/POTENTIAL,
%   CURL, DIVERGENCE, HESSIAN, GRADIENT, JACOBIAN, LAPLACIAN,
%   VECTORPOTENTIAL

%   Copyright 2011-2015 The MathWorks, Inc.

args = privResolveArgs(sym(f));
fsym = formula(args{1});

if ~isscalar(fsym)
    error(message('symbolic:sym:gradient:FirstArgumentMustBeScalar'));
end
if ~isfinite(fsym)
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargin == 1
    if isa(f,'symfun')
        x = argnames(f);
    else
        x = symvar(f);
    end
end

if isempty(x)
    res = sym(zeros(0,numel(fsym)));
else
    if ~isvector(x) || ~isAllVars(x)
        error(message('symbolic:sym:gradient:SecondArgumentMustBeVectorOfVariables'));
    end
    if isempty(fsym)
        res = sym(zeros(numel(x),0));
    else 
        res = mupadmex('symobj::gradient',fsym.s,x.s);
    end
end

if isa(f,'symfun')
    G = symfun(res, argnames(f));
else
    G = res;
end
