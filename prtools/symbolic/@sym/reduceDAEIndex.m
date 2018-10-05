function [newEqs, newVars, trans, index] = reduceDAEIndex(eqs, vars)
%REDUCEDAEINDEX  Convert a system of symbolic first-order differential 
%   algebraic equations (DAE) to an equivalent system with a lower
%   differential index.  
%
%   [newEqs,newVars] = reduceDAEIndex(eqs,vars)
%   [newEqs,newVars,R] = reduceDAEIndex(eqs,vars)
%   [newEqs,newVars,R,index] = reduceDAEIndex(eqs,vars)
%
%   eqs is a vector of symbolic equations or expressions. Here,
%   expressions are interpreted as equations with zero right side.
%
%   vars is a vector consisting of univariate symbolic functions or 
%   univariate symbolic function calls. All symbolic function calls 
%   must have the same symbolic independent variable (the 'time').
%   
%   eqs and vars must have the same length.
%
%   The equations eqs represent a system of differential algebraic 
%   equations for the variables specified by vars. Any additional
%   symbolic objects in eqs are regarded as parameters of the DAE 
%   system.
%
%   REDUCEDAEINDEX uses the Pantelides algorithm. This algorithm finds
%   algebraic constraints hidden in the input system and differentiates
%   them with respect to the time variable. These constraints and their 
%   derivatives are added to the input equations. Higher-order time 
%   derivatives of the input variables are introduced and appear as new 
%   variables.
%
%   newEqs is a column vector that consists of the input equations eqs, 
%   rewritten as expressions and augmented by algebraic and differential 
%   expressions involving the input variables and additional variables.
%
%   newVars is a column vector that consists of the input variables vars, 
%   followed by the generated variables.
%
%   R is a matrix with two columns. The first column contains the 
%   additional variables introduced by the algorithm, the second column 
%   contains their definition as derivatives of the input variables.
%
%   index is a nonnegative integer, returned as a double value. It
%   indicates the differential index of the input DAE given by eqs and 
%   vars.
%
%   The equations in newEqs define a system of DAEs for the variables
%   in newVars. It usually has a differential index of 1. The algorithm 
%   is not fail-safe. If the DAE system given by newEqs has a 
%   differential index higher than 1, REDUCEDAEINDEX issues a warning 
%   and assigns NaN to the output variable index.
%
%   If the input DAE system is inconsistent and does not define unique
%   solution curves through given consistent initial values for the
%   variables (a 'singular' DAE), then the algorithm aborts with an
%   error.
%   
%   Example: Create the following first-order DAE system for three
%     unknown functions x(t),y(t),z(t):
%
%     >> syms x(t) y(t) z(t);
%        eqs = [diff(x(t),t) == y(t),... 
%               diff(y,t) == z(t),...
%               x(t)^2 + y(t)^2 == 1];
%        vars = [x(t), y(t), z(t)];
%
%     Reduce the differential index of this system:
%
%     >> [newEqs, newVars, R, index] = reduceDAEIndex(eqs, vars)
%
%     newEqs =
%                        diff(x(t), t) - y(t)
%                               Dyt(t) - z(t)
%                        x(t)^2 + y(t)^2 - 1
%        2*Dyt(t)*y(t) + 2*x(t)*diff(x(t), t)
%
%     newVars =
%                 x(t)
%                 y(t)
%                 z(t)
%               Dyt(t)
%
%     R =
%         [ Dyt(t), diff(y(t), t)]
%
%     index =
%              2
%
%   See also: REDUCEDAETOODE, ISLOWINDEXDAE.

%   Copyright 2014 The MathWorks, Inc.

  narginchk(2,2);
  [eqs, vars] = checkDAEInput(eqs, vars);
  if numel(eqs) ~= numel(vars)
     error(message('symbolic:daeFunction:ExpectingAsManyEquationsAsVariables'));
  end

  A = feval(symengine, 'symobj::reduceDAEIndex', eqs, vars);
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
  if nargout > 3
     index = A{4};
     % Pantelides might have failed and 
     % the index can be UNKNOWN:
     if strcmp(char(index),'UNKNOWN')
        index = NaN;
     else
        index = double(index);
     end
  end
end
