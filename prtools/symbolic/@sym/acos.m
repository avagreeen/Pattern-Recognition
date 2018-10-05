function Y = acos(X)
%ACOS   Symbolic inverse cosine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'acos');
end