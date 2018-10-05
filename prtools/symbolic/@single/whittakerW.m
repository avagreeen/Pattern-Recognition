function W = whittakerW(a,b,x)
%whittakerW Whittaker W function.
%   W = whittakerW(a,b,x) computes the value of the Whittaker W for
%   arguments a,b,x.
%
%   Reference:
%       [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 13",
%       Handbook of Mathematical Functions with Formulas, Graphs, and
%       Mathematical Tables, New York: Dover, pp. 504, 1965.

%   Copyright 2012 The MathWorks, Inc.

W = sym.useSymForNumeric(@whittakerW, a, b, x);
