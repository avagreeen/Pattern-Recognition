function Y = legendreP(n, x)
%LEGENDREP   Legendre polynomials.

%   Copyright 2014 The MathWorks, Inc.
Y = sym.useSymForNumeric(@legendreP, n, x); 
end
