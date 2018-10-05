function I = besseli(nu,Z)
%BESSELI Symbolic Bessel function, I(nu,z).

%   Copyright 2013 The MathWorks, Inc.

I = privBinaryOp(nu, Z, 'symobj::vectorizeSpecfunc', 'besseli', 'infinity');
end
