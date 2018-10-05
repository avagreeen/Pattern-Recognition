function y = airy(k,x,scale)
%AIRY   Airy function.
%   W = AIRY(X) is the Airy function, Ai(x).
%
%   W = AIRY(0,X) is the same as AIRY(x).
%   W = AIRY(1,X) is the derivative, Ai'(x).
%   W = AIRY(2,X) is the Airy function of the second kind, Bi(x).
%   W = AIRY(3,X) is the derivative, Bi'(x).
%
%   W = AIRY(K,X,SCALE) returns a scaled AIRY(K,X) specified by SCALE:
%       0 - (default) is the same as AIRY(K,X)
%       1 - returns AIRY(K,X) scaled by EXP(2/3.*X.^(3/2)) for K = 0,1,
%           and scaled by EXP(-ABS(2/3.*REAL(X.^(3/2)))) for K = 2,3.

%   Copyright 2013-2015 The MathWorks, Inc.

if nargin == 1
    x = k;
    k = 0;
    scale = 0;
elseif nargin == 2
    scale = 0;
end
if ~(isscalar(scale) && (scale==0 || scale==1))
    error(message('symbolic:sym:airy:InvalidThirdArgument'));
end
if ~(isa(k,'sym') || isa(x,'sym'))
    y = airy(k,x,double(scale));
    return;
end 
if scale==0
    y = privBinaryOp(k, x, 'symobj::vectorizeSpecfunc', 'symobj::airy', 'infinity');
else
    y = privBinaryOp(k, x, 'symobj::vectorizeSpecfunc', 'symobj::scaledAiry', 'infinity');
end
end
