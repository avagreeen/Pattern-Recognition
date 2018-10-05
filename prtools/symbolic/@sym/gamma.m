function Y = gamma(X)
%GAMMA  Symbolic gamma function.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'gamma', 'infinity');
end
