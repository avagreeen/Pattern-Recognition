function Y = tan(X)
%TAN    Symbolic tangent function.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'tan', 'infinity');
end
