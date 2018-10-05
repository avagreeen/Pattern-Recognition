function Y = tanh(X)
%TANH   Symbolic hyperbolic tangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'tanh');
end
