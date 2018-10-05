function s = sum(A,varargin)
%SUM    Sum of the elements.
%   For vectors, SUM(X) is the sum of the elements of X.
%   For matrices, SUM(X) or SUM(X,1) is a row vector of column sums
%   and SUM(X,2) is a column vector of row sums.
%
%   See also SYM/PROD.

%   Copyright 2013-2014 The MathWorks, Inc.

narginchk(1,3);

style = 'native';
lastarg = nargin;
dim = 1;
dimGiven = false;

if lastarg > 1 && ischar(varargin{lastarg-1})
    style = validatestring(varargin{lastarg-1}, {'native', 'double', 'default'}, lastarg);
    lastarg = lastarg-1;
end

if lastarg == 2
    dimGiven = true;
    dim = varargin{1};
    if isa(dim,'sym')
        s = sum(A, double(dim), style);
        return
    end
    if ~(isscalar(dim) && isreal(dim) && dim == round(dim) && ...
             dim >= 0) || ~isfinite(dim)
        error(message('symbolic:sym:SecondArgumentPositiveInteger'))
    end
    dA = ndims(A);
    if isa(A, 'sym')
        dA = ndims(formula(A));
    end
    if dim > dA && ~strcmp(style, 'double')
        s = A;
        return
    end
end

if isempty(A) || strcmp(style, 'double')
    if dimGiven
        s = sum(double(A),dim,style);
    else
        s = sum(double(A),style);
    end
    if ~strcmp(style,'double')
        s = sym(s);
    end
elseif dimGiven
    s = privUnaryOp(A, 'symobj::prodsumdim', num2str(dim), '_plus');
else
    s = privUnaryOp(A, 'symobj::prodsum', '_plus');
end
end
