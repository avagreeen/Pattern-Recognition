function [newEqs, newVars, R] = reduceRedundancies(eqs, vars)
%REDUCEREDUNDANCIES   Eliminate simple equations from a system of
%   symbolic differential algebraic equations (DAEs).
%
%   [newEqs, newVars] = reduceRedundancies(eqs, vars)
%   [newEqs, newVars, R] = reduceRedundancies(eqs, vars)
%
%   eqs is a vector of symbolic equations or expressions for the 
%   variables specified in the symbolic vector vars. The routine 
%   returns a column vector newEqs of symbolic expressions -- to 
%   be interpreted as equations with zero right side -- and a 
%   column vector newVars  which contains only those variables in 
%   vars that are still involved in newEqs.
%
%   If an input equation does not contain any of the variables 
%   specified in vars, then REDUCEREDUNDANCIES removes that
%   equation from newEqs.
%
%   If an input equation contains exactly one of the variables
%   specified in vars and depends linearly on that variable, then
%   REDUCERDUNDANCIES solves it for that variable and removes the 
%   equation from newEqs and the corresponding variable from newVars.
%   Its value is inserted in the remaining equations in newEqs.
%
%   If an input equation contains exactly two of the variables
%   specified in vars and depends linearly on at least one variable,
%   then REDUCEREDUNDANCIES solves for that variable and removes the
%   equation from newEqs and the corresponding variable from newVars.
%   Its value, expressed in terms of the second variable, is inserted 
%   in the remaining equations newEqs.
%
%   R is a structure array containing information on the eliminated 
%   equations and variables. It has the following fields:
%
%   R.solvedEquations is a symbolic column vector of all equations 
%   that REDUCEREDUNDANCIES used to replace variables and that do 
%   not turn up in newEqs.
%
%   R.constantVariables is a matrix with 2 columns. The first column 
%   contains the variables from vars that REDUCEREDUNDANCIES eliminated
%   and replaced by constant values. The second column contains the 
%   corresponding constant values.
%   
%   R.replacedVariables is a matrix with 2 columns. The first column
%   contains the variables from vars that REDUCEREDUNDANCIES eliminated 
%   and replaced in terms of other variables. The second column contains 
%   the corresponding values of the eliminated variables.
%
%   R.otherEquations is a column vector with all input equations
%   that do not contain any of the input variables.
%
%   Example:
%     Create a system of five differential algebraic equations
%     for four 'state variables' x1,x2,x3,x4. The system contains 
%     symbolic parameters and a function f(t) that does not represent
%     a state variable:
%
%     >> syms x1(t) x2(t) x3(t) x4(t) a1 a2 a3 a4 b c f(t);
%        eqs = [a1*diff(x1(t),t)+a2*diff(x2(t),t) == b*x4(t), ...
%               a3*diff(x2(t),t)+a4*diff(x3(t),t) == c*x4(t), ...
%               x1(t) == 2*x2(t), ...
%               x4(t) == f(t), ...
%               f(t) == sin(t)];
%        vars = [x1(t), x2(t), x3(t), x4(t)];
%    
%     Use REDUCEREDUNCANDIES to simplify the system. 

%     >> [newEqs, newVars, R] = reduceRedundancies(eqs, vars);
%
%     The resulting system essentially consists of two equations 
%     for the two variables x2(t),x3(t): 
%
%     >> newEqs
%
%     2*a1*diff(x2(t), t) + a2*diff(x2(t), t) - b*f(t)
%       a3*diff(x2(t), t) + a4*diff(x3(t), t) - c*f(t)
%
%     >> newVars
%
%     x2(t)
%     x3(t)
%
%     REDUCEREDUNDANCIES used these equations to define the input 
%     variables x1(t),x4(t) in terms of the remaining variables:
%
%     >> R.solvedEquations
%
%     x1(t) - 2*x2(t)
%        x4(t) - f(t)
%
%     >> R.constantVariables
%
%     [ x4(t), f(t)]
%
%     >> R.replacedVariables
%
%     [ x1(t), 2*x2(t)]
%
%     >> R.otherEquations
%
%     f(t) - sin(t)
%

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);

  A = feval(symengine, 'symobj::reduceRedundancies', eqs, vars);
  A = num2cell(A);
  newEqs = A{1}.';
  if nargout <= 1
     return
  end
  newVars = A{2}.';
  if nargout == 2
     return
  end
  
  R = struct();
  R.solvedEquations = A{3}.';

  Eqs1 = children(A{4});
  if length(Eqs1) == 1
     Eqs1 = children(Eqs1); 
  elseif isempty(Eqs1)
     Eqs1 = sym([]);
  elseif size(Eqs1, 2) > 1
     Eqs1 = [Eqs1{:}];
  end
  Eqs1 = reshape(Eqs1, 2, length(Eqs1)/2).';
  R.constantVariables = Eqs1;

  Eqs2 = children(A{5});
  if length(Eqs2) == 1
     Eqs2 = children(Eqs2);
  elseif isempty(Eqs2)
     Eqs2 = sym([]);
  elseif size(Eqs2, 2) > 1
     Eqs2 = [Eqs2{:}];
  end
  Eqs2 = reshape(Eqs2, 2, length(Eqs2)/2).';
  R.replacedVariables = Eqs2;

  R.otherEquations = A{6}.';

end
