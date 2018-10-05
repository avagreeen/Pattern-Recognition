function Y = sinh(X)
%SINH   Symbolic hyperbolic sine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'sinh');
end
