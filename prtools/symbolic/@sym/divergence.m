function D = divergence(V,X)
%DIVERGENCE of a vector field.
%   D = DIVERGENCE(V,X) computes the divergence of the vector field v with
%   respect to the vector x, i.e., the scalar quantity dv(1)/dx(1) +
%   dv(2)/dx(2) + ... + dv(n)/dx(n).
%
%   Example:
%       syms x y z; divergence([x^2 2*y z], [x y z])
%       returns  2*x + 3
%
%   See also SYM/CURL, SYM/DIFF, SYM/GRADIENT, SYM/HESSIAN, SYM/JACOBIAN,
%   SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, HESSIAN, JACOBIAN,
%   LAPLACIAN, VECTORPOTENTIAL

%   Copyright 2011-2015 The MathWorks, Inc.

args = privResolveArgs(sym(V));
Vsym = formula(args{1});

if ~isvector(Vsym)
    error(message('symbolic:sym:divergence:ArgumentsMustBeScalarsOrVectors'));
end
if any(~isfinite(Vsym))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargin == 1
    if isa(V,'symfun')
        X = argnames(V);
    else
        X = symvar(Vsym);
    end
end

if ~isvector(X) || ~isAllVars(X)
     error(message('symbolic:sym:divergence:SecondArgumentMustBeVectorOfVariables'));
end
if numel(Vsym) ~= numel(X)
   if nargin == 1
     error(message('symbolic:sym:divergence:VectorMismatch'));
   else
     error(message('symbolic:sym:divergence:VectorMustHaveSameDimension'));
   end
end
res = mupadmex('symobj::divergence', Vsym.s, X.s);

if isa(V,'symfun')
    D = symfun(res, argnames(V));
else
    D = res;
end
