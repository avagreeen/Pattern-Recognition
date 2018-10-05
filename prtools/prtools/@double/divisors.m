function d = divisors(n)
%DIVISORS Divisors of an integer.
%   DIVISORS(N), where N is an integer, returns the nonnegative divisors of N.
%
%   Example:
%
%   divisors(6) is
%   [1 2 3 6]
%
%   See also FACTOR.

%   Copyright 2013 The MathWorks, Inc.

if ~isscalar(n)
    error(message('symbolic:sym:ExpectingScalar1'));
end
if ~isreal(n) || (floor(n) ~= n) 
    error(message('symbolic:sym:InputMustBeRealInteger'));
end
d = sym.useSymForNumeric(@divisors, n);
