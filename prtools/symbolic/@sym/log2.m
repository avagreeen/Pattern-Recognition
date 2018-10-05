function Y = log2(X)
%LOG2   Symbolic matrix element-wise base-2 logarithm.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X,'symobj::vectorizeSpecfunc','log2','-infinity');
end
