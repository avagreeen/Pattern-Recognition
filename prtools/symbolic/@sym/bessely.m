function Y = bessely(nu,Z)
%BESSELY Symbolic Bessel function, Y(nu,z).

%   Copyright 2013 The MathWorks, Inc.

Y = privBinaryOp(nu, Z, 'symobj::vectorizeSpecfunc', 'bessely', 'infinity');
end
