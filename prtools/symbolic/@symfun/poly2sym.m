function p = poly2sym(c,x)
%POLY2SYM Polynomial coefficient vector to symbolic polynomial.
%   POLY2SYM(C,V) is a polynomial in the symbolic variable V
%   with coefficients from the vector C.
% 
%   Example:
%       x = sym('x');
%       poly2sym([1 0 -2 -5],x)
%   is
%       x^3-2*x-5
%
%   See also SYM/SYM2POLY, POLYVAL.

%   Copyright 2014 The MathWorks, Inc.

if nargin == 1
    p = symfun(poly2sym(formula(c)), argnames(c));    
elseif isa(c, 'symfun')
    p = symfun(poly2sym(formula(c), x), argnames(c));
else    
    % overloading by second argument, which then cannot be a variable
    error(message('symbolic:sym:SymVariableExpected'));
end
