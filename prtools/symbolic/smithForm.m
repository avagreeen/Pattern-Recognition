function [U,V,S] = smithForm(A, varargin)
%SMITHFORM   Smith normal form.
%   S = SMITHFORM(A) computes the Smith normal form of the square
%   invertible matrix A. The elements of A must be integers or 
%   univariate polynomials in the variable x = symvar(A,1).
%
%   The Smith form S is a diagonal matrix. The first diagonal
%   element divides the second, the second divides the third,
%   and so on.
%
%   [U,V,S] = SMITHFORM(A) also computes unimodular transformation 
%   matrices U and V, such that S = U*A*V. 
%
%   S = SMITHFORM(A,x) computes the Smith Normal Form of the square
%   invertible matrix A. The elements of A are regarded as univariate
%   polynomials in the specified variable x.
%
%   [U,V,S] = SMITHFORM(A,x) also computes unimodular transformation 
%   matrices U and V, such that S = U*A*V. 
%
%   Example:
%      >> A = sym(invhilb(5));
%      >> S = smithForm(A)
%
%      S =
%          [ 5,  0,   0,   0,    0]
%          [ 0, 60,   0,   0,    0]
%          [ 0,  0, 420,   0,    0]
%          [ 0,  0,   0, 840,    0]
%          [ 0,  0,   0,   0, 2520]
%
%      >> syms x y 
%      >> A = [2/x+y, x^2-y^2; 3*sin(x)+y, x];
%      >> [U,V,S] = smithForm(A,y)
%
%      U =
%          [ 0,       1]
%          [ x, y^2-x^2]
%
%      V =
%          [   0,                 1]
%          [ 1/x, -(3*sin(x))/x-y/x]
%
%      S =
%          [ 1,                                          0]
%          [ 0, 3*y^2*sin(x)-3*x^2*sin(x)+y^3+y*(-x^2+x)+2]
%
%      >> simplify(U*A*V - S)
%
%       ans =
%          [ 0, 0]
%          [ 0, 0]
%
%      >> A = [2*(x-y),3*(x^2-y^2);4*(x^3-y^3),5*(x^4-y^4)];
%      >> [U,V,S] = smithForm(A,x)
%
%      U =
%          [ 0,                     1]
%          [ 1, -x/(10*y^3)-3/(5*y^2)]
%          
%      V =
%          [ -x/(4*y^3), -(5*x*y^2)/2-(5*x^2*y)/2-(5*x^3)/2-(5*y^3)/2]
%          [  1/(5*y^3),                            2*x^2+2*x*y+2*y^2]
% 
%      S =
%          [ x-y,                       0]
%          [   0, x^4+6*x^3*y-6*x*y^3-y^4]
%  
%   See also HERMITEFORM, JORDAN.

%   Copyright 2015 MathWorks, Inc.

narginchk(1,2);
A0 = A; 
if ~isa(A, 'sym')
   % apart from sym, support only double and single
   if isa(A, 'double') || isa(A, 'single')
      A = sym(A);
   else
      error(message('symbolic:sym:smithForm:WrongInput')); 
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
      Usym = feval(symengine,'symobj::smithForm',A);
   else
      Usym = feval(symengine,'symobj::smithForm',A,x);
   end
   U = cast(privResolveOutput(Usym, A),'like',A0);
else
   if isempty(x)
      [Usym,Vsym,Ssym] = mupadmexnout('symobj::smithForm',A,'All');
   else
      [Usym,Vsym,Ssym] = mupadmexnout('symobj::smithForm',A,x,'All');
   end
   U = cast(privResolveOutput(Usym, A),'like',A0);
   V = cast(privResolveOutput(Vsym, A),'like',A0);
   S = cast(privResolveOutput(Ssym, A),'like',A0);
end
