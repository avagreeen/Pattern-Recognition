function Y = chebyshevT(n, x)
%CHEBYSHEVT   Chebyshev polynomials of the first kind.

%   Copyright 2014 The MathWorks, Inc.
Y = sym.useSymForNumeric(@chebyshevT, n, x); 
end
