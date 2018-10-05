function Y = fix(X)
%FIX    Symbolic matrix element-wise integer part.
%   Y = FIX(X) is the matrix of the integer parts of X.
%   FIX(X) = FLOOR(X) if X is positive and CEIL(X) if X is negative.
%
%   See also SYM/ROUND, SYM/CEIL, SYM/FLOOR, SYM/FRAC.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'trunc');
end
