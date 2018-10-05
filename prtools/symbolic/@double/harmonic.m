function Y = harmonic(X)
% HARMONIC Harmonic function. 
%    Y = HARMONIC(X) is the harmonic function of X.
%    It is defined as
%    HARMONIC(x) = psi(x+1) + eulergamma.
%    See also PSI.

%   Copyright 2013 The MathWorks, Inc.
Y = sym.useSymForNumeric(@harmonic, X); 
end
