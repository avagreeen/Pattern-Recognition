function X = real(Z)
%REAL   Symbolic real part.
%   REAL(Z) is the real part of a symbolic Z.

%   Copyright 2013 The MathWorks, Inc.

X = privUnaryOp(Z, 'symobj::map', 'Re');
end
