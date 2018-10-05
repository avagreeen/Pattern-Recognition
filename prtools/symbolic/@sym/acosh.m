function Y = acosh(X)
%ACOSH  Symbolic inverse hyperbolic cosine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'acosh');
end
