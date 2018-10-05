function Z = pochhammer(X,K)
%POCHHAMMER  The Pochhammer symbol
%
%  POCHHAMMER(X,K) = GAMMA(X+K)./GAMMA(X), continuously extended

%   Copyright 2014 The MathWorks, Inc.

Z = privBinaryOp(X, K, 'symobj::vectorizeSpecfunc', 'pochhammer', 'infinity');
end
