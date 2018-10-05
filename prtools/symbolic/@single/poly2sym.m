function p = poly2sym(c,x)
%POLY2SYM Polynomial coefficient vector to symbolic polynomial.
%   POLY2SYM(C) is a symbolic polynomial in 'x' with coefficients
%   from the vector C.
%   POLY2SYM(C, V) uses the symbolic
%   variable specified by the second argument.
%
%   Example:
%       poly2sym([1 0 -2 -5])
%   is
%       x^3-2*x-5
%
%       t = sym('t')
%       poly2sym([1 0 -2 -5],t)
%   returns
%       t^3-2*t-5
%
%   See also SYM/SYM2POLY, POLYVAL.

%   Copyright 1993-2014 The MathWorks, Inc.

if nargin < 2, x = sym('x'); end
p = poly2sym(sym(c), x);
