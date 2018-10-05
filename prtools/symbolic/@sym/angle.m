function X = angle(Z)
%ANGLE   Symbolic polar angle.
%   ANGLE(Z) is the polar angle of a symbolic Z.

%   Copyright 2013 The MathWorks, Inc.

X = privUnaryOp(Z, 'symobj::map', 'angle');
end
