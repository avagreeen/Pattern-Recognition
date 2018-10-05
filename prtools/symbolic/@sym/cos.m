function Y = cos(X)
%COS    Symbolic cosine function.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'cos');
end
