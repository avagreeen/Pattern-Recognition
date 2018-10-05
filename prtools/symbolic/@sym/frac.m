function Y = frac(X)
%FRAC  Symbolic matrix element-wise fractional part.
%   Y = FRAC(X) is the matrix of the fractional part of the elements of X.
%   FRAC(X) = X - FIX(X).
%   Example:
%      x = sym(-5/2)
%      [fix(x) floor(x) round(x) ceil(x) frac(x)]
%      = [ -2, -3, -3, -2, -1/2]
%
%   See also SYM/ROUND, SYM/CEIL, SYM/FLOOR, SYM/FIX.

%   Copyright 2011 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'symobj::frac');
end