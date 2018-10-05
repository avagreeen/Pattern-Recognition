function Y = floor(X)
%FLOOR  Symbolic matrix element-wise floor.
%   Y = FLOOR(X) is the matrix of the greatest integers <= X.
%   Example:
%      x = sym(-5/2)
%      [fix(x) floor(x) round(x) ceil(x) frac(x)]
%      = [ -2, -3, -3, -2, -1/2]
%
%   See also SYM/ROUND, SYM/CEIL, SYM/FIX, SYM/FRAC.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'floor');
end
