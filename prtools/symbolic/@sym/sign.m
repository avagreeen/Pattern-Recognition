function Y = sign(X)
%SIGN  Symbolic sign function.
%   For each element of X, sign(X) returns 1 if the element
%   is greater than zero, 0 if it equals zero and -1 if it is
%   less than zero. For the nonzero elements of complex X,
%   sign(X) = X/ABS(X).
%
%   See also ABS, SYM/ABS

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'sign');
end
