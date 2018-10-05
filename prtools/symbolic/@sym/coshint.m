function y = coshint(x)
% COSHINT  Hyperbolic cosine integral function
%    Y = COSHINT(X) represents the hyperbolic cosine integral function, 
%    which is defined as: 
%
%       coshint(x) = eulergamma + log(x) + int((cosh(t)-1)/t,t,[0,x])
%
%    Here eulergamma denotes the Euler-Mascheroni constant. 
%    coshint(x) returns the special values 
%    
%       coshint(inf) = inf, 
%       coshint(-inf) = inf + i*pi, 
%       coshint(i*inf) = i*pi/2, 
%       coshint(-i*inf) = -i*pi/2.
%  
%    For all other symbolic arguments COSHINT returns symbolic function 
%    calls.  
%
%   See also COS, COSH, COSINT, SINHINT, SSININT.
 
%   Copyright 2013 The MathWorks, Inc.

y = privUnaryOp(x,'symobj::vectorizeSpecfunc','Chi','-infinity');
end
