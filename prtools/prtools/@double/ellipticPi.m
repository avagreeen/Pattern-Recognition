function Y=ellipticPi(varargin)
%ELLIPTICPI  Elliptic integral of the third kind
%   Y = ellipticPi(N, M) returns the complete elliptic integral of the third kind,
%   evaluated for each pair of elements of N and M.
%
%   Y = ellipticPi(N, PHI, M) returns the incomplete elliptic integral of the third kind,
%   evaluated for each three-tuple of elements of N, PHI and M.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICK, SYM/ELLIPTICE, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICCPI

% Copyright 2012, The MathWorks, Inc.
narginchk(2,3);
Y = sym.useSymForNumeric(@ellipticPi, varargin{:});
