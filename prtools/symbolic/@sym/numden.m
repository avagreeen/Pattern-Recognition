function [n,d] = numden(s)
%NUMDEN Numerator and denominator of a symbolic expression.
%   [N,D] = NUMDEN(A) converts each element of A to a rational 
%   form where the numerator and denominator are relatively prime 
%   polynomials with integer coefficients. 
%
%   Examples: 
%      [n,d] = numden(sym(4/5)) returns n = 4 and d = 5.
%      [n,d] = numden(x/y + y/x) returns
%         n = x^2+y^2 , d = y*x

%   Copyright 1993-2012 The MathWorks, Inc.

if builtin('numel',s) ~= 1,  s = normalizesym(s);  end
[n,d] = mupadmexnout('symobj::numden',s);
n = privResolveOutput(n, s);
d = privResolveOutput(d, s);
