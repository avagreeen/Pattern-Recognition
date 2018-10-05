function r = simplifyFraction(s,varargin)
%simplifyFraction Symbolic simplification of fractions.
%   SIMPLIFYFRACTION(S)  returns a simplified form of the rational   
%   expression S. Simplified form means that both numerator and denominator 
%   are polynomials whose greatest common divisor is 1.
%
%   SIMPLIFYFRACTION(S,'Expand',true) returns numerator and denominator 
%   in expanded form whereas SIMPLIFYFRACTION(S,'Expand',false) (which is 
%   the default) will not expand numerator and denominator completely. 
%   
%   Examples:
%      simplifyFraction((x^2-1)/(x+1))  
%      returns x-1
%
%      simplifyFraction(((y+1)^3*x)/((x^3-x*(x+1)*(x-1))*y))  
%      returns (y+1)^3/y
% 
%      simplifyFraction(((y+1)^3*x)/((x^3-x*(x+1)*(x-1))*y),'Expand',true)  
%      returns (y^3+3*y^2+3*y+1)/y 
%
%   See also SYM/SIMPLIFY, SYM/FACTOR, SYM/COLLECT, SYM/EXPAND.

%   Copyright 2011-2014 The MathWorks, Inc.

p = inputParser;
p.addParameter('Expand', false, @(X) X == sym(true) || X == sym(false));
p.parse(varargin{:});
if p.Results.Expand == true
    options = 'Expand = TRUE';
else
    options = 'Expand = FALSE';
end    

s = privResolveArgs(s);
s = s{1};
rSym = mupadmex('symobj::map',s.s,'normal',options);
r = privResolveOutput(rSym, s);
