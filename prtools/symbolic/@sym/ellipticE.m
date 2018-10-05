function Y=ellipticE(PHI, X)
%ELLIPTICE  Elliptic integral of the second kind
%   Y = ellipticE(X) returns the complete elliptic integral of the second kind,
%   evaluated for each element of X.
%
%   Y = ellipticE(PHI, X) returns the incomplete elliptic integral of the second kind,
%   evaluated for each pair of elements of PHI and X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICK, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1 
    Y = privUnaryOp(PHI, 'symobj::vectorizeSpecfunc', 'ellipticE', 'infinity');
else
    Y = privBinaryOp(PHI, X, 'symobj::vectorizeSpecfunc', 'ellipticE', 'infinity');
end
end
