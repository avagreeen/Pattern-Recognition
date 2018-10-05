function b = bernstein(f, varargin)
% BERNSTEIN(f,n,x) with a nonnegative integer n and a 
%       function handle f is the n-th order Bernstein 
%       polynomial approximation
%         symsum(nchoosek(n,k)*x^k*(1-x)^(n-k)*f(k/n),k,0,n),
%       of f, evaluated at the point x.
%
% BERNSTEIN(f,n,x) with a nonnegative integer n and a
%       symbolic expression or symfun f is the n-th order
%       Bernstein polynomial approximation of f at the 
%       point x. The expression f is regarded as a univariate 
%       function of the unknown determined via symvar(f,1).
%
% BERNSTEIN(f,var,n,x) with a nonnegative integer n and
%       a symbolic expression or symfun f is the n-th order 
%       Bernstein polynomial approximation of f at the
%       point x. The expression f is regarded as a univariate 
%       function of the unknown var. 
%
% Functions f must accept one scalar input argument and
% return a scalar value.
%
% The symbolic polynomials returned for symbolic x are
% numerically stable when substituting numerical values
% between 0 and 1 for x.
%
% Examples:
%   The second order approximation of the exponential 
%   function by Bernstein polynomials in the symbolic
%   variable x is given by:
%
%   syms x;
%   bernstein(exp(x), 2, x)
%
%   This returns:
%
%        (x - 1)^2 + x^2*exp(1) - 2*x*exp(1/2)*(x - 1)
%
%   The following is the 5th order Bernstein approximation 
%   of a function f representing a linear ramp:
%
%   syms x;
%   f(x) = triangularPulse(1/4, 3/4, Inf, x);
%   p = bernstein(f, 5, x)
%
%   This returns:
%
%       7*x^3*(x-1)^2 - 3*x^2*(x-1)^3 - 5*x^4*(x-1) + x^5.
%
%   The call simplify(p) simplifies this to:
%
%       -x^2*(2*x - 3).
%
%   Note that simplification of a symbolic Bernstein polynomial
%   may produce a representation that cannot be evaluated in a
%   numerically stable way. Compare the following plot of a
%   rectangular pulse function, its numerically stable Bernstein 
%   representation f1, and its simplified version f2 that is not 
%   numerically stable:
%
%     f = @(x)rectangularPulse(1/4,3/4,x);
%     b1 = bernstein(f,100,sym('x'))
%     b2 = simplify(b1)
%     f1 = matlabFunction(b1);
%     f2 = matlabFunction(b2);
%     x = 0:0.001:1;
%     plot(x,f(x),x,f1(x),x,f2(x))
%
%   See also BERNSTEIN, BERNSTEINMATRIX, SYM/NCHOOSEK, 
%   SYM/SYMVAR, SYM/SYMSUM.

%   Copyright 2013 The MathWorks, Inc.

if nargin == 3
   n = varargin{1};
   x = varargin{2};
   if isa(f, 'sym')
     var = symvar(f, 1);
   elseif isa(f, 'function_handle')
     var = sym([]); % we only need a dummy
   else
     var = symvar(sym(f),1);
   end
elseif nargin == 4
   var = varargin{1};
   n   = varargin{2};
   x   = varargin{3};
   if isa(f, 'function_handle')
     error(message('symbolic:sym:bernstein:ExpectingThreeArguments'));
   end
else
   error(message('symbolic:sym:bernstein:ExpectingThreeOrFourArguments'));
end

% check argument var
if ~isa(var,'sym'), var = sym(var); end
if builtin('numel',var) ~= 1,  var = normalizesym(var);  end
if nargin == 4 &&  ~isequal(var, symvar(var, 1))
   error(message('symbolic:sym:bernstein:ExpectingUnknown2'));
end

% check argument n
n = formula(sym(n));
if builtin('numel',n) ~= 1,  n = normalizesym(n);  end
n = feval(symengine, 'specfunc::makeInteger', n);
if ~(isscalar(n) && isreal(n) && n == round(n) && n >= 0) || ~isfinite(n) 
   if nargin == 3
      error(message('symbolic:sym:bernstein:ExpectingNonNegativeInteger2'));
   else
      error(message('symbolic:sym:bernstein:ExpectingNonNegativeInteger3'));
   end
end

% check argument x
if ~isa(x,'sym'), x = sym(x); end
if builtin('numel',x) ~= 1,  x = normalizesym(x);  end
x = formula(x);
if ~isscalar(x)  
   if nargin == 3
      error(message('symbolic:sym:bernstein:ExpectingScalar3'));
   else
      error(message('symbolic:sym:bernstein:ExpectingScalar4'));
   end
end

% check argument f
if isa(f, 'function_handle')
   % ---------------------------------------------------------
   % Create matrix input [f(0/n), f(1/n), ...] from function f
   % ---------------------------------------------------------
   nf = nargin(f);
   if ~(nf == 1 || nf == -1 || nf == -2)
     error(message('symbolic:sym:bernstein:ExpectingUnivariateFunctionHandle'));
   end
   if n == 0
      vector = 0;
   else
      vector = (0:1/n:1)';
   end
   f = arrayfun(f, sym(vector), 'UniformOutput', false);
   f = sym([f{:}]);
   if numel(size(f)) ~=2 || any(size(f) ~= [1 n+1])
       error(message('symbolic:sym:bernstein:FunctionMustProduceScalars'));
   end
   if any(~isfinite(f))
      error(message('symbolic:sym:bernstein:FunctionMustProduceFiniteValues'));
   end
elseif ~isscalar(f)
   error(message('symbolic:sym:bernstein:ExpectingScalar1')); 
end
if ~isa(f,'sym')
    f = sym(f); 
end
if builtin('numel',f) ~= 1
    f = normalizesym(f);
end

%----------------
% replace symfuns
%----------------
issymfun = isa(f, 'symfun');
if issymfun 
   fargs = argnames(f);   
   % Eliminate var from the arguments of the symfun
   fargs = privsubsref(fargs, logical(fargs ~= var));
   f = formula(f);     
   if ~isscalar(f)  
      error(message('symbolic:sym:bernstein:ExpectingScalar1'));
   end
end

if isempty(var)
    b = mupadmex('bernstein', f.s, n.s, x.s);
else
    b = mupadmex('bernstein', f.s, var.s, n.s, x.s);
end
% -------------------------
% re-vitalize symfuns
% -------------------------
if issymfun && ~isempty(fargs)
     b = symfun(b, fargs);
end
