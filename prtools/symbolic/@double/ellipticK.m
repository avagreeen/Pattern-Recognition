function Y=ellipticK(X)
%ELLIPTICK  Complete elliptic integral of the first kind
%   Y = ellipticK(X) returns the complete elliptic integral of the first kind,
%   evaluated for each element of X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICE, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

% Copyright 2012 The MathWorks, Inc.
Y = sym.useSymForNumeric(@ellipticK, X);
