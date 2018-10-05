function [newEqs, newVars] = checkDAEInput(eqs, vars, ~)
%
  
%  Helper function to check equations and variables used as
%  input of the routines for manipulating DAEs. It raises
%  an error when the input does not meet the expectations.
%
%    syms x(t);
%    checkDAEInput(diff(x,2)==-x, x)
%
%  raises no error.
%
%    checkDAEInput(diff(x,2)==-x, x+1)
%
%  raises an error because the second argument should consist  
%  of variables.
%  Note: any third argument switches off the check for
%  infinities (desired for incidenceMatrix).

%   Copyright 2014 The MathWorks, Inc.

narginchk(2, 3);

if ~isa(eqs, 'sym')
   eqs = sym(eqs);
end
eqs = formula(eqs);
if ~isa(vars, 'sym')
   vars = sym(vars);
end
vars = formula(vars);
newEqs = eqs;
if ndims(newEqs) > 1 % return a column of equations
   newEqs = reshape(newEqs, numel(newEqs), 1);
end
newVars = vars;
if ndims(newVars) > 1 % return a column of variables
   newVars = reshape(newVars, numel(newVars), 1);
end
  
if nargin == 2 
   if any(~isfinite(newEqs)) || any(~isfinite(newVars))
      error(message('symbolic:sym:InputMustNotContainNaNOrInf'));
   end
end
end
