function Y = dilog(X)
% DILOG Dilogarithm function
%    Y = DILOG(X) is the dilogarithm function of X. 
%    It is defined as
%    DILOG(x) = integral from 1 to x of log(t)/(1-t) dt
%    See also LOG.

%   Copyright 2013 The MathWorks, Inc.
Y = privUnaryOp(X, 'symobj::map', 'dilog');
end