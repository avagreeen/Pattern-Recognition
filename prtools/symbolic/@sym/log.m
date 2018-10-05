function Y = log(X)
%LOG    Symbolic matrix element-wise natural logarithm.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'log', '-infinity');
end
