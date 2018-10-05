function Y = gegenbauerC(n, a, x)
%GEGENBAUERC   Gegenbauer polynomials.
%    Y = gegenbauerC(N, A, X) is the N-th ultraspherical polynomial.

%   Copyright 2014 The MathWorks, Inc.

Y = privTrinaryOp(n,a,x, 'symobj::vectorizeSpecfunc', 'orthpoly::gegenbauer', 'undefined');

