function Y = hermiteH(n, x)
%HERMITEH   Hermite polynomials.
%    Y = HERMITEH(N, X) is the N-th Hermite polynomial.

%   Copyright 2014 The MathWorks, Inc.

Y = privBinaryOp(n, x, 'symobj::vectorizeSpecfunc', 'orthpoly::hermite', 'undefined');

