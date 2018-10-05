function h = hypergeom(n,d,z)
% HYPERGEOM  Generalized hypergeometric function.
% HYPERGEOM(N, D, Z) is the generalized hypergeometric function F(N, D, Z),
% also known as the Barnes extended hypergeometric function and denoted by
% jFk where j = length(N) and k = length(D).   For scalar a, b and c,
% HYPERGEOM([a,b],c,z) is the Gauss hypergeometric function 2F1(a,b;c;z).
%
% The definition by a formal power series is
%    hypergeom(N,D,z) = sum(k=0:inf, (C(N,k)/C(D,k))*z^k/k!) where
%    C(V,k) = prod(i=1:length(V), gamma(V(i)+k)/gamma(V(i)))
% Either of the first two arguments may be a vector providing the coefficient
% parameters for a single function evaluation.  If the third argument is a
% vector, the function is evaluated pointwise.  The result is numeric if all
% the arguments are numeric and symbolic if any of the arguments is symbolic.
% See Abramowitz and Stegun, Handbook of Mathematical Functions, chapter 15.
%
% Examples:
%    syms a z
%    hypergeom([],[],z)             returns   exp(z)
%    hypergeom(1,[],z)              returns   -1/(-1+z)
%    hypergeom(1,2,z)               returns   (exp(z)-1)/z
%    hypergeom([1,2],[2,3],z)       returns   -2*(-exp(z)+1+z)/z^2
%    hypergeom(a,[],z)              returns   (1-z)^(-a)
%    hypergeom([],1,-z^2/4)         returns   besselj(0,z)
%    hypergeom([-n, n],1/2,(1-z)/2) returns   T(n,z)    where
%    T(n,z) = expand(cos(n*acos(z))) is the n-th Chebyshev polynomial.

%   Copyright 2013 The MathWorks, Inc.

args = privResolveArgs(z, n, d);
hSym = mupadmex('symobj::map', args{1}.s, 'symobj::hypergeom',...
    args{2}.s, args{3}.s);
h = privResolveOutput(hSym, args{1});
end
