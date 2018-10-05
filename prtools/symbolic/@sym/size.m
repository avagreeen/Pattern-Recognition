function [varargout] = size(x,n)
%SIZE Size of a sym array.
%   D = SIZE(A), for an M-by-N sym matrix A, returns the two-element
%   row vector D = [M,N] containing the number of rows and columns in the
%   matrix.  For N-D sym arrays, SIZE(A) returns a 1-by-N vector of
%   dimension lengths.  Trailing singleton dimensions are ignored.
%
%   [M,N] = SIZE(A), for a sym matrix A, returns the number of rows
%   and columns in A as separate output variables. 
%   
%   [M1,M2,M3,...,MN] = SIZE(A), for N>1, returns the sizes of the first N 
%   dimensions of the sym array A.  If the number of output arguments
%   N does not equal NDIMS(A), then for:
%
%   N > NDIMS(A), SIZE returns ones in the "extra" variables, i.e., outputs
%                 NDIMS(A)+1 through N.
%   N < NDIMS(A), MN contains the product of the sizes of dimensions N
%                 through NDIMS(A).
%  
%   M = SIZE(A,DIM) returns the length of the dimension specified by the
%   scalar DIM.  For example, SIZE(A,1) returns the number of rows. If DIM >
%   NDIMS(A), M will be 1.
%
%   See also SYM.

%   Copyright 2008-2014 The MathWorks, Inc.

if nargin == 2 && isa(n, 'sym')
    n = double(n);
    [varargout{1:nargout}] = size(x, n);
    return
end    

xsym = privResolveArgs(x);
x = formula(xsym{1});
cc = mupadmex('symobj::size', x.s, 0);
sz = eval(cc);
if nargin == 2
    if nargout > 1
        error(message('MATLAB:TooManyOutputs'));
    end
    validateattributes(n, {'numeric'}, {'positive', 'integer'}, 2);
    if n > length(sz)
        sz = 1;
    else
        sz = sz(n);
    end
end
if nargout > 1
    varargout = cell(1,nargout);
    for k = 1:nargout
        if k > length(sz)
            varargout{k} = 1;
        else
            varargout{k} = sz(k);
        end
    end
    if nargout < length(sz)
        varargout{end} = prod(sz(nargout:end));
    end
else
    varargout{1} = sz;
end

