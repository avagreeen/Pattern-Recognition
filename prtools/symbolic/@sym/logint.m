function Y = logint(X)
% LOGINT Integral logarithm.
%    Y = LOGINT(X) is the integral logarithm of X.
%    It is defined as:
%    LOGINT(x) = integral from 0 to x of 1/log(t) dt.
%    See also EXPINT.

%   Copyright 2013 The MathWorks, Inc.
Y = privUnaryOp(X, 'symobj::map', 'Li');
end