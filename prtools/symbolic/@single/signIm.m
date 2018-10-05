function s=signIm(z)
% signIm - correction factor for sqrt(z.^2)/z
%
%  signIm(z) ==  1 if imag(z) > 0 or (imag(z) == 0 and real(z) < 0)
%  signIm(z) ==  0 if z == 0
%  signIm(z) == -1 otherwise

% Copyright 2014 The MathWorks, Inc.

s = -single(ones(size(z)));
s(imag(z) > 0) = 1;
s(imag(z) == 0 & real(z) < 0) = 1;
s(z == 0) = 0;
s(isnan(z)) = nan;
end
