function Y=ellipticPi(N, PHI, M)
%ELLIPTICPI  Elliptic integral of the third kind
%   Y = ellipticPi(N, M) returns the complete elliptic integral of the third kind,
%   evaluated for each pair of elements of N and M.
%
%   Y = ellipticPi(N, PHI, M) returns the incomplete elliptic integral of the third kind,
%   evaluated for each three-tuple of elements of N, PHI and M.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICK, SYM/ELLIPTICE, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICCPI

%   Copyright 2013 The MathWorks, Inc.

if nargin == 2
    Y = privBinaryOp(N, PHI, 'symobj::vectorizeSpecfunc', 'ellipticPi', 'infinity');
else
    Y = privTrinaryOp(N, PHI, M, 'symobj::vectorizeSpecfunc', 'ellipticPi', 'infinity');
end
end
