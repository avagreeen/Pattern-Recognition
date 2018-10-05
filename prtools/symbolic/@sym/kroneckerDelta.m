function Z = kroneckerDelta(M,N)
%KRONECKERDELTA  The Kronecker delta symbol
%
%  KRONECKERDELTA(M, N) is 1 if M==N, 0 otherwise.
%  If M or N are NaN, KRONECKERDELTA(M,N) returns NaN.
%
%  For non-constant entries in M and N, a symbolic kroneckerDelta call
%  is returned.
%
%  If M or N are non-scalar, KRONECKERDELTA is applied element-by-element.
%
%  KRONECKERDELTA(M) == KRONECKERDELTA(M, 0)
%
%  kroneckerDelta(1,sym(0)) returns 0
%  kroneckerDelta(1:4, sym('n')) returns
%    [kroneckerDelta(n - 1, 0), kroneckerDelta(n - 2, 0), ...
%     kroneckerDelta(n - 3, 0), kroneckerDelta(n - 4, 0)]

%   Copyright 2014 The MathWorks, Inc.

if nargin==1
  N = sym(0);
end

Z = privBinaryOp(M, N, 'symobj::vectorizeSpecfunc', 'kroneckerDelta', '0');
end
