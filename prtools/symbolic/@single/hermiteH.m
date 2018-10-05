function Y = hermiteH(n, x)
%HERMITEH   Hermite polynomials.

%   Copyright 2014 The MathWorks, Inc.
Y = sym.useSymForNumeric(@hermiteH, n, x); 
end
