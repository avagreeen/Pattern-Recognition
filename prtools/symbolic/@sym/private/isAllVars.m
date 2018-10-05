function res = isAllVars(expr)
%  isAllVars(expr)
% 
%  Private helper function to check if a matrix consists of variables 
%  (e.g. to perform differentiation).

%   Copyright 2013-2014 The MathWorks, Inc.

if ~isa(expr, 'sym') || isa(expr, 'symfun')
    res = false;
else    
    res = all(arrayfun(@sym.isVariable, expr(:)));
end
