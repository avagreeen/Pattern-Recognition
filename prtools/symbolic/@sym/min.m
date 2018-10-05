function [C,I] = min(X,Y,dim)
%MIN    Symbolic minimum computation.
%   C = min(X) (X must be a SYM with all entries being convertible to  
%               floating-point numbers) 
%   If X is a vector, min(X) returns the smallest element in X.
%   If X is a matrix, min(X) treats the columns of X as vectors, returning 
%   a row vector containing the minimum element from each column. 
%   The case of X being a multi-dimensional array is not supported. 
%
%   C = min(X,[],dim) (X must be a SYM with all entries being convertible 
%                      to floating-point numbers and dim must be a positive 
%                      integer)
%   Returns the smallest elements along the dimension of X specified by 
%   scalar dim. For example, min(X,[],1) produces the minimum values along 
%   the first dimension of X. The case of X being a multi-dimensional array 
%   is not supported. 
%
%   [C,I] = min(...) finds the indices of the minimum values of X (with all 
%   entries being convertible to floating-point numbers), and returns them 
%   in output vector I. If there are several identical minimum values, the 
%   index of the first one found is returned. The case of X being a 
%   multi-dimensional array is not supported.
%
%   C = min(X,Y) (X,Y must be SYMs with all entries being convertible to 
%                 floating-point numbers)
%   Returns a result of the same size as X and Y with the smallest elements 
%   taken from X or Y. The dimensions of X and Y must match, or they may be 
%   scalar! The case of X or Y being multi-dimensional arrays is not 
%   supported.
%
%   Special cases: 
%      When X is complex, the minimum is computed using the magnitude
%      min(abs(X)). In the case of equal magnitude elements, then the phase
%      angle min(angle(X)) is used.
%
%%  See also MIN, MAX, MEDIAN, MEAN, SORT.
 
%   Copyright 2013-2015 The MathWorks, Inc.

narginchk(1,3);

if nargin > 2 
    if ~isempty(Y) 
        error(message('symbolic:sym:min:SecondArgumentMustBeEmpty'));
    end
    if isa(dim, 'sym') && ~isa(X, 'sym') && ~isa(Y, 'sym')
        dim = double(dim);
        if nargout <= 1
            C = min(X, Y, dim);
        else
            [C, I] = min(X, Y, dim);
        end
        return;
    end        
end

if nargin == 2 
    if nargout > 1 
        error(message('symbolic:sym:min:TwoInputsTwoOutputsNotSupported'));
    end
    args = privResolveArgs(X,Y);
    Xsym = formula(args{1});
    Ysym = formula(args{2});
    if isscalar(Xsym) && ~isscalar(Ysym)
        Xsym = Xsym*ones(size(Ysym));
    elseif isscalar(Ysym) && ~isscalar(Xsym)
        Ysym = Ysym*ones(size(Xsym));
    elseif ~isequal(size(Xsym),size(Ysym)) 
        error(message('symbolic:sym:min:DimensionsMustAgree'));
    end
    
else
    args = privResolveArgs(sym(X));
    Xsym = formula(args{1});
    Ysym = sym([]);
end

if nargin < 3
    sz = size(Xsym);
    dim = find(sz ~= 1,1,'first'); 
    if isempty(dim)
        dim = 2;
    end
    dim = sym(dim);
elseif ischar(dim) 
    error(message('symbolic:sym:min:StringThirdInputNotSupported'));
else 
    dim = sym(dim);
    dim = feval(symengine, 'specfunc::makeInteger', dim);
end

if ~ismatrix(Xsym) || ~ismatrix(Ysym)
    error(message('symbolic:sym:min:HigherDimensionsNotSupported')); 
end

if strcmp(mupadmex('symobj::isfloatable',Xsym.s,0),'FALSE') || ...
        strcmp(mupadmex('symobj::isfloatable',Ysym.s,0),'FALSE') 
    error(message('symbolic:sym:min:InputsMustBeConvertibleToFloatingPointNumbers'));
end    

if nargin == 3 && strcmp(mupadmex('testtype',dim.s,'Type::PosInt',0),'FALSE')
    error(message('symbolic:sym:min:InvalidDimensionFlag'));
end

if ischar(X) 
    error(message('symbolic:sym:min:StringFirstInputNotSupported'));
end

if ndims(Xsym) < dim 
    C = Xsym;
    C = privResolveOutput(C,args{1});
    I = ones(size(Xsym));
    return
end    

if isempty(X) 
    if nargin == 1
        [C,I] = min(double(X));
    elseif nargin == 2 
        C = min(double(X),zeros(size(Ysym)));
    else 
        [C,I] = min(double(X),zeros(size(Ysym)),double(dim));
    end
    C = sym(C);
else 
    [C,I] = mupadmexnout('symobj::maxmin',Xsym,Ysym,dim,'min');    
    I = double(I);
end

C = privResolveOutput(C,args{1});
end

