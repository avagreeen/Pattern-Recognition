function y = catalan
% CATALAN  Catalan's constant
%    CATALAN represents Catalan's constant, which is defined 
%    as: 
%
%       catalan = symsum((-1)^k / (2*k + 1)^2, k, [0,inf])
%
%    The floating point value is 0.9159655942... 
%
%
%   See also EULERGAMMA.
 
%   Copyright 2013 The MathWorks, Inc.

y = feval(symengine, 'CATALAN');
end