function Y=ellipticCK(X)
%ELLIPTICCK  Complementary complete elliptic integral of the first kind
%   Y = ellipticCK(X) returns the complementary complete elliptic integral
%   of the first kind, evaluated for each element of X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICE, SYM/ELLIPTICK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'ellipticCK', 'infinity');
end
