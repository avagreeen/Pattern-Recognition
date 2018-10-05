function g = finverse(f,x)
%FINVERSE Functional inverse.
%   g = FINVERSE(f) returns the functional inverse of f. 
%   f is a scalar sym representing a function of exactly 
%   one symbolic variable, say 'x'. Then g is a scalar sym
%   that satisfies f(g(x)) = x.
%
%   g = FINVERSE(f,v) uses the symbolic variable v, where v is
%   a sym, as the independent variable. Then g is a scalar 
%   sym that satisfies f(g(v)) = v. Use this form when f contains 
%   more than one symbolic variable.
%
%   If no inverse can be found g is either the empty sym object
%   or, if f is a polynomial, a RootOf expression.
%
%   Examples:
%      finverse(1/tan(x)) returns atan(1/x).
%
%      f = x^2+y;
%      finverse(f,y) returns y - x^2.
%      finverse(f) returns (x - y)^(1/2) 
%
%   See also SYM/COMPOSE.

%   Copyright 1993-2014 The MathWorks, Inc.

f = sym(f);
if ~isscalar(formula(f))
    error(message('symbolic:sym:finverse:ScalarExpected'));
end

if nargin == 1
    x = symvar(f,1);
    if isempty(x), error(message('symbolic:sym:finverse:errmsg1')); end
else
    if ~sym.isVariable(x)
        error(message('symbolic:sym:finverse:VariableExpected'))
    end
end
g = privBinaryOp(f, x, 'symobj::finverse');
