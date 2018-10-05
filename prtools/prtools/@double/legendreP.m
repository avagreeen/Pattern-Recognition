function Y = legendreP(n, x)
%LEGENDREP   Legendre polynomials.

%   Copyright 2014 The MathWorks, Inc.
narginchk(2, 2);
Y = sym.useSymForNumeric(@legendreP, n, x); 
end
