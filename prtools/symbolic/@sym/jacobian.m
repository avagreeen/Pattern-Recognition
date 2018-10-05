function J = jacobian(f, x)
%JACOBIAN Jacobian matrix.
%   JACOBIAN(f,x) computes the Jacobian of the scalar or vector f
%   with respect to the vector x. The (i,j)-th entry of the result
%   is df(i)/dx(j). Note that when f is scalar, the Jacobian of f
%   is the gradient of f. Also, note that scalar x is allowed,
%   although this is just DIFF(f,x).
%
%   Example:
%       syms x y z u v; jacobian([x*y*z; y; x+z],[x y z])
%       returns  [y*z, x*z, x*y; 0, 1, 0; 1, 0, 1]
%
%       jacobian(u*exp(v),[u;v])
%       returns  [exp(v), u*exp(v)]
%
%   See also SYM/CURL, SYM/DIFF, SYM/DIVERGENCE, SYM/GRADIENT, SYM/HESSIAN,
%   SYM/POTENTIAL, CURL, DIVERGENCE, HESSIAN, LAPLACIAN, VECTORPOTENTIAL,
%   SUBS.

%   Copyright 1993-2015 The MathWorks, Inc.

args = privResolveArgs(sym(f));
fsym = formula(args{1});

if ~isvector(fsym) && ~isempty(fsym)
    error(message('symbolic:sym:jacobian:FirstArgumentMustBeScalarOrVector'));
end
if any(~isfinite(fsym))
    error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
end

if nargin == 1
    if isa(f,'symfun')
        x = argnames(f);
    else
        x = symvar(fsym);
    end
end

if isempty(x)
   res = sym(ones(numel(fsym),0));
else 
   if ~isvector(x) || ~isAllVars(x)
       error(message('symbolic:sym:jacobian:SecondArgumentMustBeVectorOfVariables'));
   end
   if isempty(fsym)
      res = sym(zeros(0,numel(x)));
   else
      res = mupadmex('symobj::jacobian',fsym.s,x.s);
   end
end

if isa(f,'symfun')
    J = symfun(res, argnames(f));
else
    J = res;
end
