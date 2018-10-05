function Y = chebyshevT(n, x)
%CHEBYSHEVT   Chebyshev polynomials of the first kind.
%    Y = CHEBYSHEVT(N, X) is the N-th Chebyshev polynomial.
%    See also CHEBYSHEVU.

%   Copyright 2014 The MathWorks, Inc.

Y = privBinaryOp(n, x, 'symobj::vectorizeSpecfunc', 'orthpoly::chebyshev1', 'undefined');

