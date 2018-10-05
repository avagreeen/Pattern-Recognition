function Y=ellipticCE(X)
%ELLIPTICCE  Complementary complete elliptic integral of the second kind
%   Y = ellipticCE(X) returns the complementary complete elliptic integral
%   of the first kind, evaluated for each element of X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICE, SYM/ELLIPTICK, SYM/ELLIPTICCK,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

% Copyright 2012 The MathWorks, Inc.

Y = sym.useSymForNumeric(@ellipticCE, X);
