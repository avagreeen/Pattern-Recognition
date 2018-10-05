function y = dawson(x)
% DAWSON  Dawson's integral
%    Y = DAWSON(X) represents Dawson's integral, which is defined as: 
% 
%       dawson(x) = exp(-x^2)*int(exp(t^2),t,[0,x]).
%
%    It returns the special values  
%
%       dawson(0) = 0,
%       dawson(inf) = 0,
%       dawson(-inf) = 0. 
%
%    For all other symbolic values of x, unevaluated function calls are 
%    returned.
%
%   See also ERF, ERFC.
 
%   Copyright 2013 The MathWorks, Inc.

y = privUnaryOp(x,'symobj::map','dawson');
end
