function Y = euler(n, x)
% EULER  Euler numbers and Euler polynomials.
%    Y = EULER(N, X) is the N-th Euler polynomial.
%    It is defined as
%    euler(n, x) = subs(diff(2*exp(x*t)/(exp(t) + 1), t, n), t, 0)
%    Y = EULER(N) is the N-th Euler number.
%    It is defined as
%    EULER(n) = 2^n*euler(n,1/2).
%    See also BERNOULLI. 

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1 
    Y = privUnaryOp(n, 'symobj::vectorizeSpecfunc', 'euler', 'undefined');
else
    Y = privBinaryOp(n, x, 'symobj::vectorizeSpecfunc', 'euler', 'undefined');
end
    