function [Y,I] = sort(X,dim,mode)
%SORT Sort symbolic arrays.
%   Y = SORT(X) sorts the elements of a symbolic vector X
%   in numerical or lexicographic order.
%   For matrices, SORT(X) sorts each column of X in ascending order.
%
%   [Y,I] = SORT(X) sorts X and returns the array I such that X(I)=Y.
%   If X is a vector, then Y = X(I).  
%   If X is an m-by-n matrix and DIM=1, then
%       for j = 1:n, Y(:,j) = X(I(:,j),j); end
%
%   Y = SORT(X,DIM,MODE)
%   has two optional parameters.  
%   DIM selects a dimension along which to sort.
%   MODE selects the direction of the sort
%      'ascend' results in ascending order
%      'descend' results in descending order
%   The result is in Y which has the same shape and type as X.
%
%   Examples:
%      syms a b c d e x
%      sort([a c e b d]) = [a b c d e]
%      sort([a c e b d]*x.^(0:4).') = 
%         d*x^4 + b*x^3 + e*x^2 + c*x + a
%
%   See also SYM/SYM2POLY, SYM/COEFFS.

%   Copyright 1993-2014 The MathWorks, Inc.

if ~isa(X, 'sym')
    if nargin == 3 && isa(mode, 'sym')
        error(message('symbolic:sort:UnknownMode'));
    end
    % Because overloading occurred, dim must be a sym
    dim = double(dim);
    if nargin == 2
        if nargout == 2
            [Y, I] = sort(X, dim);
        else    
            Y = sort(X, dim);
        end
    else
        if nargout == 2
            [Y, I] = sort(X, dim, mode);
        else    
            Y = sort(X, dim, mode);
        end
    end
    return
end    
            
Xsym = privResolveArgs(X);
X = Xsym{1};

if nargout > 1
    inds = 'TRUE';
else
    inds = 'FALSE';
end
gotModeAsSecondInput = false;
if nargin == 2 && isa(dim,'char')
    mode = dim;
    gotModeAsSecondInput = true;
    dim = '"Auto"';
elseif nargin < 2 
    dim = '"Auto"';
else
    dim = double(dim);
    if ~(isscalar(dim) && isreal(dim) && dim == round(dim) && ... 
             dim > 0) || ~isfinite(dim) 
        error(message('symbolic:sym:SecondArgumentPositiveInteger'))
    end
    dim = num2str(dim);
end
if nargin < 3 && ~gotModeAsSecondInput
    mode = 'TRUE';
else
    try 
        mode = validatestring(mode, {'ascend','descend'});
    catch err
        error(message('symbolic:sort:UnknownMode'));
    end
    if strcmp(mode,'ascend') 
        mode = 'TRUE';
    else
        mode = 'FALSE';
    end
end
[Ysym,Isym] = mupadmexnout('symobj::sort',X,dim,mode,inds);
if nargout > 1
    I = double(Isym);
end
Y = privResolveOutput(Ysym, X);
