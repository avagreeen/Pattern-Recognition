function c = simscapeEquation(lhs,rhs)
%simscapeEquation  generate a Simscape equation from a sym
%   simscapeEquation(S) generates a string containing the Simscape equation defining S.
%   Any derivative with respect to the variable 't' is converted to the
%   Simscape notation X.der where X is the time-dependent variable. Any other
%   use of the variable 't' is replaced with 'time'.
%
%   simscapeEquation(LHS,RHS) returns a Simscape equation LHS == RHS. 
%   
%   Examples:
%      syms t
%      x = sym('x(t)');
%      y = sym('y(t)');
%      phi = diff(x)+5*y + sin(t);
%      simscapeEquation(phi)
%         phi == sin(time)+y*5.0+x.der;
%      simscapeEquation(diff(y),phi)
%         y.der == sin(time)+y*5.0+x.der;
%
%   See also sym/matlabFunction, ssc_new.

%   Copyright 2009-2010 The MathWorks, Inc.

if nargin == 1
    rhs = lhs;
    lhs = inputname(1);
    if isempty(lhs), lhs = 'T'; end
end
if ~isa(rhs,'sym'), rhs = sym(rhs); end
if builtin('numel',rhs) ~= 1,  rhs = normalizesym(rhs);  end
if ~isa(lhs,'sym'), lhs = sym(lhs); end
if builtin('numel',lhs) ~= 1,  lhs = normalizesym(lhs);  end
eqn = feval(symengine,'_equal',lhs,rhs);
c = sprintf(mupadmex('generate::Simscape', eqn.s, 0));
c(c == '"') = [];
c = strtrim(c);
