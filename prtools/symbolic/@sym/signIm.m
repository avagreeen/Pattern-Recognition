function s=signIm(z)
% signIm - correction factor for sqrt(z.^2)/z
%
%  signIm(z) ==  1 if imag(z) > 0 or (imag(z) == 0 and real(z) < 0)
%  signIm(z) ==  0 if z == 0
%  signIm(z) == -1 otherwise

% Copyright 2014 The MathWorks, Inc.

s = privUnaryOp(z, 'symobj::map', 'signIm');
end
