function Y = sec(X)
%SEC    Symbolic secant.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X,'symobj::vectorizeSpecfunc','sec','infinity');
end
