function Y = atanh(X)
%ATANH  Symbolic inverse hyperbolic tangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'atanh');
end
