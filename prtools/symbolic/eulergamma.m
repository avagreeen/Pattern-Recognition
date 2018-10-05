function y = eulergamma
% EULERGAMMA  Euler-Mascheroni constant
%    EULERGAMMA represents the Euler-Mascheroni constant, which is defined 
%    as: 
%
%       eulergamma = limit(symsum(1/k,k,[1,n]) - log(n), n, inf)
%
%    The floating point value is 0.5772156649... 
%
%    For example, the Euler-Mascheroni constant plays a role in the 
%    definition of the hyperbolic cosine integral function coshint. 
%
%   See also PI, CHI, COSHINT.
 
%   Copyright 2013 The MathWorks, Inc.

y = feval(symengine,'EULER');
end
