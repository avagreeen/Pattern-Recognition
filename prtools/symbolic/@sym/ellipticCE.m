function Y=ellipticCE(X)
%ELLIPTICCE  Complementary complete elliptic integral of the second kind
%   Y = ellipticCE(X) returns the complementary complete elliptic integral
%   of the second kind, evaluated for each element of X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICE, SYM/ELLIPTICK, SYM/ELLIPTICCK,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'ellipticCE', 'infinity');
end
