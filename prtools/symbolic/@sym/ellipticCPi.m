function Y=ellipticCPi(N, M)
%ELLIPTICCPI  Complementary complete elliptic integral of the third kind
%   Y = ellipticCPi(N, M) returns the complementary complete elliptic integral
%   of the third kind, evaluated for each pair of elements of N and M.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICE, SYM/ELLIPTICK, SYM/ELLIPTICCE, SYM/ELLIPTICCK,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI

%   Copyright 2013 The MathWorks, Inc.

Y = privBinaryOp(N, M, 'symobj::vectorizeSpecfunc', 'ellipticCPi', 'infinity');
end
