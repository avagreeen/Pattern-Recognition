function y = ssinint(x)
% SSININT  The shifted sine integral 
%    SSININT(X) represents the shifted sine integral sinint(X)-pi/2. It 
%    returns the special values:
%
%       ssinint(0) = -pi/2,
%       ssinint(inf) = 0, 
%       ssinint(-inf) = -pi. 
%
%    The reflection rule ssinint(x) = -ssinint(-x)-pi is used if the 
%    argument is a negative integer or a negative rational number. It is 
%    also used if the argument is a symbolic product involving such a 
%    factor.
% 
%   See also SIN, SINH, SININT, SINHINT.
 
% Copyright 2013 The MathWorks, Inc.

y = privUnaryOp(x,'symobj::map','Ssi');
end
