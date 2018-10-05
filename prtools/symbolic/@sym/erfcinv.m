function Y = erfcinv(X)
%Y = ERFCINV(X) Inverse complementary error function.
%
%   Reference:
%       [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 7",
%       Handbook of Mathematical Functions with Formulas, Graphs, and
%       Mathematical Tables, New York: Dover, 1965.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'inverfc');
end
