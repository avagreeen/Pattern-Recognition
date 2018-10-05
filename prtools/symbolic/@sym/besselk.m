function K = besselk(nu,Z)
%BESSELK Symbolic Bessel function, K(nu,z).

%   Copyright 2013 The MathWorks, Inc.

K = privBinaryOp(nu, Z, 'symobj::vectorizeSpecfunc', 'besselk', 'infinity');
end
