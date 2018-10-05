function c = nchoosek(n,k)
%NCHOOSEK Binomial coefficient or all combinations.
%    NCHOOSEK(N,K) where N and K are scalars returns N!/K!(N-K)!.
%
%    NCHOOSEK(V,K) returns a matrix containing all possible combinations 
%    of the elements of vector V taken K at a time. K must be a
%    non-negative integer.
%    The result has K columns and NCHOOSEK(N, K) rows, where N is length(V).

%   Copyright 2011-2015 The MathWorks, Inc.
    

if ~isa(n, 'sym') && ~isscalar(n)
    c = nchoosek(n, double(k));
    return;
end    

N = formula(sym(n));
K = formula(sym(k));

if isscalar(N)
    args = privResolveArgs(n, k);
    if ~isscalar(K) 
        error(message('symbolic:sym:nchoosek:SecondArgumentMustBeScalar'));
    end
    cSym = binomial(N, K);
else
    args = privResolveArgs(n);
    if ~isPositiveInteger(K) && ~isequal(K, sym(0))
        error(message('symbolic:sym:nchoosek:SecondArgumentMustBeNonNegInt'));
    end    
    if ~isvector(N) 
        error(message('symbolic:sym:nchoosek:FirstArgumentMustBeScalarOrVector'));
    end    
    cSym = subwords(N, K);
end
 c = privResolveOutput(cSym, args{1});


function cSym = binomial(N, K)    
if N == sym(inf) 
    % for compatibility with doubles
    if K == sym(0) 
        cSym = sym(1);
    elseif K == sym(1)
        cSym = sym(inf);
    else
        cSym = sym(NaN);
    end    
elseif ~isfinite(N) || ~isfinite(K)
    cSym = sym(NaN);
else
    cSym = mupadmex('binomial', N.s, K.s);
end    

function cSym = subwords(N, K)
N = feval(symengine, 'symobj::tolist', N);
cSym = feval(symengine, 'combinat::subwords', N, K);
cSym = feval(symengine, 'matrix', numel(cSym), K, cSym);


