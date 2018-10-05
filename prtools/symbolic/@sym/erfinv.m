function Y = erfinv(X)
%Y = ERFINV(X) Inverse error function.
%
%   Reference:
%       [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 7",
%       Handbook of Mathematical Functions with Formulas, Graphs, and
%       Mathematical Tables, New York: Dover, 1965.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(X, 'symobj::map', 'inverf');
end
