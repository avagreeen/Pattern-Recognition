function [U,H] = hermiteForm(A, varargin)
%HERMITEFORM   Hermite normal form.
%   H = HERMITEFORM(A) computes the Hermite normal form of the 
%   matrix A. The elements of A must be integers or univariate 
%   polynomials in the variable x = symvar(A,1).
%
%   The Hermite form H is an upper triangular matrix. 
%
%   [U,H] = HERMITEFORM(A) also computes the unimodular 
%   transformation matrix U, such that H = U*A. 
%
%   H = HERMITEFORM(A,x) computes the Hermite Normal Form of
%   the matrix A. The elements of A are regarded as univariate
%   polynomials in the specified variable x.
%
%   [U,H] = HERMITEFORM(A,x) also computes the unimodular 
%   transformation matrix U, such that H = U*A. 
%
%   Example:
%      >> A = sym(invhilb(5));
%      >> H = hermiteForm(A)
%
%      H =
%          [ 5,  0, -210, -280,  630]
%          [ 0, 60,    0,    0,    0]
%          [ 0,  0,  420,    0,    0]
%          [ 0,  0,    0,  840,    0]
%          [ 0,  0,    0,    0, 2520]
%
%      >> syms x y 
%      >> A = [2*(x-y),3*(x^2-y^2);4*(x^3-y^3),5*(x^4-y^4)];
%      >> [U,H] = hermiteForm(A,x)
%
%      U =
%          [               1/2,  0]
%          [ 2*x^2+2*x*y+2*y^2, -1]
%       
%      H =
%          [ x-y,     (3*x^2)/2-(3*y^2)/2]
%          [   0, x^4+6*x^3*y-6*x*y^3-y^4]
%      
%      >> simplify(U*A - H)
%
%      ans =
%          [ 0, 0]
%          [ 0, 0]
%       
%      >> A = [2/x+y, x^2-y^2; 3*sin(x)+y, x];
%      >> [U,H] = hermiteForm(A,y)
%
%      U =
%          [ -x/(3*x*sin(x)-2), x/(3*x*sin(x)-2)]
%          [       -y-3*sin(x),            y+2/x]
%       
%      H =
%          [ 1, (x*y^2)/(3*x*sin(x)-2)+(x*(x-x^2))/(3*x*sin(x)-2)]
%          [ 0,        3*y^2*sin(x)-3*x^2*sin(x)+y^3+y*(-x^2+x)+2]
%
%   See also SMITHFORM, JORDAN.

%   Copyright 2015 MathWorks, Inc.

narginchk(1,2);
A0 = A; 
if ~isa(A, 'sym')
   % apart from sym, support only double and single
   if isa(A, 'double') || isa(A, 'single')
      A = sym(A);
   else
      error(message('symbolic:sym:hermiteForm:WrongInput')); 
   end
end
if builtin('numel',A) ~= 1
   % compatibility with old MATLAB versions
   A = normalizesym(A);  
end
if any(~isfinite(privsubsref(A,':')))
   error(message('symbolic:sym:InputMustNotContainNaNOrInf')); 
end
if nargin < 2 
   x = symvar(A,1);
else
   x = varargin{1};
   if ~sym.isVariable(x)
      error(message('symbolic:sym:SymVariableExpected'));
   end
end
if nargout <= 1
   if isempty(x)
      Usym = feval(symengine,'symobj::hermiteForm',A);
   else
      Usym = feval(symengine,'symobj::hermiteForm',A,x);
   end
   U = cast(privResolveOutput(Usym, A),'like',A0);
else
   if isempty(x)
      [Usym,Hsym] = mupadmexnout('symobj::hermiteForm',A,'All');
   else
      [Usym,Hsym] = mupadmexnout('symobj::hermiteForm',A,x,'All');
   end
   U = cast(privResolveOutput(Usym, A),'like',A0);
   H = cast(privResolveOutput(Hsym, A),'like',A0);
end
