function Y = asin(X)
%ASIN   Symbolic inverse sine.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'asin');
end
