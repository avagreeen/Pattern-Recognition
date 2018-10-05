function Y = cot(X)
%COT    Symbolic cotangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'cot', 'infinity');
end
