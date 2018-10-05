function y = numel(x,varargin)
%NUMEL Number of elements in a sym array.
%   N = NUMEL(A) returns the number of elements in the sym array A.
%
%   See also SYM, SIZE.

%   Copyright 2008-2013 The MathWorks, Inc.

if nargin>1 % numel(x,1,2) is used internally to find the size of x(1,2). We ignore symfun until we need it.
	y=1;
	return
end

xsym = privResolveArgs(x);
x = xsym{1};
y = eval(mupadmex('symobj::numel', x.s, 0));
