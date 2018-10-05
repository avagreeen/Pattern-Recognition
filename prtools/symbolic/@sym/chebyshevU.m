function Y = chebyshevU(n, x)
%CHEBYSHEVU   Chebyshev polynomials of the second kind.
%    Y = CHEBYSHEVU(N, X) is the N-th Chebyshev polynomial.
%    See also CHEBYSHEVT.

%   Copyright 2014 The MathWorks, Inc.

Y = privBinaryOp(n, x, 'symobj::vectorizeSpecfunc', 'orthpoly::chebyshev2', 'undefined');

