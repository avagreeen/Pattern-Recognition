function Y = laguerreL(n,a,x)
% LAGUERREL   Laguerre's L function and Laguerre polynomials. 
%
%    Y = LAGUERREL(N,A,X) is the generalized Laguerre 
%    function with parameter A. It is an N-th degree
%    polynomial in X if N is a nonnegative integer.

%   Copyright 2014 The MathWorks, Inc.

if nargin == 2
 Y = privBinaryOp(n, a, 'symobj::vectorizeSpecfunc', 'laguerreL', 'undefined');
else % nargin == 3
 Y = privTrinaryOp(n,a,x, 'symobj::vectorizeSpecfunc', 'laguerreL', 'undefined');
end
end
