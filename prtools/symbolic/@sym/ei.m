function Y = ei(X)
%EI  One argument exponential integral function.
%   Y = EI(X) is the 1-argument exponential integral. It is
%   defined as:
%
%      EI(x) = integral from -Inf to x of exp(t)/t dt
%
%   See also EXPINT, SYM/EXPINT.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X,'symobj::vectorizeSpecfunc','Ei','-infinity');
end
