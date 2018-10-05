function p = prod(A,varargin)
%PROD   Product of the elements.
%   For vectors, PROD(X) is the product of the elements of X.
%   For matrices, PROD(X) or PROD(X,1) is a row vector of column products
%   and PROD(X,2) is a column vector of row products.
%
%   See also SYM/SUM.

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
    if isa(dim, 'sym') 
        p = prod(A, double(dim), style);
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
        p = A;
        return
    end
end

if isempty(A) || strcmp(style,'double')
    if dimGiven
        p = prod(double(A),dim,style);
    else
        p = prod(double(A),style);
    end
    if ~strcmp(style,'double')
        p = sym(p);
    end
elseif dimGiven
    p = privUnaryOp(A, 'symobj::prodsumdim', num2str(dim), '_mult');
else
    p = privUnaryOp(A, 'symobj::prodsum', '_mult');
end
end
