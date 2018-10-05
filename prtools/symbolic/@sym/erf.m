function Y = erf(X)
%ERF    Symbolic error function.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'erf');
end
