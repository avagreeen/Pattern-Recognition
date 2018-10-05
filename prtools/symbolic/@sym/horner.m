function r = horner(p)
%HORNER Horner polynomial representation.
%   HORNER(P) transforms the symbolic polynomial P into its Horner,
%   or nested, representation.
%
%   Example:
%       horner(x^3-6*x^2+11*x-6) returns
%           x*(x*(x-6)+11)-6
%
%   See Also SIMPLIFY, FACTOR, COLLECT, SUBS.

%   Copyright 1993-2011 The MathWorks, Inc.

r = privUnaryOp(p, 'symobj::map', 'symobj::horner');
