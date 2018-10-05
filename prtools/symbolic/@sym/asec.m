function Y = asec(X)
%ASEC   Symbolic inverse secant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'asec', 'infinity');
end
