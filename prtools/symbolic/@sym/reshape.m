function y = reshape(x,varargin)
%RESHAPE Change size of symbolic array.
%    RESHAPE(X,M,N) returns the M-by-N matrix whose elements
%    are taken columnwise from X.  An error results if X does
%    not have M*N elements.
%
%    RESHAPE(X,M,N,P,...) returns an N-D array with the same
%    elements as X but reshaped to have the size M-by-N-by-P-by-...
%    M*N*P*... must be the same as PROD(SIZE(X)).
%
%    RESHAPE(X,[M N P ...]) is the same thing.
%
%    RESHAPE(X,...,[],...) calculates the length of the dimension
%    represented by [], such that the product of the dimensions
%    equals PROD(SIZE(X)). PROD(SIZE(X)) must be evenly divisible
%    by the product of the known dimensions. You can use only one
%    occurrence of [].
%
%    In general, RESHAPE(X,SIZ) returns an N-D array with the same
%    elements as X but reshaped to the size SIZ.  PROD(SIZ) must be
%    the same as PROD(SIZE(X)).
%
%    See also SQUEEZE, SHIFTDIM, COLON.

%   Copyright 2009-2013 The MathWorks, Inc.

narginchk(2,inf);
args = cellfun(@double, varargin, 'UniformOutput', false);

if ~isa(x, 'sym')
    % overloading by dimension argument
    % all dimensions have been converted to double now, 
    % call built-in reshape
    y = reshape(x, args{:});
    return;
end    
    
xsym = privResolveArgs(x);
x = xsym{1};

if nargin > 2 && any(cellfun(@numel,args) > 1)
    error(message('MATLAB:checkDimScalar:scalarSize'));
end

args = cellfun(@checkArg,args,'UniformOutput',false);

if numel(find(cellfun(@(x) isequal(x,'#COLON'),args))) > 1
    error(message('MATLAB:getReshapeDims:unknownDim'));
end
ySym = mupadmex('symobj::reshape',x.s,args{:});
y = privResolveOutput(ySym, x);

function arg = checkArg(arg)
    if isempty(arg)
        arg = '#COLON';
    else
        if ~all(isreal(arg) & arg == round(arg))
            error(message('symbolic:reshape:BadDim'));
        end
        if isscalar(arg)
            arg = int2str(arg);
        elseif ~isrow(arg)
            error(message('symbolic:reshape:VectorShape'));
        else
            arg = num2str(arg(:).','%d,');
            arg = ['[' arg(1:end-1) ']'];
        end
    end
