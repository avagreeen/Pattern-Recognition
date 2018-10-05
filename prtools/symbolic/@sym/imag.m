function Y = imag(Z)
%IMAG   Symbolic imaginary part.
%   IMAG(Z) is the imaginary part of a symbolic Z.

%   Copyright 2013 The MathWorks, Inc.

Y = privUnaryOp(Z, 'symobj::map', 'Im');
end
