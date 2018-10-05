function n = ndims(x)
%NDIMS   Number of dimensions in symbolic array.
%    N = NDIMS(X) returns the number of dimensions in the sym array X.
%    The number of dimensions in an array is always greater than
%    or equal to 2.  Trailing singleton dimensions are ignored.
%    Put simply, it is LENGTH(SIZE(X)).
%
%    See also SIZE, SYM.

%   Copyright 2013 The MathWorks, Inc.

n = length(size(x));
end
