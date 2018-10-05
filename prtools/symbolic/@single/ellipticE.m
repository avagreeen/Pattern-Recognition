function Y=ellipticE(varargin)
%ELLIPTICE  Elliptic integral of the second kind
%   Y = ellipticE(X) returns the complete elliptic integral of the second kind,
%   evaluated for each element of X.
%
%   Y = ellipticE(PHI, X) returns the incomplete elliptic integral of the second kind,
%   evaluated for each pair of elements of PHI and X.
%
%   See also SYM/ELLIPKE, SYM/ELLIPTICK, SYM/ELLIPTICCK, SYM/ELLIPTICCE,
%   SYM/ELLIPTICF, SYM/ELLIPTICPI, SYM/ELLIPTICCPI

% Copyright 2012 The MathWorks, Inc.
narginchk(1,3);
Y = sym.useSymForNumeric(@ellipticE, varargin{:});
