function Y = log10(X)
%LOG10  Symbolic matrix element-wise common logarithm.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X,'symobj::vectorizeSpecfunc','log10','-infinity');
end
