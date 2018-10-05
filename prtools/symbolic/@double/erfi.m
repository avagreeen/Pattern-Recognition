function Y = erfi(x)
%ERFI  Imaginary error function.
%   Y = ERFI(x) computes the value of the imaginary error function
%   for the argument x.
%
%   The imaginary error function is defined in terms of the error function
%   ERF via erfi(i*x) = -i*erf(-x).

% See also erf, erfc, erfcinv, erfcx, erfinv

%   Copyright 2012 The MathWorks, Inc.
Y = sym.useSymForNumeric(@erfi, x);
