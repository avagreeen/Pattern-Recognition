function y = ei(x)
%EI  1-argument exponential integral function.
%   Y = EI(X) is the 1-argument exponential integral. It is defined
%   as:
%
%      EI(x) = integral from -Inf to x of exp(t)/t dt
%
%   See also EXPINT, SYM/EXPINT.

%   Copyright 2012 The MathWorks, Inc.

y = sym.useSymForNumeric(@ei, x);
