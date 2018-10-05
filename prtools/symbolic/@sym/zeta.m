function Z = zeta(n,X)
%ZETA   Symbolic Riemann zeta function.
%   ZETA(z) = symsum(1/k^z,k,1,inf).
%   ZETA(n,z) = n-th derivative of ZETA(z)

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    X = n;
    n = sym(0);
end
Z = privBinaryOp(n, X, 'symobj::vectorizeSpecfunc', 'symobj::zeta', 'infinity');
end
