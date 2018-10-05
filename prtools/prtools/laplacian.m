function L = laplacian(f,x)
%LAPLACIAN of a function.
%   L = LAPLACIAN(f,x) computes the Laplacian of the scalar function f with 
%   respect to the vector x, i.e. the scalar quantity 
%   d^2f/dx(1)^2 + d^2f/dx(2)^2 + ... + d^2f/dx(n)^2.
%
%   L = LAPLACIAN(f) computes the Laplacian of the function f with respect
%   to the vector x = symvar(f). If f is a SYMFUN then x = argnames(f)
%   will be used.
%
%   Examples:
%       syms x y z;
%       laplacian(1/x + y^2 + z^3, [x y z])
%       returns  6*z + 2/x^3 + 2
%
%       laplacian(1/x^3 + y^2)
%       returns  12/x^5 + 2
%
%   See also SYM/CURL, SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN,
%   SYM/JACOBIAN, SYM/POTENTIAL, CURL, DIVERGENCE, GRADIENT, HESSIAN,
%   JACOBIAN, VECTORPOTENTIAL, SUBS.

%   Copyright 2011-2015 The MathWorks, Inc.

args = privResolveArgs(sym(f));
fsym = formula(args{1});

if ~isscalar(fsym)
    error(message('symbolic:sym:laplacian:FirstArgumentMustBeScalar'));
end
if ~isfinite(fsym)
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargin == 1
    if isa(f,'symfun')
        x = argnames(f);
    else
        x = symvar(fsym);
    end
end

if ~isvector(x) || ~isAllVars(x)
    error(message('symbolic:sym:laplacian:SecondArgumentMustBeVectorOfVariables'));
end
res = privBinaryOp(fsym,x,'symobj::laplacian');

if isa(f,'symfun')
    L = symfun(res, argnames(f));
else
    L = res;
end

