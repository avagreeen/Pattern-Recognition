function P = psi(k,X)
%PSI Symbolic Psi (polygamma) function.
%   psi(X)   = diff(gamma(X))/gamma(X).
%   psi(k,X) = k-th derivative of psi(X)

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    X = k;
    k = sym(0);
end

P = privBinaryOp(k, X, 'symobj::vectorizeSpecfunc', 'symobj::psi', 'infinity');
end
