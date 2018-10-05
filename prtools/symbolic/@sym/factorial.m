function c = factorial(n)
%C = FACTORIAL(N) Factorial of symbolic argument N.

%   Copyright 2011 The MathWorks, Inc.

c = privUnaryOp(n, 'symobj::map', 'fact');
