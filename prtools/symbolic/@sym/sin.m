function Y = sin(X)
%SIN    Symbolic sine function.
       
%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'sin');
end
