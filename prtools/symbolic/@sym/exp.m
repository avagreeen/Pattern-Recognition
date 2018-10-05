function Y = exp(X)
%EXP    Symbolic matrix element-wise exponentiation.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'exp');
end
