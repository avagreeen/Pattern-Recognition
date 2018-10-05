function Y = expint(X,Z)
%EXPINT   Exponential integral function.
%   Y = EXPINT(N,X) is the 2-argument version of the exponential
%   integral. It is defined as:
%
%      EXPINT(n,x) = integral from 1 to Inf of exp(-x*t)/t^n dt
%
%   The function EXPINT can also be called with 1 argument.
%
%   Y = EXPINT(X) is the exponential integral function. The
%   exponential integral is defined as:
%
%      EXPINT(x) = integral from x to Inf of (exp(-t)/t) dt,
%
%   for x > 0. By analytic continuation, EXPINT is a scalar-valued
%   function in the complex plane.
%
%   See also EXPINT, SYM/EI.

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    N = sym(1);
else
    N = X;
    X = Z;
end
Y = privBinaryOp(N,X,'symobj::vectorizeSpecfunc','Ei','infinity');
end
