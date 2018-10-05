function M = whittakerM(a,b,x)
%whittakerM Whittaker M function.
%   M = whittakerM(a,b,x) computes the value of the Whittaker M function
%   for the arguments a,b,x.
%
%   Reference:
%       [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 13",
%       Handbook of Mathematical Functions with Formulas, Graphs, and
%       Mathematical Tables, New York: Dover, pp. 504, 1965.

%   Copyright 2012 The MathWorks, Inc.

M = sym.useSymForNumeric(@whittakerM, a, b, x);
