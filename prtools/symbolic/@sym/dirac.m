function Y = dirac(n,X)
%DIRAC  Symbolic delta function.
%    DIRAC(X) is zero for all X, except X == 0 where it is infinite.
%    DIRAC(X) is not a function in the strict sense, but rather a
%    distribution with int(dirac(x-a)*f(x),-inf,inf) = f(a) and
%    diff(heaviside(x),x) = dirac(x).
%    DIRAC(N,X) represents the N-th derivative of DIRAC(X).
%
%    See also SYM/HEAVISIDE.

%   Copyright 2013-2014 The MathWorks, Inc.

if nargin == 1
    X = n;
    n = sym(0);
end
Y = privBinaryOp(n, X, 'symobj::vectorizeSpecfunc', 'symobj::dirac', 'infinity');
end
