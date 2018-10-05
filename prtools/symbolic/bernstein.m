function b = bernstein(f, varargin)
% BERNSTEIN(f,n,x) with a nonnegative integer n and a 
%       function handle or double f is the n-th order 
%       Bernstein polynomial approximation
%         symsum(nchoosek(n,k)*x^k*(1-x)^(n-k)*f(k/n),k,0,n),
%       of f, evaluated at the scalar point x.
%
% Function handles f must accept one scalar input argument and 
% return a scalar value. Scalar double values f are accepted
% and regarded as constant functions.
%
% Examples:
%   The 5th order approximation of the sine function
%   by Bernstein polynomials is given by:
%
%   b = bernstein(@(x) sin(2*pi*x), 5, 0.5);
%
%   See also BERNSTEINMATRIX, SYM/BERNSTEIN
 
%   Copyright 2013 The MathWorks, Inc.

if nargin < 3 || nargin > 4
   error(message('symbolic:sym:bernstein:ExpectingThreeOrFourArguments'));
elseif nargin == 4  
   % The user should not see that this is not sym/bernstein.
   % Throw an error that would be adequate for the sym version.
   if isa(f, 'function_handle')
     error(message('symbolic:sym:bernstein:ExpectingThreeArguments'));
   end
   error(message('symbolic:sym:bernstein:ExpectingUnknown2'));
end

if ~(isa(f, 'function_handle') || (isnumeric(f) && isscalar(f)))
  error(message('symbolic:sym:bernstein:ExpectingFunctionHandleOrDouble1'));
end

n = varargin{1};
if ~(isscalar(n) && isreal(n) && n == round(n) && n >= 0) || ~isfinite(n)
   error(message('symbolic:sym:bernstein:ExpectingNonNegativeInteger2'));
end

x = varargin{2};
if ~(isnumeric(x) && isscalar(x)) 
   error(message('symbolic:sym:bernstein:ExpectingScalar3'));
end

if n == 0
  vector = 0;
else
  vector = (0:1/n:1)';
end

if isa(f, 'function_handle')
  nf = nargin(f);
  if ~(nf == 1 || nf == -1 || nf == -2)
     error(message('symbolic:sym:bernstein:ExpectingUnivariateFunctionHandle'));
  end
  f = arrayfun(f, vector, 'UniformOutput', false);
  f = [f{:}];
  if numel(size(f)) ~=2 || any(size(f) ~= [1 n+1])
       error(message('symbolic:sym:bernstein:FunctionMustProduceScalars'));
  end
  if any(~isfinite(sym(f)))
    error(message('symbolic:sym:bernstein:FunctionMustProduceFiniteValues'));
  end
else % regard f as constant function
  if any(~isfinite(sym(f)))
    error(message('symbolic:sym:bernstein:ExpectingFiniteValues'));
  end
  b = f;
  return
end

% ------------------------------
% Do the de Casteljau algorithm:
% ------------------------------
for j = 1:n
  f(1:n-j+1) = (1-x).*f(1:n-j+1) + x.*f(2:n-j+2);
end
b = f(1);
end
