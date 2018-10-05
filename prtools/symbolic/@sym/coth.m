function Y = coth(X)
%COTH   Symbolic hyperbolic cotangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'coth', 'infinity');
end
