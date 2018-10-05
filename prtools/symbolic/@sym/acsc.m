function Y = acsc(X)
%ACSC   Symbolic inverse cosecant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'acsc', 'infinity');
end
