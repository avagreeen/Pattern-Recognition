function Y = erfi(X)
%   Y = ERFI(X) computes the value of the imaginary error function
%   for the argument X.
%
%   The imaginary error function is defined in terms of the error
%   function ERF via erfi(i*x) = -i*erf(-x).

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'erfi');
end
