function M = incidenceMatrix(eqs, vars)
%INCIDENCEMATRIX   Return the incidence matrix of a system of
%   differential algebraic equations (DAEs).
%
%   A = incidenceMatrix(eqs, vars)
%   with a symbolic vector of m equations or expressions and 
%   a vector of n variables returns an m x n double matrrix A
%   with A(i,j) = 1 if eqs(i) contains vas(j) or some derivative 
%   of vars(j). All other entries of A are zero.
%
%   Example:
%     >> syms Y1(t) Y2(t) Y3(t) Y4(t) Y5(t);
%        eqs = [diff(Y1)==Y2, diff(Y2)==Y1+Y3, ...
%               diff(Y3)==Y2+Y4, diff(Y4)==Y3+Y5, ...
%               diff(Y5)==Y4];
%        vars = [Y1,Y2,Y3,Y4,Y5];
%        A = incidenceMatrix(eqs, vars)
%     returns
%       1     1     0     0     0
%       1     1     1     0     0
%       0     1     1     1     0
%       0     0     1     1     1
%       0     0     0     1     1
%
%   The sparsity pattern can be visualized by the function spy.
%
%   See also: SPY.

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars, 'AllowInfinities');
  M = double(feval(symengine, 'daetools::incidenceMatrix', eqs, vars));
end
