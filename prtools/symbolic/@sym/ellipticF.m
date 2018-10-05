function Y=ellipticF(PHI, X)
%ELLIPTICF  Incomplete elliptic integral of the first kind
%   Y = ellipticF(PHI, X) returns the incomplete elliptic integral of the first kind,
%   evaluated for each pair of elements of PHI and X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICK, SYM/ELLIPTICE, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICPI, SYM/ELLIPTICCPI

%   Copyright 2013 The MathWorks, Inc.
Y = privBinaryOp(PHI, X, 'symobj::vectorizeSpecfunc', 'ellipticF', 'infinity');
end
