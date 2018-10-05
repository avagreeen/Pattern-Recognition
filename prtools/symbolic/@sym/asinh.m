function Y = asinh(X)
%ASINH  Symbolic inverse hyperbolic sine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'asinh');
end
