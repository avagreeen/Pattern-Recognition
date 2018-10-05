function Y = chebyshevU(n, x)
%ChebyshevU   Chebyshev polynomials of the second kind.

%   Copyright 2014 The MathWorks, Inc.
narginchk(2, 2);
Y = sym.useSymForNumeric(@chebyshevU, n, x); 
end
