function Y = laguerreL(n, a, x)
%LAGUERREL    Laguerre's L function and Laguerre polynomials.

%   Copyright 2014 The MathWorks, Inc.
if nargin == 2
    Y = sym.useSymForNumeric(@laguerreL, n, a);
else
    Y = sym.useSymForNumeric(@laguerreL, n, a, x);
end
end
