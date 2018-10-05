function r = cumsumprod(op, A, varargin)
%CUMSUMPROD   Symbolic cumulative sum or product of elements.
%   CUMSUMPROD('_plus', ...) computes CUMSUM(...)
%   CUMSUMPROD ('_mult', ...) computes CUMPROD(...)

%   Copyright 2014 The MathWorks, Inc. 

% cumsum and cumprod have checked that nargin >= 2 and nargin <= 4
switch nargin
    case 2
        dim = 0;
        direction = 'Forward';
    case 3
        if isa(varargin{1}, 'char')
            dim = 0;
            direction = validatestring(varargin{1}, {'Forward','Reverse'});
        else    
            dim = checkdim(varargin{1});
            direction = 'Forward';
        end    
    case 4
        dim = checkdim(varargin{1});
        direction = validatestring(varargin{2}, {'Forward','Reverse'});
end    

if ~isa(A, 'sym')
    if strcmp(op, '_plus')
        r = cumsum(A, double(dim), direction);
    else
        r = cumprod(A, double(dim), direction);
    end
    return;
end    
        
dim = sym(dim);
Asym = formula(A);
if length(size(Asym)) > 2
    error(message('symbolic:sym:cumsumprod:VectorsAndMatrices'));
end

r = mupadmex('symobj::cumsumprod',Asym.s,dim.s,op,direction);
r = privResolveOutput(r, A);


% checkdim - checks whether n is a valid dimension
function N = checkdim(n)
if isa(n, 'sym') 
    n = feval(symengine, 'specfunc::makeInteger', formula(n));
    if ~strcmp(mupadmex('testtype',n.s,'Type::PosInt',0),'TRUE')
        error(message('symbolic:sym:cumsumprod:InvalidDimensionFlag'));
    end
else 
    if ~(isscalar(n) && isnumeric(n) && n==round(n) && n > 0 && isfinite(n))
        error(message('symbolic:sym:cumsumprod:InvalidDimensionFlag'));
    end    
end    
N = n;