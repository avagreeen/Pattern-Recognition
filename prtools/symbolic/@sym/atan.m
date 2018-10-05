function Z = atan(Y,X)
%ATAN   Symbolic inverse tangent.
%       With two arguments, ATAN(Y,X) is the symbolic form of ATAN2(Y,X).

%   Copyright 2013 The MathWorks, Inc.

if nargin == 1
    Z = privUnaryOp(Y, 'symobj::map', 'atan');
else
    Z = privBinaryOp(Y, X, 'symobj::atan2');
end
end
