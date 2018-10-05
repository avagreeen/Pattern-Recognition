function Z=polylog(N, X)
%POLYLOG  polylogarithm function.
%   POLYLOG(0,X) = X./(1-X)
%   POLYLOG(1,X) = -log(1-X)
%   POLYLOG(N+1,X) = int(polylog(N,t)/t,t,0,X) for 0 < X < 1 and any N; or for N >= 1 and any X

% Copyright 2012 The MathWorks, Inc.
Z = sym.useSymForNumeric(@polylog, N, X);
