function G = functionalDerivative(f,x)
%FUNCTIONALDERIVATIVE Euler Operator.
%   G = FUNCTIONALDERIVATIVE(f,x) computes the functional derivative of
%   the symbolic scalar expression f with respect to the vector x 
%   of variables. 
%   All variables in x must be symbolic functions or symbolic 
%   function calls depending on the same independent variables.
%
%   Example 1:
%     >> syms x(t) y(t);
%     >> functionalDerivative(x*y*diff(x,t)+diff(y,t)*diff(y,t,t,t),[x,y])
%
%     ans(t) =
%
%                               -x(t)*diff(y(t), t)
%     x(t)*diff(x(t), t) - 2*diff(y(t), t, t, t, t)
%
%   Example 2:
%     >> syms u(x,y);
%     >> functionalDerivative(sqrt(1+diff(u,x)^2+diff(u,y)^2), u)
%
%     ans(x,y) =
%
%        -(  diff(u(x, y), y)^2*diff(u(x, y), x, x) ...
%          + diff(u(x, y), x)^2*diff(u(x, y), y, y) ...
%          - 2*diff(u(x, y), x)*diff(u(x, y), y)*diff(u(x, y), x, y) ...
%          + diff(u(x, y), x, x) + diff(u(x, y), y, y) ...
%         )/(diff(u(x, y), x)^2 + diff(u(x, y), y)^2 + 1)^(3/2)

%   Copyright 2014 The MathWorks, Inc.

narginchk(2,2);
args = privResolveArgs(f,x);
fsym = formula(args{1});
xsym = formula(args{2});

if isempty(xsym)
    res = sym(zeros(0,1));
else
    if ~isscalar(fsym)
        error(message('symbolic:sym:functionalDerivative:FirstArgumentMustBeScalar'));
    end
    res = mupadmex('symobj::functionalDerivative',fsym.s,xsym.s);
end

G = privResolveOutput(res, args{1});
