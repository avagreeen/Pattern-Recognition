function y = sinhint(x)
% SINHINT  Hyperbolic sine integral function
%    Y = SINHINT(X) represents the hyperbolic sine integral function, which
%    is defined as: 
%
%       sinhint(x) = int(sinh(t)/t,t,[0,x])
%
%    sinhint(x) returns the special values: 
%     
%       sinhint(0) = 0, 
%       sinhint(inf) = inf, 
%       sinhint(-inf) = -inf. 
% 
%    For all other symbolic arguments, sinhint returns symbolic function 
%    calls.
%
%   See also SIN, SINH, SININT, SSININT. 
 
% Copyright 2013 The MathWorks, Inc.

y = privUnaryOp(x,'symobj::map','Shi');
end
