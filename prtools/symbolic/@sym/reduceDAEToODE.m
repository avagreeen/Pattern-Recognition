function [newEqs, constraints, index] = reduceDAEToODE(eqs, vars)
%REDUCEDAETOODE   Reduce the differential index of a system of first-order
%    semi-linear differential algebraic equations (DAEs) to 0.
%
%    newEqs = reduceDAEToODE(eqs,vars)
%    [newEqs, constraints] = reduceDAEToODE(eqs,vars)
%    [newEqs, constraints, index] = reduceDAEToODE(eqs,vars)
%
%   eqs is a vector of symbolic equations or expressions. Here, expressions 
%   are interpreted as equations with zero right side.
%
%   vars is a vector consisting of univariate symbolic functions or 
%   univariate symbolic function calls. All symbolic function calls have
%   the same symbolic variable (the 'time').
%
%   The equations eqs represent a system of differential algebraic 
%   equations for the variables specified by vars. Any additional
%   symbolic objects in eqs are regarded as parameters of the DAE.
%
%   The implemented algorithm finds algebraic constraints hidden in
%   the input DAE, differentiates them with respect to time and replaces 
%   some of the input equations by the differentiated constraints. The
%   final goal is reached, when the rank of the Jacobian of the 
%   equations with respect to the first derivatives of the variables equals
%   the number of variables, that is, if the equations can be solved
%   for all derivatives.
%
%   newEqs is a column vector that consists of the input equations eqs, 
%   in which some equations are replaced by new equations involving the 
%   variables in vars and their derivatives.
%
%   newEqs defines a system of DAEs for the variables in the input parameter 
%   vars. It has a differential index of 0, that is, the new system is 
%   an implicit set of ODEs for the variables in vars. 
%
%   constraints is a column vector of algebraic expressions depending on 
%   the variables in vars, but not on their derivatives. The constraints 
%   are conserved quantities of the differential equations in newEqs, 
%   that is, the time derivative of each constraint vanishes modulo the 
%   equations in newEqs.
%
%   The output parameter index is a non-negative integer representing the
%   maximal number of differentiations of the input equations used to 
%   convert the original equations eqs to the new equations newEqs. This
%   is the differential index of the input DAE system eqs for the
%   variables in vars. 
%   
%   Example:
%     Create a DAE system of two differential equations and one algebraic
%     constraint for three variables:
%     >> syms x(t) y(t) z(t);
%        eqs = [diff(x,t)+x*diff(y,t) == y,...
%               x*diff(x, t)+x^2*diff(y) == sin(x),...
%               x^2 + y^2 == t*z];
%        vars = [x,y,z];
%
%     Reduce the DAE system to an ODE:
%     >>  [newEqs, constraints, index] = reduceDAEToODE(eqs, vars)
%
%     newEqs =
%                                x(t)*diff(y(t), t) - y(t) + diff(x(t), t)
%                    diff(x(t), t)*(cos(x(t)) - y(t)) - x(t)*diff(y(t), t)
%     z(t) - 2*x(t)*diff(x(t), t) - 2*y(t)*diff(y(t), t) + t*diff(z(t), t)
%
%     constraints =
%                    t*z(t) - y(t)^2 - x(t)^2
%                       sin(x(t)) - x(t)*y(t)
%                       
%     index =
%              1
%
%   See also: SYM/DECIC, REDUCEDAETOODE.

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);
  if numel(eqs) ~= numel(vars)
     error(message('symbolic:daeFunction:ExpectingAsManyEquationsAsVariables'));
  end

  A = feval(symengine, 'daetools::reduceDAEToODE', eqs, vars);
  A = num2cell(A);

  newEqs = A{1}.';
  newEqs = feval(symengine, 'rewrite', newEqs, 'diff');

  if nargout > 1
    constraints = A{2}.';
    constraints = feval(symengine, 'rewrite', constraints, 'diff');
  end
  if nargout > 2
    index = double(A{3}.');
  end
end
