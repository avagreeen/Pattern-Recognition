function H = hessian(f, x)
%HESSIAN Hessian matrix.
%   HESSIAN(f,x) computes the Hessian of the scalar f with respect
%   to the vector x. The (i,j)-th entry of the resulting matrix is
%   (d^2f/(dx(i)dx(j)). Note that scalar x is allowed although this
%   is just DIFF(f,x,2).
%
%   Example:
%       syms x y z; hessian(x*y + 2*z*x, [x, y, z])
%       returns  [0, 1, 2; 1, 0, 0; 2, 0, 0]
%
%   See also SYM/CURL, SYM/DIFF, SYM/GRADIENT, SYM/JACOBIAN, SYM/DIVERGENCE,
%   SYM/POTENTIAL, CURL, DIVERGENCE, HESSIAN, JACOBIAN, LAPLACIAN,
%   VECTORPOTENTIAL, SUBS.

%   Copyright 2011-2015 The MathWorks, Inc.

args = privResolveArgs(sym(f));
fsym = formula(args{1});

if ~isscalar(fsym) 
    error(message('symbolic:sym:hessian:FirstArgumentMustBeScalar'));
end
if ~isfinite(fsym)
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
   res = sym([]);
else
   if ~isvector(x) || ~isAllVars(x)
      error(message('symbolic:sym:hessian:SecondArgumentMustBeVectorOfVariables'));
   end
   res = mupadmex('symobj::hessian',fsym.s,x.s);
end

if isa(f,'symfun')
    H = symfun(res, argnames(f));
else
    H = res;
end
