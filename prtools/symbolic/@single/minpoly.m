function P = minpoly(A,varargin)
%MINPOLY   Minimal polynomial of a matrix.
%   P = MINPOLY(A) returns the coefficients of the minimal polynomial
%   of the matrix A. If A is a SYM object, the vector returned is a
%   SYM object, too. Otherwise a vector with doubles or singles
%   is returned, depending on the type of A.
%
%   P = MINPOLY(A,x) returns the minimal polynomial of the matrix A in
%   terms of the variable x. Here x must be a free symbolic variable.
%
%   Examples:
%       syms x;
%       A = sym([1 1 0; 0 1 0; 0 0 1]);
%
%       P = minpoly(A)
%       returns  [ 1, -2, 1]
%
%       P = sym2poly(minpoly(A,x))
%       returns    1    -2     1
%
%       P = minpoly(A,x)
%       returns  x^2 - 2*x + 1
%
%       P = poly2sym(minpoly(A),x)
%       returns  x^2 - 2*x + 1
%
%   See also CHARPOLY, SYM/POLY2SYM, SYM/SYM2POLY, SYM/JORDAN, SYM/EIG,
%   SOLVE.

%   Copyright 2012-2014 The MathWorks, Inc.

oldDigits = digits(9);
cleanupObj = onCleanup(@() digits(oldDigits));

P = minpoly(sym(A), varargin{:});

if nargin==1
    P = single(P);
end
