function Y = abs(X)
%ABS    Absolute value.
%   ABS(X) is the absolute value of the elements of X. When
%   X is complex, ABS(X) is the complex modulus (magnitude) of
%   the elements of X.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'abs');
end
