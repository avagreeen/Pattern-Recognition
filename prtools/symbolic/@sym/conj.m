function X = conj(Z)
%CONJ   Symbolic conjugate.
%   CONJ(Z) is the conjugate of a symbolic Z.

%   Copyright 2013 The MathWorks, Inc.

X = privUnaryOp(Z, 'conjugate');
end
