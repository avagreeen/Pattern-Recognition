function y = kummerU(a,b,x)
%KUMMERU    Kummer's confluent hypergeometric U function.
%   U = kummerU(a,b,x) computes the value of Kummer's U function
%     U = 1/gamma(a) * int(exp(-x*t)*t^(a-1)*(1+t)^(b-a-1),t,0,inf).
%
%   Reference:
%     [1] Abramowitz, Milton; Stegun, Irene A., eds., "Chapter 13",
%     Handbook of Mathematical Functions with Formulas, Graphs, and
%     Mathematical Tables, New York: Dover, pp. 504, 1965.

%   Copyright 2014 The MathWorks, Inc.

y = sym.useSymForNumeric(@kummerU, a, b, x);
end
