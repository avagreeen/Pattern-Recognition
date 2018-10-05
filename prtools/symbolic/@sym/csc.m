function Y = csc(X)
%CSC    Symbolic cosecant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::vectorizeSpecfunc', 'csc', 'infinity');
end
