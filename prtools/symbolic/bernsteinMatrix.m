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
%   The third order Bernstein matrix, evaluated on an
%   equidistant grid in the interval from t = 0 to t = 1,
%   is given by:
%
%     t = 0:1/100:1;
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
%     C = B*P;
%     plot(C(:,1), C(:,2))
%
%   See also BERNSTEIN, SYM/BERNSTEIN.

%   Copyright 2013 The MathWorks, Inc.
 
if ~(isscalar(n) && isreal(n) && n == round(n) && n >= 0),
   error(message('symbolic:sym:bernsteinMatrix:ExpectingNonNegativeInteger1'));
end
if isempty(t) 
   b = ones(0, n+1);
   return
end
if ~isvector(t)
   error(message('symbolic:sym:bernsteinMatrix:ExpectingVector2'));
end

% compute B(j+1) = binomial(n, j), j = 0..n
B = ones(n+1, 1); 
for j = 1:ceil(n/2)
  B(j+1) = B(j)*(n+1-j)/j;
  B(n+1-j) = B(j+1);
end
% compute T(i, j) = t(i)^j, TT(i, j) = (1-t(i))^(n-j)
T = ones(length(t), n+1);
TT = ones(length(t), n+1);
% turn a row t into a column t so that 
% we can do diag(t)*T(:,j) by t.*T(:,j)
t = reshape(t, length(t), 1);
tt = 1 - t;
for j = 1:n 
  T(:, j+1) = t .* T(:, j); 
  T(:, j) = T(:, j) .* B(j);
 TT(:,n+1-j) = tt .* TT(:,n+2-j);
end

b =  T.*TT;
