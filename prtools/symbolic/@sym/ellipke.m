function [K,E]=ellipke(X)
%ELLIPKE Complete elliptic integrals of the first and second kind
%  [K,E] = ellipke(X) returns the complete elliptic integrals of the first
%   and second kinds, evaluated for each element of X.
%
%  See also SYM/ELLIPTICE, SYM/ELLIPTICK

%   Copyright 2013 The MathWorks, Inc.

K = ellipticK(X);
if nargout > 1
    E = ellipticE(X);
end
end
