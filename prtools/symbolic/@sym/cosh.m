function Y = cosh(X)
%COSH   Symbolic hyperbolic cosine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'cosh');
end
