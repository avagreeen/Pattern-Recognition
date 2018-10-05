function Y = pochhammer(X,K)
%POCHHAMMER  The Pochhammer symbol
%   POCHHAMMER(X,K) is the continuous continuation of GAMMA(X+K)./GAMMA(X)

%   Copyright 2014 The MathWorks, Inc.

Y = sym.useSymForNumeric(@pochhammer, X, K);
end
