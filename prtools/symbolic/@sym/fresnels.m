function Y = fresnels(X)
% FRESNELS Fresnel sine integral.
%    Y = FRESNELS(X) is the Fresnel sine integral of X.
%    It is defined as:
%    FRESNELS(x) = integral from 0 to x of sin(pi*t^2 / 2) dt 
%    See also FRESNELC.

%   Copyright 2013 The MathWorks, Inc.
Y = privUnaryOp(X, 'symobj::map', 'fresnelS');
end