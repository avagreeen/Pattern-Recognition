function Y = acsch(X)
%ACSCH  Symbolic inverse hyperbolic cosecant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'acsch', 'infinity');
end
