function Y = csch(X)
%CSCH   Symbolic hyperbolic cosecant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'csch', 'infinity');
end
