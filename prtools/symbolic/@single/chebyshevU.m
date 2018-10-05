function Y = chebyshevU(n, x)
%CHEBYSHEVU   Chebyshev polynomials of the second kind.

%   Copyright 2014 The MathWorks, Inc.
Y = sym.useSymForNumeric(@chebyshevU, n, x); 
end
