function y = gammaln(x)
% GAMMALN  Logarithmic gamma function
%    Y = GAMMALN(X) represents the logarithmic gamma function 
%    LOG(GAMMA(X)). 
%
%    The logarithmic gamma function is defined for all complex arguments 
%    apart from the singular points 0, - 1, - 2, ... 
%    For these points, gammaln returns positive infinity. 
%   
%    Along the positive real semi axis, the logarithmic gamma function
%    gammaln(x) coincides with the logarithm log(gamma(x)) of the gamma 
%    function. For negative or general complex arguments x, however, one 
%    has gammaln(x) = log(gamma(x)) + f(x)*2*pi*i with some integer valued 
%    function f(x). The integer multiples of 2*pi*i are chosen such that
%    gammaln is analytic throughout the complex plane with a branch cut
%    along the negative real semi axes. For negative real x, the value 
%    gammaln(x) coincides with the limit "from above".
%
%   See also LOG, GAMMA. 
 
% Copyright 2013 The MathWorks, Inc.

y = privUnaryOp(x, 'symobj::vectorizeSpecfunc', 'lngamma', 'infinity'); 
end
