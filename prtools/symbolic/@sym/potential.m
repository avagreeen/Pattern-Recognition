function P = potential(V,X,Y)
%POTENTIAL of a function.
%   P = POTENTIAL(V,X) computes the potential of vector field V with
%   respect to X. V and X must be vectors of the same dimension. The vector
%   field V must be a gradient field. If the function POTENTIAL cannot
%   verify that V is a gradient field, it returns NaN.
%
%   P = POTENTIAL(V,X,Y) computes the potential of vector field V with
%   respect to X using Y as base point for the integration. If Y is not a
%   scalar, then Y must be of the same dimension as V and X. If Y is
%   scalar, then Y is expanded into a vector of the same size as X with
%   all components equal to Y.
%
%   Examples:
%       syms x y z; potential([x y z*exp(z)], [x y z])
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1).
%
%       syms x0 y0 z0; potential([x y z*exp(z)], [x y z], [x0 y0 z0])
%       returns x^2/2 - x0^2/2 + y^2/2 - y0^2/2 + exp(z)*(z - 1) -
%               exp(z0)*(z0 - 1)
%
%       potential([x y z*exp(z)], [x y z], [1,1,1])
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1) - 1
%
%       potential([x y z*exp(z)], [x y z], 1)
%       returns x^2/2 + y^2/2 + exp(z)*(z - 1) - 1
%
%       potential([y -x], [x y])
%       returns NaN since the potential does not exist.
%
%   See also SYM/DIFF, SYM/JACOBIAN, SYM/GRADIENT, SYM/HESSIAN, SYM/CURL,
%   SYM/DIVERGENCE, SYM/LAPLACIAN, CURL, DIVERGENCE, GRADIENT, HESSIAN,
%   JACOBIAN, SUBS.

%   Copyright 2011-2015 The MathWorks, Inc.

narginchk(1,3);
args = privResolveArgs(sym(V));
Vsym = formula(args{1}); 

if ~isvector(Vsym)
    error(message('symbolic:sym:potential:FirstArgumentMustBeScalarOrVector'));
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
    error(message('symbolic:sym:potential:SecondArgumentMustBeVectorOfVariables'));
end
if numel(Vsym) ~= numel(X)
    if nargin == 1
        error(message('symbolic:sym:potential:VectorMismatch'));
    else
        error(message('symbolic:sym:potential:SameDimension'));
    end
end

if nargin < 3
    Ysym = sym([]);
else
    Ysym = formula(sym(Y));
    if ~isscalar(Ysym) && numel(Ysym) ~= numel(X)
       error(message('symbolic:sym:potential:SameDimensionOrScalar'));
    end
end

if isempty(Ysym)
    res = privBinaryOp(Vsym,X,'symobj::potential');
else
    res = privTrinaryOp(Vsym,X,Ysym,'symobj::potential');
end

if isa(V,'symfun')
    P = symfun(res, argnames(V));
else
    P = res;
end
