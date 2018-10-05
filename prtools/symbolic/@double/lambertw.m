function W = lambertw(varargin)
%LAMBERTW Lambert's W function.
%   W = LAMBERTW(X) is the solution to w*exp(w) = x.
%   W = LAMBERTW(K,X) is the K-th branch of this multi-valued function.
%   Reference: Robert M. Corless, G. H. Gonnet, D. E. G. Hare,
%   D. J. Jeffrey, and D. E. Knuth, "On the Lambert W Function",
%   Advances in Computational Mathematics, volume 5, 1996, pp. 329-359.

%   More information available from:
%   http://www.apmaths.uwo.ca/~rcorless/frames/PAPERS/LambertW

%   Copyright 2012 The MathWorks, Inc.
narginchk(1,2);
W = sym.useSymForNumeric(@lambertw, varargin{:});
