function Z = sinint(X)
%SININT Sine integral function.
%   SININT(x) = int(sin(t)/t,t,0,x).
%
%   See also SYM/COSINT.

%   Copyright 2013 The MathWorks, Inc.

Z = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'Si', '-infinity');
end
