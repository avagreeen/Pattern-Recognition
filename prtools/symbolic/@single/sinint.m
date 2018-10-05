function z = sinint(x)
%SININT Sine integral function.
%  SININT(x) = int(sin(t)/t,t,0,x).
%
%  See also COSINT.

%   Copyright 2012 The MathWorks, Inc.

z = sym.useSymForNumeric(@sinint, x);
