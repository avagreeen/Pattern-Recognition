function [newEqs, newVars, trans] = reduceDifferentialOrder(eqs, vars)
%REDUCEDIFFERENTIALORDER   Reduce higher-order differential equations
%   to a system of first-order differential equations.
%
%   [newEqs, newVars] = reduceDifferentialOrder(eqs, vars)
%   [newEqs, newVars, R] = reduceDifferentialOrder(eqs, vars)
%
%   You can always reduce a higher-order differential equation or
%   expression given by a symbolic vector eqs to a first-order system
%   by introducing derivatives as new 'auxiliary' algebraic variables. 
%
%   The vector vars defines the 'state variables'. These variables 
%   can be specified as symbolic variables, univariate symbolic 
%   functions, or univariate symbolic function calls. The function
%   REDUCEDIFFERENTALORDER rewrites higher-order derivatives of the
%   state variables as first-order derivatives of the new 'auxiliary' 
%   variables. Higher-order derivatives of functions not specified in 
%   vars are not reduced.
%
%   newEqs is a column vector that consists of the input equations eqs, 
%   rewritten as expressions and augmented by differential expressions 
%   relating the new 'auxiliary' variables with the input variables.
%
%   newVars is a column vector that consists of the input variables vars
%   followed by the new 'auxiliary' variables.
%
%   R is a matrix with two columns. The first column contains the new 
%   'auxiliary' variables. The second column contains their definition 
%   as derivatives of the input variables.
%
%   Example:
%     >> syms x(t) y(t) f(t)
%        eqs = [diff(x(t),t,t) == diff(f(t),t,t,t),...
%               diff(y(t),t,t,t) == diff(f(t),t,t)];
%        vars = [x(t), y(t)];
%        [newEqs, newVars, R] = reduceDifferentialOrder(eqs, vars);
%     >> newEqs
%
%     diff(Dxt(t), t) - diff(f(t), t, t, t)
%       diff(Dytt(t), t) - diff(f(t), t, t)
%                    Dxt(t) - diff(x(t), t)
%                    Dyt(t) - diff(y(t), t)
%                 Dytt(t) - diff(Dyt(t), t)
%
%     >> newVars 
%
%        x(t)
%        y(t)
%      Dxt(t)
%      Dyt(t)
%     Dytt(t)
%
%     The new varables Dxt, Dyt, Dytt are related to the input
%     variables x(t),y(t) as follows:
%     >> R 
%
%     [  Dxt(t),    diff(x(t), t)]
%     [  Dyt(t),    diff(y(t), t)]
%     [ Dytt(t), diff(y(t), t, t)]
 
%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);

  A = feval(symengine, 'symobj::reduceDifferentialOrder', eqs, vars);
  A = num2cell(A);

  newEqs = A{1}.';

  if nargout > 1
    newVars = A{2}.';
  end
  if nargout > 2
    trans = children(A{3}.');
    if isempty(trans)
       trans = sym(ones(0, 2));
    end
    if size(trans, 1) > 1
       trans = [trans{:}];
    end
    trans = reshape(trans, 2, length(trans)/2).';
  end
end
