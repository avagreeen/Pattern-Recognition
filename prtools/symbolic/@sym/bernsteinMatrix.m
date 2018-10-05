function b = bernsteinMatrix(n, t)
% BERNSTEINMATRIX(n,t) with a nonnegative integer n 
%   and a vector t of doubles or symbolic expressions
%   returns a matrix B of size length(t) times n+1 
%   containing the Bernstein base polynomials
%     B(i,j+1) = nchoosek(n,j)*t(i)^j*(1-t(i))^(n-j)
%   with i = 1:length(t) and j = 0:n, evaluated at the 
%   elements of t.
%
%   The product B*P of the Bernstein matrix B with 
%   a matrix P with n+1 rows produces a matrix of
%   meshpoints on the Bezier curve defined by the 
%   n+1 control vectors given by the rows of P.
%
% Examples:
%   The third order Bernstein matrix with a symbolic 
%   parameter t is given by:
%
%     syms t;
%     B = bernsteinMatrix(3, t);
%
%   The third order Bezier curve given by 4 control 
%   points in 2D, defined by the rows of the matrix
%
%     P = [ 0 1; 2, 0; 1, 1; 2, 2 ]
%
%   is given by a matrix multiplication with this
%   Bernstein matrix:
%
%     C = B*P
%
%   This call produces the following curve:
%
%     [6*t*(t-1)^2-3*t^2*(t-1)+2*t^3, 
%           2*t^3-(t-1)^3-3*t^2*(t-1)]
%
%   The following command produces the plot over the 
%   range of the curve parameter from t = 0 to t = 1:
%
%     ezplot(C(1), C(2), [0, 1])
%
%   See also BERNSTEIN, SYM/BERNSTEIN.
 
%   Copyright 2013 The MathWorks, Inc.

% check argument n
n = formula(sym(n));
if builtin('numel',n) ~= 1,  n = normalizesym(n);  end
n = feval(symengine, 'specfunc::makeInteger', n);
if ~(isscalar(n) && isreal(n) && n == round(n) && n >= 0),
   error(message('symbolic:sym:bernsteinMatrix:ExpectingNonNegativeInteger1'));
end

% check argument t
args = privResolveArgs(t, n);
t = formula(args{1});
if isempty(t)
   b = sym(ones(0, double(n)+1));
   b = privResolveOutput(b, args{1});
   return
end
if ~isvector(t)
   error(message('symbolic:sym:bernsteinMatrix:ExpectingVector2'));
end

b = mupadmex('bernsteinMatrix', n.s, t.s);
b = privResolveOutput(b, args{1});
