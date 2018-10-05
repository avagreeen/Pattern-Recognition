function Y = hermiteH(n, x)
%HERMITEH    Hermite polynomials.

%   Copyright 2014 The MathWorks, Inc.
narginchk(2, 2);
Y = sym.useSymForNumeric(@hermiteH, n, x); 
end
