function Y = legendreP(n, x)
% LEGENDREP  Legendre polynomials.
%    Y = LEGENDREP(N, X) is the N-th Legendre polynomial.

%   Copyright 2014 The MathWorks, Inc.

Y = privBinaryOp(n, x, 'symobj::vectorizeSpecfunc', 'orthpoly::legendre', 'infinity');

