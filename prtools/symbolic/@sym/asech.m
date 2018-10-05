function Y = asech(X)
%ASECH  Symbolic inverse hyperbolic secant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'asech', 'infinity');
end
