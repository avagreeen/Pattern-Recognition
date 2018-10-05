function Y = gegenbauerC(n,a,x)
%GEGENBAUERC   Gegenbauer polynomials.
%    Y = gegenbauerC(N,A,X) is the N-th ultraspherical polynomial.

%   Copyright 2014 The MathWorks, Inc.
Y = sym.useSymForNumeric(@gegenbauerC, n, a, x); 
end
