function Y = acoth(X)
%ACOTH  Symbolic inverse hyperbolic cotangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'acoth', 'infinity');
end
