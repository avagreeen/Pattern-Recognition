function Z = polylog(n,X)
%POLYLOG  Symbolic polylogarithm.
%   POLYLOG(0,X) = X./(1-X)
%   POLYLOG(1,X) = -log(1-X)
%   POLYLOG(N+1,X) = int(polylog(N,t)/t,t,0,X) for 0 < X < 1 and any N; or for N >= 1 and any X

% Copyright 2013 The MathWorks, Inc.

Z = privBinaryOp(n, X, 'symobj::vectorizeSpecfunc', 'symobj::polylog', 'infinity');
