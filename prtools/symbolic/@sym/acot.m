function Y = acot(X)
%ACOT   Symbolic inverse cotangent.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'acot');
end
