function y = kummerU(a,b,x)
%KUMMERU    Kummer's confluent hypergeometric U function.
%   U = kummerU(a,b,x) computes the value of Kummer's U function
%     U = 1/gamma(a) * int(exp(-x*t)*t^(a-1)*(1+t)^(b-a-1),t,0,inf).

%   Copyright 2014 The MathWorks, Inc.

y = privTrinaryOp(a, b, x, 'symobj::vectorizeSpecfunc', 'kummerU', 'infinity');
end
