function [c,t] = coeffs(p,varargin)
%COEFFS Coefficients of a multivariate polynomial.
%   C = COEFFS(P) returns the coefficients of the polynomial P with respect to
%   all the indeterminates of P.
%   C = COEFFS(P,X) returns the coefficients of the polynomial P with
%   respect to X.
%   C = COEFFS(P,[X,Y,...]) returns the coefficients of the polynomial P with
%   respect to the variables X, Y, ...
%   C = COEFFS(__,'All') includes the coefficients that are 0.
%   For C = COEFFS(P, [X,Y,...],'All'), C will have as many dimensions
%   as there are variables in the list.
%   [C,T] = COEFFS(P,...) also returns a vector (or, for multi-variable calls
%   with option 'All', an n-dimensional array) of the terms of P.  There is a
%   one-to-one correspondence between the coefficients and the terms of P.
%
%   Examples:
%      syms x
%      t = 2 + (3 + 4*x)^2 - 5*x;
%      coeffs(t) = [ 11, 19, 16]
%
%      syms x y
%      z = 3*x^2*y^2 + 5*x*y^3;
%      coeffs(z) = [5, 3]
%      coeffs(z,x) = [5*y^3, 3*y^2]
%      [c,t] = coeffs(z,y) returns c = [5*x, 3*x^2], t = [y^3, y^2]
%
%   See also SYM/SYM2POLY.

%   Copyright 1993-2015 The MathWorks, Inc.

if ~isa(p,'sym'), p = sym(p); end
if builtin('numel',p) ~= 1,  p = normalizesym(p);  end
if ~isscalar(formula(p))
    error(message('symbolic:coeffs:FirstArgumentMustBeScalar'));
end

args = varargin;
all = false;
if ~isempty(args) && ischar(args{end}) && strcmpi(args{end},'all')
    all = true;
    args(end) = [];
end

if numel(args) > 1
    error(message('MATLAB:TooManyInputs'));
end

if ~isempty(args)
    x2 = sym(args{end});
    args = {x2.s};
else
    args = {};
end

if all
    args = [args, {'All'}];
end

if nargout < 2
    cSym = mupadmex('symobj::coeffs',p.s, args{:});
    c = privResolveOutput(cSym, p);
else
    [cSym,tSym] = mupadmexnout('symobj::coeffsterms', p, args{:});
    c = privResolveOutput(cSym, p);
    t = privResolveOutput(tSym, p);
end
