function Y = fresnelc(X)
% FRESNELC Fresnel cosine integral.
%    Y = FRESNELC(X) is the Fresnel cosine integral of X.
%    It is defined as:
%    FRESNELC(x) = integral from 0 to x of cos(pi*t^2 / 2) dt 
%    See also FRESNELS.

%   Copyright 2013 The MathWorks, Inc.
Y = privUnaryOp(X, 'symobj::map', 'fresnelC');
end