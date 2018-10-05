function Y = sech(X)
%SECH   Symbolic hyperbolic secant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X,'symobj::vectorizeSpecfunc','sech','infinity');
end
