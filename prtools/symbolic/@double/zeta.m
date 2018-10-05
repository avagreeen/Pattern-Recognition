function Z = zeta(varargin)
%ZETA   Symbolic Riemann zeta function.
%   ZETA(z) = symsum(1/k^z,k,1,inf).
%   ZETA(n,z) = n-th derivative of ZETA(z)

%   Copyright 2012 The MathWorks, Inc.
narginchk(1,2);
Z = sym.useSymForNumeric(@zeta, varargin{:});
