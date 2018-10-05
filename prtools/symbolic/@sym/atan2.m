function Z = atan2(Y,X)
%ATAN2  Symbolic four quadrant inverse tangent

%   Copyright 2013 The MathWorks, Inc.

Z = privBinaryOp(Y, X, 'symobj::atan2');
end
