function Y = sqrt(X)
%SQRT   Symbolic matrix element-wise square root.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'sqrt');
end
