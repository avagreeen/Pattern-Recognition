function Y = igamma(nu,Z)
%IGAMMA   Incomplete gamma function.
%   IGAMMA(nu,z) is the incomplete gamma function defined by
%    IGAMMA(nu,z) = integral from z to infinity of t^(nu-1)*exp(-t) dt.
%
%    See also GAMMAINC.
%
%   Copyright 2013 The MathWorks, Inc.

Y = privBinaryOp(nu, Z, 'symobj::vectorizeSpecfunc', 'igamma', 'infinity');
end
